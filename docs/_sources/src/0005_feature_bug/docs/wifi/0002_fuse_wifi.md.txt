# 熔丝后wifi不行

高通2290平台, 烧录efuse后,wifi打不开

# log

```
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: WifiThreadRunner.call() timed out!
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: java.lang.Throwable: Caller thread Stack trace:
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.server.wifi.WifiThreadRunner.call(WifiThreadRunner.java:85)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.server.wifi.WifiServiceImpl.getPrimaryClientModeManagerBlockingThreadSafe(WifiServiceImpl.java:887)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.server.wifi.WifiServiceImpl.getWifiEnabledState(WifiServiceImpl.java:1020)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at android.net.wifi.IWifiManager$Stub.onTransact(IWifiManager.java:952)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at android.os.Binder.execTransactInternal(Binder.java:1179)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at android.os.Binder.execTransact(Binder.java:1143)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: WifiThreadRunner.call() timed out!
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: java.lang.Throwable: Wifi thread Stack trace:
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at android.os.HwRemoteBinder.transact(Native Method)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.wifi.x.android.hardware.wifi.V1_0.IWifi$Proxy.start(IWifi.java:378)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.server.wifi.HalDeviceManager.startWifi(HalDeviceManager.java:1392)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.server.wifi.HalDeviceManager.start(HalDeviceManager.java:204)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.server.wifi.WifiVendorHal.startVendorHal(WifiVendorHal.java:416)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.server.wifi.WifiNative.startHal(WifiNative.java:470)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.server.wifi.WifiNative.setupInterfaceForClientInScanMode(WifiNative.java:1238)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.server.wifi.ConcreteClientModeManager$ClientModeStateMachine$IdleState.processMessage(ConcreteClientModeManager.java:825)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.wifi.x.com.android.internal.util.StateMachine$SmHandler.processMsg(StateMachine.java:993)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at com.android.wifi.x.com.android.internal.util.StateMachine$SmHandler.handleMessage(StateMachine.java:810)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at android.os.Handler.dispatchMessage(Handler.java:106)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at android.os.Looper.loopOnce(Looper.java:201)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at android.os.Looper.loop(Looper.java:288)
05-05 09:41:39.095  1250  6196 E WifiThreadRunner: 	at android.os.HandlerThread.run(HandlerThread.java:67)
```

# 原因

* 熔丝后,modem没有正常加载,imei 获取不了,wifi也打不开,可以进入设置,关于手机,Android 12,可以看到没有modem版本号


# 解决方法

调用正确的modem签名路径,ls A6650_Unpacking_Tool/MPSS.HA.1.1/modem_proc/build/ms/bin/kamorta.genw3k.prod/

```
A6650_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/copy_sc200e_qcm2290_ddr4_genw3k_sec_img_NA.py
modem_path=home_path+"/MPSS.HA.1.1/modem_proc/build/ms/bin/kamorta.genw3k.prod/"
# MPSS.AT.3.1
if os.path.exists(modem_path):
       #shutil.copy((secimage_path+"mba/mba.mbn"), (modem_path+"mba.mbn"))
       shutil.copy((secimage_path+"modem/modem.mbn"), (modem_path+"qdsp6sw.mbn"))
```