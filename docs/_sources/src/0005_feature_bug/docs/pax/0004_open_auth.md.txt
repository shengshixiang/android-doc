# README

在sp runthos端,默认开启授权态,调试态给ap,L0

# 方法

```
--- a/vendor/platform/common/modules/pax/libdevio/include/sdk_inc/runthos/devio/devio_sp/dev_system_sp.h
+++ b/vendor/platform/common/modules/pax/libdevio/include/sdk_inc/runthos/devio/devio_sp/dev_system_sp.h
@@ -297,6 +297,10 @@ static inline int ros_get_authinfo(struct ros_dev *dev, RUNTHOS_POS_AUTH_INFO *a
        if (ret == 0) {
                if(arg_out.ret >= 0)
                        *authinfo = arg_out.authinfo;
+            //victor open auth begin^M
+        arg_out.authinfo.AppDebugStatus = 1;^M
+        arg_out.authinfo.FirmDebugStatus = 1;^M
+            //victor open auth end^M
                return arg_out.ret;
        }
        return ret;
```

# sp boot阶段,默认关闭触发

```
+++ b/vendor/apps/boot/src/auth.c
@@ -365,7 +365,7 @@ int AuthInit(void)
 #endif
        iRet = bbl_get_status();
        if (iRet) {
-               authinfo.LastBblStatus = iRet;
+               authinfo.LastBblStatus = 0;//iRet;//starmen^M
                AuthClearSensor();
                printf("bbl_get_status_err,LastBblStatus=%d\r\n", iRet);
        }
xielianxiong@xielianxiong-pc:/mnt/e/runthos$ adb reboot bootloader
```

# 之前方法打开固件调试可能不行

因为状态没有同步,所以可以参照 编译debug sp os的宏,打开固件调试态

```
diff --git a/vendor/platform/common/drivers/sys_param/sys_param.c b/vendor/platform/common/drivers/sys_param/sys_param.c
index 44a0eb64..ea269f4a 100644
--- a/vendor/platform/common/drivers/sys_param/sys_param.c
+++ b/vendor/platform/common/drivers/sys_param/sys_param.c
@@ -42,6 +42,7 @@ void sys_param_save(void *p)
        struct boot_param *bootparam = p;
        sys_param_data.bootparam = *bootparam;
-#ifdef CONFIG_NO_SIG
+#if 1//def CONFIG_NO_SIG
+       sys_param_data.bootparam.authinfo.FirmDebugStatus = 1;
        sys_param_data.bootparam.authinfo.AppDebugStatus = 1;
 #endif
 }
diff --git a/vendor/platform/common/modules/pax/libservice/authinfo.c b/vendor/platform/common/modules/pax/libservice/authinfo.c
index 7f1a984c..2776c9b8 100644
--- a/vendor/platform/common/modules/pax/libservice/authinfo.c
+++ b/vendor/platform/common/modules/pax/libservice/authinfo.c
@@ -56,7 +56,7 @@ void update_authinfo(unsigned int status)
                sysparam.bootparam.bootdebug = 0;
                sysparam.bootparam.authinfo.TamperClear = 0;
                sysparam.bootparam.authinfo.LastBblStatus = sensor_status;
-               sysparam.bootparam.authinfo.FirmDebugStatus = 0;
-#ifdef CONFIG_NO_SIG
+               sysparam.bootparam.authinfo.FirmDebugStatus = 1;
+#if 1//def CONFIG_NO_SIG
                sysparam.bootparam.authinfo.AppDebugStatus = 1;
 #else
                sysparam.bootparam.authinfo.AppDebugStatus = 0;
```

# boot阶段可能还会提示 clean触发

需要把把clearTamer 写死为2