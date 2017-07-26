package com.comnet.molenet;


import android.content.Context;
import android.app.Service;
import android.os.IBinder;
import android.content.Intent;
import android.app.PendingIntent;
import android.content.IntentFilter;
import android.os.Bundle;

import android.content.BroadcastReceiver;
import android.support.v4.content.LocalBroadcastManager;

import org.qtproject.qt5.android.bindings.QtService;


import android.hardware.usb.UsbDevice;
import android.hardware.usb.UsbDeviceConnection;
import android.hardware.usb.UsbManager;


import com.felhr.usbserial.UsbSerialDevice;
import com.felhr.usbserial.UsbSerialInterface;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;


import android.util.Log;

public class MoleNetService extends QtService {

    private static Context context;

    public static final String ACTION_USB_PERMISSION = "com.comnet.molenet.USB_PERMISSION";
    static  UsbManager usbManager;
    static  UsbDevice device;
    static  UsbSerialDevice serialPort;
    static  UsbDeviceConnection connection;

    private static StringBuilder sb = new StringBuilder();

       static UsbSerialInterface.UsbReadCallback mCallback = new UsbSerialInterface.UsbReadCallback() { //Defining a Callback which triggers whenever data is read.
           @Override
           public void onReceivedData(byte[] arg0) {
               String data = null;
               try {
                   data = new  String(arg0);
                   sb.append(data);

               // we do not receive all the packet string at once
               // so we process the string until we receive the full string
                   String sttr =  processData();  //
               if(!sttr.isEmpty())
               {
                   Log.d("SERIAL SB",sttr);
                  // largeLog("SERIAL", sttr);
                   JavaNatives.sendRadioData(sttr);
                }
               } catch (Exception e) {
                   e.printStackTrace();
               }
           }
       };

   private static  String processData() {
       String fullMsg = "";
             // append string
       int endOfLineIndex = sb.indexOf("\r\n");  // determine the end-of-line
       if (endOfLineIndex > 0) {


           // add the current string to eol to a local string
           String sbprint = sb.substring(0, endOfLineIndex);

           // get the start and end indexes of the heading
           int startHeading = sb.indexOf("HG");

           int endHeading = sb.indexOf("/HG");

           if(startHeading > endHeading)
           { sb.delete(0, endHeading); }
           else
           {
       //    Log.d("SERIAL head","startheading :"+startHeading +"endHeading :"+endHeading+"\n");
           // set the heading
           fullMsg = sb.substring((startHeading + 2), endHeading);
           sb.delete(0, sb.length());
           }
       }
       return fullMsg;
   }

private static void largeLog(String tag, String content) {
   if (content.length() > 4000) {
       Log.d("SERIAL Long", content.substring(0, 4000));
       largeLog("SERIAL Long", content.substring(4000));
   } else {
       Log.d("SERIAL SHORT", content);
   }
}



private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() { //Broadcast Receiver to automatically start and stop the Serial connection.
    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent.getAction().equals(ACTION_USB_PERMISSION)) {
            boolean granted = intent.getExtras().getBoolean(UsbManager.EXTRA_PERMISSION_GRANTED);
            if (granted) {
                connection = usbManager.openDevice(device);
                serialPort = UsbSerialDevice.createUsbSerialDevice(device, connection);
                if (serialPort != null) {
                    if (serialPort.open()) { //Set Serial Connection Parameters.

         //Not needed?                   setUiEnabled(true);

                        serialPort.setBaudRate(57600);
                        serialPort.setDataBits(UsbSerialInterface.DATA_BITS_8);
                        serialPort.setStopBits(UsbSerialInterface.STOP_BITS_1);
                        serialPort.setParity(UsbSerialInterface.PARITY_NONE);
                        serialPort.setFlowControl(UsbSerialInterface.FLOW_CONTROL_OFF);
                        serialPort.read(mCallback);

                        // send info to qt here

                        JavaNatives.showMsgFromUno("Serial Opened");

                    } else {
                        Log.d("SERIAL", "PORT NOT OPEN");
                    }
                } else {
                    Log.d("SERIAL", "PORT IS NULL");
                }
            } else {
                Log.d("SERIAL", "PERM NOT GRANTED");
            }
        }
    else if (intent.getAction().equals(UsbManager.ACTION_USB_DEVICE_ATTACHED)) {
        // open usb connection
        initializeUSB(true);
        }
    else if (intent.getAction().equals(UsbManager.ACTION_USB_DEVICE_DETACHED)) {

        //   Close usb connection
        initializeUSB(false);

        }
    };
};


public static void initializeUSB(boolean open) {

    Log.v("WORKING","open");

    JavaNatives.showMsgFromUno("Serial Opened");
    if(open)
    {
    HashMap<String, UsbDevice> usbDevices = usbManager.getDeviceList();
    if (!usbDevices.isEmpty()) {
        boolean keep = true;
        for (Map.Entry<String, UsbDevice> entry : usbDevices.entrySet()) {
            device = entry.getValue();
            int deviceVID = device.getVendorId();
            if (deviceVID == 0x2341)//Arduino Vendor ID
            {
                PendingIntent pi = PendingIntent.getBroadcast(context, 0, new Intent(ACTION_USB_PERMISSION), 0);
                usbManager.requestPermission(device, pi);
                keep = false;
            } else {
                connection = null;
                device = null;
            }

            if (!keep)
                break;
            }
        }
    }
else {  // serialPort.close();
    }


}

private static void cleanUp()
{
   sb.delete(0, sb.length());
}


   /** Called when the service is being created. */
   @Override
   public void onCreate() {
      super.onCreate();
      Log.i("Service", "Service created!");
      MoleNetService.context = getApplicationContext();

      usbManager = (UsbManager) getSystemService(this.USB_SERVICE);

//       setUiEnabled(false);
      IntentFilter filter = new IntentFilter();
      filter.addAction(ACTION_USB_PERMISSION);
      filter.addAction(UsbManager.ACTION_USB_DEVICE_ATTACHED);
      filter.addAction(UsbManager.ACTION_USB_DEVICE_DETACHED);
      registerReceiver(broadcastReceiver, filter);
   }

   /** The service is starting, due to a call to startService() */
   @Override
   public int onStartCommand(Intent intent, int flags, int startId) {
      int ret = super.onStartCommand(intent, flags, startId);
      Log.i("Service", "Service created!");
      return ret;
      //return mStartMode;
   }

   /** A client is binding to the service with bindService() */
   @Override
   public IBinder onBind(Intent intent) {
      return super.onBind(intent);
      //return mBinder;
   }

   /** Called when all clients have unbound with unbindService() */
   @Override
   public boolean onUnbind(Intent intent) {
      return super.onUnbind(intent);
   }

   /** Called when a client is binding to the service with bindService()*/
   @Override
   public void onRebind(Intent intent) {
         super.onRebind(intent);
   }

   /** Called when The service is no longer used and is being destroyed */
   @Override
   public void onDestroy() {
      super.onDestroy();
   }
}
