# API description

## Register to listen

### FlutterPluginEngagelab.addEventHandler （Both android/ios support）

Register the sdk callback event

#### Parameter Description
- message:Returned event data
  - message["event_name"]: event type
    - iOS/android:
      - "onConnectStatus":callback for tcp connection status
      - "onNotificationArrived": Notification delivery callback (iOS only triggers this event when notification is received in foreground)
      - "onNotificationClicked":Notification click callback
      - "onCustomMessage":Custom message callback
      - "onTagMessage":callback for tag operation
      - "onAliasMessage":Callback for alias operation
      - "onInAppMessageShow": callback for inapp message arrival
      - "onInAppMessageClick": callback for inapp message click
  
    - android Only:
      - "onNotificationStatus":callback for application notification switch status, content type is boolean, true means open, false means closed
      - "onNotificationDeleted":Notification deletion callback, the content is the notification message body
      - "onPlatformToken":Manufacturer token message callback, the content is the manufacturer token message body
      - "onNotificationUnShow":Callback for not displaying notification messages in the foreground (when the notification sent in the background is foreground information)
     
    - iOS Only:
      - "checkNotificationAuthorization":Callback events to notify permission authorization status, callback event returned when iOS calls checkNotificationAuthorization method
      - "onNotiInMessageShow": callback for noti inmessage arrival
      - "onNotiInMessageClick": callback for noti inmessage click
      - "onSetUserLanguage": callback for set user language, callback event returned when iOS calls setUserLanguage: method
      - "onReceiveDeviceToken": callback for deviceToken 
      - "willPresentNotification":Callback for notification arrival, the content is the notification message body, recommend using onNotificationArrived instead
      - "didReceiveNotificationResponse":Notification click callback, the content is the notification message body, recommend using onNotificationClicked instead, note that return fields need to be re-adapted
      - "networkDidLogin":login successful, can use onConnectStatus instead, note that return fields need to be re-adapted
      - "addTags": callback for addTags event, can use onTagMessage instead, note that return fields need to be re-adapted
      - "setTags":callback for setTags event, can use onTagMessage instead, note that return fields need to be re-adapted
      - "deleteTags":callback for deleteTags event, can use onTagMessage instead, note that return fields need to be re-adapted
      - "cleanTags":callback for cleanTags event, can use onTagMessage instead, note that return fields need to be re-adapted
      - "getAllTags":callback for getAllTags event, can use onTagMessage instead, note that return fields need to be re-adapted
      - "validTag":callback for validTag event, can use onTagMessage instead, note that return fields need to be re-adapted
      - "setAlias":callback for setAlias event, can use onAliasMessage instead, note that return fields need to be re-adapted
      - "deleteAlias":callback for deleteAlias event, can use onAliasMessage instead, note that return fields need to be re-adapted
      - "getAlias":callback for getAlias event, can use onAliasMessage instead, note that return fields need to be re-adapted
      - "networkDidReceiveMessage":The callback of the custom message, the content is the message body of the custom message, can use onCustomMessage instead, note that return fields need to be re-adapted
  - message["event_data"]: content, return value descriptions for each event are as follows:

#### Event Return Value Description

##### iOS/android Common Events

- **onConnectStatus** - Callback for tcp connection status
  - Return value type: JSON object, containing the following fields:
    - "enable": boolean - Connection status, true means connected, false means disconnected

- **onNotificationArrived** - Notification delivery callback
  - Return value type: JSON object, containing the following fields:
    - "messageId": string - Message ID
    - "content": string - Notification content
    - "title": string - Notification title
    - "extras": object - Extended fields (key-value pairs)

- **onNotificationClicked** - Notification click callback
  - Return value type: Same as onNotificationArrived, JSON object structure is the same

- **onCustomMessage** - Custom message callback
  - Return value type: JSON object, containing the following fields:
    - "messageId": string - Message ID
    - "content": string - Message content
    - "title": string - Message title
    - "extras": object - Extended fields (key-value pairs)

- **onTagMessage** - Callback for tag operation
  - Return value type: JSON object, containing the following fields:
    - "code": number - Operation result code, 0 means success
    - "sequence": number - Request sequence number
    - "tags": array - Tag array
    - "queryTag": string - Query tag (only valid for query tag operation)
    - "isBind": boolean - Whether the query tag is bound (only valid for query tag operation, true means bound, false means not bound)

