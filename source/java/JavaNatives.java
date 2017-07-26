//adapt that accordingly
package com.comnet.molenet;

import android.app.Activity;
import android.graphics.Rect;
import android.view.View;
import android.view.Window;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;


import org.qtproject.qt5.android.QtNative;
import android.content.Intent;

class JavaNatives{
    public static native void sendRadioData(String data);

    public static native void showMsgFromUno(String data);
}
