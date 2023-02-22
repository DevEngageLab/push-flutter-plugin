package com.engagelab.privates.flutter_plugin_engagelab;

import android.content.Context;

import com.engagelab.privates.common.component.MTCommonReceiver;
import com.engagelab.privates.push.api.CustomMessage;
import com.engagelab.privates.push.api.NotificationMessage;
import com.engagelab.privates.push.api.PlatformTokenMessage;

/**
 * This class echoes a string called from JavaScript.
 */
public class UserReceiver extends MTCommonReceiver {

    private static final String TAG = "UserReceiver";

    /**
     * 应用通知开关状态回调
     *
     * @param context 不为空
     * @param enable  通知开关是否开，true为打开，false为关闭
     */
    @Override
    public void onNotificationStatus(Context context, boolean enable) {
        FlutterPluginEngagelabPlugin.logD(TAG, "onNotificationStatus:" + enable);
        FlutterPluginEngagelabPlugin.onCommonReceiver("onNotificationStatus", MsgToJson.booleanToJson(enable));
    }

    /**
     * 长连接状态回调
     *
     * @param context 不为空
     * @param enable  是否连接
     */
    @Override
    public void onConnectStatus(Context context, boolean enable) {
        FlutterPluginEngagelabPlugin.logD(TAG, "onConnectState:" + enable);
        FlutterPluginEngagelabPlugin.onCommonReceiver("onConnectStatus", MsgToJson.booleanToJson(enable));
    }

    /**
     * 通知消息到达回调
     *
     * @param context             不为空
     * @param notificationMessage 通知消息
     */
    @Override
    public void onNotificationArrived(Context context, NotificationMessage notificationMessage) {
        FlutterPluginEngagelabPlugin.logD(TAG, "onNotificationArrived:" + notificationMessage.toString());
        FlutterPluginEngagelabPlugin.onCommonReceiver("onNotificationArrived", MsgToJson.notificationMessageToJson(notificationMessage));
    }

    /**
     * 通知消息点击回调
     *
     * @param context             不为空
     * @param notificationMessage 通知消息
     */
    @Override
    public void onNotificationClicked(Context context, NotificationMessage notificationMessage) {
        FlutterPluginEngagelabPlugin.logD(TAG, "onNotificationClicked:" + notificationMessage.toString());
        FlutterPluginEngagelabPlugin.onCommonReceiver("onNotificationClicked", MsgToJson.notificationMessageToJson(notificationMessage));
    }

    /**
     * 通知消息删除回调
     *
     * @param context             不为空
     * @param notificationMessage 通知消息
     */
    @Override
    public void onNotificationDeleted(Context context, NotificationMessage notificationMessage) {
        FlutterPluginEngagelabPlugin.logD(TAG, "onNotificationDeleted:" + notificationMessage.toString());
        FlutterPluginEngagelabPlugin.onCommonReceiver("onNotificationDeleted", MsgToJson.notificationMessageToJson(notificationMessage));
    }

    /**
     * 自定义消息回调
     *
     * @param context       不为空
     * @param customMessage 自定义消息
     */
    @Override
    public void onCustomMessage(Context context, CustomMessage customMessage) {
        FlutterPluginEngagelabPlugin.logD(TAG, "onCustomMessage:" + customMessage.toString());
        FlutterPluginEngagelabPlugin.onCommonReceiver("onCustomMessage", MsgToJson.customMessageToJson(customMessage));
    }

    /**
     * 厂商token消息回调
     *
     * @param context              不为空
     * @param platformTokenMessage 厂商token消息
     */
    @Override
    public void onPlatformToken(Context context, PlatformTokenMessage platformTokenMessage) {
        FlutterPluginEngagelabPlugin.logD(TAG, "onPlatformToken:" + platformTokenMessage.toString());
        FlutterPluginEngagelabPlugin.onCommonReceiver("onPlatformToken", MsgToJson.platformTokenMessageToJson(platformTokenMessage));
    }

}

