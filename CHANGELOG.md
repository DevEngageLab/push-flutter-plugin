## 1.4.5+5431543
+ Android main SDK remains 5.4.3; upgrade the vivo vendor plugin to 5.4.3.1 to include launcher badge permissions

## 1.4.4+543543
+ update Android SDK 5.4.2 → 5.4.3，iOS SDK 保持 5.4.3，HarmonyOS SDK 保持 1.0.1
+ Android: 支持 OPPO 与 vivo 厂商消息角标处理

## 1.4.3+542543
+ update iOS SDK 5.4.1 → 5.4.3，HarmonyOS SDK 1.0.0 → 1.0.1
+ iOS/HarmonyOS: 新增 `turnOffPush` 关闭推送服务接口
+ iOS/HarmonyOS: 新增 `turnOnPush` 使用指定 AppKey 重新开启推送服务接口
+ HarmonyOS 接口迁移：旧版 `turnOnPush()` / `turnOffPush()` 实际对应 `resumePush()` / `stopPush()`，本版本分别更名为 `resumePush()` / `stopPush()`；原方法名用于上述新增的重新开启/关闭推送服务接口。已有 HarmonyOS 用户升级后需同步修改旧接口调用

## 1.4.2+542541
+ update Android SDK 5.4.1 → 5.4.2，iOS SDK 保持 5.4.1
+ Android: 新增 VoIP 消息支持，覆盖小米、OPPO、vivo、荣耀四大厂商通道，通过 `onMTCommonReceiver` 事件的 `onVoipMessage` 名称接收
+ Android: OPPO/vivo/荣耀厂商 SDK 依赖版本升级，由 `com.engagelab.plugin:*` 封装模块内部处理，无需手动配置
+ Bug 修复

## 1.4.1+541541
+ update Android SDK 5.4.0 → 5.4.1，iOS SDK 5.4.0 → 5.4.1
+ 新增 `reportCustomMessageDisplay(messageId, platform, platformMessageId)`：上报自定义消息展示数据（Android/iOS，iOS 仅使用 messageId）。与鸿蒙专用的 `reportCustomDisplay()` 是不同的接口
+ 新增 `reportCustomMessageClick(messageId, platform, platformMessageId)`：上报自定义消息点击数据（Android/iOS，iOS 仅使用 messageId）。与鸿蒙专用的 `reportCustomClick()` 是不同的接口

## 1.4.0+540540
+ update Android SDK 5.3.0 → 5.4.0，iOS SDK 5.3.0 → 5.4.0
+ Android: 小米厂商 SDK 升级（6.0.1 → 7.9.2），合规优化：AndroidId 采集默认关闭
+ Android: `setCollectControl` 的 `aid` 参数自 Android SDK 5.4.0 起废弃，AndroidId 采集默认关闭，无需再传入 aid
+ iOS: 已知 Bug 修复

## 1.3.9+530530
+ iOS: 修复 APNS 推送中 `aps.alert` 字段兼容性。

## 1.3.8+530530
+ 支持鸿蒙（HarmonyOS）：新增 HarmonyOS 平台支持。

## 1.3.7+530530
+ update android 5.3.0 ios 5.3.0
+ Android: 更新setCollectControl方法，新增aid参数支持（AndroidId数据采集控制）

## 1.3.6+523523
+ add setEnableUdp method for iOS and Android (allow/disallow SDK to use UDP, must be called before SDK initialization)

## 1.3.5+523523
+ enabel push text to speech
+ add setEnablePushTextToSpeech method for iOS and Android (enable/disable text to speech)
+ add setAppGroupId method for iOS (you need also call set mtpushSetAppGroupId: in notification service extension)

## 1.3.4+523523
+ update android 5.2.3 ios 5.2.3

## 1.3.3+520520
+ update android 5.2.0 ios 5.2.0
+ add setBadge method for iOS (with completion callback)
+ add setCollectControl method for Android (data collection control)
+ Set the minimum supported version to Android 6.

## 1.3.2+510510
+ fix android cannot find addEventHandlerMethod error
## 1.3.1+510510
+ update android 5.1.0 ios 5.1.0
+ add setEnableResetOnDeviceChange method for device migration feature

## 1.3.0+500500
+ fix ios code launch from notification click not call back

## 1.2.9+500500
+ update android 5.0.0 ios 5.0.0
  
## 1.2.8+454454
+ update android 4.5.4 ios 4.5.4

## 1.2.7
+ update 4.5.2

## 1.2.6
+ Set the appKey

## 1.2.5
+ update 4.5.1。

## 1.2.4
+ 1.iOS新增setUnShowAtTheForegroundIos方法，可以控制通知在前台是否展示。
+ 2.iOS修改setDebugMode设置为no, 不生效的问题。
  
## 1.2.3
+ iOS SDK升级到4.4.0
+ android SDK升级到4.4.0

## 1.2.2
+ iOS SDK升级到4.3.5
+ android SDK升级到4.3.9
+ android不再支持国外小米厂商，新增支持国内小米厂商，manifestPlaceholders中不需要填写"XIAOMI_GLOBAL_APPID" 和 "XIAOMI_GLOBAL_APPKEY"， 新增 "XIAOMI_APPID" 和 "XIAOMI_APPKEY" 配置项。
+ iOS 和 android 都不用主动去设置 数据中心。FlutterPluginEngagelab.setSiteName("") 该方法失效，不需要调用。SDK会根据appkey自动取获取数据中心连接地址。android工程manifestPlaceholders中不需要 设置和填写"ENGAGELAB_PRIVATES_SITE_NAME"项。具体可以查看README.md文档。

## 1.0.0
+ 第一版
