package com.engagelab.privates.flutter_plugin_engagelab;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;

import com.engagelab.privates.common.global.MTGlobal;
import com.engagelab.privates.core.api.MTCorePrivatesApi;
import com.engagelab.privates.push.api.MTPushPrivatesApi;
import com.engagelab.privates.push.api.NotificationMessage;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterPluginEngagelabPlugin
 */
public class FlutterPluginEngagelabPlugin implements FlutterPlugin, MethodCallHandler {
    private static final String TAG = "FlutterEngagelabPlugin";
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity

    public static FlutterPluginEngagelabPlugin instance;
    private MethodChannel channel;
    private Context context;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_plugin_engagelab");
        channel.setMethodCallHandler(this);
        context = flutterPluginBinding.getApplicationContext();
        instance = this;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
//        if (call.method.equals("getPlatformVersion")) {
//            Log.d(TAG, "onMethodCall:" + call);
//            List<Object> arguments = (List<Object>) call.arguments;
//
//            Log.d(TAG, "onMethodCall List arguments:" + arguments);
//            result.success("Android " + android.os.Build.VERSION.RELEASE);
//        } else if (call.method.equals("configHeartbeatInterval")) {
////            MTPushEngagelab.configHeartbeatInterval(call, result);
//        } else {
//            result.notImplemented();
//        }
        List<Object> arguments = (List<Object>) call.arguments;
//        Log.e(TAG, "arguments:" + arguments);
        JSONArray data = new JSONArray();
        if (null != arguments) {
            for (Object o : arguments) {
                data.put(o);
            }
        }
        execute(call.method, data, result);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }


    public boolean execute(String name, JSONArray data, @NonNull Result result) {
        try {
            if ("configDebugMode".equals(name)) {
                DEBUG = data.getBoolean(0);
            }
            logD(TAG, "execute name:" + name);
            logD(TAG, "execute data:" + data);

            try {
                Method method = FlutterPluginEngagelabPlugin.class.getDeclaredMethod(name, JSONArray.class, Result.class);
                method.invoke(FlutterPluginEngagelabPlugin.this, data, result);
            } catch (Exception e) {
                logE(TAG, e.toString());
                result.notImplemented();
            }


        } catch (Throwable e) {

        }
        return true;
    }

    private static boolean DEBUG = false;

    private static List<CommonReceiverCache> onCommonReceiverCache = new ArrayList<CommonReceiverCache>();

    public static synchronized void onCommonReceiver(String name, String data) {
        logD(TAG, "onCommonReceiver name =" + name);
        logD(TAG, "onCommonReceiver data =" + data);
        logD(TAG, "onCommonReceiver instance =" + instance);
        if (null != instance){

            Map<String, String> dataJosn = new HashMap<>();
            dataJosn.put("event_name", name);
            dataJosn.put("event_data", data);
            instance.channel.invokeMethod("onMTCommonReceiver", dataJosn);
        } else {
            onCommonReceiverCache.add(new CommonReceiverCache(name, data));
        }
    }
    private static synchronized void sendCommonReceiverCache() {
        if (!onCommonReceiverCache.isEmpty()) {
            logD(TAG, "sendCommonReceiverCache:" + onCommonReceiverCache.size());
            for (CommonReceiverCache c : onCommonReceiverCache) {
                onCommonReceiver(c.getName(), c.getData());
            }
            onCommonReceiverCache.clear();
        }
    }


    private static class CommonReceiverCache {
        private String name;
        private String data;

        public CommonReceiverCache(String name, String data) {
            this.name = name;
            this.data = data;
        }

        public String getName() {
            return name;
        }

        public String getData() {
            return data;
        }
    }


    Context getApplicationContext() {
        return context;
    }


    /**
     * 设置心跳时间间隔
     * <p>
     * 需要在Application.onCreate()方法中调用
     *
     * @param context           不为空
     * @param heartbeatInterval 时间单位为毫秒、必须大于0、默认值是4分50秒\
     */
    void configHeartbeatInterval(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            long heartbeatInterval = data.getLong(0);
            MTCorePrivatesApi.configHeartbeatInterval(context, heartbeatInterval);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


    /**
     * 设置长连接重试次数
     * <p>
     * 需要在Application.onCreate()方法中调用
     *
     * @param context           不为空
     * @param connectRetryCount 重试的次数、默认值为3、最少3次
     */
    void configConnectRetryCount(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            int connectRetryCount = data.getInt(0);
            MTCorePrivatesApi.configConnectRetryCount(context, connectRetryCount);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * 设置是否debug模式，debug模式会打印更对详细日志
     * <p>
     * 需要在Application.onCreate()方法中调用
     *
     * @param context 不为空
     * @param enable  是否调试模式，true为调试模式，false不是
     */
    void configDebugMode(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            boolean enable = data.getBoolean(0);
            logD(TAG, "configDebugMode enable:" + enable);
            MTCorePrivatesApi.configDebugMode(context, enable);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * 配置使用国密加密
     *
     * @param context 不为空
     */
    void configSM4(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            MTCorePrivatesApi.configSM4(context);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 获取当前设备的userId，Engagelab私有云唯一标识，可同于推送
     *
     * @param context 不为空
     * @return userId
     */
    String getUserId(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            long userId = MTCorePrivatesApi.getUserId(context);
            result.success(userId + "");
        } catch (Throwable e) {
            e.printStackTrace();
            result.error("-1", "getUserId", e.getMessage());
        }
        return null;
    }

    /**
     * 获取当前设备的registrationId，Engagelab私有云唯一标识，可同于推送
     *
     * @param context 不为空
     * @return registrationId
     */
    String getRegistrationId(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            String registrationId = MTCorePrivatesApi.getRegistrationId(context);
            result.success(registrationId);
        } catch (Throwable e) {
            e.printStackTrace();
            result.error("-1", "getRegistrationId", e.getMessage());
        }
        return null;
    }

//    /**
//     * 配置push版本号为3.9.X
//     *
//     * @param context 不为空
//     */
//    void configOldPushVersion(JSONArray data, Result result) {
//        try {
//            Context context = getApplicationContext();
//            MTPushPrivatesApi.configOldPushVersion(context);
//        } catch (Throwable e) {
//            e.printStackTrace();
//        }
//    }

    /**
     * MTPush初始化
     * <p>
     * 建议在Application.onCreate()方法中调用
     *
     * @param context 不为空，请使用applicationContext对象
     */
    void init(JSONArray data, Result result) {
        try {
            logD(TAG, "init");
            Context context = getApplicationContext();
            MTPushPrivatesApi.init(context);
            sendCommonReceiverCache();
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void setSiteName(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            String siteName = data.getString(0);
            MTCorePrivatesApi.configAppSiteName(context, siteName);
        }catch (Throwable e) {
            e.printStackTrace();
        }
    }
    void configAppKey(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            String appKey = data.getString(0);
            MTCorePrivatesApi.configAppKey(context,appKey);
        }catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void setUserLanguage(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            String language = data.getString(0);
            MTPushPrivatesApi.configUserLanguage(context,language);
        }catch (Throwable e) {
            e.printStackTrace();
        }
    }

//    // 继承MTCommonReceiver后，复写onNotificationStatus方法，获取通知开关状态，如果enable为true说明已经开启成功
//    @Override
//    public void onNotificationStatus(Context context, boolean enable) {
//        if(enable){
//            // 已设置通知开关为打开
//        }
//    }
//    启动sdk后可根据onNotificationStatus回调结果，再决定是否需要调用此借口

    /**
     * 前往通知开关设置页面
     *
     * @param context 不为空 //TODO weiry
     */
    void goToAppNotificationSettings(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            MTPushPrivatesApi.goToAppNotificationSettings(context);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

//    // 继承MTCommonReceiver后，复写onConnectStatus方法，获取长连接的连接状态，如果enable为true说明已经开启成功
//    @Override
//    public void onConnectStatus(Context context, boolean enable){
//        if(enable){
//            // 开启 push 推送成功
//        }
//    }

    /**
     * 开启 Push 推送，并持久化存储开关状态为true，默认是true
     *
     * @param context 不能为空  //TODO weiry
     */
    void turnOnPush(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            MTPushPrivatesApi.turnOnPush(context);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 关闭 push 推送，并持久化存储开关状态为false，默认是true
     *
     * @param context 不能为空 //TODO weiry
     */
    void turnOffPush(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            MTPushPrivatesApi.turnOffPush(context);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 设置通知展示时间，默认任何时间都展示
     *
     * @param context   不为空
     * @param beginHour 允许通知展示的开始时间（ 24 小时制，范围为 0 到 23 ）
     * @param endHour   允许通知展示的结束时间（ 24 小时制，范围为 0 到 23 ），beginHour不能大于等于endHour
     * @param weekDays  允许通知展示的星期数组（ 7 日制，范围为 1 到 7），空数组代表任何时候都不展示通知
     */
    void setNotificationShowTime(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            int beginHour = data.getInt(0);
            int endHour = data.getInt(1);
            int[] weekDays = new int[0];
            if (null != data.get(2)) {
                List<Integer> jsonArray = (List<Integer>) data.get(2);
                weekDays = new int[jsonArray.size()];
                for (int i = 0; i < jsonArray.size(); i++) {
                    weekDays[i] = jsonArray.get(i);
                }
            }
            MTPushPrivatesApi.setNotificationShowTime(context, beginHour, endHour, weekDays);

        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 重置通知展示时间，默认任何时间都展示
     *
     * @param context 不为空
     */
    void resetNotificationShowTime(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            MTPushPrivatesApi.resetNotificationShowTime(context);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 设置通知静默时间，默认任何时间都不静默
     *
     * @param context     不为空
     * @param beginHour   允许通知静默的开始时间，单位小时（ 24 小时制，范围为 0 到 23 ）
     * @param beginMinute 允许通知静默的开始时间，单位分钟（ 60 分钟制，范围为 0 到 59 ）
     * @param endHour     允许通知静默的结束时间，单位小时（ 24 小时制，范围为 0 到 23 ）
     * @param endMinute   允许通知静默的结束时间，单位分钟（ 60 分钟制，范围为 0 到 59 ）
     */
    void setNotificationSilenceTime(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            int beginHour = data.getInt(0);
            int beginMinute = data.getInt(1);
            int endHour = data.getInt(2);
            int endMinute = data.getInt(3);
            MTPushPrivatesApi.setNotificationSilenceTime(context, beginHour, beginMinute, endHour, endMinute);

        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 重置通知静默时间，默认任何时间都不静默
     *
     * @param context 不为空
     */
    void resetNotificationSilenceTime(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            MTPushPrivatesApi.resetNotificationSilenceTime(context);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

//    /**
//     * 设置自定义通知布局，默认使用系统通知布局
//     *
//     * @param context            不为空
//     * @param builderId          构建id
//     * @param notificationLayout 自定义通知布局的对象，不为空
//     */
//    public static void setNotificationLayout(Context context, int builderId, NotificationLayout notificationLayout) {
////        // 这里定义一个常量，代表构建id
////        private static final int BUILDER_ID = 11;
////
////        // 构建出一个notificationLayout
////        NotificationLayout notificationLayout = new NotificationLayout()
////                .setLayoutId(R.layout.custom_notification_layout)        // 布局layout_id
////                .setIconViewId(R.id.iv_notification_icon)                // 通知图标view_id
////                .setIconResourceId(R.drawable.mtpush_notification_icon)   // 通知图标source_id
////                .setTitleViewId(R.id.tv_notification_title)              // 通知标题view_id
////                .setContentViewId(R.id.tv_notification_content)          // 通知内容view_id
////                .setTimeViewId(R.id.tv_notification_time);               // 通知时间view_id
////
////        // 设置构建id为BUILDER_ID的自定义布局，下发通知时指定builderId为BUILDER_ID，即可改变通知布局
////        MTPushPrivatesApi.setNotificationLayout(this.getApplicationContext(), BUILDER_ID, notificationLayout);
//    }

//    /**
//     * 重置自定义通知布局，默认使用系统通知布局
//     *
//     * @param context   不为空
//     * @param builderId 自定义通知布局的id
//     */
//    public static void resetNotificationLayout(Context context, int builderId) {
////        // 这里定义一个常量，代表构建id
////        private static final int BUILDER_ID = 11;
////
////        // 重置构建id为BUILDER_ID的自定义布局，下发通知时指定builderId为BUILDER_ID，将使用系统默认布局
////        MTPushPrivatesApi.resetNotificationLayout(context,BUILDER_ID);
//    }

    /**
     * 设置通知栏的通知数量，默认数量为5
     *
     * @param context 不为空
     * @param count   限制通知栏的通知数量，超出限制数量则移除最老通知，不能小于等于0
     */
    void setNotificationCount(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            int count = data.getInt(0);
            MTPushPrivatesApi.setNotificationCount(context, count);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 重置通知栏的通知数量，默认数量为5
     *
     * @param context 不为空
     */
    void resetNotificationCount(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            MTPushPrivatesApi.resetNotificationCount(context);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 设置应用角标数量，默认0（仅华为/荣耀生效）
     *
     * @param context 不为空
     * @param badge   应用角标数量
     */
    void setNotificationBadge(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            int badge = data.getInt(0);
            MTPushPrivatesApi.setNotificationBadge(context, badge);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 重置应用角标数量，默认0（仅华为/荣耀生效）
     *
     * @param context 不为空
     */
    void resetNotificationBadge(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            MTPushPrivatesApi.resetNotificationBadge(context);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 展示自定义通知
     */
    void sendLocalNotification(JSONArray data, Result result) {

        try {
            HashMap<String, Object> map = (HashMap<String, Object>)data.get(0);
            HashMap<String, Object> extra = (HashMap<String, Object>) map.get("extra");
            Context context = getApplicationContext();
            Bundle bundle = hashMapToBundle(extra);
            // 构建一个基础的通知，其中messageId和content是必须，否则通知无法展示
            NotificationMessage notificationMessage = new NotificationMessage()
                    .setNotificationId((int) map.get("id"))
                    .setTitle((String) map.get("title"))
                    .setContent((String) map.get("content"))
                    .setCategory((String) map.get("category"))
                    .setExtras(bundle);
            if (map.get("priority") != null) {
                notificationMessage.setPriority((int)map.get("priority"));
            }
            // 展示通知
            MTPushPrivatesApi.showNotification(context,notificationMessage);
        }catch (Throwable e) {
            e.printStackTrace();
        }

    }

    Bundle hashMapToBundle(HashMap<String, Object> map) {
        Bundle bundle = new Bundle();
        if (map != null) {
            Iterator iter = map.entrySet().iterator();
            while (iter.hasNext()) {
                Map.Entry entry = (Map.Entry) iter.next();
                String key = (String) entry.getKey();
                Object value = entry.getValue();
                if (value instanceof String) {
                    bundle.putString(key, (String) value);
                } else if (value instanceof Integer) {
                    bundle.putInt(key, (Integer) value);
                } else if (value instanceof Boolean) {
                    bundle.putBoolean(key, (Boolean) value);
                } else if (value instanceof Long) {
                    bundle.putLong(key, (Long) value);
                } else if (value instanceof Double) {
                    bundle.putDouble(key, (Double) value);
                }
            }
        }
        return bundle;
    }



    /**
     * 上报厂商通道通知到达
     * <p>
     * 走http/https上报
     *
     * @param context           不为空
     * @param messageId         Engagelab消息id，不为空
     * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
     * @param platformMessageId 厂商消息id，可为空
     */
    void reportNotificationArrived(JSONArray data, Result result) {
//        // 上报厂商通知到达，messageId为“12345”，厂商为小米，厂商messageId为“MI-6476RHT25”
//        MTPushPrivatesApi.reportNotificationArrived(context,“12345”,MTPushPrivatesApi.PLATFORM_XIAOMI,"MI-6476RHT25");

        try {
            Context context = getApplicationContext();
            String messageId = data.getString(0);
            byte platform = (byte) data.getInt(1);
            String platformMessageId = data.getString(2);
            MTPushPrivatesApi.reportNotificationArrived(context, messageId, platform, platformMessageId);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 上报厂商通道通知点击
     * <p>
     * 走http/https上报
     *
     * @param context           不为空
     * @param messageId         Engagelab消息id，不为空
     * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
     * @param platformMessageId 厂商消息id，可为空
     */
    void reportNotificationClicked(JSONArray data, Result result) {
//        // 上报厂商通知点击，messageId为“12345”，厂商为小米，厂商messageId为“MI-6476RHT25”
//        MTPushPrivatesApi.reportNotificationClicked(context,“12345”,MTPushPrivatesApi.PLATFORM_XIAOMI,"MI-6476RHT25");
        try {
            Context context = getApplicationContext();
            String messageId = data.getString(0);
            byte platform = (byte) data.getInt(1);
            String platformMessageId = data.getString(2);
            MTPushPrivatesApi.reportNotificationClicked(context, messageId, platform, platformMessageId);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 上报厂商通道通知删除
     * <p>
     * 走http/https上报
     *
     * @param context           不为空
     * @param messageId         Engagelab消息id，不为空
     * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
     * @param platformMessageId 厂商消息id，可为空
     */
    void reportNotificationDeleted(JSONArray data, Result result) {
//// 上报厂商通知删除，messageId为“12345”，厂商为mi，厂商messageId为“MI-6476RHT25”
//        MTPushPrivatesApi.reportNotificationDeleted(context,“12345”,MTPushPrivatesApi.PLATFORM_XIAOMI,"MI-6476RHT25");

        try {
            Context context = getApplicationContext();
            String messageId = data.getString(0);
            byte platform = (byte) data.getInt(1);
            String platformMessageId = data.getString(2);
            MTPushPrivatesApi.reportNotificationDeleted(context, messageId, platform, platformMessageId);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    /**
     * 上报厂商通道通知打开
     * <p>
     * 走http/https上报
     *
     * @param context           不为空
     * @param messageId         Engagelab消息id，不为空
     * @param platform          厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
     * @param platformMessageId 厂商消息id，可为空
     */
    void reportNotificationOpened(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            String messageId = data.getString(0);
            byte platform = (byte) data.getInt(1);
            String platformMessageId = data.getString(2);
            MTPushPrivatesApi.reportNotificationOpened(context, messageId, platform, platformMessageId);
        } catch (Throwable e) {
            e.printStackTrace();
        }

//        Bundle bundle = intent.getExtras();
//        String platformMessage = "";
//        // huawei
//        if (intent.getData() != null) {
//            platformMessage = intent.getData().toString();
//        }
//        // 其他厂商
//        if (TextUtils.isEmpty(platformMessage) && intent.getExtras() != null) {
//            if (MTGlobal.IS_FOR_JIGUANG) {
//                platformMessage = bundle.getString("JMessageExtra");
//            }else {
//                platformMessage = bundle.getString("MTMessageExtra");
//            }
//        }
//        if (TextUtils.isEmpty(platformMessage)) {
//            return;
//        }
//        JSONObject messageJson = new JSONObject(platformMessage);
//        tvMessage.setText(toLogString(messageJson));
//        // 解析
//        String messageId = messageJson.optString("msg_id");
//        byte platform = (byte) messageJson.optInt("rom_type");
//        String title = messageJson.optString("n_title");
//        String content = messageJson.optString("n_content");
//        // 上报通知点击activity打开，建议所有厂商跳转都加上，仅MTPush4.0.0以下版本需要
//        MTPushPrivatesApi.reportNotificationOpened(this, messageId, platform, "");
    }

    /**
     * 上传厂商token
     * <p>
     * 走tcp上传
     *
     * @param context  不为空
     * @param platform 厂商，取值范围（1:mi、2:huawei、3:meizu、4:oppo、5:vivo、8:google）
     * @param token    厂商返回的token，不为空
     */
    void uploadPlatformToken(JSONArray data, Result result) {
//        // 上报厂商token，厂商为mi，厂商token为“MI-6476s-afs-afs-afaR-HT25”
//        MTPushPrivatesApi.uploadPlatformToken(context,MTPushPrivatesApi.PLATFORM_XIAOMI,"MI-6476s-afs-afs-afaR-HT25");

        try {
            Context context = getApplicationContext();
            byte platform = (byte) data.getInt(0);
            String token = data.getString(1);
            String region = data.getString(2);
            MTPushPrivatesApi.uploadPlatformToken(context, platform, token, region);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }


    /**
     * 清除厂商token，成功后通过onPlatformToken回调，数据platform为-128，表示清除成功
     */
    void clearPlatformToken(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            MTPushPrivatesApi.clearPlatformToken(context);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void addTags(JSONArray data, Result result) {
        int sequence = -1;
        Set<String> tags = new HashSet<String>();

        try {
            String string = data.getString(0);
            JSONObject params = new JSONObject(string);
            sequence = params.getInt("sequence");
            JSONArray tagsArr = params.getJSONArray("tags");
            for (int i = 0; i < tagsArr.length(); i++) {
                tags.add(tagsArr.getString(i));
            }

        } catch (JSONException e) {
            e.printStackTrace();
            return;
        }
        String[] toArray = tags.toArray(new String[tags.size()]);
        MTPushPrivatesApi.addTag(getApplicationContext(), sequence, toArray);
    }

    void deleteTags(JSONArray data, Result result) {
        int sequence = -1;
        Set<String> tags = new HashSet<String>();

        try {
            String string = data.getString(0);
            JSONObject params = new JSONObject(string);
            sequence = params.getInt("sequence");

            JSONArray tagsArr = params.getJSONArray("tags");
            for (int i = 0; i < tagsArr.length(); i++) {
                tags.add(tagsArr.getString(i));
            }

        } catch (JSONException e) {
            e.printStackTrace();
            return;
        }
        String[] toArray = tags.toArray(new String[tags.size()]);
        MTPushPrivatesApi.deleteTag(getApplicationContext(), sequence, toArray);
    }

    void updateTags(JSONArray data, Result result) {
        int sequence = -1;
        Set<String> tags = new HashSet<String>();

        try {
            String string = data.getString(0);
            JSONObject params = new JSONObject(string);
            sequence = params.getInt("sequence");

            JSONArray tagsArr = params.getJSONArray("tags");
            for (int i = 0; i < tagsArr.length(); i++) {
                tags.add(tagsArr.getString(i));
            }

        } catch (JSONException e) {
            e.printStackTrace();
            return;
        }
        String[] toArray = tags.toArray(new String[tags.size()]);
        MTPushPrivatesApi.updateTag(getApplicationContext(), sequence, toArray);
    }

    void queryTag(JSONArray data, Result result) {

        int sequence = -1;
        String tag = "";

        try {
            String string = data.getString(0);
            JSONObject params = new JSONObject(string);
            sequence = params.getInt("sequence");
            tag = params.getString("tag");

        } catch (JSONException e) {
            e.printStackTrace();
            return;
        }
        MTPushPrivatesApi.queryTag(getApplicationContext(), sequence, tag);
    }

    void deleteAllTag(JSONArray data, Result result) {
        try {
            int sequence = data.getInt(0);
            MTPushPrivatesApi.deleteAllTag(getApplicationContext(), sequence);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void queryAllTag(JSONArray data, Result result) {
        try {
            int sequence = data.getInt(0);
            MTPushPrivatesApi.queryAllTag(getApplicationContext(), sequence);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void setAlias(JSONArray data, Result result) {
        try {
            int sequence = data.getInt(0);
            String alias = data.getString(1);
            MTPushPrivatesApi.setAlias(getApplicationContext(), sequence, alias);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void getAlias(JSONArray data, Result result) {
        try {
            int sequence = data.getInt(0);
            MTPushPrivatesApi.getAlias(getApplicationContext(), sequence);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void clearAlias(JSONArray data, Result result) {
        try {
            int sequence = data.getInt(0);
            MTPushPrivatesApi.clearAlias(getApplicationContext(), sequence);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void setCountryCode(JSONArray data, Result result) {
        try {
            String ccode = data.getString(0);
            MTGlobal.setCountryCode(ccode);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void clearNotification(JSONArray data, Result result) {
        try {
            int notifyId = data.getInt(0);
            MTPushPrivatesApi.clearNotification(getApplicationContext(),notifyId);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void clearNotificationAll(JSONArray data, Result result) {
        try {
            MTPushPrivatesApi.clearNotification(getApplicationContext());
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }


    void onFragmentResume(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            String className = data.getString(0);
            MTPushPrivatesApi.onFragmentResume(getApplicationContext(),className);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    void onFragmentPause(JSONArray data, Result result) {
        try {
            Context context = getApplicationContext();
            String className = data.getString(0);
            MTPushPrivatesApi.onFragmentPause(getApplicationContext(),className);
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    public static void logD(String tag, String msg) {
        if (DEBUG) {
            Log.d("ENGAGELAB-PRIVATES-Flu", "[" + tag + "]" + msg);
        }
    }

    public static void logE(String tag, String msg) {
        Log.e("ENGAGELAB-PRIVATES-Flu", "[" + tag + "]" + msg);
    }


    public static void logW(String tag, String msg) {
        Log.w("ENGAGELAB-PRIVATES-Flu", "[" + tag + "]" + msg);
    }
}
