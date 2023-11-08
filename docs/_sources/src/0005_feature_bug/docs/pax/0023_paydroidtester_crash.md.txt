# 概要

展锐 A12 uis8581e 项目,运行 paydroidtester报停

# log

* 异常log

```
11-07 08:03:31.118   974  1342 D SSense.SRecogCollector:  getStartUpComponent  sizeof resolves : 0  for pkg name:com.android.permissioncontroller
11-07 08:03:31.120   974  1673 I StorageManagerService: Cmd send setupAppDir /storage/emulated/0/Android/data/com.pax.paydroid.tester/files/
11-07 08:03:31.122   303   303 E vold    : Failed to set project id on /data/media/0/Android/data/com.pax.paydroid.tester/: Operation not supported on transport endpoint
11-07 08:03:31.124  3154  3154 W ContextImpl: Failed to ensure /storage/emulated/0/Android/data/com.pax.paydroid.tester/files: android.os.ServiceSpecificException:  (code -1)
11-07 08:03:31.127   974  1673 I StorageManagerService: Cmd send setupAppDir /storage/emulated/0/Android/data/com.pax.paydroid.tester/cache/
11-07 08:03:31.128   303   303 E vold    : Failed to set project id on /data/media/0/Android/data/com.pax.paydroid.tester/: Operation not supported on transport endpoint
11-07 08:03:31.129  3154  3154 W ContextImpl: Failed to ensure /storage/emulated/0/Android/data/com.pax.paydroid.tester/cache: android.os.ServiceSpecificException:  (code -1)
11-07 08:03:31.130  3154  3154 D AndroidRuntime: Shutting down VM
--------- beginning of crash
11-07 08:03:31.131  3154  3154 E AndroidRuntime: FATAL EXCEPTION: main
11-07 08:03:31.131  3154  3154 E AndroidRuntime: Process: com.pax.paydroid.tester, PID: 3154
11-07 08:03:31.131  3154  3154 E AndroidRuntime: java.lang.RuntimeException: Unable to start activity ComponentInfo{com.pax.paydroid.tester/com.pax.paydroid.tester.ui.PaydroidTesterActivity}: java.lang.NullPointerException: Attempt to invoke virtual method 'java.lang.String java.io.File.getPath()' on a null object reference
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.ActivityThread.performLaunchActivity(ActivityThread.java:3683)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.ActivityThread.handleLaunchActivity(ActivityThread.java:3840)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.servertransaction.LaunchActivityItem.execute(LaunchActivityItem.java:105)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.servertransaction.TransactionExecutor.executeCallbacks(TransactionExecutor.java:136)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.servertransaction.TransactionExecutor.execute(TransactionExecutor.java:96)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2252)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.os.Handler.dispatchMessage(Handler.java:106)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.os.Looper.loopOnce(Looper.java:201)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.os.Looper.loop(Looper.java:288)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.ActivityThread.main(ActivityThread.java:7941)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at java.lang.reflect.Method.invoke(Native Method)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:553)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:1003)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: Caused by: java.lang.NullPointerException: Attempt to invoke virtual method 'java.lang.String java.io.File.getPath()' on a null object reference
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at com.pax.paydroid.tester.utils.TesterConfig.initDir(TesterConfig.java:37)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at com.pax.paydroid.tester.ui.PaydroidTesterActivity.onCreate(PaydroidTesterActivity.java:431)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.Activity.performCreate(Activity.java:8060)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.Activity.performCreate(Activity.java:8040)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.Instrumentation.callActivityOnCreate(Instrumentation.java:1329)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	at android.app.ActivityThread.performLaunchActivity(ActivityThread.java:3653)
11-07 08:03:31.131  3154  3154 E AndroidRuntime: 	... 12 more
11-07 08:03:31.132   524   524 D enhanceHAL: slpSetBrightness: ambient = 170
```

* 正常log

