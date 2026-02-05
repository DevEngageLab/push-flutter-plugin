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
