import {
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';

import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { pushCommon, RemoteNotificationExtensionAbility } from '@kit.PushKit';
import { EPushInterface, CallBackMsg, EMessage, ECustomMessage, EAliasMessage, ETagMessage } from '@engagelab/push';

/** 与 Android 一致的通知类 event_data */
interface NotificationEventData {
  messageId: string;
  title: string;
  content: string;
  extras: Object;
  channel?: number;
}

/** 与 Android 一致的自定义消息 event_data */
interface CustomMessageEventData {
  messageId: string;
  title: string;
  content: string;
  extras: Object;
  contentType?: string;
}

/** 与 Android 一致的 tag 操作 event_data */
interface TagMessageEventData {
  code: number;
  sequence: number;
  tags: string[];
  queryTag: string;
  isBind: boolean;
}

/** 与 Android 一致的 alias 操作 event_data */
interface AliasMessageEventData {
  alias: string;
  code: number;
  sequence: number;
}

/** 注册回调 event_data */
interface RegisterEventData {
  registrationId: string;
}

/** 长连接状态 event_data */
interface ConnectStatusEventData {
  enable: boolean;
}

/**
 * 将鸿蒙 EMessage 转为与 Android 一致的 event_data（messageId、title、content、extras）
 */
function buildNotificationEventData(eMessage: EMessage): string {
  let out: NotificationEventData = {
    messageId: eMessage.msgId ?? '',
    title: eMessage.title ?? '',
    content: eMessage.content ?? '',
    extras: eMessage.extras ?? {}
  };
  if (eMessage.channel !== undefined) {
    out.channel = eMessage.channel;
  }
  return JSON.stringify(out);
}

/**
 * 将鸿蒙 ECustomMessage 转为与 Android 一致的 event_data（messageId、title、content、extras、contentType）
 */
function buildCustomMessageEventData(eCustomMessage: ECustomMessage): string {
  let out: CustomMessageEventData = {
    messageId: eCustomMessage.msgId ?? '',
    title: eCustomMessage.title ?? '',
    content: eCustomMessage.content ?? '',
    extras: eCustomMessage.extras ?? {}
  };
  if (eCustomMessage.contentType !== undefined) {
    out.contentType = eCustomMessage.contentType;
  }
  return JSON.stringify(out);
}

/**
 * 将鸿蒙 ETagMessage 转为与 Android 一致的 event_data（code、sequence、tags、queryTag、isBind）
 */
function buildTagMessageEventData(eTagMessage: ETagMessage): string {
  let tags = eTagMessage.tags ?? [];
  let queryTag: string = (eTagMessage as Record<string, Object>)['queryTag'] as string
    ?? (eTagMessage as Record<string, Object>)['tag'] as string
    ?? (Array.isArray(tags) && tags.length === 1 ? String(tags[0]) : '');
  let validated: boolean | undefined = (eTagMessage as Record<string, Object>)['validated'] as boolean | undefined;
  let out: TagMessageEventData = {
    code: eTagMessage.code ?? 0,
    sequence: eTagMessage.sequence ?? 0,
    tags: tags,
    queryTag: queryTag,
    isBind: validated ?? false
  };
  return JSON.stringify(out);
}

/**
 * 将鸿蒙 EAliasMessage 转为与 Android 一致的 event_data（alias、code、sequence）
 */
function buildAliasMessageEventData(eAliasMessage: EAliasMessage): string {
  let out: AliasMessageEventData = {
    alias: eAliasMessage.alias ?? '',
    code: eAliasMessage.code ?? 0,
    sequence: eAliasMessage.sequence ?? 0
  };
  return JSON.stringify(out);
}

/**
 * 继承 CallBackMsg，将 SDK 回调转为 { event_name, event_data } 通过 MethodChannel 发给 Dart
 * event_data 与 Android MsgToJson / APIs 文档一致，便于 Dart 统一解析
 */
class FlutterCallBackMsg extends CallBackMsg {
  private sendEvent: (eventName: string, eventData: string) => void;

  constructor(sendEvent: (eventName: string, eventData: string) => void) {
    super();
    this.sendEvent = sendEvent;
  }

  onRegister(registrationId: string): void {
    let data: RegisterEventData = { registrationId: registrationId };
    this.sendEvent('onRegister', JSON.stringify(data));
  }

  onConnected(isConnected: boolean): void {
    let data: ConnectStatusEventData = { enable: isConnected };
    this.sendEvent('onConnectStatus', JSON.stringify(data));
  }

  onClickMessage(eMessage: EMessage): void {
    this.sendEvent('onNotificationClicked', buildNotificationEventData(eMessage));
  }

  onArrivedMessage(eMessage: EMessage): void {
    this.sendEvent('onNotificationArrived', buildNotificationEventData(eMessage));
  }

  onUnShowMessage(eMessage: EMessage): void {
    this.sendEvent('onNotificationUnShow', buildNotificationEventData(eMessage));
  }

  onCustomMessage(eCustomMessage: ECustomMessage): void {
    this.sendEvent('onCustomMessage', buildCustomMessageEventData(eCustomMessage));
  }

  onTagOperatorResult(eTagMessage: ETagMessage): void {
    this.sendEvent('onTagMessage', buildTagMessageEventData(eTagMessage));
  }

  onAliasOperatorResult(eAliasMessage: EAliasMessage): void {
    this.sendEvent('onAliasMessage', buildAliasMessageEventData(eAliasMessage));
  }
}

/** FlutterPluginEngagelabPlugin **/
export default class FlutterPluginEngagelabPlugin implements FlutterPlugin, MethodCallHandler {
  private channel: MethodChannel | null = null;
  private applicationContext: common.UIAbilityContext | null = null;
  private callBackMsg: FlutterCallBackMsg | null = null;

  constructor() {
  }

  getUniqueClassName(): string {
    return "FlutterPluginEngagelabPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.applicationContext = binding.getApplicationContext() as common.UIAbilityContext;
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_plugin_engagelab");
    this.channel.setMethodCallHandler(this);
    this.registerCallBackMsg();
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
    this.callBackMsg = null;
    this.applicationContext = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    if (call.method == "getPlatformVersion") {
      result.success("OpenHarmony ^ ^ ")
    } else if (call.method == "init"){
      this.init()
    } else if (call.method == "setAppKey"){
      this.setAppKey(call.args)
    } else if (call.method == "setChannel"){
      this.setChannel(call.args)
    } else if (call.method == "configDebugMode"){
      this.configDebugMode(call.args)
      result.success(null)
    } else if (call.method == "getRegistrationId") {
      this.getRegistrationId(result)
    } else if (call.method == "addTags") {
      this.addTags(call.args);
      result.success(null);
    } else if (call.method == "deleteTags") {
      this.deleteTags(call.args);
      result.success(null);
    } else if (call.method == "updateTags") {
      this.updateTags(call.args);
      result.success(null);
    } else if (call.method == "queryTag") {
      this.queryTag(call.args);
      result.success(null);
    } else if (call.method == "deleteAllTag") {
      this.deleteAllTag(call.args);
      result.success(null);
    } else if (call.method == "queryAllTag") {
      this.queryAllTag(call.args);
      result.success(null);
    } else if (call.method == "setAlias") {
      this.setAlias(call.args);
      result.success(null);
    } else if (call.method == "getAlias") {
      this.getAlias(call.args);
      result.success(null);
    } else if (call.method == "clearAlias") {
      this.clearAlias(call.args);
      result.success(null);
    } else if (call.method == "setCustomMessageMaxCacheCount") {
      this.setCustomMessageMaxCacheCount(call.args);
      result.success(null);
    } else if (call.method == "setUserRequestNotificationPermission") {
      this.setUserRequestNotificationPermission(call.args);
      result.success(null);
    } else if (call.method == "clearToken") {
      this.clearToken(result);
    } else if (call.method == "turnOnPush") {
      this.resumePush();
      result.success(null);
    } else if (call.method == "turnOffPush") {
      this.stopPush();
      result.success(null);
    } else if (call.method == "isPushStopped") {
      this.isPushStopped(result);
    } else if (call.method == "setTcpSSL") {
      this.setTcpSSl(call.args);
      result.success(null);
    } else if (call.method == "configHeartbeatInterval") {
      this.setHeartbeatTime(call.args);
      result.success(null);
    } else if (call.method == "setBadge") {
      this.setBadgeNumber(call.args, result);
    } else if (call.method == "clearNotification") {
      this.clearNotification(call.args);
      result.success(null);
    } else if (call.method == "clearNotificationByMsgId") {
      this.clearNotificationByMsgId(call.args);
      result.success(null);
    } else if (call.method == "clearNotificationAll") {
      this.clearNotificationAll();
      result.success(null);
    } else if (call.method == "reportNotificationClick") {
      this.reportNotificationClick(call.args);
      result.success(null);
    } else if (call.method == "reportNotificationDisplay") {
      this.reportNotificationDisplay(call.args);
      result.success(null);
    } else if (call.method == "reportCustomDisplay") {
      this.reportCustomDisplay(call.args);
      result.success(null);
    } else if (call.method == "reportCustomClick") {
      this.reportCustomClick(call.args);
      result.success(null);
    } else {
      result.notImplemented()
    }
  }

  /**
   * 获取 Registration ID（rid）
   * 文档：EPushInterface.getRegistrationId(): string，请先 init 否则调用无效
   */
  private getRegistrationId(result: MethodResult): void {
    try {
      let rid = EPushInterface.getRegistrationId();
      result.success(rid != null ? rid : '');
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin getRegistrationId error: ' + JSON.stringify(e));
      result.success('');
    }
  }

  /**
   * 内部注册 setCallBackMsg，供 addEventHandler 收到的事件能发到 Dart
   * 文档：EPushInterface.setCallBackMsg(继承CallBackMsg的实体类)，在 init 之前调用
   */
  private registerCallBackMsg(): void {
    if (this.channel == null) {
      return;
    }
    if (this.callBackMsg == null) {
      this.callBackMsg = new FlutterCallBackMsg((eventName: string, eventData: string) => {
        this.sendEventToDart(eventName, eventData);
      });
      EPushInterface.setCallBackMsg(this.callBackMsg);
    }
  }

  private sendEventToDart(eventName: string, eventData: string): void {
    if (this.channel != null) {
      let map: Record<string, string> = {
        'event_name': eventName,
        'event_data': eventData
      };
      this.channel.invokeMethod('onMTCommonReceiver', map);
      console.log('FlutterPluginEngagelabPlugin sendEventToDart: ' + eventName);
    }
  }

  /**
   * 初始化推送 SDK，需在 setAppKey/setChannel 之后调用
   * 使用 onAttachedToEngine 时保存的 applicationContext
   */
  init(): void {
    console.log('FlutterPluginEngagelabPlugin init, applicationContext: ' + (this.applicationContext != null ? 'ok' : 'null'));
    EPushInterface.init(this.applicationContext);
  }

  /**
   * 设置 AppKey
   * Dart 传参: invokeMethod("setAppKey", [appKey])，appKey 为 string
   * @param args MethodChannel 的 call.args，为数组 [appKey]
   */
  setAppKey(args: Object | null): void {
    let appKey = this.getStringFromArgs(args);
    console.log('FlutterPluginEngagelabPlugin setAppKey, appKey: ' + appKey);
    EPushInterface.setAppKey(appKey);
  }

  /**
   * 设置渠道名
   * Dart 传参: invokeMethod("setChannel", [channel])，channel 为 string
   * @param args MethodChannel 的 call.args，为数组 [channel]
   */
  setChannel(args: Object | null): void {
    let channel = this.getStringFromArgs(args);
    console.log('FlutterPluginEngagelabPlugin setChannel, channel: ' + channel);
    EPushInterface.setChannel(channel);
  }

  /**
   * 设置是否 debug 模式，debug 模式会打印更多详细日志
   * Dart 传参: invokeMethod("configDebugMode", [enable])，enable 为 boolean
   */
  configDebugMode(args: Object | null): void {
    let enable = this.getBooleanFromArgs(args);
    console.log('FlutterPluginEngagelabPlugin configDebugMode, enable: ' + enable);
    EPushInterface.setDebug(enable);
  }




  // ---------- 标签与别名：Dart 通过 onTagMessage / onAliasMessage 收结果 ----------

  /**
   * 新增标签。鸿蒙 Dart 传 [sequence, jsonEncode(tags)]，避免桥接 Map 无法枚举
   * 文档：EPushInterface.addTags(sequence, tags)
   */
  private addTags(args: Object | null): void {
    let sequence = this.getNumberFromArgs(args, 0);
    let tags = this.getStringArrayFromArgsAtIndex(args, 1);
    if (tags.length === 0) {
      console.error('FlutterPluginEngagelabPlugin addTags: tags empty');
      return;
    }
    console.log('FlutterPluginEngagelabPlugin addTags sequence=' + sequence + ' tags=' + JSON.stringify(tags));
    try {
      EPushInterface.addTags(sequence, tags);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin addTags error: ' + JSON.stringify(e));
    }
  }

  /**
   * 删除标签。鸿蒙 Dart 传 [sequence, jsonEncode(tags)]
   */
  private deleteTags(args: Object | null): void {
    let sequence = this.getNumberFromArgs(args, 0);
    let tags = this.getStringArrayFromArgsAtIndex(args, 1);
    if (tags.length === 0) {
      console.error('FlutterPluginEngagelabPlugin deleteTags: tags empty');
      return;
    }
    console.log('FlutterPluginEngagelabPlugin deleteTags sequence=' + sequence + ' tags=' + JSON.stringify(tags));
    try {
      EPushInterface.deleteTags(sequence, tags);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin deleteTags error: ' + JSON.stringify(e));
    }
  }

  /**
   * 更新标签（覆盖）。鸿蒙 Dart 传 [sequence, jsonEncode(tags)]
   * 文档：EPushInterface.setTags(sequence, tags)
   */
  private updateTags(args: Object | null): void {
    let sequence = this.getNumberFromArgs(args, 0);
    let tags = this.getStringArrayFromArgsAtIndex(args, 1);
    console.log('FlutterPluginEngagelabPlugin updateTags sequence=' + sequence + ' tags=' + JSON.stringify(tags));
    try {
      EPushInterface.setTags(sequence, tags);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin updateTags error: ' + JSON.stringify(e));
    }
  }

  /**
   * 查询指定标签是否绑定。鸿蒙 Dart 传 [sequence, tag]
   * 文档：EPushInterface.checkTagBindState(sequence, tag)，结果走 onTagOperatorResult
   */
  private queryTag(args: Object | null): void {
    let sequence = this.getNumberFromArgs(args, 0);
    let tag = this.getStringFromArgsAtIndex(args, 1);
    if (tag === '') {
      console.error('FlutterPluginEngagelabPlugin queryTag: tag empty');
      return;
    }
    console.log('FlutterPluginEngagelabPlugin queryTag sequence=' + sequence + ' tag=' + tag);
    try {
      EPushInterface.checkTagBindState(sequence, tag);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin queryTag error: ' + JSON.stringify(e));
    }
  }

  /**
   * 删除所有标签。Dart 传 [sequence]
   * 文档：EPushInterface.cleanTags(sequence)
   */
  private deleteAllTag(args: Object | null): void {
    let sequence = this.getNumberFromArgs(args, 0);
    console.log('FlutterPluginEngagelabPlugin deleteAllTag sequence=' + sequence);
    try {
      EPushInterface.cleanTags(sequence);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin deleteAllTag error: ' + JSON.stringify(e));
    }
  }

  /**
   * 查询所有标签。Dart 传 [sequence]
   * 文档：EPushInterface.getTags(sequence, curr)，curr 为当前页数、从 1 开始，结果走 onTagOperatorResult
   */
  private queryAllTag(args: Object | null): void {
    let sequence = this.getNumberFromArgs(args, 0);
    console.log('FlutterPluginEngagelabPlugin queryAllTag sequence=' + sequence);
    try {
      EPushInterface.getTags(sequence, 1);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin queryAllTag error: ' + JSON.stringify(e));
    }
  }

  /**
   * 设置别名。Dart 传 [sequence, alias]
   */
  private setAlias(args: Object | null): void {
    let sequence = this.getNumberFromArgs(args, 0);
    let alias = '';
    if (args != null && Array.isArray(args) && args.length > 1) {
      let v: Object | undefined = args[1];
      alias = (v != null && typeof v === 'string') ? v : String(v);
    }
    console.log('FlutterPluginEngagelabPlugin setAlias sequence=' + sequence + ' alias=' + alias);
    try {
      EPushInterface.setAlias(sequence, alias);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin setAlias error: ' + JSON.stringify(e));
    }
  }

  /**
   * 获取别名。Dart 传 [sequence]，结果走 onAliasOperatorResult
   */
  private getAlias(args: Object | null): void {
    let sequence = this.getNumberFromArgs(args, 0);
    console.log('FlutterPluginEngagelabPlugin getAlias sequence=' + sequence);
    try {
      EPushInterface.getAlias(sequence);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin getAlias error: ' + JSON.stringify(e));
    }
  }

  /**
   * 清除别名。Dart 传 [sequence]
   * 文档：EPushInterface.deleteAlias(sequence)
   */
  private clearAlias(args: Object | null): void {
    let sequence = this.getNumberFromArgs(args, 0);
    console.log('FlutterPluginEngagelabPlugin clearAlias sequence=' + sequence);
    try {
      EPushInterface.deleteAlias(sequence);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin clearAlias error: ' + JSON.stringify(e));
    }
  }

  // ---------- 未实现接口补充：EPushInterface 文档中的其余 API ----------

  /**
   * 配置自定义消息缓存条数。Dart 传 [count]
   * 文档：EPushInterface.setCustomMessageMaxCacheCount(count)
   */
  private setCustomMessageMaxCacheCount(args: Object | null): void {
    let count = this.getNumberFromArgs(args, 0);
    try {
      EPushInterface.setCustomMessageMaxCacheCount(count);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin setCustomMessageMaxCacheCount error: ' + JSON.stringify(e));
    }
  }

  /**
   * 控制通知权限申请方式。Dart 传 [enable]
   * 文档：EPushInterface.setUserRequestNotificationPermission(applicationContext, enable)，需传入 ApplicationContext
   */
  private setUserRequestNotificationPermission(args: Object | null): void {
    let enable = this.getBooleanFromArgs(args);
    try {
      let appContext = this.applicationContext?.getApplicationContext();
      if (appContext != null) {
        EPushInterface.setUserRequestNotificationPermission(appContext, enable);
      }
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin setUserRequestNotificationPermission error: ' + JSON.stringify(e));
    }
  }

  /**
   * 清除 Token。文档：EPushInterface.clearToken()
   */
  private clearToken(result: MethodResult): void {
    try {
      EPushInterface.clearToken();
      result.success(null);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin clearToken error: ' + JSON.stringify(e));
      result.success(null);
    }
  }

  /**
   * 停止推送。Dart 调用 turnOffPush。文档：EPushInterface.stopPush()
   */
  private stopPush(): void {
    try {
      EPushInterface.stopPush();
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin stopPush error: ' + JSON.stringify(e));
    }
  }

  /**
   * 恢复推送。Dart 调用 turnOnPush。文档：EPushInterface.resumePush()
   */
  private resumePush(): void {
    try {
      EPushInterface.resumePush();
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin resumePush error: ' + JSON.stringify(e));
    }
  }

  /**
   * 查询推送是否已停止。文档：EPushInterface.isPushStopped(): boolean
   */
  private isPushStopped(result: MethodResult): void {
    try {
      let stopped = EPushInterface.isPushStopped();
      result.success(stopped === true);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin isPushStopped error: ' + JSON.stringify(e));
      result.success(false);
    }
  }

  /**
   * 设置 TCP SSL。Dart 传 [enable]。文档：EPushInterface.setTcpSSl(enable)
   */
  private setTcpSSl(args: Object | null): void {
    let enable = this.getBooleanFromArgs(args);
    try {
      EPushInterface.setTcpSSl(enable);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin setTcpSSl error: ' + JSON.stringify(e));
    }
  }

  /**
   * 设置心跳周期。Dart 传 [intervalMs]。文档：EPushInterface.setHeartbeatTime(time)
   */
  private setHeartbeatTime(args: Object | null): void {
    let time = this.getNumberFromArgs(args, 0);
    try {
      EPushInterface.setHeartbeatTime(time);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin setHeartbeatTime error: ' + JSON.stringify(e));
    }
  }

  /**
   * 设置角标数量。Dart 传 [badge]。文档：EPushInterface.setBadgeNumber(count)
   */
  private setBadgeNumber(args: Object | null, result: MethodResult): void {
    let badge = this.getNumberFromArgs(args, 0);
    try {
      EPushInterface.setBadgeNumber(badge);
      result.success({ 'success': true });
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin setBadgeNumber error: ' + JSON.stringify(e));
      result.success({ 'success': false, 'error': String(e) });
    }
  }

  /**
   * 按通知 ID 清除通知。Dart 传 [notifyId]。文档：EPushInterface.clearNotification(notifyId)
   */
  private clearNotification(args: Object | null): void {
    let notifyId = this.getNumberFromArgs(args, 0);
    try {
      EPushInterface.clearNotification(notifyId);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin clearNotification error: ' + JSON.stringify(e));
    }
  }

  /**
   * 按消息 ID 清除通知。Dart 传 [msgId]。文档：EPushInterface.clearNotificationByMsgId(msgId)
   */
  private clearNotificationByMsgId(args: Object | null): void {
    let msgId = this.getStringFromArgs(args);
    if (msgId === '') {
      console.error('FlutterPluginEngagelabPlugin clearNotificationByMsgId: msgId empty');
      return;
    }
    try {
      EPushInterface.clearNotificationByMsgId(msgId);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin clearNotificationByMsgId error: ' + JSON.stringify(e));
    }
  }

  /**
   * 清除所有通知。文档：EPushInterface.clearNotificationAll()
   */
  private clearNotificationAll(): void {
    try {
      EPushInterface.clearNotificationAll();
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin clearNotificationAll error: ' + JSON.stringify(e));
    }
  }

  /**
   * 上报通知点击。Dart 传 [channel, msgId]。文档：EPushInterface.reportNotificationClick(channel, msgId)
   */
  private reportNotificationClick(args: Object | null): void {
    let channel = this.getNumberFromArgs(args, 0);
    let msgId = this.getStringFromArgsAtIndex(args, 1);
    try {
      EPushInterface.reportNotificationClick(channel, msgId);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin reportNotificationClick error: ' + JSON.stringify(e));
    }
  }

  /**
   * 上报通知展示。Dart 传 [channel, msgId]。文档：EPushInterface.reportNotificationDisplay(channel, msgId)
   */
  private reportNotificationDisplay(args: Object | null): void {
    let channel = this.getNumberFromArgs(args, 0);
    let msgId = this.getStringFromArgsAtIndex(args, 1);
    try {
      EPushInterface.reportNotificationDisplay(channel, msgId);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin reportNotificationDisplay error: ' + JSON.stringify(e));
    }
  }

  /**
   * 上报自定义消息展示。Dart 传 [channel, msgId]。文档：EPushInterface.reportCustomDisplay(channel, msgId)
   */
  private reportCustomDisplay(args: Object | null): void {
    let channel = this.getNumberFromArgs(args, 0);
    let msgId = this.getStringFromArgsAtIndex(args, 1);
    try {
      EPushInterface.reportCustomDisplay(channel, msgId);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin reportCustomDisplay error: ' + JSON.stringify(e));
    }
  }

  /**
   * 上报自定义消息点击。Dart 传 [channel, msgId]。文档：EPushInterface.reportCustomClick(channel, msgId)
   */
  private reportCustomClick(args: Object | null): void {
    let channel = this.getNumberFromArgs(args, 0);
    let msgId = this.getStringFromArgsAtIndex(args, 1);
    try {
      EPushInterface.reportCustomClick(channel, msgId);
    } catch (e) {
      console.error('FlutterPluginEngagelabPlugin reportCustomClick error: ' + JSON.stringify(e));
    }
  }

  // ---------- Tools ----------

  /**
   * 从 MethodChannel args 解析出单个字符串（Dart 传 [value]）
   */
  private getStringFromArgs(args: Object | null): string {
    if (args == null) {
      return '';
    }
    let v: Object | undefined;
    if (Array.isArray(args) && args.length > 0) {
      v = args[0];
    } else if (typeof args === 'string') {
      return args;
    } else {
      return '';
    }
    if (v == null) {
      return '';
    }
    if (typeof v === 'string') {
      return v;
    }
    return String(v);
  }

  /**
   * 从 MethodChannel args 解析出单个布尔值（Dart 传 [enable]）
   */
  private getBooleanFromArgs(args: Object | null): boolean {
    if (args == null) {
      return false;
    }
    let v: Object | undefined;
    if (Array.isArray(args) && args.length > 0) {
      v = args[0];
    } else if (typeof args === 'boolean') {
      return args;
    } else {
      return false;
    }
    if (v == null) {
      return false;
    }
    if (typeof v === 'boolean') {
      return v;
    }
    return (v === true || v === 'true');
  }

  /**
   * 从 args 解析出 params 对象（Dart 传 [params]，params 为 { sequence, tags } 或 { sequence, tag }）
   * 兼容：args[0] 为 object 或 JSON 字符串（与 Android 端一致）
   */
  private getParamsFromArgs(args: Object | null): Record<string, Object> | null {
    if (args == null) {
      return null;
    }
    let v: Object | undefined;
    if (Array.isArray(args) && args.length > 0) {
      v = args[0];
    } else if (typeof args === 'object' && args !== null) {
      v = args;
    } else {
      return null;
    }
    if (v == null) {
      return null;
    }
    if (typeof v === 'string') {
      try {
        let parsed: Object = JSON.parse(v as string) as Object;
        if (parsed != null && typeof parsed === 'object') {
          return parsed as Record<string, Object>;
        }
      } catch (e) {
        console.error('FlutterPluginEngagelabPlugin getParamsFromArgs JSON.parse error: ' + (e as Error).message);
      }
      return null;
    }
    if (typeof v === 'object') {
      return v as Record<string, Object>;
    }
    return null;
  }

  /**
   * 从 args 解析出单个 number（Dart 传 [sequence]）
   */
  private getNumberFromArgs(args: Object | null, index: number = 0): number {
    if (args == null) {
      return 0;
    }
    let arr: Object[] | undefined;
    if (Array.isArray(args) && args.length > index) {
      let v: Object | undefined = args[index];
      if (typeof v === 'number') {
        return v;
      }
      if (typeof v === 'string') {
        let n = parseInt(v, 10);
        return isNaN(n) ? 0 : n;
      }
    }
    return 0;
  }

  /**
   * 从 args 的指定下标取字符串（鸿蒙 Dart 传 [sequence, tag] 时取 tag）
   */
  private getStringFromArgsAtIndex(args: Object | null, index: number): string {
    if (args == null || !Array.isArray(args) || args.length <= index) {
      return '';
    }
    let v: Object | undefined = args[index];
    if (v == null) {
      return '';
    }
    if (typeof v === 'string') {
      return v;
    }
    return String(v);
  }

  /**
   * 从 args 的指定下标取 string[]（鸿蒙 Dart 传 [sequence, jsonEncode(tags)] 时取 tags）
   */
  private getStringArrayFromArgsAtIndex(args: Object | null, index: number): string[] {
    if (args == null || !Array.isArray(args) || args.length <= index) {
      return [];
    }
    let v: Object | undefined = args[index];
    if (v == null) {
      return [];
    }
    if (typeof v === 'string') {
      try {
        let parsed: Object = JSON.parse(v as string) as Object;
        if (Array.isArray(parsed)) {
          return this.collectStringArray(parsed as Object[]);
        }
      } catch (_e) {
        return [v as string];
      }
      return [];
    }
    if (Array.isArray(v)) {
      return this.collectStringArray(v);
    }
    if (typeof v === 'object') {
      return this.collectStringArrayFromArrayLike(v);
    }
    return [];
  }

  private getNumberParam(params: Record<string, Object> | null, key: string): number {
    if (params == null) {
      return 0;
    }
    let v: Object | undefined = params[key];
    if (v == null) {
      return 0;
    }
    if (typeof v === 'number') {
      return v;
    }
    if (typeof v === 'string') {
      let n = parseInt(v, 10);
      return isNaN(n) ? 0 : n;
    }
    return 0;
  }

  private getStringParam(params: Record<string, Object> | null, key: string): string {
    if (params == null) {
      return '';
    }
    let v: Object | undefined = params[key];
    if (v == null) {
      return '';
    }
    if (typeof v === 'string') {
      return v;
    }
    return String(v);
  }

  /**
   * 从 params 解析出 string[]（如 tags）
   * 兼容：tags 为真实 Array，或 MethodChannel 桥接后的 array-like 对象（含 length、数字下标）
   */
  private getStringArrayParam(params: Record<string, Object> | null, key: string): string[] {
    if (params == null) {
      return [];
    }
    let v: Object | undefined = params[key];
    if (v == null) {
      return [];
    }
    if (typeof v === 'string') {
      try {
        let parsed: Object = JSON.parse(v as string) as Object;
        if (Array.isArray(parsed)) {
          return this.collectStringArray(parsed as Object[]);
        }
      } catch (_e) {
        return [v];
      }
      return [];
    }
    if (Array.isArray(v)) {
      return this.collectStringArray(v);
    }
    if (typeof v === 'object') {
      return this.collectStringArrayFromArrayLike(v);
    }
    return [];
  }

  private collectStringArray(arr: Object[]): string[] {
    let out: string[] = [];
    for (let i = 0; i < arr.length; i++) {
      let item: Object | undefined = arr[i];
      if (item != null && typeof item === 'string') {
        out.push(item);
      } else {
        out.push(String(item));
      }
    }
    return out;
  }

  private collectStringArrayFromArrayLike(obj: Object): string[] {
    let out: string[] = [];
    let rec = obj as Record<string, Object>;
    let len = rec['length'];
    let n: number;
    if (typeof len === 'number' && len >= 0) {
      n = Math.floor(len);
    } else {
      return out;
    }
    for (let i = 0; i < n; i++) {
      let item: Object | undefined = rec[String(i)];
      if (item != null && typeof item === 'string') {
        out.push(item);
      } else {
        out.push(String(item));
      }
    }
    return out;
  }

  // ---------- 供 EntryAbility / PushMessageAbility / RemoteNotificationExtensionAbility 调用的静态封装 ----------

  /**
   * 设置点击通知时的 Want，供 EntryAbility 在 onCreate/onNewWant 中调用
   */
  static setClickWant(want: Want, context: common.UIAbilityContext): void {
    EPushInterface.setClickWant(want, context);
  }

  /**
   * 后台自定义消息处理，供 PushMessageAbility receiveMessage('BACKGROUND') 回调中调用
   * @param data 即 pushService.receiveMessage('BACKGROUND', ...) 回调的 pushCommon.PushPayload
   */
  static async customMessageBackgroundData(data: pushCommon.PushPayload) {
    return await EPushInterface.customMessageBackgroundData(data);
  }

  /**
   * 拓展通知消息处理，供 PushMessageAbility receiveMessage('IM') 回调中调用
   */
  static async extraMessageBackgroundData(data: pushCommon.PushPayload) {
    return await EPushInterface.extraMessageBackgroundData(data);
  }

  /**
   * VoIP 消息处理，供 PushMessageAbility receiveMessage('VoIP') 回调中调用
   */
  static async voIPMessageBackgroundData(data: pushCommon.PushPayload) {
    return await EPushInterface.voIPMessageBackgroundData(data);
  }

  /**
   * 通知扩展接收消息，供 RemoteNotificationExtensionAbility.onReceiveMessage 中调用
   * @param rNEAbility 即 RemoteNotificationExtensionAbility 的 this
   * @param remoteNotificationInfo 即 onReceiveMessage 的 pushCommon.RemoteNotificationInfo 参数
   */
  static async receiveExtraDataMessage(rNEAbility: RemoteNotificationExtensionAbility,
    remoteNotificationInfo: pushCommon.RemoteNotificationInfo) {
    return await EPushInterface.receiveExtraDataMessage(rNEAbility, remoteNotificationInfo)
  }

}