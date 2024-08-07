# flutter_plugin_engagelab

### Setup

Add dependencies to project pubspec.yaml

```
  
// by github:
dependencies:
  flutter_plugin_engagelab:
    git:
      url: git://github.com/DevEngageLab/push-flutter-plugin.git
      ref: main
      
// by pub:
dependencies:
  flutter_plugin_engagelab: 1.2.4
```

### Configuration

##### Android:

Add the following code in `/android/app/build.gradle`:

```groovy
android: {
  ....
  defaultConfig {
    applicationId "Replace with your own application ID"
    ....
    manifestPlaceholders = [
                ENGAGELAB_PRIVATES_APPKEY : "your appkey",
                ENGAGELAB_PRIVATES_CHANNEL: "developer",
                ENGAGELAB_PRIVATES_PROCESS: ":remote",
                XIAOMI_APPID            : "",//Xiaomi manufacturer, fill in the MI-appid if it exists. If not, don’t fill it in. Leave it as ""
                XIAOMI_APPKEY           : "",//Xiaomi manufacturer, if available, fill in MI-appkey, if not, don’t fill it in, leave it as ""
                MEIZU_APPID            : "",//Meizu manufacturer, if available, fill in MZ-appid, if not, do not fill in, leave it as ""
                MEIZU_APPKEY           : "",//Meizu manufacturer, if available, fill in MZ-appkey, if not, do not fill in, leave it as ""
                OPPO_APPID             : "",//OOPPO manufacturer, if yes, fill in OP-appid, if not, no need to fill in, leave it as ""
                OPPO_APPKEY            : "",//OPPO manufacturer, if yes, fill in OP-appkey, if not, no need to fill in, leave it as ""
                OPPO_APPSECRET         : "",//OPPO manufacturer, if yes, fill in OP-appsecret, if not, no need to fill in, leave it as ""
                VIVO_APPID             : "",//VIVO manufacturer, if available, fill in vivo appid, if not, don’t fill in, leave it as ""
                VIVO_APPKEY            : "",//VIVO manufacturer, if available, fill in vivo appkey, if not, don’t fill in, leave it as ""
                HONOR_APPID            : "",//Honor manufacturer, if you have it, fill in honnor appid, if not, don’t fill it in, leave it as ""
                APP_TCP_SSL            : "",//android - Whether the tcp connection is encrypted, fill in true to indicate encryption, otherwise it means not encrypted, and can be left as "". For this data to take effect, you need to add android:name="com.engagelab.privates.flutter_plugin_engagelab.MTApplication" to the application in AndroidManifest.xml. Or let your MainApplication inherit MTApplication.
                APP_DEBUG            : "",//android - Fill in true to indicate debug mode, others indicate non-debug mode, and can be left as "". For this data to take effect, you need to add android:name="com.engagelab.privates.flutter_plugin_engagelab.MTApplication" to the application in AndroidManifest.xml, or inherit this object.
                COUNTRY_CODE            : "",//For testing, can be left as "".For this data to take effect, you need to add android:name="com.engagelab.privates.flutter_plugin_engagelab.MTApplication" to the application in AndroidManifest.xml, or inherit this object.
        ]
  }    
}
```

##### iOS:

- After xcode8, you need to click on the push option: TARGETS -> Capabilities -> Push Notification and set it to on.

### Usage

```dart
import 'package:flutter_plugin_engagelab/flutter_plugin_engagelab.dart';
```

### APIs

**Note** : FlutterPluginEngagelab.init needs to be called first to initialize the plug-in to ensure that other functions work properly.工作。

 [refer to](./documents/APIs.md)

