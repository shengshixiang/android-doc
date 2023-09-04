# 概要

测试部测试低温续航,去看的时候,关机了,然后机器拿出来开机还有20%电量,不知道为什么关机了

# log

```
[2023-08-17 15:14:55].208 D/SDL     ( 3350): [aceedcb0] WaitForEvent[aceedcb0] waiting...
[2023-08-17 15:14:55].785 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:0,cap_rm:0 mah, vol:3506 mv, temp:-1, curr:-596 ma, ui_soc:0]
[2023-08-17 15:14:55].785 E/icnss   (    0): Battery percentage read failure
[2023-08-17 15:14:55].787 W/healthd (    0): battery l=0 v=3506 t=-1.0 h=2 st=3 c=-596000 fc=2633000 cc=16 chg=
[2023-08-17 15:14:55].793 D/BatteryService( 1330): Processing new values: info={.chargerAcOnline = false, .chargerUsbOnline = false, .chargerWirelessOnline = false, .maxChargingCurrent = 0, .maxChargingVoltage = 0, .batteryStatus = DISCHARGING, .batteryHealth = GOOD, .batteryPresent = true, .batteryLevel = 0, .batteryVoltage = 3506, .batteryTemperature = -10, .batteryCurrent = -596000, .batteryCycleCount = 16, .batteryFullCharge = 2633000, .batteryChargeCounter = 0, .batteryTechnology = Li-ion}, chargerVoltage = 5000000, chargerCurrent = 500000, soh =100, batteryManufactuer = iconergy
[2023-08-17 15:14:55].793 D/BatteryService( 1330): , batterySerialNumber = , mBatteryLevelCritical=true, mPlugType=0
[2023-08-17 15:14:55].807 E/KernelCpuSpeedReader( 1330): Failed to read cpu-freq: /sys/devices/system/cpu/cpu0/cpufreq/stats/time_in_state: open failed: ENOENT (No such file or directory)
[2023-08-17 15:14:55].807 E/KernelCpuSpeedReader( 1330): Failed to read cpu-freq: /sys/devices/system/cpu/cpu4/cpufreq/stats/time_in_state: open failed: ENOENT (No such file or directory)
[2023-08-17 15:14:55].810 I/EventSequenceValidator( 1330): Transition from INTENT_FAILED to INTENT_STARTED
[2023-08-17 15:14:55].923 V/ShutdownCheckPoints( 1330): Shutdown intent checkpoint recorded intent=com.android.internal.intent.action.REQUEST_SHUTDOWN from package=android
[2023-08-17 15:14:55].925 I/ActivityTaskManager( 1330): START u0 {act=com.android.internal.intent.action.REQUEST_SHUTDOWN flg=0x10000000 cmp=android/com.android.internal.app.ShutdownActivity (has extras)} from uid 1000
[2023-08-17 15:14:55].930 E/ANDR-PERF-LM(  644): ThreadHelper: thread_callback() 145: More than one pending updates!!! This should not happen. MeterMgr should avoid this case.
[2023-08-17 15:14:55].932 E/ANDR-PERF-JNI( 1330): com_qualcomm_qtiperformance_native_perf_io_prefetch_start
[2023-08-17 15:14:55].934 W/ActivityTaskManager( 1330): Can't find TaskDisplayArea to determine support for multi window. Task id=71 attached=false

[2023-08-17 15:14:56].066 I/ShutdownActivity( 1330): onCreate(): confirm=false
[2023-08-17 15:14:56].068 D/ActivityTrigger( 1330): ActivityTrigger activityPauseTrigger 
[2023-08-17 15:14:56].083 I/EventSequenceValidator( 1330): Transition from ACTIVITY_LAUNCHED to ACTIVITY_CANCELLED
[2023-08-17 15:14:56].088 D/InterruptionStateProvider( 2076): No bubble up: not allowed to bubble: 0|com.qualcomm.qti.logkit.lite|1|null|1000
[2023-08-17 15:14:56].089 D/InterruptionStateProvider( 2076): No heads up: unimportant notification: 0|com.qualcomm.qti.logkit.lite|1|null|1000
[2023-08-17 15:14:56].107 D/PeopleSpaceWidgetMgr( 2076): Sbn doesn't contain valid PeopleTileKey: null/0/com.qualcomm.qti.logkit.lite
[2023-08-17 15:14:56].113 D/InterruptionStateProvider( 2076): No bubble up: not allowed to bubble: 0|com.qualcomm.qti.logkit.lite|1|null|1000
[2023-08-17 15:14:56].114 D/InterruptionStateProvider( 2076): No heads up: unimportant notification: 0|com.qualcomm.qti.logkit.lite|1|null|1000
[2023-08-17 15:14:56].129 D/PeopleSpaceWidgetMgr( 2076): Sbn doesn't contain valid PeopleTileKey: null/0/com.qualcomm.qti.logkit.lite
[2023-08-17 15:14:56].135 V/ShutdownCheckPoints( 1330): Binder shutdown checkpoint recorded with pid=1330
[2023-08-17 15:14:56].185 V/ShutdownCheckPoints( 1330): System server shutdown checkpoint recorded
[2023-08-17 15:14:56].185 D/ShutdownThread( 1330): Notifying thread to start shutdown longPressBehavior=1
[2023-08-17 15:14:56].187 D/ShutdownThread( 1330): Attempting to use SysUI shutdown UI
[2023-08-17 15:14:56].187 D/ShutdownThread( 1330): SysUI handling shutdown UI
[2023-08-17 15:14:56].192 W/Looper  ( 1330): Slow dispatch took 172ms main h=android.app.ActivityThread$H c=null m=159
[2023-08-17 15:14:56].222 I/ShutdownThread( 1330): Logging pre-reboot information...
[2023-08-17 15:14:56].226 I/init    (    0): processing action (sys.shutdown.requested=*) from (/vendor/etc/init/hw/init.qcom.rc:670)
[2023-08-17 15:14:56].240 I/init    (    0): Sending signal 9 to service 'cnss-daemon' (pid 1031) process group...
[2023-08-17 15:14:56].247 D/PreRebootLogger( 1330): Wiping pre-reboot information...
```

