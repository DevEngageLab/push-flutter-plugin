package com.engagelab.privates.flutter_plugin_engagelab;

import android.app.Application;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.util.Log;

import com.engagelab.privates.common.log.MTCommonLog;
import com.engagelab.privates.core.api.MTCorePrivatesApi;

public class MTApplication extends Application {
    private static final String TAG = "ENGAGELAB-MTApplication";

    @Override
    public void onCreate() {
        super.onCreate();
        String APP_TCP_SSL = getMetaData(getApplicationContext(), "APP_TCP_SSL");
        String APP_DEBUG = getMetaData(getApplicationContext(), "APP_DEBUG");
        Log.e(TAG,"APP_TCP_SSL:"+APP_TCP_SSL);
        Log.e(TAG,"APP_DEBUG:"+APP_DEBUG);
        MTCorePrivatesApi.setTcpSSl(isTrue(APP_TCP_SSL));
        MTCorePrivatesApi.configDebugMode(getApplicationContext(), isTrue(APP_DEBUG));

    }

    private boolean isTrue(String APP_TCP_SSL) {
        return "true".equals(APP_TCP_SSL);
    }

    public static String getMetaData(Context context, String metaDataName) {
        try {
            ApplicationInfo info = context.getPackageManager().getApplicationInfo(context.getPackageName(), PackageManager.GET_META_DATA);
            if (info != null && info.metaData != null) {
                Object obj = info.metaData.get(metaDataName);
                if (null == obj) {
                    return "";
                }
                return String.valueOf(obj);
            }
        } catch (Throwable throwable) {
            Log.w(TAG, "getMetaData failed " + throwable.getMessage());
        }
        return "";
    }
}