```
11-07 02:23:13.969   986  1677 W ActivityTaskManager: startActivity ActivityRecord r=ActivityRecord{2d46008 u0 com.android.permissioncontroller/.permission.ui.GrantPermissionsActivity
11-07 02:23:13.969   986  1677 W ActivityTaskManager: packageName com.android.permissioncontroller is running
11-07 02:23:13.972   986  1677 D CompatibilityChangeReporter: Compat change id reported: 174042980; UID 10091; state: DISABLED
11-07 02:23:13.973   986  1677 D CompatibilityChangeReporter: Compat change id reported: 184838306; UID 10091; state: DISABLED
11-07 02:23:13.974   986  1677 D CompatibilityChangeReporter: Compat change id reported: 185004937; UID 10091; state: DISABLED
11-07 02:23:13.975   986  1677 D CompatibilityChangeReporter: Compat change id reported: 181136395; UID 10091; state: DISABLED
11-07 02:23:13.977   986  1677 D CompatibilityChangeReporter: Compat change id reported: 174042936; UID 10091; state: DISABLED
11-07 02:23:13.983   986  1677 I ActivityTaskManager: ->startActivity for ActivityRecord{2d46008 u0 com.android.permissioncontroller/.permission.ui.GrantPermissionsActivity t12} result:START_SUCCESS
11-07 02:23:13.987  3623  3623 D PaydroidTesterActivity: isOriginalSystem=false
11-07 02:23:13.990   986  1044 D SSense  : windowsChanged
11-07 02:23:13.994   986  1799 D SSense.SRecogCollector:  getStartUpComponent  sizeof resolves : 0  for pkg name:com.android.permissioncontroller
11-07 02:23:13.995   986  1039 I StorageManagerService: Cmd send setupAppDir /storage/emulated/0/Android/data/com.pax.paydroid.tester/files/
11-07 02:23:13.998   986  1039 I StorageManagerService: Cmd send setupAppDir end /storage/emulated/0/Android/data/com.pax.paydroid.tester/files/
11-07 02:23:14.003   986  1039 I StorageManagerService: Cmd send setupAppDir /storage/emulated/0/Android/data/com.pax.paydroid.tester/cache/
11-07 02:23:14.005   986  1039 I StorageManagerService: Cmd send setupAppDir end /storage/emulated/0/Android/data/com.pax.paydroid.tester/cache/
11-07 02:23:14.019  3623  3623 D PaydroidTesterActivity: onCreate
11-07 02:23:14.024  3623  3623 I PaydroidTesterActivity: ------changeStorageDir=/storage/emulated/0/Android/data/com.pax.paydroid.tester/cache/shared_prefs/
11-07 02:23:14.030   607   607 D enhanceHAL: slpSetBrightness: ambient = 229
11-07 02:23:14.074  3623  3623 D CompatibilityChangeReporter: Compat change id reported: 171228096; UID 10099; state: ENABLED
11-07 02:23:14.111   986   986 W NotificationHistory: Attempted to add notif for locked/gone/disabled user 0
11-07 02:23:14.130  1606  1606 D InterruptionStateProvider: No bubble up: not allowed to bubble: 0|com.pax.paydroid.tester.service|1110|null|1000
11-07 02:23:14.132  1606  1606 W NotifBindPipeline: Row is not set so pipeline will not run. notif = 0|com.pax.paydroid.tester.service|1110|null|1000
11-07 02:23:14.133  1606  1705 D PeopleSpaceWidgetMgr: Sbn doesn't contain valid PeopleTileKey: null/0/com.pax.paydroid.tester.service
11-07 02:23:14.139  1606  1606 D NotifContentInflater: apply, finishIfDone
```

# 初步log分析

看起来跟vold有关,对应代码,但是基本没改过这一块

* idh.code/system/vold/Utils.cpp

```
int SetQuotaProjectId(const std::string& path, long projectId) {
    struct fsxattr fsx;

    android::base::unique_fd fd(TEMP_FAILURE_RETRY(open(path.c_str(), O_RDONLY | O_CLOEXEC)));
    if (fd == -1) {
        PLOG(ERROR) << "Failed to open " << path << " to set project id.";
        return -1;
    }    

    int ret = ioctl(fd, FS_IOC_FSGETXATTR, &fsx);
    if (ret == -1) {
        PLOG(ERROR) << "Failed to get extended attributes for " << path << " to get project id.";
        return ret; 
    }    

    fsx.fsx_projid = projectId;
    ret = ioctl(fd, FS_IOC_FSSETXATTR, &fsx);
    if (ret == -1) {
        PLOG(ERROR) << "Failed to set project id on " << path;
        return ret; 
    }    
    return 0;
}
```

* 对应展锐有一篇相关文档

![0023_0001](images/0023_0001.png)

# 复测

因为问题不是必现的,只有出现一次的时候,就会出现,不出现的时候就不会出现.不排除跟从f2fs改为ext4有关

* 先用ext4版本复测

发现跟清除固件调试态,授权固件调试态有些关系.

出现问题后,设置恢复出厂设置,重新安装apk,问题也还在.

只有bootloader模式下,fastboot erase userdata,再装apk,问题不复现.

看起来跟展锐说的文件系统还是有点关系.

* 都清除固件调试后,压力测试10次ext4软件

# 必现方法

* 固件调试态授权,重启,安装apk,复现

* 清除固件调试态,重启,安装apk,复现

# 出现后,修正方法

* bootloader,fastboot erase userdata,安装apk,正常运行

# f2fs软件

使用f2fs的软件复测,看看跟ext4是不是强相关

看起来跟文件系统也有关系.

使用f2fs的软件,使用上面的必现方法,没有复现

# 跟文件系统相关代码

如果想解决ext4文件系统闪退问题,还得分析挂载ext4系统的时候,跟`IsSdcardfsUsed` 相关的参数

* idh.code/system/vold/Utils.cpp

```
static int FixupAppDir(const std::string& path, mode_t mode, uid_t uid, gid_t gid, long projectId) {
    namespace fs = std::filesystem;

    // Setup the directory itself correctly
    int ret = PrepareDirWithProjectId(path, mode, uid, gid, projectId);
    if (ret != OK) {
        return ret; 
    }    

    // Fixup all of its file entries
    for (const auto& itEntry : fs::directory_iterator(path)) {
        ret = lchown(itEntry.path().c_str(), uid, gid);
        if (ret != 0) { 
            return ret; 
        }    

        ret = chmod(itEntry.path().c_str(), mode);
        if (ret != 0) { 
            return ret; 
        }    

        if (!IsSdcardfsUsed()) {
            ret = SetQuotaProjectId(itEntry.path(), projectId);
            if (ret != 0) { 
                return ret; 
            }    
        }    
    }    

    return OK;
}

int PrepareDirWithProjectId(const std::string& path, mode_t mode, uid_t uid, gid_t gid,
                            long projectId) {
    int ret = fs_prepare_dir(path.c_str(), mode, uid, gid);

    if (ret != 0) {
        return ret;
    }

    if (!IsSdcardfsUsed()) {
        ret = SetQuotaProjectId(path, projectId);
    }

    return ret;
}
```

# 解决方法

* 让测试部,不要打开固件调试态测试

* 打开固件调试态的话,要同步 fastboot erase userdata,fastboot erase metadata