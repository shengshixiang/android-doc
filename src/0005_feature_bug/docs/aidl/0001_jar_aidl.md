# README

aidl 跨进程调用例子

# jar包

创建一个public interface IPaxDeviceManager extends IInterface {的aidl文件

本文重点说Android系统部分

# Android

* 创建一个 IPaxDeviceManager.aidl 文件,实现具体接口

    ```
    interface IPaxDeviceManager {
        /** 
        * ###### NOTE: new AIDL interface must appended to the end of this file. ######
        */  
        /** 
        * Get Device's TSN(Terminal Serial Number).
        */  
        String getDeviceTSN();
    ```

* 添加调用  libpaxdroid_framework_aidl
    ```
    QSSI.12/paxdroid/frameworks/base/Android.bp
    java_defaults {
    name: "framework-minus-apex-defaults",
    defaults: ["framework-aidl-export-defaults", "btadva_fwk_java_defaults"],
    srcs: [
        ":framework-non-updatable-sources",
        ":libpaxdroid_framework_aidl",
        ":libpaxdroid_framework_java_api31",

        "core/java/**/*.logtags",
    ],  
    ```

* 添加libpaxdroid_framework_aidl 的实现

    ```
    filegroup {
        name: "libpaxdroid_framework_aidl",
        srcs: [
            // Fixme: Since IPaxDeviceManager.aidl relies on ISwitchSimCallback.aidl, we move it to frameworks/base/*.
            // "core/java/com/paxdroid/os/ISwitchSimCallback.aidl",
        // Fixme: Since IPaxDeviceManager.aidl relies on IDataPriorityCallback.aidl, we move it to frameworks/base/*.
        // "core/java/com/paxdroid/os/IDataPriorityCallback.aidl",
        "core/java/com/paxdroid/os/IPaxDeviceManager.aidl",
        "core/java/com/cmbc/security/PackageManagerAidl.aidl",
        "core/java/com/paxdroid/prompt/ISystemPromptService.aidl",
        "core/java/com/paxdroid/osmanager/IOsManagerUtil.aidl",
        "core/java/com/paxdroid/osmanager/IPkgSecurity.aidl",
        "core/java/com/paxdroid/verify/IPkgVerifier.aidl",
        "core/java/com/paxdroid/os/IPaxTrafficService.aidl",
        "core/java/com/paxdroid/os/IAdvanceManagerUtils.aidl",
        "core/java/com/paxdroid/os/IProbeListener.aidl",
        "core/java/com/paxdroid/scanner/IPaxScannerManager.aidl",
        "core/java/com/paxdroid/scanner/IPaxScanner.aidl",
        "core/java/com/paxdroid/os/IPaxSettingsInternalManager.aidl",
        "core/java/com/paxdroid/os/IPaxResManager.aidl",
        ],  
        path: "core/java",
    }
    ```

* 新增 DeviceManagerService ,负责具体service实现
    ```
    PaxSystemServer.java
    public void start() {
        mPaxdroidPlatform = new PaxdroidPlatform(mSystemContext);
        mPaxdroidPlatform.platformInit();

        // start pax services

        // Add pax device manager service
        try {
            Slog.i(TAG, "add DeviceManagerService");
            PaxDeviceManagerService paxDevMgr = new PaxDeviceManagerService(mSystemContext,
                                                    mWindowManagerService, mConnectivityManager);
            ServiceManager.addService("DeviceManagerService", paxDevMgr);
        } catch (Throwable e) {
            reportWtf("starting Pax DeviceManagerService", e); 
        }   
    }   
    ```

* 新增 PaxDeviceManagerService.Java,负责具体逻辑业务实现

    ```
    /**  
     * Get Device's TSN(Terminal Serial Number).
     */
    public String getDeviceTSN() {
        String devTSN = PaxdroidPlatform.getDeviceTSN();
        return devTSN;
    }
    public int update(int mode, String source) throws RemoteException {
        Plog.s(TAG, "remote["+PkgParser.getProcessNameByPid(Binder.getCallingPid())+"] calling update()");
        if (!(mode == 0 || mode == 1 || mode == 2)) {
            Log.w(TAG, "update mode = "+mode+" not supported!");
            return -1;
        }
        // Check permission
    ```

# 启动调用流程

* android framework,systemServer 启动PaxSystemServer.java

    ```
    QSSI.12/frameworks/base/services/java/com/android/server/SystemServer.java
            final ConnectivityManager connectivityF = (ConnectivityManager)
                    context.getSystemService(Context.CONNECTIVITY_SERVICE);


            if (true) {
                PaxSystemServer mPaxSystemServer = new PaxSystemServer(context, wm, connectivityF);
                mPaxSystemServer.start();
            }    

            // We now tell the activity manager it is okay to run third party
            // code.  It will call back into us once it has gotten to the state
            // where third party code can really run (but before it has actually
            // started launching the initial applications), for us to complete our
            // initialization.
            mActivityManagerService.systemReady(() -> { 
```

* PaxSystemServer 启动PaxDeviceManagerService

    ```
    public void start() {
        mPaxdroidPlatform = new PaxdroidPlatform(mSystemContext);
        mPaxdroidPlatform.platformInit();

        // start pax services

        // Add pax device manager service
        try {
            Slog.i(TAG, "add DeviceManagerService");
            PaxDeviceManagerService paxDevMgr = new PaxDeviceManagerService(mSystemContext,
                                                    mWindowManagerService, mConnectivityManager);
            ServiceManager.addService("DeviceManagerService", paxDevMgr);//paxDevMgr 是一个IBinder
        } catch (Throwable e) {
            reportWtf("starting Pax DeviceManagerService", e); 
        }   
    }   
    ```

* PaxDeviceManagerService 实现具体方法

```
    public class PaxDeviceManagerService extends IPaxDeviceManager.Stub {//IPaxDeviceManager.Stub 类是继承于Binder类的，也就是说Stub实例就是Binder实例
    /**  
     * Get Device's TSN(Terminal Serial Number).
     */
    public String getDeviceTSN() {
        String devTSN = PaxdroidPlatform.getDeviceTSN();
        return devTSN;
    }
    public int update(int mode, String source) throws RemoteException {
        Plog.s(TAG, "remote["+PkgParser.getProcessNameByPid(Binder.getCallingPid())+"] calling update()");
        if (!(mode == 0 || mode == 1 || mode == 2)) {
            Log.w(TAG, "update mode = "+mode+" not supported!");
            return -1;
        }
        // Check permission
```
