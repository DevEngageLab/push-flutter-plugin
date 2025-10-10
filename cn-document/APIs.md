# API 说明

## 注册监听

### FlutterPluginEngagelab.addEventHandler （android/ios都支持）

集成了 sdk 回调的事件

#### 参数说明
- message:反回的事件数据
  - message["event_name"]: 为事件类型
    - android:
      - "onNotificationStatus":应用通知开关状态回调,内容类型为boolean，true为打开，false为关闭
      - "onConnectStatus":长连接状态回调,内容类型为boolean，true为连接
      - "onNotificationArrived":通知消息到达回调，内容为通知消息体
      - "onNotificationClicked":通知消息点击回调，内容为通知消息体
      - "onNotificationDeleted":通知消息删除回调，内容为通知消息体
      - "onCustomMessage":自定义消息回调，内容为通知消息体
      - "onPlatformToken":厂商token消息回调，内容为厂商token消息体
      - "onTagMessage":tag操作回调
      - "onAliasMessage":alias操作回调
      - "onNotificationUnShow":在前台，通知消息不显示回调（后台下发的通知是前台信息时）
      - "onInAppMessageShow": 应用内消息展示
      - "onInAppMessageClick": 应用内消息点击
    - ios:
      - "willPresentNotification":通知消息到达回调，内容为通知消息体
      - "didReceiveNotificationResponse":通知消息点击回调，内容为通知消息体
      - "networkDidReceiveMessage":自定义消息回调，内容为通知消息体
      - "networkDidLogin":登陆成功
      - "checkNotificationAuthorization":检测通知权限授权情况
      - "addTags":添加tag回调
      - "setTags":设置tag回调
      - "deleteTags":删除tag回调
      - "cleanTags":清除tag回调
      - "getAllTags":获取tag回调
      - "validTag":校验tag回调
      - "setAlias":设置Alias回调
      - "deleteAlias":删除Alias回调
      - "getAlias":获取Alias回调
      - "deleteAlias":删除Alias回调
      - "onInAppMessageShow": 应用内消息展示
      - "onInAppMessageClick": 应用内消息点击
      - "onNotiInMessageShow": 增强提醒展示
      - "onNotiInMessageClick": 增强提醒点击
      - "onSetUserLanguage": 设置用户语言
      - "onReceiveDeviceToken": 收到deviceToken
  - message["event_data"]: 为对应内容


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

初始化sdk

#### 接口定义

```js
if (Platform.isIOS) {
  FlutterPluginEngagelab.initIos(
          appKey: "你的appkey",
          channel: "testChannel",
);
} else if (Platform.isAndroid) {
  FlutterPluginEngagelab.initAndroid();
}
```

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

### configDebugMode （android/ios都支持）

设置是否debug模式，debug模式会打印更对详细日志

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

## 获取 RegistrationID （android/ios都支持）

### getRegistrationId

RegistrationID 定义:
获取当前设备的registrationId，Engagelab私有云唯一标识，可同于推送

#### 接口定义

```js
FlutterPluginEngagelab.getRegistrationId()
```

#### 返回值

调用此 API 来取得应用程序对应的 RegistrationID。 只有当应用程序成功注册到 JPush 的服务器时才返回对应的值，否则返回空字符串。

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

设置数据采集控制（Android 5.2.0+）

#### 接口定义

```js
FlutterPluginEngagelab.setCollectControl(params)
```

#### 参数说明

- params: Map<String, dynamic> - 采集控制参数字典
  - gaid: boolean - 是否启用GAID采集

#### 代码示例

```js
FlutterPluginEngagelab.setCollectControl(
  gaid: true
);
```
