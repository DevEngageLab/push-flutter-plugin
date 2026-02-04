# EngageLab 推送 Flutter 插件 - 鸿蒙集成说明

本文说明在本插件（flutter_plugin_engagelab）下如何搭建鸿蒙环境、配置 EngageLab 推送，并与 [EngageLab HarmonyOS SDK 集成指南](https://www.engagelab.com/zh_CN/docs/app-push/developer-guide/client-sdk-reference/harmonyOS-sdk/harmonyOS-sdk-integration-guide) 保持一致。

---

## 一、鸿蒙版 Flutter 环境搭建

请先按鸿蒙官方文档完成 Flutter 鸿蒙环境搭建：

[鸿蒙版 Flutter 环境搭建指导](https://gitee.com/openharmony-sig/flutter_samples/blob/master/ohos/docs/03_environment/%E9%B8%BF%E8%92%99%E7%89%88Flutter%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA%E6%8C%87%E5%AF%BC.md)

---

## 二、本插件鸿蒙结构说明

- **插件本体**：`ohos/` 目录，通过 **自动集成** 方式依赖 EngageLab 鸿蒙 SDK（`@engagelab/push`）。EPushInterface 的调用均封装在插件的静态方法中。
- **Example 应用**：`example/ohos/` 目录。entry 模块**仅需依赖插件 HAR**（`flutter_plugin_engagelab.har`，由 `flutter build hap` 生成到 `example/ohos/har/`）；EntryAbility、PushMessageAbility、RemoteNotificationExtensionAbility 通过调用插件的静态方法完成推送相关能力。

---

## 三、鸿蒙 Demo 首次构建顺序

`example/ohos` 依赖 `har/flutter.har` 与 `har/flutter_plugin_engagelab.har`，这些由 **鸿蒙版 Flutter** 的构建生成。标准 Flutter 无 `flutter build hap` 命令，需先按上文安装鸿蒙版 Flutter。

**建议顺序**：

```bash
cd example
flutter build hap            # 使用鸿蒙版 Flutter，生成 ohos/har/flutter.har、flutter_plugin_engagelab.har 等
cd ohos
ohpm install                 # 解析 entry 与根级依赖
```

再用 DevEco Studio 打开 `example/ohos` 进行开发。

---


## 四、配置

### 4.1 配置字节码编译环境（useNormalizedOHMUrl）

EngageLab HAR 为字节码，需：

- IDE 升级到 **5.0.3.500** 及以上；
- 在 **工程级**（example/ohos 最外层）**build-profile.json5** 的 `products` 中配置：

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

本插件 example 已包含上述配置。

---

### 4.2 配置 EngageLab 平台信息（包名与 appKey）

- 在 **EngageLab 控制台** 创建应用，并确保 **包名**、**appKey** 与本地工程一致。
- **包名**：在 **AppScope/app.json5** 中配置，例如：

```json5
{
  "app": {
    "bundleName": "你的包名"
  }
}
```

本插件 example 包名为 `cn.allpublic.test.hmos`。

- **appKey**：在 **init 之前** 通过 Flutter 侧调用设置（见下文「启用推送与 Flutter 调用示例」），例如：

```dart
FlutterPluginEngagelab.setAppKey("你的 appKey");
FlutterPluginEngagelab.setChannel("testChannel");
FlutterPluginEngagelab.initOhos();
```

EngageLab 官方文档中也可在 **AbilityStage#onCreate** 里调用 `EPushInterface.setAppKey("你的appKey")`；本插件通过 Flutter 统一设置并调用 `EPushInterface.init()`，无需在原生 AbilityStage 再写 setAppKey。

---

### 4.3 配置通知跳转页（点击通知打开应用）

发送通知时请选择「打开应用」方式，以便通过 Want 获取通知数据。

在 **example/ohos/entry** 的 **EntryAbility.ets** 中，在 `onCreate` 与 `onNewWant` 里通过**插件静态方法**调用 `FlutterPluginEngagelabPlugin.setClickWant`：

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

### 4.4 配置自定义消息（BACKGROUND）

若需接收后台自定义消息，需完成以下两步。

#### 步骤一：PushMessage 与 proxyData

- 在 **entry** 的 `src/main/resources/base/profile/` 下创建 **PushMessage.json**：

```json
{
  "path": "pushmessage/t_push_message",
  "type": "rdb",
  "scope": "application"
}
```

- 在 **entry** 的 **module.json5** 的 `module` 下添加 **proxyData**（将 `{bundleName}` 换为实际包名）：

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

#### 步骤二：PushMessageAbility 与 action.ohos.push.listener

- 仅可使用 **UIAbility** 接收 BACKGROUND 消息。在 **PushMessageAbility.ets** 中调用 `pushService.receiveMessage('BACKGROUND', ...)` 与**插件静态方法** `FlutterPluginEngagelabPlugin.customMessageBackgroundData`。注意：ArkTS 要求显式类型，`jg` 建议写成 `boolean | undefined`，例如：

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
    // IM、VoIP 同理，见下文
  }
}
```

- 在 **module.json5** 的 **abilities** 中配置 PushMessageAbility，且 **有且只能有一个** ability 的 skills.actions 包含 `action.ohos.push.listener`：

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

### 4.5 配置扩展通知（IM）与 VoIP

在 **PushMessageAbility** 的 `onCreate` 中继续注册 **IM**、**VoIP**，通过**插件静态方法** `FlutterPluginEngagelabPlugin.extraMessageBackgroundData`、`voIPMessageBackgroundData` 处理，并给回调中的变量**显式类型**（避免 arkts-no-any-unknown）：

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

若 `receiveMessage` 的回调参数类型与 `PushPayload` 不一致，请按 PushKit 实际类型替换（保证不用 `any`/`unknown`）。

---

### 4.6 配置通知扩展（RemoteNotificationExtensionAbility）

若需在通知扩展进程中处理/修改通知（如语音播报、修改内容），需：

- 创建 **RemoteNotificationExtensionAbility** 子类，在 **onReceiveMessage** 中通过**插件静态方法**调用 `FlutterPluginEngagelabPlugin.receiveExtraDataMessage`，返回值建议给**显式类型**（如 `Object | undefined` 或 SDK 提供的类型），例如：

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

- 在 **module.json5** 的 **extensionAbilities** 中注册（有且仅一个 remoteNotification 类型，actions 固定）：

```json5
"extensionAbilities": [
  {
    "name": "RemoteNotificationExtAbility",
    "type": "remoteNotification",
    "srcEntry": "./ets/entryability/RemoteNotificationExtensionAbility.ets",
    "description": "EngageLab 通知扩展",
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

## 五、启用推送与 Flutter 调用示例

- 在 **init 之前** 必须先设置 **appKey** 和 **接收回调**（本插件在原生侧已通过 `EPushInterface.setCallBackMsg` 注册，将事件转发到 Flutter 的 `onMTCommonReceiver`）。
- Flutter 侧需先 **addEventHandler**，再 **setAppKey / setChannel**，最后 **initOhos**。

示例（与 example/lib/main.dart 一致）：

```dart
import 'package:flutter_plugin_engagelab/flutter_plugin_engagelab.dart';
import 'dart:io' show Platform;

// 1. 注册回调（在 init 之前）
FlutterPluginEngagelab.addEventHandler(
  onMTCommonReceiver: (Map<String, dynamic> message) async {
    String eventName = message["event_name"];
    String eventData = message["event_data"];
    // 处理 onConnectStatus、onNotificationArrived、onTagMessage 等
  },
);

FlutterPluginEngagelab.configDebugMode(true);

if (Platform.isAndroid) {
  FlutterPluginEngagelab.initAndroid();
} else if (Platform.isIOS) {
  FlutterPluginEngagelab.initIos(appKey: "你的appKey", channel: "testChannel");
} else {
  // 鸿蒙
  FlutterPluginEngagelab.setAppKey("你的 appKey");
  FlutterPluginEngagelab.setChannel("testChannel");
  FlutterPluginEngagelab.initOhos();
}
```

鸿蒙下无需在 AbilityStage 再写 `EPushInterface.setAppKey`，插件在 `init` 时会使用 Flutter 传入的 appKey/channel。

---


## 六、APIs

Flutter 侧 API 说明见：[APIs 文档](./APIs.md)。

EngageLab HarmonyOS SDK 接口说明见：[EngageLab HarmonyOS SDK 集成指南](https://www.engagelab.com/zh_CN/docs/app-push/developer-guide/client-sdk-reference/harmonyOS-sdk/harmonyOS-sdk-integration-guide) 与 [SDK API 参考](https://www.engagelab.com/zh_CN/docs/app-push/developer-guide/client-sdk-reference/harmonyOS-sdk/sdk-api-guide)。
