# EngageLab Push Flutter Plugin – HarmonyOS Integration

This document describes how to set up the HarmonyOS (Ohos) environment and configure EngageLab push with this plugin (`flutter_plugin_engagelab`), aligned with the [EngageLab HarmonyOS SDK Integration Guide](https://www.engagelab.com/zh_CN/docs/app-push/developer-guide/client-sdk-reference/harmonyOS-sdk/harmonyOS-sdk-integration-guide).

---

## 1. Flutter for HarmonyOS Environment Setup

Set up the Flutter-for-HarmonyOS environment first according to the official docs:

[Flutter for HarmonyOS Environment Setup](https://gitee.com/openharmony-sig/flutter_samples/blob/master/ohos/docs/03_environment/%E9%B8%BF%E8%92%99%E7%89%88Flutter%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA%E6%8C%87%E5%AF%BC.md)

---

## 2. Plugin HarmonyOS Structure

- **Plugin core**: The `ohos/` directory depends on the EngageLab HarmonyOS SDK via **automatic integration** (`@engagelab/push`). All `EPushInterface` usage is wrapped in the plugin’s static methods.
- **Example app**: The `example/ohos/` directory. The entry module **only depends on the plugin HAR** (`flutter_plugin_engagelab.har`, produced under `example/ohos/har/` by `flutter build hap`). EntryAbility, PushMessageAbility, and RemoteNotificationExtensionAbility use the plugin’s static methods for push-related behavior.

---

## 3. First-Time Build Order for the HarmonyOS Demo

`example/ohos` depends on `har/flutter.har` and `har/flutter_plugin_engagelab.har`, which are produced by **Flutter for HarmonyOS**. Standard Flutter does not provide `flutter build hap`; install Flutter for HarmonyOS as above first.

**Recommended order**:

```bash
cd example
flutter build hap            # With Flutter for HarmonyOS; generates ohos/har/flutter.har, flutter_plugin_engagelab.har, etc.
cd ohos
ohpm install                 # Resolve entry and root-level dependencies
```

Then open `example/ohos` in DevEco Studio for development.

---

## 4. Configuration

### 4.1 Bytecode Build (useNormalizedOHMUrl)

The EngageLab HAR is bytecode. You need to:

- Use IDE **5.0.3.500** or newer.
- In the **project-level** `build-profile.json5` (top-level `example/ohos`), under `products`, add:

```json5
"products": [
  {
    "buildOption": {
      "strictMode": {
        "useNormalizedOHMUrl": true
      }
    },
    "name": "default",
    "signingConfig": "default",
    "compatibleSdkVersion": "5.0.0(12)",
    "runtimeOS": "HarmonyOS"
  }
]
```

The plugin example already includes this.

---

### 4.2 EngageLab Platform (Package Name and appKey)

- Create an app in the **EngageLab console** and ensure **package name** and **appKey** match your project.
- **Package name**: In **AppScope/app.json5**, for example:

```json5
{
  "app": {
    "bundleName": "your.bundle.name"
  }
}
```

The plugin example uses `cn.allpublic.test.hmos`.

- **appKey**: Set from Flutter **before** calling init (see “Enable push and Flutter usage” below), e.g.:

```dart
FlutterPluginEngagelab.setAppKey("your appKey");
FlutterPluginEngagelab.setChannel("testChannel");
FlutterPluginEngagelab.initOhos();
```

The EngageLab docs also show calling `EPushInterface.setAppKey("yourAppKey")` in **AbilityStage#onCreate**. This plugin sets appKey/channel from Flutter and calls `EPushInterface.init()`, so you do not need to call setAppKey in the native AbilityStage.

---

### 4.3 Notification Click (Open App from Notification)

When sending a notification, choose “Open app” so the app can receive data via Want.

In **EntryAbility.ets** under **example/ohos/entry**, call the **plugin static method** `FlutterPluginEngagelabPlugin.setClickWant` in `onCreate` and `onNewWant`:

```ets
import { FlutterAbility, FlutterEngine, Log } from '@ohos/flutter_ohos';
import { GeneratedPluginRegistrant } from '../plugins/GeneratedPluginRegistrant';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import FlutterPluginEngagelabPlugin from 'flutter_plugin_engagelab';

const TAG: string = 'EngageLab-Push-flutter-EntryAbility'

export default class EntryAbility extends FlutterAbility {
  configureFlutterEngine(flutterEngine: FlutterEngine) {
    Log.i(TAG, 'configureFlutterEngine')
    super.configureFlutterEngine(flutterEngine)
    GeneratedPluginRegistrant.registerWith(flutterEngine)
  }

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): Promise<void> {
    Log.i(TAG, 'onCreate :' + JSON.stringify(want))
    FlutterPluginEngagelabPlugin.setClickWant(want, this.context)
    return super.onCreate(want, launchParam)
  }

  onNewWant(want: Want, launchParams: AbilityConstant.LaunchParam): void {
    Log.i(TAG, 'onNewWant :' + JSON.stringify(want));
    FlutterPluginEngagelabPlugin.setClickWant(want, this.context)
    super.onNewWant(want, launchParams)
  }
}
```

---

### 4.4 Custom Messages (BACKGROUND)

To receive background custom messages, do the following.

#### Step 1: PushMessage and proxyData

- Under **entry** `src/main/resources/base/profile/`, create **PushMessage.json**:

```json
{
  "path": "pushmessage/t_push_message",
  "type": "rdb",
  "scope": "application"
}
```

- In **entry** **module.json5**, under `module`, add **proxyData** (replace `{bundleName}` with your bundle name):

```json5
"proxyData": [
  {
    "uri": "datashareproxy://{bundleName}/PushMessage",
    "requiredWritePermission": "ohos.permission.WRITE_PRIVACY_PUSH_DATA",
    "metadata": {
      "name": "dataProperties",
      "resource": "$profile:PushMessage"
    }
  }
]
```

#### Step 2: PushMessageAbility and action.ohos.push.listener

- Only **UIAbility** can receive BACKGROUND messages. In **PushMessageAbility.ets** use `pushService.receiveMessage('BACKGROUND', ...)` and the **plugin static method** `FlutterPluginEngagelabPlugin.customMessageBackgroundData`. Give callback variables explicit types (e.g. `boolean | undefined` for `jg`):

```ets
import { UIAbility } from '@kit.AbilityKit';
import { pushCommon, pushService } from '@kit.PushKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import FlutterPluginEngagelabPlugin from 'flutter_plugin_engagelab';

const TAG: string = 'engagelab-JLog-PushMessageAbility'

export default class PushMessageAbility extends UIAbility {
  onCreate(): void {
    try {
      pushService.receiveMessage('BACKGROUND', this, async (data: pushCommon.PushPayload) => {
        let jg: boolean | undefined = await FlutterPluginEngagelabPlugin.customMessageBackgroundData(data);
        if (jg) {
          return;
        }
      });
    } catch (e) {
      hilog.info(0x0000, TAG, '%{public}s', 'BACKGROUND fail:' + JSON.stringify(e));
    }
    // IM, VoIP: see below
  }
}
```

- In **module.json5** **abilities**, register PushMessageAbility. Exactly **one** ability must have `action.ohos.push.listener` in `skills.actions`:

```json5
{
  "name": "PushMessageAbility",
  "srcEntry": "./ets/entryability/PushMessageAbility.ets",
  "launchType": "singleton",
  "startWindowIcon": "$media:icon",
  "startWindowBackground": "$color:start_window_background",
  "skills": [
    {
      "actions": ["action.ohos.push.listener"]
    }
  ]
}
```

---

### 4.5 Extended Notifications (IM) and VoIP

In **PushMessageAbility** `onCreate`, register **IM** and **VoIP** using the **plugin static methods** `FlutterPluginEngagelabPlugin.extraMessageBackgroundData` and `voIPMessageBackgroundData`. Use explicit types in callbacks (avoid arkts-no-any-unknown):

```ets
try {
  pushService.receiveMessage('IM', this, async (data: pushCommon.PushPayload) => {
    let jg: boolean | undefined = await FlutterPluginEngagelabPlugin.extraMessageBackgroundData(data);
    if (jg) return;
  });
} catch (e) {
  hilog.info(0x0000, TAG, '%{public}s', 'IM fail:' + JSON.stringify(e));
}

try {
  pushService.receiveMessage('VoIP', this, async (data: pushCommon.PushPayload) => {
    let jg: boolean | undefined = await FlutterPluginEngagelabPlugin.voIPMessageBackgroundData(data);
    if (jg) return;
  });
} catch (e) {
  hilog.info(0x0000, TAG, '%{public}s', 'VoIP fail:' + JSON.stringify(e));
}
```

If the `receiveMessage` callback parameter type differs from `PushPayload`, use the actual PushKit type (avoid `any`/`unknown`).

---

### 4.6 Notification Extension (RemoteNotificationExtensionAbility)

To handle or modify notifications in the extension process (e.g. TTS, content changes):

- Create a **RemoteNotificationExtensionAbility** subclass. In **onReceiveMessage**, call **plugin static method** `FlutterPluginEngagelabPlugin.receiveExtraDataMessage`. Use an explicit return type (e.g. `Object | undefined` or the type provided by the SDK):

```ets
import { pushCommon, RemoteNotificationExtensionAbility } from '@kit.PushKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import FlutterPluginEngagelabPlugin from 'flutter_plugin_engagelab';

const TAG: string = 'engagelab-JLog-RemoteNotificationExtAbility'

export default class RemoteNotificationExtAbility extends RemoteNotificationExtensionAbility {
  async onReceiveMessage(remoteNotificationInfo: pushCommon.RemoteNotificationInfo): Promise<pushCommon.RemoteNotificationContent> {
    hilog.info(0x0000, TAG, 'onReceiveMessage, remoteNotificationInfo: %{public}s',
      JSON.stringify(remoteNotificationInfo));
    let jMessageExtra: Object | undefined = await FlutterPluginEngagelabPlugin.receiveExtraDataMessage(this, remoteNotificationInfo);
    hilog.info(0x0000, TAG, 'onReceiveMessage jMessageExtra:' + JSON.stringify(jMessageExtra));
    return {};
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG, 'RemoteNotificationExtAbility onDestroy.');
  }
}
```

- Register it in **module.json5** **extensionAbilities** (exactly one `remoteNotification` type; actions are fixed):

```json5
"extensionAbilities": [
  {
    "name": "RemoteNotificationExtAbility",
    "type": "remoteNotification",
    "srcEntry": "./ets/entryability/RemoteNotificationExtensionAbility.ets",
    "description": "EngageLab notification extension",
    "exported": false,
    "skills": [
      {
        "actions": ["action.hms.push.extension.remotenotification"]
      }
    ]
  }
]
```

---

## 5. Enable Push and Flutter Usage

- **Before** calling init, you must set **appKey** and register the **event callback**. The plugin registers `EPushInterface.setCallBackMsg` on the native side and forwards events to Flutter’s `onMTCommonReceiver`.
- On the Flutter side: **addEventHandler** first, then **setAppKey / setChannel**, then **initOhos**.

Example (aligned with example/lib/main.dart):

```dart
import 'package:flutter_plugin_engagelab/flutter_plugin_engagelab.dart';
import 'dart:io' show Platform;

// 1. Register callback (before init)
FlutterPluginEngagelab.addEventHandler(
  onMTCommonReceiver: (Map<String, dynamic> message) async {
    String eventName = message["event_name"];
    String eventData = message["event_data"];
    // Handle onConnectStatus, onNotificationArrived, onTagMessage, etc.
  },
);

FlutterPluginEngagelab.configDebugMode(true);

if (Platform.isAndroid) {
  FlutterPluginEngagelab.initAndroid();
} else if (Platform.isIOS) {
  FlutterPluginEngagelab.initIos(appKey: "your_appKey", channel: "testChannel");
} else {
  // HarmonyOS
  FlutterPluginEngagelab.setAppKey("your appKey");
  FlutterPluginEngagelab.setChannel("testChannel");
  FlutterPluginEngagelab.initOhos();
}
```

On HarmonyOS you do not need to call `EPushInterface.setAppKey` in AbilityStage; the plugin uses the appKey/channel from Flutter when init runs.

---

## 6. APIs

- Flutter API: [APIs document](./cn-document/APIs.md).
- EngageLab HarmonyOS SDK: [EngageLab HarmonyOS SDK Integration Guide](https://www.engagelab.com/zh_CN/docs/app-push/developer-guide/client-sdk-reference/harmonyOS-sdk/harmonyOS-sdk-integration-guide) and [SDK API Reference](https://www.engagelab.com/zh_CN/docs/app-push/developer-guide/client-sdk-reference/harmonyOS-sdk/sdk-api-guide).
