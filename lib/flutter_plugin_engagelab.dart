import 'dart:async';

import 'package:flutter/services.dart';

import 'dart:io' show Platform;

typedef Future<dynamic> EventHandler(Map<String, dynamic> event);

class FlutterPluginEngagelab {
  static const String flutter_log = "| ENGAGELAB-PRIVATES-Flutter | ";
  static const MethodChannel _channel =
      MethodChannel('flutter_plugin_engagelab');

  static bool debug = false;

  static EventHandler? _onMTCommonReceiver;

  static void printMy(msg) {
    if (debug) {
      print(flutter_log + "::" + msg);
    }
  }

  static void addEventHandler({EventHandler? onMTCommonReceiver}) {
    _onMTCommonReceiver = onMTCommonReceiver;
    _channel.setMethodCallHandler(_handleMethod);
  }

  static Future<dynamic> _handleMethod(MethodCall call) {
    printMy("_handleMethod");
    printMy("_handleMethod method: " + call.method.toString());
    printMy("_handleMethod data: " + call.arguments.toString());
    switch (call.method) {
      case "onMTCommonReceiver":
        printMy("_handleMethod _onMTCommonReceiver: " +
            _onMTCommonReceiver.toString());
        return _onMTCommonReceiver!(call.arguments.cast<String, dynamic>());
      default:
        return call.arguments;
    }
  }

  static void errorCallback(msg) {
    printMy("errorCallback Error: " + msg.toString());
  }

  static initIos({
    String appKey = '',
    bool isProduction = false,
    String channel = '',
    bool isIdfa = false,
  }) {
    printMy(" init");
    _channel.invokeMethod('init', [
      {
        "appKey": appKey,
        "channel": channel,
        "production": isProduction,
        "idfa": isIdfa
      }
    ]);
  }

  static initAndroid() {
    printMy(" init");
    _channel.invokeMethod('init');
  }

  /**
   * 设置数据中心 --- 该接口在1.2.1版本后失效，不需要调用
   * <p>
   * 需要在Application.onCreate()方法中调用， 
   * iOS 需要在initIos方法前调用
   *
   * @param siteName 数据中心的名字
   */
  static setSiteName(siteName) {
    // printMy("setSiteName");
    // _channel.invokeMethod('setSiteName', [siteName]);
  }

  /**
   * 设置用户语言
   */
  static setUserLanguage(language) {
    printMy("setUserLanguage");
    _channel.invokeMethod('setUserLanguage', [language]);
  }

  static configAppKeyAndroid(appKey) {
    printMy("configAppKeyAndroid");
    _channel.invokeMethod('configAppKey', [appKey]);
  }

/**
   * 设置iOS在前台是否展示通知
   * @param enable  是否展示通知，true为调试模式，false不是
   */
  static setUnShowAtTheForegroundIos(enable) {
    printMy("setUnShowAtTheForegroundIos:" + enable.toString());
    _channel.invokeMethod("setUnShowAtTheForeground", [enable]);
  }

  /**
   * 设置心跳时间间隔
   * <p>
   * 需要在Application.onCreate()方法中调用
   *
   * @param heartbeatInterval 时间单位为毫秒、必须大于0、默认值是4分50秒\
   */
  static configHeartbeatIntervalAndroid(heartbeatInterval) {
    printMy("configHeartbeatInterval" + heartbeatInterval.toString());
    _channel.invokeMethod("configHeartbeatInterval", [heartbeatInterval]);
  }

  /**
   * 设置长连接重试次数
   * <p>
   * 需要在Application.onCreate()方法中调用
   * @param connectRetryCount 重试的次数、默认值为3、最少3次
   */
  static configConnectRetryCountAndroid(connectRetryCount) {
    printMy("configConnectRetryCount" + connectRetryCount.toString());
    _channel.invokeMethod("configConnectRetryCount", [connectRetryCount]);
  }

  /**
   * 设置是否debug模式，debug模式会打印更对详细日志
   * <p>
   * 需要在Application.onCreate()方法中调用
   *
   * @param context 不为空
   * @param enable  是否调试模式，true为调试模式，false不是
   */
  static configDebugMode(enable) {
    debug = enable;
    printMy("configDebugMode:" + enable.toString());
    _channel.invokeMethod("configDebugMode", [enable]);
  }

  /**
   * 配置使用国密加密
   *
   * @param context 不为空
   */
  static configSM4Android() {
    printMy("configSM4");
    _channel.invokeMethod("configSM4", []);
  }

  /**
   * 获取当前设备的userId，Engagelab私有云唯一标识，可同于推送
   *
   * @param context 不为空
   * @return userId
   */
  static Future<String> getUserIdAndroid() async {
    printMy("getUserId");
    final String userID = await _channel.invokeMethod("getUserId", []);
    return userID;
  }