# 分析

* sys.shutdown.requested=*

搜索shutdown,从log可以看到,init进程收到了 shutdown的requested,所以关机了

* ShutdownActivity( 1330): onCreate(): confirm=false

继续倒推,从 log可以看到,1330 进程,调用ShutdownActivity,并且不用用户确认,就关机了.

可以推测是程序关机的

搜索1330,没有看到创建,但是匹配一些log,可以推测,是system-server

例如 log有```key canCmd start```,这一句是QSSI.12/frameworks/base/services/core/java/com/android/server/policy/PhoneWindowManager.java 调用的,这个类归属system-server

* com.android.internal.intent.action.REQUEST_SHUTDOWN

再往上看,```ActivityTaskManager( 1330): START u0 {act=com.android.internal.intent.action.REQUEST_SHUTDOWN flg=0x10000000 cmp=android/com.android.internal.app.ShutdownActivity (has extras)} from uid 1000```

uid = 1000(system_server),发送的REQUEST_SHUTDOWN 关机广播

* battery

再继续看,明显看到电池 电量capcity:0,battery l=0 ,电压也很低,3.50v,所以很明显就是电量为0,系统自信关机

```
[2023-08-17 15:14:55].785 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:0,cap_rm:0 mah, vol:3506 mv, temp:-1, curr:-596 ma, ui_soc:0]
[2023-08-17 15:14:55].785 E/icnss   (    0): Battery percentage read failure
[2023-08-17 15:14:55].787 W/healthd (    0): battery l=0 v=3506 t=-1.0 h=2 st=3 c=-596000 fc=2633000 cc=16 chg=
```

* 电池电量

搜索电池电量的log,可以看到电池电量平稳下降,所以没电了,关机时正常的

开机后,电池电量马上飙到20%,电压也有3.8v, 应该就是-10度低温环境下,电池活性不够.

电池到常温,电压又上来了.

