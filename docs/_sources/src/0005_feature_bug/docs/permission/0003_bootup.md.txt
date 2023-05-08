# 开机广播

同事反馈没有接收到开机广播

# 代码

* AndroidManifest.xml

```
    
    <application
        android:allowBackup="true"
        android:icon="@drawable/visalogo"
        android:label="@string/app_name"
        android:theme="@style/AppTheme">
        <activity
            android:name="com.pax.paywaveapp.MainActivity"
            android:label="@string/app_name">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />

                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
 	    <receiver android:name="com.pax.paywaveapp.BootReceiver">
                  <!-- android:permission="android.permission.RECEIVE_BOOT_COMPLETED"-->
            <intent-filter>
                  <action android:name="paydroid.intent.action.BOOT_COMPLETED" />
                  <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>
        </receiver>
    </application>
```

```
package com.pax.paywaveapp;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class BootReceiver extends BroadcastReceiver{

        private static final String TAG = "BootReceiver";
        
        @Override
        public void onReceive(Context context, Intent arg1) {
                // TODO Auto-generated method stub
                Log.d(TAG, "onReceive");
                Intent i = new Intent(context, MainActivity.class);
                i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(i);
        }

}
```

# log

```
03-30 04:47:11.321  6366  6366 D BootReceiver: onReceive
03-30 04:47:11.327  1228  1588 I EventSequenceValidator: Transition from INTENT_FAILED to INTENT_STARTED
03-30 04:47:11.327  1228  2229 I ActivityTaskManager: START u0 {flg=0x10000000 cmp=com.pax.paywave_app/com.pax.paywaveapp.MainActivity} from uid 10177
03-30 04:47:11.330  1228  2229 W ActivityTaskManager: Background activity start [callingPackage: com.pax.paywave_app; callingUid: 10177; appSwitchAllowed: true; isCallingUidForeground: false; callingUidHasAnyVisibleWindow: false; callingUidProcState: RECEIVER; isCallingUidPersistentSystemProcess: false; realCallingUid: 10177; isRealCallingUidForeground: false; realCallingUidHasAnyVisibleWindow: false; realCallingUidProcState: RECEIVER; isRealCallingUidPersistentSystemProcess: false; originatingPendingIntent: null; allowBackgroundActivityStart: false; intent: Intent { flg=0x10000000 cmp=com.pax.paywave_app/com.pax.paywaveapp.MainActivity }; callerApp: ProcessRecord{af47b6f 6366:com.pax.paywave_app/u0a177}; inVisibleTask: false]
```

# 分析

从开机log可以看到.其实已经收到开机广播,```03-30 04:47:11.321  6366  6366 D BootReceiver: onReceive```

只是开机广播里面,启动MainActivity失败了

# 解决方法

* 添加system uid权限

* 或者ams 去掉这个限制