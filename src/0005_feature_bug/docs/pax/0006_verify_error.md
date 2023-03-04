# README

A6650 过pci的时候,安装pedtest apk,重启机器,点击pedtest apk,概率性弹出 invalid app,原因是验签失败

# log

* 表象log

![0006_0001](images/0006_0001.png)

* 实际更往前的log

# 常用变量备注

* US_PUK = ID_US_PUK = 1

* UA_PUK = ID_UA_PUK = 2

* ID_MK_PUK = 0

* ID_MF_PUK = 0xff

# 分析

* 开机自动执行systool_server

```
init.paxdroid.Ginkgo.rc
149 service systoold /system/bin/systool_server
150     class main
151     user root
152     group root
```

* systool_server.cpp 执行main, -> systool_threadloop

```
int main(void)
{
    systool_self_init();
    systool_pipe_init();
    // start a thread to do other works,
    // so that we can start 'systool_binder' service as earlier as possible.
    systool_threadloop();

    addSystoolFuncs();
    ProcessState::self()->startThreadPool();
    sp<IServiceManager> serviceMgr = defaultServiceManager();
    sp<SystoolService> service = new SystoolService();
    serviceMgr->addService(String16("systool_binder"), service);
    IPCThreadState::self()->joinThreadPool(true);
}
```

* threadloop.c,创建 systool_main_loop_thread

```
void systool_threadloop(void)
{
    DLOG("New a thread for systool threadloop\n");
    /* Start a thread */
    pthread_t tid;
    if (pthread_create(&tid, NULL, systool_main_loop_thread, NULL)) {
        DLOG("pthread_create fail tid=%ld\n", tid);
    }
}
```

* systool_main_loop_thread 执行 systool_security_init

```
static void* systool_main_loop_thread(void *arg)
{
    paxdroid_init_first_stage();

    platform_init();
    DLOG("start paxdroid_lateinit");
    paxdroid_lateinit();
    DLOG("done paxdroid_lateinit");

    DLOG("+++ In systool_main_loop_thread\n");

    int isBootcompletedCheckTriggered = 0;
    while(1) {
        char value[PROPERTY_VALUE_MAX] = {0};
        char system_ready_prop[PROPERTY_VALUE_MAX] = {0};
        property_get("sys.boot_completed", value, "0");
        property_get("sys.system_ready", system_ready_prop, "0");
        if (strcmp("1", value) && strcmp("1", system_ready_prop)) {
            sleep(1);
            continue;
        }
        if (isBootcompletedCheckTriggered == 0) {
            isBootcompletedCheckTriggered = 1;
			sleep(5);
            DLOG("sys.boot_completed=%s, sys.system_ready=%s", value, system_ready_prop);
            systool_trigger_bootcompleted_check();
        }

#ifdef WAIT_FOR_SP_READY
        memset(value, 0, sizeof(value));
        property_get("sys.sp.status", value, "0");
        if (strcmp("1", value)) {
            sleep(1);
            continue;
        }
        DLOG("SP is ready.\n");
#endif

        DLOG("Now system is ready, do some security job.\n");
        // do some init job for security
        systool_security_init();
        break;
    }

    DLOG("+++ Out systool_main_loop_thread\n");
    return NULL;
}
```

* 最后调用到 pax_ReadPuk的时候,ret = b->transact(TRANSACTION_ReadPuk, data, &reply, 0); 出错了

* kernel, binder.c

出错的时候有,got transaction to invalid handle

# 打开binder尽量多的调试开关

* binder.c

```
static uint32_t binder_debug_mask = BINDER_DEBUG_USER_ERROR |
	BINDER_DEBUG_FAILED_TRANSACTION | BINDER_DEBUG_DEAD_TRANSACTION | BINDER_DEBUG_OPEN_CLOSE |
	BINDER_DEBUG_DEAD_BINDER | BINDER_DEBUG_DEATH_NOTIFICATION | BINDER_DEBUG_READ_WRITE |
	BINDER_DEBUG_USER_REFS | BINDER_DEBUG_THREADS | BINDER_DEBUG_TRANSACTION |
	BINDER_DEBUG_TRANSACTION_COMPLETE | BINDER_DEBUG_FREE_BUFFER | BINDER_DEBUG_INTERNAL_REFS |
	BINDER_DEBUG_PRIORITY_CAP | BINDER_DEBUG_SPINLOCKS;
```