- **onAliasMessage** - Callback for alias operation
  - Return value type: JSON object, containing the following fields:
    - "alias": string - Alias
    - "code": number - Operation result code, 0 means success
    - "sequence": number - Request sequence number

- **onInAppMessageShow** - Callback for inapp message arrival
  - Return value type: JSON object, containing the following fields:
    - "messageId": string - Message ID
    - "target": string - Target identifier
    - "content": string - Message content
    - "clickAction": string - Click action
    - "extras": object - Extended fields (key-value pairs)

- **onInAppMessageClick** - Callback for inapp message click
  - Return value type: Same as onInAppMessageShow, JSON object structure is the same

##### Android Only Events

- **onNotificationStatus** - Callback for application notification switch status
  - Return value type: JSON object, containing the following fields:
    - "enable": boolean - Notification switch status, true means open, false means closed

- **onNotificationDeleted** - Notification deletion callback
  - Return value type: JSON object, containing the following fields:
    - "messageId": string - Message ID
    - "content": string - Notification content
    - "title": string - Notification title
    - "extras": object - Extended fields (key-value pairs)

- **onPlatformToken** - Manufacturer token message callback
  - Return value type: JSON object, containing the following fields:
    - "platform": string - Platform identifier
    - "token": string - Manufacturer token

- **onNotificationUnShow** - Callback for not displaying notification messages in the foreground
  - Return value type: JSON object, containing the following fields:
    - "messageId": string - Message ID
    - "content": string - Notification content
    - "title": string - Notification title
    - "extras": object - Extended fields (key-value pairs)

##### iOS Only Events

- **checkNotificationAuthorization** - Callback events to notify permission authorization status
  - Return value type: JSON object, containing the following fields:
    - "enable": boolean - Authorization status, true means authorized, false means not authorized

- **onNotiInMessageShow** - Callback for noti inmessage arrival
  - Return value type: JSON object, containing the following fields:
    - "messageId": string - Message ID
    - "content": string - Notification content
    - "title": string - Notification title
    - "extras": object - Extended fields (key-value pairs)

- **onNotiInMessageClick** - Callback for noti inmessage click
  - Return value type: JSON object, containing the following fields:
    - "messageId": string - Message ID
    - "content": string - Notification content
    - "title": string - Notification title
    - "extras": object - Extended fields (key-value pairs)

- **onSetUserLanguage** - Callback for set user language
  - Return value type: JSON object, containing the following fields:
    - "code": number - Operation result code, 0 means success
    - "error": string - Error message (exists when failed)

- **onReceiveDeviceToken** - Callback for deviceToken
  - Return value type: JSON object, containing the following fields:
    - "deviceToken": string - Device token string

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

## Set device migration feature

### setEnableResetOnDeviceChange

Enable or disable the device migration feature. When enabled, if a device model change is detected, the registration information will be automatically cleared and re-registered.

#### Interface definition

```js
FlutterPluginEngagelab.setEnableResetOnDeviceChange(enable)
```

#### Parameter Description

- enable: true to enable, false to disable, default is false

#### code example

```js
// Enable device migration feature
FlutterPluginEngagelab.setEnableResetOnDeviceChange(true);

// Disable device migration feature (default state)
FlutterPluginEngagelab.setEnableResetOnDeviceChange(false);
```

#### Note

- This method should be called before initialization
- When device model changes (such as flashing, device replacement, etc.), local cached registration information will be automatically cleared

## Set Badge (iOS 5.2.0+)

### setBadge

Set the application badge number with completion callback (iOS 5.2.0+)

#### Interface definition

```js
FlutterPluginEngagelab.setBadge(badge)
```

#### Parameter Description

- badge: The badge number to set

#### Return value

Returns a Map containing:
- success: boolean - Whether the operation was successful
- error: string - Error message if operation failed

#### code example

```js
FlutterPluginEngagelab.setBadge(5).then((result) {
  if (result['success']) {
    FlutterPluginEngagelab.printMy("Badge set successfully");
  } else {
    FlutterPluginEngagelab.printMy("Failed to set badge: ${result['error']}");
  }
});
```

## Set Data Collection Control (Android 5.2.0+)

### setCollectControl

Set data collection control settings (Android 5.2.0+)

#### Interface definition

```js
FlutterPluginEngagelab.setCollectControl(params)
```

#### Parameter Description

- params: Map<String, dynamic> - Collection control parameters dictionary
  - gaid: boolean - Whether to enable GAID collection

