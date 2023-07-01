# 概要

开机的时候,需要下一些at命令,使ESIM功能正常操作.

或者读取一些关键信息保存,例如imei号等.

# Android.mk

```
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := paxatcommand.cpp

LOCAL_SHARED_LIBRARIES := liblog libbase libcutils 

LOCAL_MODULE := paxatcommand

LOCAL_PROPRIETARY_MODULE := false

LOCAL_CERTIFICATE := platform

LOCAL_MODULE_TAGS := optional

LOCAL_INIT_RC := paxatcommand.rc

LOCAL_CFLAGS := -Wall

include $(BUILD_EXECUTABLE)
```

# paxatcommand.rc

boot_completed 的时候,调用paxatcommand,并且运行一次

```
on property:sys.boot_completed=1
    start paxatcommand

service paxatcommand /system/bin/paxatcommand
    class main
    user root
    group root
    oneshot
    disabled
```

# paxatcommand.cpp

```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LOG_TAG "paxatcommand"
#define LOG_NDEBUG 0
#include <log/log.h>
#include <cutils/properties.h>
#include <cutils/log.h>
#include <android-base/properties.h>

#define ATCOMMAND_FILE                        "/dev/smd8"
#define AT_OUTPUT_LEN                           100

void intercept_string(char* input,char* output,char* startChar,char* endChar){
    char* ptr;
    char* output_ptr = output;
    ptr = strstr(input,startChar);
    if(ptr == NULL){
        return;
    }
    ptr++;
    while(*ptr != *endChar && *ptr != '\0'){
        *output_ptr++ = *ptr++;
    }
    *output_ptr=0;
}

int boot_send_at_commond(char* command,char* value,int needOutput){
    int len = 0;
    FILE *file;
    char content[AT_OUTPUT_LEN]={0};
    char ch;
    len = strlen(command);
    ALOGD("%s,strlen(command) = %d,",__FUNCTION__,len);
    if(command == NULL || len >= AT_OUTPUT_LEN) {
        ALOGE("command error,");
        return -1;
    }
    memcpy(content, command, len);
    file = fopen(ATCOMMAND_FILE, "w");
    if (file == NULL) {
        ALOGE("fopen file error,");
        return -1;
    }

    fputs(content, file);
    fclose(file);

    if(needOutput == 1){
        file = fopen(ATCOMMAND_FILE, "r");
        if (file == NULL) {
            ALOGE("fopen file error,");
            return -1;
        }

        memset(content,0,sizeof(content));
        len = 0;
        while ((ch = fgetc(file)) != EOF) {
            content[len]=ch;
            if(content[len-1]=='O' && content[len]=='K') break;
            if(len++ > AT_OUTPUT_LEN) break;
        }

        fclose(file);
        intercept_string(content,value,"\"","\"");
    }

    return 0;
} 

int main() {
    int ret;
    char output[AT_OUTPUT_LEN]={0};
    char imei_command_1[20] = "AT+EGMR=0,7\r\n";
    char imei_command_2[20] = "AT+EGMR=0,10\r\n";
    char dual_sim[PROPERTY_VALUE_MAX] = {0};
    ALOGD("%s,go in,",__FUNCTION__);

    ret = boot_send_at_commond(imei_command_1,output,1);
    if( ret == 0 ){
        ALOGE("imei_command_1 = %s,",output);
        android::base::SetProperty("pax.persist.wnet.imei", output);
    }else{
        ALOGE("read imei_command_1 error,");
    }

    memset(dual_sim, 0, sizeof(dual_sim));
    if (property_get("ro.fac.cfg.DUAL_SIM", dual_sim, NULL) != 0) {
        if (strcmp(dual_sim, "TRUE") == 0) {
            memset(output,0,sizeof(output));
            ret = boot_send_at_commond(imei_command_2,output,1);
            if( ret == 0 ){
                ALOGE("imei_command_2 = %s,",output);
                android::base::SetProperty("pax.persist.wnet.imei2", output);
            }else{
                ALOGE("read imei_command_2 error,");
            }
        }
    }

    return ret;
}
```

