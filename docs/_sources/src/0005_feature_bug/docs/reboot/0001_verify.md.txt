# bug现象
机器不断重启,在开机动画

# log显示
* 列一些关键log
Watchdog: *** WATCHDOG KILLING SYSTEM PROCESS: Blocked in handler on foreground thread (android.fg)
Watchdog:     - waiting to lock <0x0960cd82> (a com.android.server.am.ActivityManagerService)
Watchdog: *** GOODBYE!

* 搜索anr相关目录,搜索关键字0x0960cd82,看到如下
```
  at android.os.BinderProxy.transactNative(Native method)
  at android.os.BinderProxy.transact(BinderProxy.java:571)
  at com.paxdroid.verify.IPkgVerifier$Stub$Proxy.verifyPackage(IPkgVerifier.java:226)
  at com.paxdroid.security.PaxPackageMgr.verifyPkgByService(PaxPackageMgr.java:44)
  at com.paxdroid.customer.CustomerBase.verifyPkgByService(CustomerBase.java:71)
  at com.paxdroid.customer.CustomerPaxsz.verifyPackage(CustomerPaxsz.java:25)
  at com.paxdroid.customer.PaxCustomerManager.customerVerifyPackage(PaxCustomerManager.java:798)
  at com.paxdroid.customer.PaxCustomerManager.packageVerifyRoutineAtRuntimeInternal(PaxCustomerManager.java:1197)
  - locked <0x0ae269bc> (a java.lang.Object)
  at com.paxdroid.customer.PaxCustomerManager.packageVerifyRoutineAtRuntime(PaxCustomerManager.java:1143)
  at com.paxdroid.customer.PaxCustomerManager.packageVerifyRoutineAtRuntime(PaxCustomerManager.java:1116)
  at com.android.server.am.ProcessList.startProcessLocked(ProcessList.java:1826)
  at com.android.server.am.ProcessList.startProcessLocked(ProcessList.java:2498)
  at com.android.server.am.ProcessList.startProcessLocked(ProcessList.java:2652)
  at com.android.server.am.ActivityManagerService.startProcessLocked(ActivityManagerService.java:2710)
  at com.android.server.am.BroadcastQueue.processNextBroadcastLocked(BroadcastQueue.java:1791)
  at com.android.server.am.ActivityManagerService.finishReceiver(ActivityManagerService.java:13849)
  - locked <0x0960cd82> (a com.android.server.am.ActivityManagerService)
```
* 看起来又是pax的verifyPackage 验签引用启动慢,在一直死锁问题,晚点处理一下

