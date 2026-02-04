# API 说明

## 注册监听

### FlutterPluginEngagelab.addEventHandler （android/ios/鸿蒙都支持）

#### 参数说明
- message:返回的事件数据
  - message["event_name"]: 为事件类型
    - iOS/android/鸿蒙 通用:
      - "onConnectStatus":长连接状态回调
      - "onNotificationArrived":通知消息到达回调 (iOS只有前台收到通知会回调该事件)
      - "onNotificationClicked":通知消息点击回调
      - "onCustomMessage":自定义消息回调
      - "onTagMessage":tag操作回调
      - "onAliasMessage":alias操作回调
  
    - iOS/android 通用:
      - "onInAppMessageShow": 应用内消息展示
      - "onInAppMessageClick": 应用内消息点击
  
    - android Only:
      - "onNotificationStatus":应用通知开关状态回调,内容类型为boolean，true为打开，false为关闭
      - "onNotificationDeleted":通知消息删除回调，内容为通知消息体
      - "onPlatformToken":厂商token消息回调，内容为厂商token消息体
      - "onNotificationUnShow":在前台，通知消息不显示回调（后台下发的通知是前台信息时）
     
    - iOS Only:
      - "checkNotificationAuthorization":检测通知权限授权情况，iOS调用checkNotificationAuthorization方法的返回回调事件。
      - "onNotiInMessageShow": 增强提醒展示
      - "onNotiInMessageClick": 增强提醒点击
      - "onSetUserLanguage": 设置用户语言，iOS调用setUserLanguage:方法的返回回调事件。
      - "onReceiveDeviceToken": 收到deviceToken
      - "willPresentNotification":通知消息到达回调，内容为通知消息体, 建议使用onNotificationArrived替代
      - "didReceiveNotificationResponse":通知消息点击回调，内容为通知消息体, 建议使用onNotificationClicked替代,注意返回字段需要重新适配
      - "networkDidLogin":登陆成功, 可以使用onConnectStatus代替,注意返回字段需要重新适配
      - "addTags":添加tag回调，可以使用onTagMessage替代,注意返回字段需要重新适配
      - "setTags":设置tag回调， 可以使用onTagMessage替代,注意返回字段需要重新适配
      - "deleteTags":删除tag回调，可以使用onTagMessage替代,注意返回字段需要重新适配
      - "cleanTags":清除tag回调，可以使用onTagMessage替代,注意返回字段需要重新适配
      - "getAllTags":获取tag回调，可以使用onTagMessage替代,注意返回字段需要重新适配
      - "validTag":校验tag回调，可以使用onTagMessage替代,注意返回字段需要重新适配
      - "setAlias":设置Alias回调，可以使用onAliasMessage替代,注意返回字段需要重新适配
      - "deleteAlias":删除Alias回调，可以使用onAliasMessage替代,注意返回字段需要重新适配
      - "getAlias":获取Alias回调，可以使用onAliasMessage替代,注意返回字段需要重新适配
      - "networkDidReceiveMessage":自定义消息回调，内容为通知消息体, 可以使用onCustomMessage替代,注意返回字段需要重新适配
  
    - 鸿蒙 Only
      - "onNotificationUnShow": 在前台，通知消息不显示回调（鸿蒙会回调，后台下发的通知是前台信息时）
  - message["event_data"]: 为对应内容，各事件的返回值说明如下。

#### 事件返回值说明

##### iOS/android/鸿蒙 通用事件

- **onConnectStatus** - 长连接状态回调
  - 返回值类型：JSON对象，包含以下字段：
    - "enable": boolean - 连接状态，true为连接，false为断开

- **onNotificationArrived** - 通知消息到达回调
  - 返回值类型：JSON对象，包含以下字段：
    - "messageId": string - 消息ID
    - "content": string - 通知内容
    - "title": string - 通知标题
    - "extras": object - 扩展字段（键值对）

- **onNotificationClicked** - 通知消息点击回调
  - 返回值类型：同 onNotificationArrived，JSON对象结构相同

- **onCustomMessage** - 自定义消息回调
  - 返回值类型：JSON对象，包含以下字段：
    - "messageId": string - 消息ID
    - "content": string - 消息内容
    - "title": string - 消息标题
    - "extras": object - 扩展字段（键值对）