  /**
   * 获取当前设备的registrationId，Engagelab私有云唯一标识，可同于推送
   *
   * @param context 不为空
   * @return registrationId
   */
  static Future<String> getRegistrationId() async {
    printMy("getRegistrationId");
    final String rid = await _channel.invokeMethod("getRegistrationId", []);
    return rid;
  }

//    // 继承MTCommonReceiver后，复写onNotificationStatus方法，获取通知开关状态，如果enable为true说明已经开启成功
//    @Override
//    public void onNotificationStatus(Context context, boolean enable) {
//        if(enable){
//            // 已设置通知开关为打开
//        }
//    }
//    启动sdk后可根据onNotificationStatus回调结果，再决定是否需要调用此借口
  /**
   * 前往通知开关设置页面
   *
   * @param context 不为空 //TODO weiry
   */
  static goToAppNotificationSettingsAndroid() {
    printMy("goToAppNotificationSettings");
    _channel.invokeMethod("goToAppNotificationSettings", []);
  }

//    // 继承MTCommonReceiver后，复写onConnectStatus方法，获取长连接的连接状态，如果enable为true说明已经开启成功
//    @Override
//    public void onConnectStatus(Context context, boolean enable){
//        if(enable){
//            // 开启 push 推送成功
//        }
//    }

  /**
   * 开启 Push 推送，并持久化存储开关状态为true，默认是true
   *
   * @param context 不能为空
   */
  static turnOnPushAndroid() {
    printMy("turnOnPush");
    _channel.invokeMethod("turnOnPush", []);
  }

//    // 继承MTCommonReceiver后，复写onConnectStatus方法，获取长连接的连接状态，如果enable为true说明已经开启成功
//    @Override
//    public void onConnectStatus(Context context, boolean enable){
//        if(enable){
//            // 开启 push 推送成功
//        }
//    }
  /**
   * 关闭 push 推送，并持久化存储开关状态为false，默认是true
   *
   * @param context 不能为空
   */
  static turnOffPushAndroid() {
    printMy("turnOffPush");
    _channel.invokeMethod("turnOffPush", []);
  }

  /**
   * 设置通知展示时间，默认任何时间都展示
   *
   * @param context   不为空
   * @param beginHour 允许通知展示的开始时间（ 24 小时制，范围为 0 到 23 ）
   * @param endHour   允许通知展示的结束时间（ 24 小时制，范围为 0 到 23 ），beginHour不能大于等于endHour
   * @param weekDays  允许通知展示的星期数组（ 7 日制，范围为 1 到 7），空数组代表任何时候都不展示通知
   */
  static setNotificationShowTimeAndroid(
      beginHour, endHour, List<int> weekDays) {
    printMy("setNotificationShowTime");
    _channel.invokeMethod(
        "setNotificationShowTime", [beginHour, endHour, weekDays]);
  }

  /**
   * 重置通知展示时间，默认任何时间都展示
   *
   * @param context 不为空
   */
  static resetNotificationShowTimeAndroid() {
    printMy("resetNotificationShowTime");
    _channel.invokeMethod("resetNotificationShowTime", []);
  }

  /**
   * 设置通知静默时间，默认任何时间都不静默
   *
   * @param context     不为空
   * @param beginHour   允许通知静默的开始时间，单位小时（ 24 小时制，范围为 0 到 23 ）
   * @param beginMinute 允许通知静默的开始时间，单位分钟（ 60 分钟制，范围为 0 到 59 ）
   * @param endHour     允许通知静默的结束时间，单位小时（ 24 小时制，范围为 0 到 23 ）
   * @param endMinute   允许通知静默的结束时间，单位分钟（ 60 分钟制，范围为 0 到 59 ）
   */
  static setNotificationSilenceTimeAndroid(
      beginHour, beginMinute, endHour, endMinute) {
    printMy("setNotificationSilenceTime");
    _channel.invokeMethod("setNotificationSilenceTime",
        [beginHour, beginMinute, endHour, endMinute]);
  }

  /**
   * 重置通知静默时间，默认任何时间都不静默
   *
   * @param context 不为空
   */
  static resetNotificationSilenceTimeAndroid() {
    printMy("resetNotificationSilenceTime");
    _channel.invokeMethod("resetNotificationSilenceTime", []);
  }

  /**
   * 设置通知栏的通知数量，默认数量为5
   *
   * @param context 不为空
   * @param count   限制通知栏的通知数量，超出限制数量则移除最老通知，不能小于等于0
   */
  static setNotificationCountAndroid(count) {
    printMy("setNotificationCount");
    _channel.invokeMethod("setNotificationCount", [count]);
  }

  /**
   * 重置通知栏的通知数量，默认数量为5
   *
   * @param context 不为空
   */
  static resetNotificationCountAndroid() {
    printMy("resetNotificationCount");
    _channel.invokeMethod("resetNotificationCount", []);
  }

