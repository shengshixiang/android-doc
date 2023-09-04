# 概要

测试部有一个用例,是需要捉取logcat -b events 里面的 boot_progress_enable_screen的时间,

简单搜索了一下代码,发现一时间还没看到boot_progress_enable_screen的时间的定义

所以继续了解一下android event log的原理

# log

* adb logcat -b events | grep "boot_progress_enable_screen"

输出log的大概意思是估计 29ms

```
08-07 22:19:38.808  1305  1551 I boot_progress_enable_screen: 29189
```

# 定义

* QSSI.12/frameworks/base/services/core/java/com/android/server/am/EventLogTags.logtags

```
# ActivityManagerService calls enableScreenAfterBoot():
3050 boot_progress_enable_screen (time|2|3)
```

* QSSI.12/frameworks/base/services/core/Android.bp

可以看到am/EventLogTags.logtags,是被编译成java静态库,out目录又相关生成

QSSI.12/out/soong/.intermediates/frameworks/base/services/core/services.core.unboosted/android_common/javac/services.core.unboosted.jar

```
java_library_static {
    name: "services.core.unboosted",
    defaults: [
        "framework-wifi-vendor-hide-access-defaults",
        "platform_service_defaults",
    ],  
    srcs: [

        "java/com/android/server/EventLogTags.logtags",
        "java/com/android/server/am/EventLogTags.logtags",
        "java/com/android/server/wm/EventLogTags.logtags",
        "java/com/android/server/policy/EventLogTags.logtags",
    ],
}
```

* QSSI.12/system/logging/logcat/event.logtags

有说明定义分为4部分, Tag numbers + Tag names + (<名字>|数据类型[|数据单位]),(<名字>|数据类型[|数据单位])

3050 boot_progress_enable_screen (time|2|3) ,所以按照以下说明,3050 就是数值,boot_progress_enable_screen就是名字, time就是变量名字,2就是long,3就是ms

对应输出,08-07 22:19:38.808  1305  1551 I boot_progress_enable_screen: 29189

    * Tag numbers are decimal integers, from 0 to 2^31.

    * Tag names are one or more ASCII letters and numbers or underscores

    * The data type is a number from the following values:

        * 1: int
        * 2: long
        * 3: string
        * 4: list
        * 5: float

    * The data unit is a number taken from the following list:

        * 1: Number of objects
        * 2: Number of bytes
        * 3: Number of milliseconds
        * 4: Number of allocations
        * 5: Id
        * 6: Percent
        * s: Number of seconds (monotonic time)
        * Default value for data of type int/long is 2 (bytes).

* QSSI.12/out/soong/.intermediates/frameworks/base/services/core/services.core.unboosted/android_common/gen/logtags/frameworks/base/services/core/java/com/android/server/am/EventLogTags.java

参考编译出来out目录的java就更加明显

```
public class EventLogTags {
  private EventLogTags() { }  // don't instantiate

  /** 3050 boot_progress_enable_screen (time|2|3) */
  public static final int BOOT_PROGRESS_ENABLE_SCREEN = 3050;
    public static void writeBootProgressEnableScreen(long time) {
    android.util.EventLog.writeEvent(BOOT_PROGRESS_ENABLE_SCREEN, time);
  }
}
```

* QSSI.12/frameworks/base/services/core/java/com/android/server/wm/ActivityTaskManagerService.java

可以看到,boot_progress_enable_screen: 29189的log输出,其实就是调用到writeBootProgressEnableScreen(SystemClock.uptimeMillis()); 这一句打印的时间

```
import static com.android.server.am.EventLogTags.writeBootProgressEnableScreen;//static ,out生成

        mInternal.enableScreenAfterBoot(isBooted());

        @Override
        public void enableScreenAfterBoot(boolean booted) {
            writeBootProgressEnableScreen(SystemClock.uptimeMillis());//记录这里的时间
            mWindowManager.enableScreenAfterBoot();
            synchronized (mGlobalLock) {
                updateEventDispatchingLocked(booted);
            }    
        }    
```

# 柱网时间

回归到测试提出柱网时间问题

* adb reboot && adb wait-for-device && adb logcat -b radio > 0809.3.boot.txt 捉取radio log

可以搜索,RIL Daemon Started 或者ril, 记录RIL 启动时间

可以搜索,DATA_REGISTRATION_STATE, 然后根据 regState = REG_HOME,cellInfoType = LTE,mcc mnc等变量判断注册上4G网

由于ap 没有rtc,时间是从sp转换,所以注意时间变化