- **onTagMessage** - tag操作回调
  - 返回值类型：JSON对象，包含以下字段：
    - "code": number - 操作结果码，0表示成功
    - "sequence": number - 请求序列号
    - "tags": array - 标签数组
    - "queryTag": string - 查询的标签（仅查询标签操作时有效）
    - "isBind": boolean - 查询标签是否绑定（仅查询标签操作时有效，true表示已绑定，false表示未绑定）

- **onAliasMessage** - alias操作回调
  - 返回值类型：JSON对象，包含以下字段：
    - "alias": string - 别名
    - "code": number - 操作结果码，0表示成功
    - "sequence": number - 请求序列号
  
##### iOS/android 通用事件

- **onInAppMessageShow** - 应用内消息展示
  - 返回值类型：JSON对象，包含以下字段：
    - "messageId": string - 消息ID
    - "target": string - 目标标识
    - "content": string - 消息内容
    - "clickAction": string - 点击动作
    - "extras": object - 扩展字段（键值对）

- **onInAppMessageClick** - 应用内消息点击
  - 返回值类型：同 onInAppMessageShow，JSON对象结构相同

##### Android Only 事件

- **onNotificationStatus** - 应用通知开关状态回调
  - 返回值类型：JSON对象，包含以下字段：
    - "enable": boolean - 通知开关状态，true为打开，false为关闭

- **onNotificationDeleted** - 通知消息删除回调
  - 返回值类型：JSON对象，包含以下字段：
    - "messageId": string - 消息ID
    - "content": string - 通知内容
    - "title": string - 通知标题
    - "extras": object - 扩展字段（键值对）

- **onPlatformToken** - 厂商token消息回调
  - 返回值类型：JSON对象，包含以下字段：
    - "platform": string - 平台标识
    - "token": string - 厂商token

- **onNotificationUnShow** - 前台通知消息不显示回调
  - 返回值类型：JSON对象，包含以下字段：
    - "messageId": string - 消息ID
    - "content": string - 通知内容
    - "title": string - 通知标题
    - "extras": object - 扩展字段（键值对）

##### iOS Only 事件

- **checkNotificationAuthorization** - 检测通知权限授权情况
  - 返回值类型：JSON对象，包含以下字段：
    - "enable": boolean - 授权状态，true为已授权，false为未授权

- **onNotiInMessageShow** - 增强提醒展示
  - 返回值类型：JSON对象，包含以下字段：
    - "messageId": string - 消息ID
    - "content": string - 通知内容
    - "title": string - 通知标题
    - "extras": object - 扩展字段（键值对）

- **onNotiInMessageClick** - 增强提醒点击
  - 返回值类型：JSON对象，包含以下字段：
    - "messageId": string - 消息ID
    - "content": string - 通知内容
    - "title": string - 通知标题
    - "extras": object - 扩展字段（键值对）

- **onSetUserLanguage** - 设置用户语言回调
  - 返回值类型：JSON对象，包含以下字段：
    - "code": number - 操作结果码，0表示成功
    - "error": string - 错误信息（失败时存在）

- **onReceiveDeviceToken** - 收到deviceToken回调
  - 返回值类型：JSON对象，包含以下字段：
    - "deviceToken": string - 设备token字符串

#### 代码示例

```js
FlutterPluginEngagelab.addEventHandler(
        onMTCommonReceiver: (Map<String, dynamic> message) async {
  FlutterPluginEngagelab.printMy("flutter onMTCommonReceiver: $message");
  String event_name = message["event_name"];
  String event_data = message["event_data"];
});
```


## 设置AppKey - android

### configAppKeyAndroid

设置appKey, 在初始化函数之前调用

#### 接口定义

```js
  FlutterPluginEngagelab.configAppKeyAndroid("appkey");
```

## 初始化

### initAndroid （android）
### initIos （ios）
### initOhos （鸿蒙）

初始化 sdk。鸿蒙需在 initOhos 之前先调用 setAppKey、setChannel；回调通过 addEventHandler 的 onMTCommonReceiver 接收，插件内部已注册 CallBackMsg。

#### 接口定义

