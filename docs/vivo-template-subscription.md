# vivo 通知渠道订阅

Android 前台页面、SDK 已初始化且通知权限已开启时调用：

```text
FlutterPluginEngagelab.requestVivoSubscribeChannelAndroid(channelIds)
```

传入 1–3 个非空通知渠道 ID。非 vivo 设备忽略。需要 Android 10 及以上、vivo Push SDK `4.1.7.0_517` 及以上和包含 `requestVivoSubscribeChannel(Activity, ArrayList<String>)` 的 EngageLab SDK。旧 SDK `5.5.1` 的公开制品没有此接口，不可直接用于本功能交付。

通过原有 `onCommandResult` 事件接收最终结果：`cmd=2013`，`errorCode` 为操作结果，`extra` 中保留 `operate_result` 与 `channel_operations`。渠道项使用厂商字段 `channelId`、`operation`，`operation=1` 表示允许、`2` 表示拒绝。以各渠道最终结果为准。桥接调用成功或弹窗启动成功不能视为授权成功。

SDK 与插件必须同窗口升级。Gradle 插件工程可通过 `engagelabSdkVersion` 属性选择新 SDK 版本；UTS 更新 `utssdk/app-android/config.json` 的 SDK 依赖；UniApp 替换工程及离线插件的主包和 vivo AAR。Android 主 SDK 与 vivo 包使用 5.5.3；Maven 依赖在正式制品发布后可解析。

验证：允许、拒绝、返回、超时、重复请求、无前台 Activity、不支持的 vivo 系统、非 vivo 静默，以及小米既有订阅回归。