```
	行 355397: [2023-08-17 15:13:17].482 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:5,cap_rm:196 mah, vol:3494 mv, temp:-1, curr:-607 ma, ui_soc:5]
	行 357060: [2023-08-17 15:13:25].676 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:4,cap_rm:187 mah, vol:3508 mv, temp:-1, curr:-589 ma, ui_soc:4]
	行 359654: [2023-08-17 15:13:33].865 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:4,cap_rm:178 mah, vol:3506 mv, temp:-1, curr:-603 ma, ui_soc:4]
	行 363834: [2023-08-17 15:13:42].064 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:4,cap_rm:170 mah, vol:3500 mv, temp:-1, curr:-593 ma, ui_soc:4]
	行 366359: [2023-08-17 15:13:50].251 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:4,cap_rm:162 mah, vol:3510 mv, temp:-1, curr:-663 ma, ui_soc:4]
	行 368108: [2023-08-17 15:13:58].441 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:4,cap_rm:147 mah, vol:3508 mv, temp:-1, curr:-596 ma, ui_soc:4]
	行 372290: [2023-08-17 15:14:06].632 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:3,cap_rm:128 mah, vol:3506 mv, temp:-1, curr:-596 ma, ui_soc:3]
	行 375860: [2023-08-17 15:14:14].827 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:3,cap_rm:111 mah, vol:3511 mv, temp:-1, curr:-603 ma, ui_soc:3]
	行 376537: [2023-08-17 15:14:23].018 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:2,cap_rm:90 mah, vol:3509 mv, temp:-1, curr:-593 ma, ui_soc:2]
	行 380725: [2023-08-17 15:14:31].210 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:2,cap_rm:74 mah, vol:3507 mv, temp:-1, curr:-600 ma, ui_soc:2]
	行 384639: [2023-08-17 15:14:39].404 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:2,cap_rm:58 mah, vol:3502 mv, temp:-1, curr:-824 ma, ui_soc:2]
	行 384932: [2023-08-17 15:14:47].593 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:1,cap_rm:43 mah, vol:3507 mv, temp:-1, curr:-586 ma, ui_soc:1]
	行 389196: [2023-08-17 15:14:55].785 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:0,cap_rm:0 mah, vol:3506 mv, temp:-1, curr:-596 ma, ui_soc:0]
	行 392280: [1970-01-02 10:09:28].277 I/PAX_BAT (    0): [status:Not charging, health:Good, present:1, tech:Li-ion, capcity:19,cap_rm:868 mah, vol:3825 mv, temp:18, curr:0 ma, ui_soc:19]
	行 392313: [1970-01-02 10:09:28].527 I/PAX_BAT (    0): [status:Charging, health:Good, present:1, tech:Li-ion, capcity:19,cap_rm:868 mah, vol:3825 mv, temp:18, curr:0 ma, ui_soc:19]
	行 399411: [1970-01-02 10:09:37].748 I/PAX_BAT (    0): [status:Charging, health:Good, present:1, tech:Li-ion, capcity:19,cap_rm:873 mah, vol:3951 mv, temp:19, curr:1330 ma, ui_soc:19]
	行 400595: [2023-08-17 21:28:38].896 I/PAX_BAT (    0): [status:Charging, health:Good, present:1, tech:Li-ion, capcity:19,cap_rm:874 mah, vol:3773 mv, temp:19, curr:-361 ma, ui_soc:19]
	行 403117: [2023-08-17 21:28:44].710 I/PAX_BAT (    0): [status:Charging, health:Good, present:1, tech:Li-ion, capcity:20,cap_rm:877 mah, vol:4054 mv, temp:19, curr:2529 ma, ui_soc:20]
	行 406423: [2023-08-17 21:28:52].905 I/PAX_BAT (    0): [status:Charging, health:Good, present:1, tech:Li-ion, capcity:20,cap_rm:886 mah, vol:4085 mv, temp:19, curr:2813 ma, ui_soc:20]
	行 412608: [2023-08-17 21:29:01].090 I/PAX_BAT (    0): [status:Charging, health:Good, present:1, tech:Li-ion, capcity:20,cap_rm:895 mah, vol:4093 mv, temp:19, curr:2789 ma, ui_soc:20]
	行 416362: [2023-08-17 21:29:09].285 I/PAX_BAT (    0): [status:Charging, health:Good, present:1, tech:Li-ion, capcity:20,cap_rm:903 ma
```

# 没电关机流程

* QSSI.12/frameworks/base/services/core/java/com/android/server/BatteryService.java

没电关机,发送广播Intent.ACTION_REQUEST_SHUTDOWN = com.android.internal.intent.action.REQUEST_SHUTDOWN

```
private void shutdownIfNoPowerLocked() {
        // shut down gracefully if our battery is critically low and we are not powered.
        // wait until the system has booted before attempting to display the shutdown dialog.
        if (shouldShutdownLocked()) {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    if (mActivityManagerInternal.isSystemReady()) {
                        Intent intent = new Intent(Intent.ACTION_REQUEST_SHUTDOWN);
                        intent.putExtra(Intent.EXTRA_KEY_CONFIRM, false);
                        intent.putExtra(Intent.EXTRA_REASON,
                                PowerManager.SHUTDOWN_LOW_BATTERY);
                        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        mContext.startActivityAsUser(intent, UserHandle.CURRENT);
                    }    
                }    
            });  
        }    
    }    
```

* QSSI.12/frameworks/base/core/res/AndroidManifest.xml