```js
if (Platform.isIOS) {
  FlutterPluginEngagelab.initIos(
          appKey: "你的appkey",
          channel: "testChannel",
  );
} else if (Platform.isAndroid) {
  FlutterPluginEngagelab.initAndroid();
} else {
  // 鸿蒙
  FlutterPluginEngagelab.setAppKey("你的appKey");
  FlutterPluginEngagelab.setChannel("testChannel");
  FlutterPluginEngagelab.initOhos();
}
```


### setAppKey（鸿蒙）

在 **initOhos 之前** 设置 EngageLab 控制台应用的 appKey。

#### 接口定义

```js
FlutterPluginEngagelab.setAppKey("你的appKey");
```

### setChannel（鸿蒙）

在 **initOhos 之前** 设置渠道名，与 EngageLab 控制台一致即可。

#### 接口定义

```js
FlutterPluginEngagelab.setChannel("testChannel");
```

### 标签与别名（鸿蒙）

鸿蒙端支持与 Android 一致的标签、别名接口，结果通过 **addEventHandler** 的 **onTagMessage**、**onAliasMessage** 回调。Dart 侧调用方式与 Android/iOS 一致，传参为字典；鸿蒙原生会按 `[sequence, jsonEncode(tags)]` 等格式传参，无需业务侧区分。

| 方法 | 说明 | Dart 传参 |
|------|------|-----------|
| addTags | 新增标签（累加） | params = { "sequence": number, "tags": ["tag1", "tag2"] } |
| deleteTags | 删除指定标签 | 同上 |
| updateTags | 更新标签（覆盖，对应 SDK setTags） | 同上 |
| queryTag | 查询指定标签是否绑定（checkTagBindState） | params = { "sequence": number, "tag": "tag1" } |
| deleteAllTag | 删除所有标签（cleanTags） | sequence: number |
| queryAllTag | 查询所有标签（getTags，第 1 页） | sequence: number |
| setAlias | 设置别名 | sequence: number, alias: string |
| getAlias | 获取别名 | sequence: number |
| clearAlias | 清除别名（deleteAlias） | sequence: number |

#### 接口定义示例

```js
FlutterPluginEngagelab.addTags({ "sequence": 1, "tags": ["tag1", "tag2"] });
FlutterPluginEngagelab.deleteTags({ "sequence": 2, "tags": ["tag1"] });
FlutterPluginEngagelab.updateTags({ "sequence": 3, "tags": ["a", "b"] });
FlutterPluginEngagelab.queryTag({ "sequence": 4, "tag": "tag1" });
FlutterPluginEngagelab.deleteAllTag(5);
FlutterPluginEngagelab.queryAllTag(6);
FlutterPluginEngagelab.setAlias(7, "myAlias");
FlutterPluginEngagelab.getAlias(8);
FlutterPluginEngagelab.clearAlias(9);
```

#### 鸿蒙注意事项

