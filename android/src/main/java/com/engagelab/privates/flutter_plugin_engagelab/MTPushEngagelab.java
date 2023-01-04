//package com.engagelab.privates.flutter_plugin_engagelab;
//
//import android.content.Context;
//import android.util.Log;
//
//import com.engagelab.privates.core.api.MTCorePrivatesApi;
//import com.engagelab.privates.push.api.MTPushPrivatesApi;
//
//import org.json.JSONArray;
//import org.json.JSONException;
//import org.json.JSONObject;
//
//import java.util.HashMap;
//
//import io.flutter.plugin.common.MethodCall;
//import io.flutter.plugin.common.MethodChannel;
//
//
///**
// * This class echoes a string called from JavaScript.
// */
//public class MTPushEngagelab {
//    private static final String TAG = "MTPushEngagelab";
//    private static boolean DEBUG = false;
//    static Context context;
//
//    public static void onCommonReceiver(String name, String data) {
////        MTPushEngagelab.logD(TAG, "onCommonReceiver name =" + name);
////        MTPushEngagelab.logD(TAG, "onCommonReceiver data =" + data);
////        if (instance == null) {
////            MTPushEngagelab.logD(TAG, "onCommonReceiver instance == null");
////            return;
////        }
////        if (null == cordovaActivity) {
////            MTPushEngagelab.logD(TAG, "onCommonReceiver cordovaActivity == null");
////            return;
////        }
////        try {
////            JSONObject dataJosn = new JSONObject();
////            dataJosn.put("event_name", name);
////            dataJosn.put("event_data", data);
////            String format = "window.plugins.mTPushEngagelab.onMTCommonReceiver(%s);";
////            final String js = String.format(format, dataJosn.toString());
////            cordovaActivity.runOnUiThread(new Runnable() {
////                @Override
////                public void run() {
////                    instance.webView.loadUrl("javascript:" + js);
////                }
////            });
////        } catch (JSONException e) {
////            e.printStackTrace();
////        }
//    }
//
//
//    static Context getApplicationContext() {
//        return context;
//    }
//
//    /**
//     * 设置心跳时间间隔
//     * <p>
//     * 需要在Application.onCreate()方法中调用
//     *
//     * @param context           不为空
//     * @param heartbeatInterval 时间单位为毫秒、必须大于0、默认值是4分50秒\
//     */
//   static void configHeartbeatInterval(MethodCall call, MethodChannel.Result result) {
//        HashMap<String, Object> map = call.arguments();
//        Context context = getApplicationContext();
//        long heartbeatInterval =call.argument("heartbeatInterval");
//        MTCorePrivatesApi.configHeartbeatInterval(context, heartbeatInterval);
//    }
//
////
////    /**
////     * 设置长连接重试次数
////     * <p>
////     * 需要在Application.onCreate()方法中调用
////     *
////     * @param context           不为空
////     * @param connectRetryCount 重试的次数、默认值为3、最少3次
////     */
////    void configConnectRetryCount(MethodCall call, MethodChannel.Result result) {
////        Context context = getApplicationContext();
////        int connectRetryCount = call.argument("connectRetryCount");
////        MTCorePrivatesApi.configConnectRetryCount(context, connectRetryCount);
////    }
////
////    /**
////     * 设置是否debug模式，debug模式会打印更对详细日志
////     * <p>
////     * 需要在Application.onCreate()方法中调用
////     *
////     * @param context 不为空
////     * @param enable  是否调试模式，true为调试模式，false不是
////     */
////    void configDebugMode(MethodCall call, MethodChannel.Result result) {
////        try {
////            Context context = getApplicationContext();
////            boolean enable = data.getBoolean(0);
////            MTCorePrivatesApi.configDebugMode(context, enable);
////        } catch (JSONException e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 配置使用国密加密
////     *
////     * @param context 不为空
////     */
////    void configSM4(MethodCall call, MethodChannel.Result result) {
////        try {
////            Context context = getApplicationContext();
////            MTCorePrivatesApi.configSM4(context);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 获取当前设备的userId，Engagelab私有云唯一标识，可同于推送
////     *
////     * @param context 不为空
////     * @return userId
////     */
////    String getUserId(MethodCall call, MethodChannel.Result result) {
////        try {
////            Context context = getApplicationContext();
////            long userId = MTCorePrivatesApi.getUserId(context);
////            callbackContext.success(userId + "");
////        } catch (Throwable e) {
////            e.printStackTrace();
////            callbackContext.error(e.getMessage());
////        }
////        return null;
////    }
////
////    /**
////     * 获取当前设备的registrationId，Engagelab私有云唯一标识，可同于推送
////     *
////     * @param context 不为空
////     * @return registrationId
////     */
////    String getRegistrationId(MethodCall call, MethodChannel.Result result) {
////        try {
////            Context context = getApplicationContext();
////            String registrationId = MTCorePrivatesApi.getRegistrationId(context);
////            callbackContext.success(registrationId);
////        } catch (Throwable e) {
////            e.printStackTrace();
////            callbackContext.error(e.getMessage());
////        }
////        return null;
////    }
////
//////    /**
//////     * 配置push版本号为3.9.X
//////     *
//////     * @param context 不为空
//////     */
//////    void configOldPushVersion(MethodCall call, MethodChannel.Result result) {
//////        try {
//////            Context context = getApplicationContext();
//////            MTPushPrivatesApi.configOldPushVersion(context);
//////        } catch (Throwable e) {
//////            e.printStackTrace();
//////        }
//////    }
////
////    /**
////     * MTPush初始化
////     * <p>
////     * 建议在Application.onCreate()方法中调用
////     *
////     * @param context 不为空，请使用applicationContext对象
////     */
////    void init(MethodCall call, MethodChannel.Result result) {
////        try {
////            Context context = getApplicationContext();
////            MTPushPrivatesApi.init(context);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
//////    // 继承MTCommonReceiver后，复写onNotificationStatus方法，获取通知开关状态，如果enable为true说明已经开启成功
//////    @Override
//////    public void onNotificationStatus(Context context, boolean enable) {
//////        if(enable){
//////            // 已设置通知开关为打开
//////        }
//////    }
//////    启动sdk后可根据onNotificationStatus回调结果，再决定是否需要调用此借口
////
////    /**
////     * 前往通知开关设置页面
////     *
////     * @param context 不为空 //TODO weiry
////     */
////    void goToAppNotificationSettings(MethodCall call, MethodChannel.Result result) {
////        try {
////            Context context = getApplicationContext();
////            MTPushPrivatesApi.goToAppNotificationSettings(context);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
//////    // 继承MTCommonReceiver后，复写onConnectStatus方法，获取长连接的连接状态，如果enable为true说明已经开启成功
//////    @Override
//////    public void onConnectStatus(Context context, boolean enable){
//////        if(enable){
//////            // 开启 push 推送成功
//////        }
//////    }
////
////    /**
////     * 开启 Push 推送，并持久化存储开关状态为true，默认是true
////     *
////     * @param context 不能为空  //TODO weiry
////     */
////    void turnOnPush(MethodCall call, MethodChannel.Result result) {
////        try {
////            Context context = getApplicationContext();
////            MTPushPrivatesApi.turnOnPush(context);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 关闭 push 推送，并持久化存储开关状态为false，默认是true
////     *
////     * @param context 不能为空 //TODO weiry
////     */
////    void turnOffPush(MethodCall call, MethodChannel.Result result) {
////        try {
////            Context context = getApplicationContext();
////            MTPushPrivatesApi.turnOffPush(context);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 设置通知展示时间，默认任何时间都展示
////     *
////     * @param context   不为空
////     * @param beginHour 允许通知展示的开始时间（ 24 小时制，范围为 0 到 23 ）
////     * @param endHour   允许通知展示的结束时间（ 24 小时制，范围为 0 到 23 ），beginHour不能大于等于endHour
////     * @param weekDays  允许通知展示的星期数组（ 7 日制，范围为 1 到 7），空数组代表任何时候都不展示通知
////     */
////    void setNotificationShowTime(MethodCall call, MethodChannel.Result result) {
////        try {
////            Context context = getApplicationContext();
////            int beginHour = data.getInt(0);
////            int endHour = data.getInt(1);
////            int[] weekDays = new int[0];
////            if (null != data.get(2)) {
////                JSONArray jsonArray = data.getJSONArray(2);
////                weekDays = new int[jsonArray.length()];
////                for (int i = 0; i < jsonArray.length(); i++) {
////                    weekDays[i] = jsonArray.getInt(i);
////                }
////            }
////            MTPushPrivatesApi.setNotificationShowTime(context, beginHour, endHour, weekDays);
////
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 重置通知展示时间，默认任何时间都展示
////     *
////     * @param context 不为空
////     */
////    void resetNotificationShowTime(JSONArray data, CallbackContext callbackContext) {
////        try {
////            Context context = getApplicationContext();
////            MTPushPrivatesApi.resetNotificationShowTime(context);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 设置通知静默时间，默认任何时间都不静默
////     *
////     * @param context     不为空
////     * @param beginHour   允许通知静默的开始时间，单位小时（ 24 小时制，范围为 0 到 23 ）
////     * @param beginMinute 允许通知静默的开始时间，单位分钟（ 60 分钟制，范围为 0 到 59 ）
////     * @param endHour     允许通知静默的结束时间，单位小时（ 24 小时制，范围为 0 到 23 ）
////     * @param endMinute   允许通知静默的结束时间，单位分钟（ 60 分钟制，范围为 0 到 59 ）
////     */
////    void setNotificationSilenceTime(JSONArray data, CallbackContext callbackContext) {
////        try {
////            Context context = getApplicationContext();
////            int beginHour = data.getInt(0);
////            int beginMinute = data.getInt(1);
////            int endHour = data.getInt(2);
////            int endMinute = data.getInt(3);
////            MTPushPrivatesApi.setNotificationSilenceTime(context, beginHour, beginMinute, endHour, endMinute);
////
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 重置通知静默时间，默认任何时间都不静默
////     *
////     * @param context 不为空
////     */
////    void resetNotificationSilenceTime(JSONArray data, CallbackContext callbackContext) {
////        try {
////            Context context = getApplicationContext();
////            MTPushPrivatesApi.resetNotificationSilenceTime(context);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
//////    /**
//////     * 设置自定义通知布局，默认使用系统通知布局
//////     *
//////     * @param context            不为空
//////     * @param builderId          构建id
//////     * @param notificationLayout 自定义通知布局的对象，不为空
//////     */
//////    public static void setNotificationLayout(Context context, int builderId, NotificationLayout notificationLayout) {
////////        // 这里定义一个常量，代表构建id
////////        private static final int BUILDER_ID = 11;
////////
////////        // 构建出一个notificationLayout
////////        NotificationLayout notificationLayout = new NotificationLayout()
////////                .setLayoutId(R.layout.custom_notification_layout)        // 布局layout_id
////////                .setIconViewId(R.id.iv_notification_icon)                // 通知图标view_id
////////                .setIconResourceId(R.drawable.mtpush_notification_icon)   // 通知图标source_id
////////                .setTitleViewId(R.id.tv_notification_title)              // 通知标题view_id
////////                .setContentViewId(R.id.tv_notification_content)          // 通知内容view_id
////////                .setTimeViewId(R.id.tv_notification_time);               // 通知时间view_id
////////
////////        // 设置构建id为BUILDER_ID的自定义布局，下发通知时指定builderId为BUILDER_ID，即可改变通知布局
////////        MTPushPrivatesApi.setNotificationLayout(this.getApplicationContext(), BUILDER_ID, notificationLayout);
//////    }
////
//////    /**
//////     * 重置自定义通知布局，默认使用系统通知布局
//////     *
//////     * @param context   不为空
//////     * @param builderId 自定义通知布局的id
//////     */
//////    public static void resetNotificationLayout(Context context, int builderId) {
////////        // 这里定义一个常量，代表构建id
////////        private static final int BUILDER_ID = 11;
////////
////////        // 重置构建id为BUILDER_ID的自定义布局，下发通知时指定builderId为BUILDER_ID，将使用系统默认布局
////////        MTPushPrivatesApi.resetNotificationLayout(context,BUILDER_ID);
//////    }
////
////    /**
////     * 设置通知栏的通知数量，默认数量为5
////     *
////     * @param context 不为空
////     * @param count   限制通知栏的通知数量，超出限制数量则移除最老通知，不能小于等于0
////     */
////    void setNotificationCount(JSONArray data, CallbackContext callbackContext) {
////        try {
////            Context context = getApplicationContext();
////            int count = data.getInt(0);
////            MTPushPrivatesApi.setNotificationCount(context, count);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 重置通知栏的通知数量，默认数量为5
////     *
////     * @param context 不为空
////     */
////    void resetNotificationCount(JSONArray data, CallbackContext callbackContext) {
////        try {
////            Context context = getApplicationContext();
////            MTPushPrivatesApi.resetNotificationCount(context);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 设置应用角标数量，默认0（仅华为/荣耀生效）
////     *
////     * @param context 不为空
////     * @param badge   应用角标数量
////     */
////    void setNotificationBadge(JSONArray data, CallbackContext callbackContext) {
////        try {
////            Context context = getApplicationContext();
////            int badge = data.getInt(0);
////            MTPushPrivatesApi.setNotificationBadge(context, badge);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 重置应用角标数量，默认0（仅华为/荣耀生效）
////     *
////     * @param context 不为空
////     */
////    void resetNotificationBadge(JSONArray data, CallbackContext callbackContext) {
////        try {
////            Context context = getApplicationContext();
////            MTPushPrivatesApi.resetNotificationBadge(context);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
//////    /**
//////     * 展示通知
//////     *
//////     * @param context             不为空
//////     * @param notificationMessage 构建的通知对象，不为空
//////     */
//////    public static void showNotification(Context context, NotificationMessage notificationMessage) {
////////        // 构建一个基础的通知，其中messageId和content是必须，否则通知无法展示
////////        NotificationMessage notificationMessage = new NotificationMessage()
////////                .setMessageId("12345")
////////                .setNotificationId(12345)
////////                .setTitle("custom_notification_title")
////////                .setContent("custom_notification_content");
////////        // 展示通知
////////        MTPushPrivatesApi.showNotification(context,notificationMessage);
//////    }
//////
//////    /**
//////     * 清除指定notifyId的通知
//////     *
//////     * @param context  不为空
//////     * @param notifyId 通知id
//////     */
//////    public static void clearNotification(Context context, int notifyId) {
//////
//////    }
////
////    /**
////     * 上报厂商通道通知到达
////     * <p>
////     * 走http/https上报
////     *
////     * @param context           不为空
////     * @param messageId         Engagelab消息id，不为空
////     * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
////     * @param platformMessageId 厂商消息id，可为空
////     */
////    void reportNotificationArrived(JSONArray data, CallbackContext callbackContext) {
//////        // 上报厂商通知到达，messageId为“12345”，厂商为小米，厂商messageId为“MI-6476RHT25”
//////        MTPushPrivatesApi.reportNotificationArrived(context,“12345”,MTPushPrivatesApi.PLATFORM_XIAOMI,"MI-6476RHT25");
////
////        try {
////            Context context = getApplicationContext();
////            String messageId = data.getString(0);
////            byte platform = (byte) data.getInt(1);
////            String platformMessageId = data.getString(2);
////            MTPushPrivatesApi.reportNotificationArrived(context, messageId, platform, platformMessageId);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 上报厂商通道通知点击
////     * <p>
////     * 走http/https上报
////     *
////     * @param context           不为空
////     * @param messageId         Engagelab消息id，不为空
////     * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
////     * @param platformMessageId 厂商消息id，可为空
////     */
////    void reportNotificationClicked(JSONArray data, CallbackContext callbackContext) {
//////        // 上报厂商通知点击，messageId为“12345”，厂商为小米，厂商messageId为“MI-6476RHT25”
//////        MTPushPrivatesApi.reportNotificationClicked(context,“12345”,MTPushPrivatesApi.PLATFORM_XIAOMI,"MI-6476RHT25");
////        try {
////            Context context = getApplicationContext();
////            String messageId = data.getString(0);
////            byte platform = (byte) data.getInt(1);
////            String platformMessageId = data.getString(2);
////            MTPushPrivatesApi.reportNotificationClicked(context, messageId, platform, platformMessageId);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 上报厂商通道通知删除
////     * <p>
////     * 走http/https上报
////     *
////     * @param context           不为空
////     * @param messageId         Engagelab消息id，不为空
////     * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
////     * @param platformMessageId 厂商消息id，可为空
////     */
////    void reportNotificationDeleted(JSONArray data, CallbackContext callbackContext) {
//////// 上报厂商通知删除，messageId为“12345”，厂商为mi，厂商messageId为“MI-6476RHT25”
//////        MTPushPrivatesApi.reportNotificationDeleted(context,“12345”,MTPushPrivatesApi.PLATFORM_XIAOMI,"MI-6476RHT25");
////
////        try {
////            Context context = getApplicationContext();
////            String messageId = data.getString(0);
////            byte platform = (byte) data.getInt(1);
////            String platformMessageId = data.getString(2);
////            MTPushPrivatesApi.reportNotificationDeleted(context, messageId, platform, platformMessageId);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
////
////    /**
////     * 上报厂商通道通知打开
////     * <p>
////     * 走http/https上报
////     *
////     * @param context           不为空
////     * @param messageId         Engagelab消息id，不为空
////     * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
////     * @param platformMessageId 厂商消息id，可为空
////     */
////    void reportNotificationOpened(JSONArray data, CallbackContext callbackContext) {
////        try {
////            Context context = getApplicationContext();
////            String messageId = data.getString(0);
////            byte platform = (byte) data.getInt(1);
////            String platformMessageId = data.getString(2);
////            MTPushPrivatesApi.reportNotificationOpened(context, messageId, platform, platformMessageId);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////
//////        Bundle bundle = intent.getExtras();
//////        String platformMessage = "";
//////        // huawei
//////        if (intent.getData() != null) {
//////            platformMessage = intent.getData().toString();
//////        }
//////        // 其他厂商
//////        if (TextUtils.isEmpty(platformMessage) && intent.getExtras() != null) {
//////            if (MTGlobal.IS_FOR_JIGUANG) {
//////                platformMessage = bundle.getString("JMessageExtra");
//////            }else {
//////                platformMessage = bundle.getString("MTMessageExtra");
//////            }
//////        }
//////        if (TextUtils.isEmpty(platformMessage)) {
//////            return;
//////        }
//////        JSONObject messageJson = new JSONObject(platformMessage);
//////        tvMessage.setText(toLogString(messageJson));
//////        // 解析
//////        String messageId = messageJson.optString("msg_id");
//////        byte platform = (byte) messageJson.optInt("rom_type");
//////        String title = messageJson.optString("n_title");
//////        String content = messageJson.optString("n_content");
//////        // 上报通知点击activity打开，建议所有厂商跳转都加上，仅MTPush4.0.0以下版本需要
//////        MTPushPrivatesApi.reportNotificationOpened(this, messageId, platform, "");
////    }
////
////    /**
////     * 上传厂商token
////     * <p>
////     * 走tcp上传
////     *
////     * @param context  不为空
////     * @param platform 厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
////     * @param token    厂商返回的token，不为空
////     */
////    void uploadPlatformToken(JSONArray data, CallbackContext callbackContext) {
//////        // 上报厂商token，厂商为mi，厂商token为“MI-6476s-afs-afs-afaR-HT25”
//////        MTPushPrivatesApi.uploadPlatformToken(context,MTPushPrivatesApi.PLATFORM_XIAOMI,"MI-6476s-afs-afs-afaR-HT25");
////
////        try {
////            Context context = getApplicationContext();
////            byte platform = (byte) data.getInt(0);
////            String token = data.getString(1);
////            String region = data.getString(2);
////            MTPushPrivatesApi.uploadPlatformToken(context, platform, token, region);
////        } catch (Throwable e) {
////            e.printStackTrace();
////        }
////    }
//
//
//    public static void logD(String tag, String msg) {
//        if (DEBUG) {
//            Log.d(tag, msg);
//        }
//    }
//
//    public static void logE(String tag, String msg) {
//        Log.e(tag, msg);
//    }
//
//
//    public static void logW(String tag, String msg) {
//        Log.w(tag, msg);
//    }
//}
//
