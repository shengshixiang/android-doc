# README

在sp runthos端,默认开启授权态,调试态给ap

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