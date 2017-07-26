package com.comnet.molenet;

import com.comnet.molenet.R;
import android.content.Context;


import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import android.util.Log;

public class MainApplication extends org.qtproject.qt5.android.bindings.QtApplication
{
    private static Context context;

    public void onCreate()
    {
        super.onCreate();
        MainApplication.context = getApplicationContext();
    }

    public static Context getAppContext()
    {
        return MainApplication.context;
    }

    public static String fetchGCMToken() {
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(getAppContext());
        String token = sharedPreferences.getString(QuickstartPreferences.GCM_TOKEN, "");
       // Log.i("Activity", token);
        return token;
        }

    public static void saveLogin (boolean isLoggedIn) {
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(getAppContext());
        SharedPreferences.Editor editor = sharedPreferences.edit();
        editor.putBoolean(QuickstartPreferences.USER_LOGIN,isLoggedIn);
        editor.commit();
        Log.i("MainApplication",String.valueOf(isLoggedIn));
        }

    public static boolean getLogin () {
        SharedPreferences sharedPreferences = PreferenceManager.getDefaultSharedPreferences(getAppContext());
        return sharedPreferences.getBoolean(QuickstartPreferences.USER_LOGIN,false);

        }
}