# paxatcommand.te

```
type paxatcommand_exec, system_file_type, exec_type, file_type;
type paxatcommand,domain;
# New added for move to /system
typeattribute paxatcommand coredomain;

init_daemon_domain(paxatcommand)

allow paxatcommand self:capability { dac_override };
allow paxatcommand property_socket:sock_file {  getattr read write };
allow paxatcommand init:unix_stream_socket { connectto };
allow paxatcommand radio_prop:property_service { set };
allow paxatcommand vendor_smd_device:chr_file { open ioctl create write setattr append getattr read lock unlink};
allow paxatcommand pax_ctrl_prop:property_service set;
allow paxatcommand pax_ctrl_prop:file { open read write getattr map };
```

# QSSI.12/system/sepolicy/private/domain.te

```
--- a/QSSI.12/system/sepolicy/private/domain.te
+++ b/QSSI.12/system/sepolicy/private/domain.te
@@ -369,6 +369,7 @@ neverallow ~{
   logkit-init
   paxdroid_logd
   paxreadnvram
+  paxatcommand
 } self:global_capability_class_set dac_override;
```

# QSSI.12/system/sepolicy/private/file_contexts

```
--- a/QSSI.12/system/sepolicy/private/file_contexts
+++ b/QSSI.12/system/sepolicy/private/file_contexts
@@ -852,3 +852,4 @@
 /dev/block/by-name/pax_nvram            u:object_r:pax_nvram_device:s0
 #[FEATURE]-Add-end by xielianxiong@paxsz.com, 2023/02/21, for authinfo
 /system/bin/paxreadnvram u:object_r:paxreadnvram_exec:s0
+/system/bin/paxatcommand u:object_r:paxatcommand_exec:s0
```

# QSSI.12/system/sepolicy/public/device.te

```
--- a/QSSI.12/system/sepolicy/public/device.te
+++ b/QSSI.12/system/sepolicy/public/device.te
@@ -128,3 +128,4 @@ type userdata_sysdev, dev_type;
 #[feature]-add-begin xielianxiong@paxsz.com,20230221,for authinfo
 type pax_nvram_device, dev_type, bdev_type;
 #[feature]-add-end xielianxiong@paxsz.com,20230221,for authinfo
+type vendor_smd_device, dev_type;
```

# QSSI.12/vendor/paxsz/paxbuild.mk

```
--- a/QSSI.12/vendor/paxsz/paxbuild.mk
+++ b/QSSI.12/vendor/paxsz/paxbuild.mk
@@ -37,6 +37,7 @@ PRODUCT_PACKAGES += init.M9200_EEA.prop
 PRODUCT_PACKAGES += PaxWebView
 PRODUCT_PACKAGES += aapt
 PRODUCT_PACKAGES += paxreadnvram
+PRODUCT_PACKAGES += paxatcommand
 
 PRODUCT_PACKAGES += Camera2
```

# 修改ignore.cil

添加 paxatcommand,paxatcommand_exec,vendor_smd_device

* QSSI.12/system/sepolicy/private/compat/26.0/26.0.ignore.cil
* QSSI.12/system/sepolicy/private/compat/27.0/27.0.ignore.cil
* QSSI.12/system/sepolicy/private/compat/28.0/28.0.ignore.cil
* QSSI.12/system/sepolicy/private/compat/29.0/29.0.ignore.cil
* QSSI.12/system/sepolicy/private/compat/30.0/30.0.ignore.cil

```
--- a/QSSI.12/system/sepolicy/private/compat/30.0/30.0.ignore.cil
+++ b/QSSI.12/system/sepolicy/private/compat/30.0/30.0.ignore.cil
@@ -199,4 +199,7 @@
     systool_binder_service
     pax_nvram_device
     paxreadnvram
-    paxreadnvram_exec))
+    paxreadnvram_exec
+    paxatcommand
+    paxatcommand_exec
+    vendor_smd_device))
```

# 调试技巧

采用 setprop ctl.start paxatcommand 来启动paxatcommand 服务,调试selinux权限,不用每次都开机