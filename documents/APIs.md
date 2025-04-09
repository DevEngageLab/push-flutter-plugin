# API description

## Register to listen

### FlutterPluginEngagelab.addEventHandler （Both android/ios support）

Register the sdk callback event

#### Parameter Description
- message:Returned event data
  - message["event_name"]: event type
    - android:
      - "onNotificationStatus":callback for application notification switch status , the content type is boolean, true means open, false means closed
      - "onConnectStatus":callback for tcp connection status , content type is boolean, true means connected
      - "onNotificationArrived": Notification delivery callback, the content is the notification message body
      - "onNotificationClicked":Notification click callback, the content is the notification message body
      - "onNotificationDeleted":Notification deletion callback, the content is the notification message body
      - "onCustomMessage":Custom message callback, the content is the custom message body
      - "onPlatformToken":Manufacturer token message callback, the content is the manufacturer token message body
      - "onTagMessage":callback for tag operation
      - "onAliasMessage":Callback for alias operation
      - "onNotificationUnShow":Callback for not displaying notification messages in the foreground (when the notification sent in the background is foreground information)
      - "onInAppMessageShow": callback for inapp message arrival
      - "onInAppMessageClick": callback for inapp message click
    - ios:
      - "willPresentNotification":Callback for notification arrival, the content is the notification message body
      - "didReceiveNotificationResponse":Notification click callback, the content is the notification message body
      - "networkDidReceiveMessage":The callback of the custom message, the content is the message body of the custom message
      - "networkDidLogin":login successful
      - "checkNotificationAuthorization":Callback events to notify permission authorization status
      - "addTags": callback for addTags event
      - "setTags":callback for setTags event
      - "deleteTags":callback for deleteTags event
      - "cleanTags":callback for cleanTags event
      - "getAllTags":callback for getAllTags event
      - "validTag":callback for validTag event
      - "setAlias":callback for setAlias event
      - "deleteAlias":callback for deleteAlias event
      - "getAlias":callback for getAlias event
      - "deleteAlias":callback for deleteAlias event
      - "onInAppMessageShow": callback for inapp message arrival
      - "onInAppMessageClick": callback for inapp message click
      - "onNotiInMessageShow": callback for noti inmessage arrival
      - "onNotiInMessageClick": callback for noti inmessage click
      - "onSetUserLanguage": callback for set user language
      - "onReceiveDeviceToken": callback for deviceToken 
  - message["event_data"]: content


#### code example

```js
FlutterPluginEngagelab.addEventHandler(
        onMTCommonReceiver: (Map<String, dynamic> message) async {
  FlutterPluginEngagelab.printMy("flutter onMTCommonReceiver: $message");
  String event_name = message["event_name"];
  String event_data = message["event_data"];
});
```


## Set the AppKey - android

### configAppKeyAndroid

Set the appKey, called before initializing the function

#### 接口定义

```js
  FlutterPluginEngagelab.configAppKeyAndroid("appkey");
```

## Setup

### initAndroid （android）
### initIos （ios）


Initialize sdk

#### Interface definition

```js
if (Platform.isIOS) {
  FlutterPluginEngagelab.initIos(
          appKey: "your appkey",
          channel: "testChannel",
);
} else if (Platform.isAndroid) {
  FlutterPluginEngagelab.initAndroid();
}
```

## Set up the data center - this method is invalid in v1.2.2 and does not need to be called

### setSiteName

Set up the data center, called before the initialization function

#### Interface definition

```js
  FlutterPluginEngagelab.setSiteName("Singapore");
```

## setUserLanguage

### setUserLanguage

Set User Language

#### 接口定义

```js
  FlutterPluginEngagelab.setUserLanguage("zh-Hans-CN");
```

## Turn on Debug mode

### configDebugMode （Both android/ios support）

Set whether to turn on debug mode. When debug mode is turned on, a detailed log will be printed.

#### Interface definition

```js
FlutterPluginEngagelab.configDebugMode(enable)
```

#### Parameter Description

- enable: Whether to turn on debugging mode, true means debugging mode, false does not

#### code example

```js
FlutterPluginEngagelab.configDebugMode(true);//Delete before publishing
```

## Get RegistrationID （Both android/ios support）

### getRegistrationId

RegistrationID :
Get the registrationId of the current device, which can be used for push

#### Interface definition

```js
FlutterPluginEngagelab.getRegistrationId()
```

#### return value

Call this API to get the RegistrationID which returned by the Engagelab server only if the application is successfully registered, otherwise an empty string is returned.

#### example

```js
FlutterPluginEngagelab.getRegistrationId().then((rid){
  FlutterPluginEngagelab.printMy("flutter get registration id : $rid");
});
```

## Set whether iOS notifications are displayed in the foreground

### setUnShowAtTheForegroundIos （ios only）

Set whether iOS notifications are displayed in the foreground

#### Interface definition

```js
FlutterPluginEngagelab.setUnShowAtTheForegroundIos(enable)
```

#### Parameter Description

- enable: true means not displaying, false means displaying

#### code example

```js
FlutterPluginEngagelab.setUnShowAtTheForegroundIos(true);
```

## Send a local notification

### sendLocalNotification

Send a local notification

/** Correspondence between PRIORITY and IMPORTANCE
   * `PRIORITY_MIN = -2` corresponds to  `IMPORTANCE_MIN = 1`;
   * `PRIORITY_LOW = -1` corresponds to  `IMPORTANCE_LOW = 2`;
   * `PRIORITY_DEFAULT = 0` corresponds to  `IMPORTANCE_DEFAULT = 3`;
   * `PRIORITY_HIGH = 1` corresponds to  `IMPORTANCE_HIGH = 4`;
   * `PRIORITY_MAX = 2` corresponds to `IMPORTANCE_MAX = 5`;
*/

#### Interface definition
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