  /**
   * 设置应用角标数量，默认0（仅华为/荣耀/ios生效）
   *
   * @param context 不为空
   * @param badge   应用角标数量
   */
  static setNotificationBadge(badge) {
    printMy("setNotificationBadge");
    _channel.invokeMethod("setNotificationBadge", [badge]);
  }

  /**
   * 重置应用角标数量，默认0（仅华为/荣耀生效/ios）
   *
   * @param context 不为空
   */
  static resetNotificationBadge() {
    printMy("resetNotificationBadge");
    _channel.invokeMethod("resetNotificationBadge", []);
  }

  /**
   * 上报厂商通道通知到达
   * <p>
   * 走http/https上报
   *
   * @param context           不为空
   * @param messageId         Engagelab消息id，不为空
   * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
   * @param platformMessageId 厂商消息id，可为空
   */
  static reportNotificationArrivedAndroid(
      messageId, platform, platformMessageId) {
    printMy("reportNotificationArrived");
    _channel.invokeMethod(
        "reportNotificationArrived", [messageId, platform, platformMessageId]);
  }

  /**
   * 上报厂商通道通知点击
   * <p>
   * 走http/https上报
   *
   * @param context           不为空
   * @param messageId         Engagelab消息id，不为空
   * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
   * @param platformMessageId 厂商消息id，可为空
   */
  static reportNotificationClickedAndroid(
      messageId, platform, platformMessageId) {
    printMy("reportNotificationClicked");
    _channel.invokeMethod(
        "reportNotificationClicked", [messageId, platform, platformMessageId]);
  }

  /**
   * 上报厂商通道通知删除
   * <p>
   * 走http/https上报
   *
   * @param context           不为空
   * @param messageId         Engagelab消息id，不为空
   * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
   * @param platformMessageId 厂商消息id，可为空
   */
  static reportNotificationDeletedAndroid(
      messageId, platform, platformMessageId) {
    printMy("reportNotificationDeleted");
    _channel.invokeMethod(
        "reportNotificationDeleted", [messageId, platform, platformMessageId]);
  }

  /**
   * 上报厂商通道通知打开
   * <p>
   * 走http/https上报
   *
   * @param context           不为空
   * @param messageId         Engagelab消息id，不为空
   * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
   * @param platformMessageId 厂商消息id，可为空
   */
  static reportNotificationOpenedAndroid(
      messageId, platform, platformMessageId) {
    printMy("reportNotificationOpened");
    _channel.invokeMethod(
        "reportNotificationOpened", [messageId, platform, platformMessageId]);
  }

  /**
   * 上传厂商token
   * <p>
   * 走tcp上传
   *
   * @param context  不为空
   * @param platform 厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
   * @param token    厂商返回的token，不为空
   * @param region    //目前只有小米、OPPO才区分国内和国际版，其他厂商不区分;没有不用传
   */
  static uploadPlatformTokenAndroid(platform, token, region) {
    printMy("uploadPlatformToken");
    _channel.invokeMethod("uploadPlatformToken", [platform, token, region]);
  }

  /**
   * 清除厂商token，成功后通过onPlatformToken回调，数据platform为-128，表示清除成功
   */
  static clearPlatformTokenAndriod(){
    printMy("clearPlatformToken");
    _channel.invokeMethod("clearPlatformToken", []);
  }

  static setCountryCodeAndroid(country) {
    printMy("setCountryCode");
    _channel.invokeMethod("setCountryCode", [country]);
  }

  // iOS Only, 使用应用内消息功能的时候请配置该接口
  // 进入页面， pageName：页面名  请与pageLeave配套使用
  static pageEnterTo(String pageName) {
    printMy("pageEnterTo:" + pageName);
    if (!Platform.isIOS) {
      return;
    } else {
      _channel.invokeMethod('pageEnterTo', [pageName]);
    }
  }

  // iOS Only, 使用应用内消息功能的时候请配置该接口
  // 离开页面，pageName：页面名， 请与pageEnterTo配套使用
  static pageLeave(String pageName) {
    printMy("pageLeave:" + pageName);
    if (!Platform.isIOS) {
      return;
    } else {
      _channel.invokeMethod('pageLeave', [pageName]);
    }
  }

  /**
   * 新增标签。
   *
   * @param params = { "sequence": number, "tags": ["tag1", "tag2"] }
   */
  static addTags(params) {
    printMy("addTags");
    _channel.invokeMethod("addTags", [params]);
  }

  /**
   * 删除标签。
   *
   * @param params = { "sequence": number, "tags": ["tag1", "tag2"] }
   */
  static deleteTags(params) {
    printMy("deleteTags");
    _channel.invokeMethod("deleteTags", [params]);
  }