# 发现验签两次

当kill引用的时候,binder还是alive的话,会自动fork起应用,导致又kill一把

```
03-01 14:56:20.834   530   530 I Zygote  : Process 7689 exited due to signal 9 (Killed)
03-01 14:56:20.832     0     0 I binder  : release 7689:7689 transaction 308900 out, still active
03-01 14:56:20.832     0     0 I binder  : undelivered TRANSACTION_COMPLETE
03-01 14:56:20.836     0     0 E binder  : invalid inc weak node for 308902
03-01 14:56:20.836     0     0 I binder  : 1226:6098 IncRefs 0 refcount change on invalid ref 760 ret -22
03-01 14:56:20.836     0     0 I binder  : 1226:6098 transaction failed 29189/0, size 4-0 line 3003
03-01 14:56:20.836     0     0 I binder  : send failed reply for transaction 308900, target dead
```

# 测试应用自启动

出现问题的时候,还发现 测试的apk 自启动很快就验签了,感觉有点问题

写一个不会自动启动的应用,测试没问题

对比系统原有流程,都是等一下几个属性OK了,才开始验签等安全相关工作

property_get("sys.boot_completed", value, "0");
property_get("sys.system_ready", system_ready_prop, "0");
property_get("sys.sp.status", value, "0");

试了不会自动启动的应用,100次没有复现问题

# 等到系统启动的完成,才开启验签,复测100遍

增加completed等判断,第一台NA机器,复测50遍,没有问题.

第二台机器EM,复测第15遍的时候出问题

String boot_complete = SystemProperties.get("sys.boot_completed","0");
String sp_status = SystemProperties.get("sys.sp.status","0");

```
//[FEATURE]-Add-BEGIN by(xielianxiong@paxsz.com), 2022/03/28,for pax verify ft bug,anr ft
        String boot_complete = SystemProperties.get("sys.boot_completed","0");
        String sp_status = SystemProperties.get("sys.sp.status","0");
        String commercial = SystemProperties.get("ro.pax.commercial.version","flase");
        Slog.w(TAG, "runtime_verify commercial = "+commercial);
        Slog.w(TAG, "runtime_verify boot_complete = "+boot_complete+",sp_status = "+sp_status);
        Slog.w(TAG, "runtime_verify app.info.sourceDir = "+app.info.sourceDir);

        if(("true").equals(commercial)){}
        else
        if(app.info.sourceDir != null && app.info.sourceDir.substring(0,10).equals("/data/app/")){
            IPkgVerifier pkgVerifier = IPkgVerifier.Stub.asInterface(ServiceManager.getService("PkgVerifyService"));
            Slog.w(TAG, "pkgVerifier = "+pkgVerifier+",processName = "+processName);
            if("1".equals(boot_complete) == false || "1".equals(sp_status) == false || pkgVerifier == null){
                if (!mService.mProcessesOnHold.contains(app)) {
                    Slog.w(TAG, "mService.mProcessesOnHold.add "+app.toString());
                    mService.mProcessesOnHold.add(app);
                }
                checkSlow(startTime, "startProcess: returning with proc on hold for system not ready");
                return app;
            }
        }
//[FEATURE]-Add-end by(xielianxiong@paxsz.com), 2022/03/28,for pax verify ft bug,anr ft
```

# 出问题的机器,把两个应用卸载,自带的readpuk没有问题

onLastStrongRef automatically unlinking death recipients: <uncached descriptor>

03-14 09:04:46.409  1023  3245 D systool_server: FUNC(svr_paxVerifyAppByName)

03-14 09:04:46.394  2541  2575 W Verifier/PkgVerifier: verifyPackage packagePath=/data/app/~~GqKZG3cb_tokS3Q-i3Bj_A==/com.pax.testp

没有什么头绪,分析不下去了.移远那边也分析不下去了.提给高通分析一下