00:45:09.193 - 00:45:00.092 + (08:00:43.055 - 08:00:41.670 )= 11s,

所以EM大概就是11s 搜到网络


```
EM log
01-01 08:00:41.670  1202  1202 D RILD    : **RIL Daemon Started**

01-01 08:00:43.055  1202  1202 D RILD    : RIL_register_socket completed
05-12 00:45:00.092  1228  1228 D TelephonyRegistry: listen oscl: mHasNotifySubscriptionInfoChangedOccurred==false no callback

05-12 00:45:09.193  2273  2565 D RILJ    : [0157]< DATA_REGISTRATION_STATE {.base = {.regState = REG_HOME, .rat = 14, .reasonDataDenied = 0, .maxDataCalls = 20, .cellIdentity = {.cellInfoType = LTE, .cellIdentityGsm = [], .cellIdentityWcdma = [], .cellIdentityCdma = [], .cellIdentityLte = [{.base = {.mcc = 460, .mnc = 00, .ci = 47418891, .pci = 376, .tac = 9365, .earfcn = 1300}, .operatorNames = {.alphaLong = 优友, .alphaShort = 优友}, .bandwidth = 2147483647}], .cellIdentityTdscdma = []}}, .vopsInfo = {.lteVopsInfo = {.isVopsSupported = false, .isEmcBearerSupported = false}}, .nrIndicators = {.isEndcAvailable = false, .isDcNrRestricted = false, .isNrAvailable = false}} [PHONE0]
```

NA实际搜到网络是11s
22:19:44.163 - 22:19:34.384 + (08:00:24.588 - 08:00:23.137) = 11s

```
NA log
01-01 08:00:23.137  1163  1163 D RILD    : **RIL Daemon Started**

01-01 08:00:24.588  1206  1206 D RILD    : RIL_register_socket completed
08-07 22:19:34.384  1531  1531 D TelephonyRegistry: listen oscl: mHasNotifySubscriptionInfoChangedOccurred==false no callback

08-07 22:19:44.163  2147  2548 D RILJ    : [0111]< DATA_REGISTRATION_STATE {.base = {.regState = REG_HOME, .rat = 14, .reasonDataDenied = 0, .maxDataCalls = 20, .cellIdentity = {.cellInfoType = LTE, .cellIdentityGsm = [], .cellIdentityWcdma = [], .cellIdentityCdma = [], .cellIdentityLte = [{.base = {.mcc = 460, .mnc = 00, .ci = 205588107, .pci = 68, .tac = 9365, .earfcn = 40936}, .operatorNames = {.alphaLong = 优友, .alphaShort = 优友}, .bandwidth = 2147483647}], .cellIdentityTdscdma = []}}, .vopsInfo = {.lteVopsInfo = {.isVopsSupported = false, .isEmcBearerSupported = false}}, .nrIndicators = {.isEndcAvailable = false, .isDcNrRestricted = false, .isNrAvailable = false}} [PHONE0]
```


* UM.9.15/hardware/interfaces/radio/1.0/types.hal

```
/**
 * Please note that registration state UNKNOWN is
 * treated as "out of service" in the Android telephony.
 * Registration state REG_DENIED must be returned if Location Update
 * Reject (with cause 17 - Network Failure) is received
 * repeatedly from the network, to facilitate
 * "managed roaming"
 */
enum RegState : int32_t {
    NOT_REG_MT_NOT_SEARCHING_OP = 0,      // Not registered, MT is not currently searching
                                          // a new operator to register
    REG_HOME = 1,                         // Registered, home network
    NOT_REG_MT_SEARCHING_OP = 2,          // Not registered, but MT is currently searching
                                          // a new operator to register
    REG_DENIED = 3,                       // Registration denied
    UNKNOWN = 4,                          // Unknown
    REG_ROAMING = 5,                      // Registered, roaming
    NOT_REG_MT_NOT_SEARCHING_OP_EM = 10,  // Same as NOT_REG_MT_NOT_SEARCHING_OP but indicates that 
                                          // emergency calls are enabled.
    NOT_REG_MT_SEARCHING_OP_EM = 12,      // Same as NOT_REG_MT_SEARCHING_OP but indicates that 
                                          // emergency calls are enabled.
    REG_DENIED_EM = 13,                   // Same as REG_DENIED but indicates that 
                                          // emergency calls are enabled.
    UNKNOWN_EM = 14,                      // Same as UNKNOWN but indicates that 
                                          // emergency calls are enabled.
};
```