  /**
   * 更新标签。ios setTags
   *
   * @param params = { "sequence": number, "tags": ["tag1", "tag2"] }
   */
  static updateTags(params) {
    printMy("updateTags");
    _channel.invokeMethod("updateTags", [params]);
  }

  /**
   * 查询标签。 ios为校验validTag
   *
   * @param params = { "sequence": number, "tag": "tag1" }
   */
  static queryTag(params) {
    printMy("queryTag");
    _channel.invokeMethod("queryTag", [params]);
  }

  /**
   * 删除所有标签。
   *
   * @param sequence = number
   */
  static deleteAllTag(sequence) {
    printMy("deleteAllTag");
    _channel.invokeMethod("deleteAllTag", [sequence]);
  }

  /**
   * 查询所有标签。
   *
   * @param sequence = number
   */
  static queryAllTag(sequence) {
    printMy("queryAllTag");
    _channel.invokeMethod("queryAllTag", [sequence]);
  }

  /**
   * 设置别名。
   *
   * @param sequence = number
   * @param alias = string
   */
  static setAlias(sequence, alias) {
    printMy("setAlias");
    _channel.invokeMethod("setAlias", [sequence, alias]);
  }

  /**
   * 获取别名。
   *
   * @param sequence = number
   */
  static getAlias(sequence) {
    printMy("getAlias");
    _channel.invokeMethod("getAlias", [sequence]);
  }

  /**
   * 清除别名。
   *
   * @param sequence = number
   */
  static clearAlias(sequence) {
    printMy("clearAlias");
    _channel.invokeMethod("clearAlias", [sequence]);
  }

  /**
   * 检测通知权限授权情况
   */
  static checkNotificationAuthorizationIos() {
    printMy("checkNotificationAuthorizationIos");
    _channel.invokeMethod("checkNotificationAuthorization", []);
  }

  /**
   * @param enable  tcp是否加密，true为加密，false为不加密
   */
  static setTcpSSLIos(enable) {
    printMy("setTcpSSL:" + enable.toString());
    _channel.invokeMethod("setTcpSSL", [enable]);
  }

  ///
  /// 发送本地通知到调度器，指定时间出发该通知。
  /// @param {Notification} notification
  ///
  static Future<String> sendLocalNotification(
      LocalNotification notification) async {
    print(flutter_log + "sendLocalNotification:");

    await _channel
        .invokeMethod('sendLocalNotification', [notification.toMap()]);

    return notification.toMap().toString();
  }

  static clearNotification(notifyId) {
    printMy("clearNotification");
    _channel.invokeMethod("clearNotification", [notifyId]);
  }

  static clearNotificationAll() {
    printMy("clearNotificationAll");
    _channel.invokeMethod("clearNotificationAll", []);
  }
}

/// @property {number} [id] - 通知 id, 可用于取消通知
/// @property {string} [title] - 通知标题
/// @property {string} [content] - 通知内容
/// @property {object} [extra] - extra 字段
/// // Android Only
/// @property {number} [priority] - 级别
/// // Android Only
/// @property {string} [category] - 类型
/// // iOS Only
/// @property {number} [fireTime] - 通知触发时间（毫秒）
/// // iOS Only
/// @property {number} [badge] - 本地推送触发后应用角标值
/// // iOS Only
/// @property {string} [soundName] - 指定推送的音频文件
/// // iOS 10+ Only
/// @property {string} [subtitle] - 子标题

/** PRIORITY与IMPORTANCE 相互转换关系
   * PRIORITY_MIN = -2 对应 IMPORTANCE_MIN = 1;
   * PRIORITY_LOW = -1; 对应 IMPORTANCE_LOW = 2;
   * PRIORITY_DEFAULT = 0; 对应 IMPORTANCE_DEFAULT = 3;
   * PRIORITY_HIGH = 1; 对应 IMPORTANCE_HIGH = 4;
   * PRIORITY_MAX = 2; 对应 IMPORTANCE_MAX = 5;
   */

class LocalNotification {
  final int? id;
  final String? title;
  final String? content;
  final int? priority;
  final String? category;
  final Map<String, String>? extra; //?
  final DateTime? fireTime;
  final int? badge; //?
  final String? soundName; //?
  final String? subtitle; //?

  const LocalNotification(
      {this.id,
      this.title,
      this.content,
      this.fireTime,
      this.extra,
      this.priority,
      this.category,
      this.badge = 0,
      this.soundName,
      this.subtitle})
      : assert(id != null),
        assert(title != null),
        assert(content != null),
        assert(fireTime != null);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'fireTime': fireTime?.millisecondsSinceEpoch,
      'priority': priority,
      'category': category,
      'extra': extra,
      'badge': badge,
      'soundName': soundName,
      'subtitle': subtitle
    }..removeWhere((key, value) => value == null);
  }
}