```
<activity android:name="com.android.internal.app.ShutdownActivity"
            android:permission="android.permission.SHUTDOWN"
            android:theme="@style/Theme.NoDisplay"
            android:exported="true"
            android:excludeFromRecents="true">
            <intent-filter>
                <action android:name="com.android.internal.intent.action.REQUEST_SHUTDOWN" />
                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>
            <intent-filter>
                <action android:name="android.intent.action.REBOOT" />
                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>
        </activity>
```

* QSSI.12/frameworks/base/core/java/com/android/internal/app/ShutdownActivity.java

pm.shutdown(mConfirm, reason, false);

```
protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Intent intent = getIntent();
        mReboot = Intent.ACTION_REBOOT.equals(intent.getAction());
        mConfirm = intent.getBooleanExtra(Intent.EXTRA_KEY_CONFIRM, false);
        mUserRequested = intent.getBooleanExtra(Intent.EXTRA_USER_REQUESTED_SHUTDOWN, false);
        final String reason = mUserRequested
                ? PowerManager.SHUTDOWN_USER_REQUESTED
                : intent.getStringExtra(Intent.EXTRA_REASON);
        Slog.i(TAG, "onCreate(): confirm=" + mConfirm);

        Thread thr = new Thread("ShutdownActivity") {
            @Override
            public void run() {
                IPowerManager pm = IPowerManager.Stub.asInterface(
                        ServiceManager.getService(Context.POWER_SERVICE));
                try {
                    if (mReboot) {
                        pm.reboot(mConfirm, null, false);
                    } else {
                        pm.shutdown(mConfirm, reason, false);
                    }   
                } catch (RemoteException e) {
                }   
            }   
        };  
        thr.start();
```

* QSSI.12/frameworks/base/services/core/java/com/android/server/power/PowerManagerService.java

对应log

```
[2023-08-17 15:14:56].135 V/ShutdownCheckPoints( 1330): Binder shutdown checkpoint recorded with pid=1330
[2023-08-17 15:14:56].185 V/ShutdownCheckPoints( 1330): System server shutdown checkpoint recorded
```

```
public void shutdown(boolean confirm, String reason, boolean wait) {
            mContext.enforceCallingOrSelfPermission(android.Manifest.permission.REBOOT, null);

            ShutdownCheckPoints.recordCheckPoint(Binder.getCallingPid(), reason);
            final long ident = Binder.clearCallingIdentity();
            try {
                shutdownOrRebootInternal(HALT_MODE_SHUTDOWN, confirm, reason, wait);
            } finally {
                Binder.restoreCallingIdentity(ident);
            }    
        }    
```

```
private void shutdownOrRebootInternal(final @HaltMode int haltMode, final boolean confirm,
            @Nullable final String reason, boolean wait) {
        if (PowerManager.REBOOT_USERSPACE.equals(reason)) {
            if (!PowerManager.isRebootingUserspaceSupportedImpl()) {
                throw new UnsupportedOperationException(
                        "Attempted userspace reboot on a device that doesn't support it");
            }    
            UserspaceRebootLogger.noteUserspaceRebootWasRequested();
        }    
        if (mHandler == null || !mSystemReady) {
            if (RescueParty.isAttemptingFactoryReset()) {
                // If we're stuck in a really low-level reboot loop, and a
                // rescue party is trying to prompt the user for a factory data
                // reset, we must GET TO DA CHOPPA!
                // No check point from ShutdownCheckPoints will be dumped at this state.
                PowerManagerService.lowLevelReboot(reason);
            } else {
                throw new IllegalStateException("Too early to call shutdown() or reboot()");
            }    
        }    

        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                synchronized (this) {
                    if (haltMode == HALT_MODE_REBOOT_SAFE_MODE) {
                        ShutdownThread.rebootSafeMode(getUiContext(), confirm);
                    } else if (haltMode == HALT_MODE_REBOOT) {
                        ShutdownThread.reboot(getUiContext(), reason, confirm);
                    } else {
                        ShutdownThread.shutdown(getUiContext(), reason, confirm);
                    }
                }
            }
        };
```

* QSSI.12/frameworks/base/services/core/java/com/android/server/power/ShutdownThread.java

最终就跑到ShutdownThread的run函数,开启shutdown了.最后就到init属性shutdown了

```
public static void shutdown(final Context context, String reason, boolean confirm) {
        mReboot = false;
        mRebootSafeMode = false;
        mReason = reason;
        shutdownInner(context, confirm);
    }   

```

```
public void run() {}
```