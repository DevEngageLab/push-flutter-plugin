package com.engagelab.privates.flutter_plugin_engagelab;

import android.os.Bundle;

import com.engagelab.privates.push.api.AliasMessage;
import com.engagelab.privates.push.api.CustomMessage;
import com.engagelab.privates.push.api.InAppMessage;
import com.engagelab.privates.push.api.NotificationMessage;
import com.engagelab.privates.push.api.PlatformTokenMessage;
import com.engagelab.privates.push.api.TagMessage;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


public class MsgToJson {

    public static String aliasMessageToJson(AliasMessage aliasMessage) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("alias", aliasMessage.getAlias());
            jsonObject.put("code", aliasMessage.getCode());
            jsonObject.put("sequence", aliasMessage.getSequence());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    public static String tagMessageToJson(TagMessage tagMessage) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("code", tagMessage.getCode());
            jsonObject.put("queryTag", tagMessage.getQueryTag());
            jsonObject.put("sequence", tagMessage.getSequence());
            String[] tags = tagMessage.getTags();
            JSONArray jsonArray = arrayToJson(tags);
            jsonObject.put("tags", jsonArray);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    public static String platformTokenMessageToJson(PlatformTokenMessage platformTokenMessage) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("platform", platformTokenMessage.getPlatform());
            jsonObject.put("token", platformTokenMessage.getToken());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    public static String customMessageToJson(CustomMessage customMessage) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("content", customMessage.getContent());
            jsonObject.put("contentType", customMessage.getContentType());
            jsonObject.put("messageId", customMessage.getMessageId());
            jsonObject.put("platform", customMessage.getPlatform());
            jsonObject.put("platformMessageId", customMessage.getPlatformMessageId());
            jsonObject.put("title", customMessage.getTitle());
            Bundle extras = customMessage.getExtras();
            JSONObject bundleToJson = bundleToJson(extras);
            jsonObject.put("extras", bundleToJson);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    public static String notificationMessageToJson(NotificationMessage notificationMessage) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("badge", notificationMessage.getBadge());
            jsonObject.put("bigPicture", notificationMessage.getBigPicture());
            jsonObject.put("bigText", notificationMessage.getBigText());
            jsonObject.put("builderId", notificationMessage.getBuilderId());
            jsonObject.put("category", notificationMessage.getCategory());
            jsonObject.put("channelId", notificationMessage.getChannelId());
            jsonObject.put("content", notificationMessage.getContent());
            jsonObject.put("defaults", notificationMessage.getDefaults());
            Bundle extras = notificationMessage.getExtras();
            jsonObject.put("extras", bundleToJson(extras));
            String[] inbox = notificationMessage.getInbox();
            jsonObject.put("inbox", arrayToJson(inbox));
            jsonObject.put("intentSsl", notificationMessage.getIntentSsl());
            jsonObject.put("intentUri", notificationMessage.getIntentUri());
            jsonObject.put("largeIcon", notificationMessage.getLargeIcon());
            jsonObject.put("messageId", notificationMessage.getMessageId());
            jsonObject.put("notificationId", notificationMessage.getNotificationId());
            jsonObject.put("overrideMessageId", notificationMessage.getOverrideMessageId());
            jsonObject.put("platform", notificationMessage.getPlatform());
            jsonObject.put("platformMessageId", notificationMessage.getPlatformMessageId());
            jsonObject.put("priority", notificationMessage.getPriority());
            jsonObject.put("smallIcon", notificationMessage.getSmallIcon());
            jsonObject.put("sound", notificationMessage.getSound());
            jsonObject.put("style", notificationMessage.getStyle());
            jsonObject.put("title", notificationMessage.getTitle());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    public static String inappMessageToJson(InAppMessage inappMessage) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("messageId", inappMessage.getMessageId());
            jsonObject.put("target", inappMessage.getTarget());
            jsonObject.put("content", inappMessage.getContent());
            jsonObject.put("clickAction", inappMessage.getClick());
            jsonObject.put("extras", inappMessage.getExtras());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }


    public static String booleanToJson(boolean enable) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("enable", enable);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

    private static JSONObject bundleToJson(Bundle extras) throws JSONException {
        JSONObject jExtras = new JSONObject();
        if (null != extras) {
            for (String key : extras.keySet()) {
                jExtras.put(key, extras.get(key));
            }
        }
        return jExtras;
    }

    private static JSONArray arrayToJson(String[] tags) {
        JSONArray jsonArray = new JSONArray();
        if (null != tags) {
            for (String t : tags) {
                jsonArray.put(t);
            }
        }
        return jsonArray;
    }
}