- 请先 **initOhos** 后再调用标签/别名接口，否则无效。
- sequence 建议每次操作使用不同数字，便于在 onTagMessage/onAliasMessage 中区分。
- 标签长度限制 40 字节，单设备最多约 1000 个；别名长度限制 40 字节。详见 [EngageLab HarmonyOS SDK API](https://www.engagelab.com/zh_CN/docs/app-push/developer-guide/client-sdk-reference/harmonyOS-sdk/sdk-api-guide)。


## 设置数据中心 - 该方法在v1.2.2版本中已失效，不需要调用

### setSiteName

设置数据中心, 在初始化函数之前调用

#### 接口定义

```js
  FlutterPluginEngagelab.setSiteName("Singapore");
```

## 设置用户语言

### setUserLanguage

设置用户语言

#### 接口定义

```js
  FlutterPluginEngagelab.setUserLanguage("zh-Hans-CN");
```

## 开启 Debug 模式

### configDebugMode （android/ios/鸿蒙都支持）

设置是否 debug 模式，debug 模式会打印更多详细日志。鸿蒙对应 EngageLab SDK 的 setDebug，需在 init 之前调用。

#### 接口定义

```js
FlutterPluginEngagelab.configDebugMode(enable)
```

#### 参数说明

- enable: 是否调试模式，true为调试模式，false不是

#### 代码示例

```js
FlutterPluginEngagelab.configDebugMode(true);//发布前要删除掉
```

## 获取 RegistrationID （android/ios/鸿蒙都支持）

### getRegistrationId

RegistrationID 定义:
获取当前设备的registrationId，Engagelab私有云唯一标识，可同于推送

#### 接口定义

```js
FlutterPluginEngagelab.getRegistrationId()
```

#### 返回值

调用此 API 来取得应用程序对应的 RegistrationID。只有当应用程序成功注册到 EngageLab 的服务器时才返回对应的值，否则返回空字符串。Android、iOS、鸿蒙均支持。

#### 代码示例

```js
FlutterPluginEngagelab.getRegistrationId().then((rid){
  FlutterPluginEngagelab.printMy("flutter get registration id : $rid");
});
```

## 设置iOS通知前台是否展示

### setUnShowAtTheForegroundIos （仅支持ios）

设置iOS通知前台是否展示

#### 接口定义

```js
FlutterPluginEngagelab.setUnShowAtTheForegroundIos(enable)
```

#### 参数说明

- enable: ios通知前台是否展示，true为不展示，false展示

#### 代码示例

```js
FlutterPluginEngagelab.setUnShowAtTheForegroundIos(true);
```

## 发送一个本地通知

### sendLocalNotification

添加本地推送通知

/** PRIORITY与IMPORTANCE 相互转换关系
   * PRIORITY_MIN = -2 对应 IMPORTANCE_MIN = 1;
   * PRIORITY_LOW = -1; 对应 IMPORTANCE_LOW = 2;
   * PRIORITY_DEFAULT = 0; 对应 IMPORTANCE_DEFAULT = 3;
   * PRIORITY_HIGH = 1; 对应 IMPORTANCE_HIGH = 4;
   * PRIORITY_MAX = 2; 对应 IMPORTANCE_MAX = 5;
*/

#### 接口定义
```js
var fireDate = DateTime.fromMillisecondsSinceEpoch(
DateTime.now().millisecondsSinceEpoch + 3000);
var localNotification = LocalNotification(
                          id: 234,
                          title: 'fadsfa',
                          content: 'fdas',
                          fireTime: fireDate, // iOS only
                          subtitle: 'fasf',  // iOS only
                          category: 'local', // Android only
                          priority: 2,  // Android only
                          badge: 5,   // iOS only
                          extra: {"fa": "0"});
FlutterPluginEngagelab.sendLocalNotification(localNotification)
```

## 设置设备迁移功能

### setEnableResetOnDeviceChange

开启或者关闭设备更换时重置RegistrationID的功能。若开启时，当检测到设备发生变化时（只有当设备型号发生变化时），会自动清除注册信息，重新注册。

#### 接口定义

```js
FlutterPluginEngagelab.setEnableResetOnDeviceChange(enable)
```

#### 参数说明

- enable: true为启用，false为禁用，默认为false

#### 代码示例

```js
// 启用设备迁移功能
FlutterPluginEngagelab.setEnableResetOnDeviceChange(true);

// 禁用设备迁移功能（默认状态）
FlutterPluginEngagelab.setEnableResetOnDeviceChange(false);
```

#### 注意事项

- 请在初始化接口前调用
- 当设备型号发生变化时（如刷机、换设备等），会自动清除本地缓存的注册信息

## 设置应用角标（iOS 5.2.0+）

### setBadge

设置应用角标数量，带完成回调（iOS 5.2.0+）

#### 接口定义

```js
FlutterPluginEngagelab.setBadge(badge)
```

#### 参数说明

- badge: 要设置的角标数量

#### 返回值

返回一个Map，包含：
- success: boolean - 操作是否成功
- error: string - 操作失败时的错误信息

#### 代码示例

```js
FlutterPluginEngagelab.setBadge(5).then((result) {
  if (result['success']) {
    FlutterPluginEngagelab.printMy("角标设置成功");
  } else {
    FlutterPluginEngagelab.printMy("角标设置失败: ${result['error']}");
  }
});
```

## 设置数据采集控制（Android 5.2.0+）

### setCollectControl

设置数据采集控制（Android 5.2.0+，5.3.0版本新增aid参数）

#### 接口定义

```js
FlutterPluginEngagelab.setCollectControl({gaid: bool?, aid: bool?})
```

#### 参数说明

- gaid: boolean? - 是否启用GAID采集（可选）
- aid: boolean? - 是否启用AndroidId采集（可选，5.3.0版本新增）

#### 代码示例

```js
// 设置GAID采集
FlutterPluginEngagelab.setCollectControl(gaid: true);

// 设置AndroidId采集（5.3.0+）
FlutterPluginEngagelab.setCollectControl(aid: false);

// 同时设置两者
FlutterPluginEngagelab.setCollectControl(gaid: true, aid: false);
```

## 设置是否启用UDP

### setEnableUdp

设置是否允许SDK使用UDP，默认是允许（iOS和Android都支持）

#### 接口定义

```js
FlutterPluginEngagelab.setEnableUdp(enable)
```

#### 参数说明

- enable: boolean - true为允许使用UDP，false为不允许使用UDP

#### 注意事项

- 此接口必须要在SDK启动前进行设置
- 默认为允许（true）

#### 代码示例

```js
// 允许使用UDP
FlutterPluginEngagelab.setEnableUdp(true);

// 不允许使用UDP
FlutterPluginEngagelab.setEnableUdp(false);
```

## 语言播报功能

## 开启或关闭语音播报功能

### setEnablePushTextToSpeech

开启或者关闭语音播报功能（iOS和Android都支持）

#### 接口定义

```js
FlutterPluginEngagelab.setEnablePushTextToSpeech(enable)
```

#### 参数说明

- enable: boolean - true为打开，false为关闭，默认为false

#### 注意事项

- 请在初始化接口前调用
- 默认为关闭

#### 代码示例

```js
// 开启语音播报
FlutterPluginEngagelab.setEnablePushTextToSpeech(true);

// 关闭语音播报
FlutterPluginEngagelab.setEnablePushTextToSpeech(false);
```

## 设置appGroupId（仅iOS）

### setAppGroupId

设置appGroupId，用于主工程和notification service extension共享存储空间（仅iOS）

#### 接口定义

```js
FlutterPluginEngagelab.setAppGroupId(appGroupId)
```

#### 参数说明

- appGroupId: string - 您为bundleid开通appGroupId能力时填写的appGroupId

#### 注意事项

- 仅iOS支持
- 请在初始化接口前调用
- appGroupId需要与notification service extension 中通过 mtpushSetAppGroupId: 方法设置的appGroupId 一致
- 用来定义主工程和notification service extension 共享存储空间，该空间用来存储语音播报相关资源

#### 代码示例

```js
if (Platform.isIOS) {
  FlutterPluginEngagelab.setAppGroupId("group.com.engagelab.push");
}
```

### iOS语言播报功能使用说明

使用该功能需要为您的bundleid开启appGroups功能。开启appGroups功能的步骤请参考 [iOS 证书设置指南](https://www.engagelab.com/zh_CN/docs/app-push/developer-guide/client-sdk-reference/ios-sdk/ios-certificate-setting-guide)。

该功能支持iOS14及以上的系统。

受系统限制，语音播报的时长和手机通知弹出展示的时间大致保持一致（大概10秒左右，不同系统可能会有稍许差异），通知弹出消失时语音播报也会停止，请注意控制播报的语音时长。

您需要在您的工程中添加一个Notification Service Extension。并用原生的方式集成 Engagelab的 Notification Service Extension SDK （请参考 [iOS 集成指南](https://www.engagelab.com/zh_CN/docs/app-push/developer-guide/client-sdk-reference/ios-sdk/ios-sdk-integration-guide#%E9%80%9A%E7%9F%A5%E9%80%81%E8%BE%BE%E7%BB%9F%E8%AE%A1)）。

```

然后按照以下的示例代码在Notification Service Extension中处理语音文件。

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {

  UNMutableNotificationContent *bestAttemptContent = [request.content mutableCopy];

  // 这个方法设置的appgroudid需要和工程中设置的appgroudid保持一致。
  [MTNotificationExtensionService mtpushSetAppGroupId:@"xxx"]; 
  // 设置appkey
  [MTNotificationExtensionService mtpushSetAppkey:@"您的appkey"];
  
  // 处理语音文件
  [MTNotificationExtensionService handleVoice:request with:^(NSString *soundName) {
      if (soundName && soundName.length >= 0 ) {
        // 语音文件处理成功后将通知的sound设置为处理好的语音文件名
        bestAttemptContent.sound = [UNNotificationSound soundNamed:soundName];
      }
      // 继续调用推送统计上报功能api
    [MTNotificationExtensionService mtpushReceiveNotificationRequest:request with:^ {
      NSLog(@"apns upload success");
      self.contentHandler(bestAttemptContent);
    }];
    
  }];

}

```

同时在flutter中，需要调用以下两个接口开启语音播报功能。

```
FlutterPluginEngagelab.setEnablePushTextToSpeech(true);
FlutterPluginEngagelab.setAppGroupId("your appGroupId");
```

### Android语言播报功能使用说明

只需要在flutter中调用以下接口开启语音播报功能。
```
FlutterPluginEngagelab.setEnablePushTextToSpeech(true);
```


### 鸿蒙其余 API

鸿蒙端已对接 EPushInterface 文档中的以下能力，对应 Dart 方法如下（均在 **initOhos 之后** 按需调用）。

| 能力 | Dart 方法 | 说明 |
|------|-----------|------|
| 开启推送 | `turnOnPush()` | 对应 resumePush，当前仅鸿蒙实现 |
| 关闭推送 | `turnOffPush()` | 对应 stopPush，当前仅鸿蒙实现 |
| 查询推送是否停止 | `isPushStopped()` → Future&lt;bool&gt; | 对应 isPushStopped，当前仅鸿蒙实现 |
| 设置心跳周期 | `configHeartbeatInterval(int intervalMs)` | 单位毫秒，对应 setHeartbeatTime，当前仅鸿蒙实现 |
| 设置 TCP SSL | `setTcpSSL(bool enable)` | 对应 setTcpSSl，当前仅鸿蒙实现 |
| 设置角标 | `setBadge(int badge)` | iOS/鸿蒙均支持，见上文 setBadge |
| 按通知 ID 清除 | `clearNotification(notifyId)` | 通用，鸿蒙已实现 |
| 按消息 ID 清除 | `clearNotificationByMsgId(String msgId)` | 通用，鸿蒙已实现 |
| 清除所有通知 | `clearNotificationAll()` | 通用，鸿蒙已实现 |
| 自定义消息缓存条数 | `setCustomMessageMaxCacheCount(int count)` | 对应 setCustomMessageMaxCacheCount，当前仅鸿蒙实现 |
| 通知权限申请方式 | `setUserRequestNotificationPermission(bool enable)` | 对应 setUserRequestNotificationPermission，当前仅鸿蒙实现 |
| 清除 Token | `clearToken()` | 对应 clearToken，当前仅鸿蒙实现 |
| 上报通知点击 | `reportNotificationClick(int channel, String msgId)` | channel: 0 厂商 1 EngageLab，当前仅鸿蒙实现 |
| 上报通知展示 | `reportNotificationDisplay(int channel, String msgId)` | 同上 |
| 上报自定义消息展示 | `reportCustomDisplay(int channel, String msgId)` | channel: 0 厂商 1 EngageLab，当前仅鸿蒙实现 |
| 上报自定义消息点击 | `reportCustomClick(int channel, String msgId)` | 同上，当前仅鸿蒙实现 |

#### 代码示例（鸿蒙）

```dart
// 开启/关闭推送
FlutterPluginEngagelab.turnOnPush();
FlutterPluginEngagelab.turnOffPush();

// 查询是否已停止
bool stopped = await FlutterPluginEngagelab.isPushStopped();

// 角标（iOS/鸿蒙）
await FlutterPluginEngagelab.setBadge(5);

// 清除通知
FlutterPluginEngagelab.clearNotification(123);
FlutterPluginEngagelab.clearNotificationByMsgId("msgId");
FlutterPluginEngagelab.clearNotificationAll();

// 上报点击（鸿蒙：channel 0 厂商 1 EngageLab）
FlutterPluginEngagelab.reportNotificationClick(1, "msgId");
```