#### code example

```js
FlutterPluginEngagelab.setCollectControl(
  gaid: true
);
```

## Set Enable UDP

### setEnableUdp

Set whether SDK is allowed to use UDP, UDP is allowed by default (Both iOS and Android)

#### Interface definition

```js
FlutterPluginEngagelab.setEnableUdp(enable)
```

#### Parameter Description

- enable: boolean - true to allow UDP, false to disallow UDP

#### Note

- This method must be called before SDK initialization
- Default is allowed (true)

#### code example

```js
// Allow UDP usage
FlutterPluginEngagelab.setEnableUdp(true);

// Disallow UDP usage
FlutterPluginEngagelab.setEnableUdp(false);
```

## Push Text To Speech Feature

## Enable Push Text To Speech

### setEnablePushTextToSpeech

Enable or disable push text to speech feature (Both iOS and Android)

#### Interface definition

```js
FlutterPluginEngagelab.setEnablePushTextToSpeech(enable)
```

#### Parameter Description

- enable: boolean - true to enable, false to disable, default is false

#### Note

- This method should be called before initialization
- Default is disabled

#### code example

```js
// Enable text to speech
FlutterPluginEngagelab.setEnablePushTextToSpeech(true);

// Disable text to speech
FlutterPluginEngagelab.setEnablePushTextToSpeech(false);
```

## Set App Group ID (iOS Only)

### setAppGroupId

Set appGroupId for sharing storage space between main app and notification service extension (iOS Only)

#### Interface definition

```js
FlutterPluginEngagelab.setAppGroupId(appGroupId)
```

#### Parameter Description

- appGroupId: string - The appGroupId you configured for your bundle ID

#### Note

- iOS only
- This method should be called before initialization
- The appGroupId must match the one set in notification service extension using mtpushSetAppGroupId: method
- Used to define shared storage space between main app and notification service extension for storing text to speech related resources

#### code example

```js
if (Platform.isIOS) {
  FlutterPluginEngagelab.setAppGroupId("group.com.engagelab.push");
}
```

### iOS Text To Speech Feature Usage Instructions

To use this feature, you need to enable appGroups capability for your bundle ID. For steps to enable appGroups capability, please refer to [iOS Certificate Setting Guide](https://www.engagelab.com/docs/app-push/developer-guide/client-sdk-reference/ios-sdk/ios-certificate-setting-guide).

This feature supports iOS 14 and above.

Due to system limitations, the duration of text-to-speech playback is roughly consistent with the notification display time (approximately 10 seconds, with slight variations across different systems). When the notification disappears, the text-to-speech playback will also stop. Please control the duration of the speech accordingly.

You need to add a Notification Service Extension to your project and integrate Engagelab's Notification Service Extension SDK natively (please refer to [iOS Integration Guide](https://www.engagelab.com/docs/app-push/developer-guide/client-sdk-reference/ios-sdk/ios-sdk-integration-guide#notification-delivery-statistics)).

Then process the voice file in the Notification Service Extension according to the following sample code:

```objc
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {

  UNMutableNotificationContent *bestAttemptContent = [request.content mutableCopy];

  // The appGroupId set by this method must match the appGroupId set in the project.
  [MTNotificationExtensionService mtpushSetAppGroupId:@"xxx"]; 
  // Set appkey
  [MTNotificationExtensionService mtpushSetAppkey:@"Your appkey"];
  
  // Process voice file
  [MTNotificationExtensionService handleVoice:request with:^(NSString *soundName) {
      if (soundName && soundName.length >= 0 ) {
        // After the voice file is processed successfully, set the notification's sound to the processed voice file name
        bestAttemptContent.sound = [UNNotificationSound soundNamed:soundName];
      }
      // Continue to call the push statistics reporting API
    [MTNotificationExtensionService mtpushReceiveNotificationRequest:request with:^ {
      NSLog(@"apns upload success");
      self.contentHandler(bestAttemptContent);
    }];
    
  }];

}
```

At the same time, you need to call the following two interfaces in Flutter to enable the text-to-speech feature.

```js
FlutterPluginEngagelab.setEnablePushTextToSpeech(true);
FlutterPluginEngagelab.setAppGroupId("your appGroupId");
```

### Android Text To Speech Feature Usage Instructions

You only need to call the following interface in Flutter to enable the text-to-speech feature.

```js
FlutterPluginEngagelab.setEnablePushTextToSpeech(true);
```
