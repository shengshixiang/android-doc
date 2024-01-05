# 概述

测试反馈,项目展锐平台,uis8581e 8核(4大核,4小核),android12 算法运算较慢,比标准慢,比对比机慢,并且差异较大

# 具体情况

* 从测试反馈看到,确实比较慢

![0030_0001](images/0030_0001.png)

* 自己测试

![0030_0002](images/0030_0002.png)

# 分析

不论从客户要求的测试方案,还是同事的测试方案,看起来都比较慢

并且固定频率好像也提升不大

但是明显可以看到,mtk 8766 平台的cpu 性能跟展锐8581e应该是同一水平才对

测试结果显示mtk的8766竟然高一个档次

所以是不是展锐的把一些关键进程放在小核运行了

# 绑定大核测试

经过一系列测试,发现绑定4个大核调度也不行

还是绑定一个核效果好一些

* 绑定一个大核

绑定一个大核,有可能第一次会慢一些.猜测是大核的频率还没升高,还是1.2Ghz左右的速度运行,没有达到最大频率1.8Ghz

```
H:\Debug_work\AF6_debug\DES_TDES_AES>adb shell
AF6:/ # ps  -e | grep paxservice --color -i
root           738     1 11350632  8764 binder_thread_read  0 S paxservice
AF6:/ # taskset -p 10 738
pid 738's current affinity mask: ff
pid 738's new affinity mask: 10
```

* 绑定4个大核测试

绑定多个大核,速度有点飘.一会快,一会慢,可能有时候cpu之间调度,导致paxservice暂停运行

-pa也不行,也飘

```
AF6:/ # ps  -e | grep paxservice --color -i
root           738     1 11350632  8764 binder_thread_read  0 S paxservice
AF6:/ # taskset -pa f0 738
pid 738's current affinity mask: 1
pid 738's new affinity mask: f0
```

* 测试数据

有一定优化

![0030_0003](images/0030_0003.png)

# 大小核测试

* taskset -p 10 738
* taskset -p 20 738
* taskset -p 40 738
* taskset -p 80 738

    速度快,最稳定还是10, 80有些AES_PER1看起来概率性比较大测试不通过

* taskset -p 01 738
* taskset -p 02 738
* taskset -p 04 738
* taskset -p 08 738

    速度慢

* cat /proc/738/cpuset

查看进程在哪个cpu上

# 加上pa 组

单单 -p参数不行,加上-a基本可以达标

* taskset

```
usage: taskset [-ap] [mask] [PID cmd [args...]]

-p      Set/get the affinity of given PID instead of a new command.

-a      Set/get the affinity of all threads of the PID.
```

# 代码修改方法

* idh.code/vendor/pax/pax-sh/init_paxconfig.sh

创建主要的绑定大核脚本,因为脚本可能多人调用,所以创建属性already.taskset.paxservice防止多次调用绑定

主要是利用pidof命令获取paxservice pid,然后利用`taskset -pa 80 $pid` 绑定到大核

```
#! /system/bin/sh

need_taskset_paxservice=`getprop already.taskset.paxservice`
if [ -z ${need_taskset_paxservice} ]; then
    echo "Start tastset paxservice......"
    pid=`pidof paxservice`
    if [ $? -ne 0 ]; then
        echo "Get paxservice pid failed"
    else
        taskset -pa 80 $pid
        if [ $? -ne 0 ]; then
            echo "taskset -pa 80 paxservice $pid failed"
        else
            setprop already.taskset.paxservice true
        fi  
    fi  
else
    echo "paxservice has been tastset "
fi
```

* idh.code/vendor/pax/pax-sh/Android.mk

配置编译方法,编译到路径`/vendor/bin/init_paxconfig.sh`

```
LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := init_paxconfig.sh 
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := FAKE
LOCAL_SRC_FILES := ${LOCAL_MODULE}
LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/bin
include $(BUILD_PREBUILT)
```

* idh.code/vendor/pax/init/init.AF6.common.rc

开机成功后,启动调用脚本

```
service init_paxconfig /vendor/bin/init_paxconfig.sh
    class late_start
    user root
    group root
    disabled
    oneshot

on property:sys.boot_completed=1
    start init_paxconfig
```

# Log

`start init_paxconfig failed`

启动失败,缺少selinux

```
[   33.649519] c4init: processing action (sys.boot_completed=1) from (/vendor/etc/init/hw/init.AF6.common.rc:30)
[   33.650593] c4init: Command 'start init_paxconfig' action=sys.boot_completed=1 (/vendor/etc/init/hw/init.AF6.common.rc:31) took 0ms and failed: Could not start service: File /vendor/bin/init_paxconfig.sh(labeled "u:object_r:vendor_file:s0") has incorrect label or no domain transition from u:r:init:s0 to another SELinux domain defined. Have you configured your service correctly? https://source.android.com/security/selinux/device-policy#label_new_services_and_address_denials. Note: this error shows up even in permissive mode in order to make auditing denials possible.
[   33.650726] c4init: processing action (sys.boot_completed=1 && sys.bootstat.first_boot_completed=0) from (/system/etc/init/bootstat.rc:79)
[   33.651288] c4init: starting service 'exec 17 (/system/bin/bootstat --record_boot_complete --record_boot_reason --record_time_since_factory_reset -l)'...
```

# selinux

* 创建文件init_paxconfig.sh属组

`idh.code/vendor/pax/sepolicy/private/file_contexts`

```
/vendor/bin/init_paxconfig.sh   u:object_r:init_paxconfig_exec:s0
```

* 创建init_paxconfig.sh运行域

`idh.code/vendor/pax/sepolicy/private/init_paxconfig.te`

```
1 typeattribute init_paxconfig coredomain;
2 init_daemon_domain(init_paxconfig)
```

* 配置运行属组的运行类型

`idh.code/vendor/pax/sepolicy/public/init_paxconfig.te`

```
type init_paxconfig, coredomain, mlstrustedsubject;
type init_paxconfig_exec, exec_type;

#type init_paxconfig, domain, mlstrustedsubject;
#type init_paxconfig_exec, exec_type, file_type, system_file_type;
```

# 编译报错

selinux的编译log太不明显了,很隐晦,很多原因不明

## 编译报错1

* log

```
libsepol.report_assertion_extended_permissions: neverallowxperm on line 362 of system/sepolicy/public/domain.te (or line 12040 of policy.conf) violated by
allow mediadrmserver mediadrmserver:icmp_socket { ioctl };
libsepol.report_assertion_extended_permissions: neverallowxperm on line 362 of system/sepolicy/public/domain.te (or line 12040 of policy.conf) violated by
allow storaged system_data_file:file { ioctl };
libsepol.check_assertions: 104536 neverallow failures occurred
Error while expanding policy
[ 88% 895/1016] //system/sepolicy:system_ext_sepolicy.cil Building cil for system_ext_sepolicy.cil [common]
FAILED: out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil
out/soong/host/linux-x86/bin/checkpolicy -C -M -c 30 -o out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.conf/android_common/conf && out/soong/host/linux-x86/bin/build_sepolicy filter_out -f out/soong/.intermediates/system/sepolicy/plat_sepolicy.cil/android_common/plat_sepolicy.cil -t out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil && grep -v ';;' out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil > out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil.tmp && mv out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil.tmp out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil && out/soong/host/linux-x86/bin/secilc -m -M true -G -c 30 out/soong/.intermediates/system/sepolicy/plat_sepolicy.cil/android_common/plat_sepolicy.cil out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil -o /dev/null -f /dev/null # hash of input list: 3032ac38d7011dd23c2f0b3d37e6350d6ea919dc0ff35e5758a67d62f17eea61
device/sprd/mpool/sepolicy/system/private/bluetooth.te:2:WARNING 'unrecognized character' at token '
' on line 66216:
allow bluetooth mediametrics_service:service_manager find;
#line 1 "device/sprd/mpool/sepolicy/system/private/bluetooth.te"
device/sprd/mpool/sepolicy/system/private/bluetooth.te:2:WARNING 'unrecognized character' at token '
' on line 66216:
allow bluetooth mediametrics_service:service_manager find;
#line 1 "device/sprd/mpool/sepolicy/system/private/bluetooth.te"
neverallowx check failed at out/soong/.intermediates/system/sepolicy/plat_sepolicy.cil/android_common/plat_sepolicy.cil:7499 from system/sepolicy/public/domain.te:362
  (neverallowx base_typeattr_188 base_typeattr_188 (ioctl file (0x0)))

Failed to generate binary
Failed to build policydb
ninja: build stopped: subcommand failed.
11:34:39 ninja failed with: exit status 1
```

* idh.code/out/soong/.intermediates/system/sepolicy/plat_sepolicy.cil/android_common/plat_sepolicy.cil

```
(allowx domain sdcard_type (ioctl file ((range 0xf501 0xf502) 0xf505 (range 0xf50c 0xf50e))))
(allow base_typeattr_225 hwservice_manager_type (hwservice_manager (add find)))
(allow base_typeattr_225 vndservice_manager_type (service_manager (add find)))
(allow domain apex_mnt_dir (dir (getattr search)))
(allow domain apex_mnt_dir (lnk_file (ioctl read getattr lock map open watch watch_reads)))
;;* lmx 362 system/sepolicy/public/domain.te

(neverallowx base_typeattr_188 base_typeattr_188 (ioctl file (0x0)))
(neverallowx base_typeattr_188 base_typeattr_188 (ioctl dir (0x0)))
```

* 解决方法

`idh.code/vendor/pax/sepolicy/public/init_paxconfig.te`

添加基础类型定义,vendor_file_type, file_type;

```
type init_paxconfig, coredomain, mlstrustedsubject;
type init_paxconfig_exec, exec_type, file_type, vendor_file_type;
```

## 编译报错2

* log

```
Error while expanding policy
[ 85% 611/718] //system/sepolicy:system_ext_sepolicy.cil Building cil for system_ext_sepolicy.cil [common]
FAILED: out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil
out/soong/host/linux-x86/bin/checkpolicy -C -M -c 30 -o out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.conf/android_common/conf && out/soong/host/linux-x86/bin/build_sepolicy filter_out -f out/soong/.intermediates/system/sepolicy/plat_sepolicy.cil/android_common/plat_sepolicy.cil -t out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil && grep -v ';;' out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil > out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil.tmp && mv out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil.tmp out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil && out/soong/host/linux-x86/bin/secilc -m -M true -G -c 30 out/soong/.intermediates/system/sepolicy/plat_sepolicy.cil/android_common/plat_sepolicy.cil out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil -o /dev/null -f /dev/null # hash of input list: 3032ac38d7011dd23c2f0b3d37e6350d6ea919dc0ff35e5758a67d62f17eea61
device/sprd/mpool/sepolicy/system/private/bluetooth.te:2:WARNING 'unrecognized character' at token '
' on line 66213:
#line 1 "device/sprd/mpool/sepolicy/system/private/bluetooth.te"
allow bluetooth mediametrics_service:service_manager find;
device/sprd/mpool/sepolicy/system/private/bluetooth.te:2:WARNING 'unrecognized character' at token '
' on line 66213:
allow bluetooth mediametrics_service:service_manager find;
#line 1 "device/sprd/mpool/sepolicy/system/private/bluetooth.te"
neverallow check failed at out/soong/.intermediates/system/sepolicy/plat_sepolicy.cil/android_common/plat_sepolicy.cil:18940 from system/sepolicy/private/domain.te:464
  (neverallow base_typeattr_636 base_typeattr_637 (file (ioctl read write create getattr setattr lock relabelfrom relabelto append map unlink link rename execute quotaon mounton audit_access open execmod watch watch_mount watch_sb watch_with_perm watch_reads execute_no_trans entrypoint)))
    <root>
    allow at out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil:526
      (allow init_paxconfig init_paxconfig_exec (file (read getattr map execute open entrypoint)))

neverallow check failed at out/soong/.intermediates/system/sepolicy/plat_sepolicy.cil/android_common/plat_sepolicy.cil:8271 from system/sepolicy/public/domain.te:986
  (neverallow base_typeattr_273 base_typeattr_274 (file (execute)))
    <root>
    allow at out/soong/.intermediates/system/sepolicy/system_ext_sepolicy.cil/android_common/system_ext_sepolicy.cil:526
      (allow init_paxconfig init_paxconfig_exec (file (read getattr map execute open entrypoint)))

Failed to generate binary
Failed to build policydb
ninja: build stopped: subcommand failed.
15:27:37 ninja failed with: exit status 1
```

* 解决方法

修改对应的neverallow

```
--- a/idh.code/system/sepolicy/private/domain.te
+++ b/idh.code/system/sepolicy/private/domain.te
@@ -480,6 +480,7 @@ full_treble_only(`
     -ueventd # reads /vendor/ueventd.rc
     -vold # loads incremental fs driver
     -update_engine
+    -init_paxconfig
   } {
     vendor_file_type
     -same_process_hal_file
diff --git a/idh.code/system/sepolicy/public/domain.te b/idh.code/system/sepolicy/public/domain.te
index ba7e3393b9d..ac5454adde3 100755
--- a/idh.code/system/sepolicy/public/domain.te
+++ b/idh.code/system/sepolicy/public/domain.te
@@ -993,6 +993,7 @@ full_treble_only(`
       -system_executes_vendor_violators
       -ueventd
       -update_engine
+      -init_paxconfig
     } {
       vendor_file_type
       -same_process_hal_file
```

## 编译报错3

* log

31.0.cil -m # hash of input list cil不对

```
No need to regenerate ninja file
Starting ninja...
[ 75% 493/656] target Prebuilt: pub_policy.cil (out/target/product/uis8581e_5h10/obj/ETC/pub_policy.cil_intermediates/pub_policy.cil)
[ 75% 494/656] target Prebuilt: microdroid_vendor_sepolicy.cil.raw (out/target/product/uis8581e_5h10/obj/ETC/microdroid_vendor_sepolicy.cil.raw_intermediates/microdroid_vendor_sepolicy.cil.raw)
[ 75% 495/656] target Prebuilt: plat_pub_policy.cil (out/target/product/uis8581e_5h10/obj/ETC/plat_pub_policy.cil_intermediates/plat_pub_policy.cil)
[ 75% 496/656] target Prebuilt: system_ext_pub_policy.conf (out/target/product/uis8581e_5h10/obj/ETC/system_ext_pub_policy.conf_intermediates/system_ext_pub_policy.conf)
[ 75% 497/656] //system/sepolicy:plat_mapping_file Versioning mapping file plat_mapping_file [common]
FAILED: out/soong/.intermediates/system/sepolicy/plat_mapping_file/android_common/31.0.cil
out/soong/host/linux-x86/bin/version_policy -b out/soong/.intermediates/system/sepolicy/plat_pub_policy.cil/android_common/plat_pub_policy.cil -n 31.0 -o out/soong/.intermediates/system/sepolicy/plat_mapping_file/android_common/31.0.cil -m # hash of input list: 049668e46e420014f4f0809f7d85e403c7a447413e6140793dd87329e99423ff
typetransition unsupported statement in attributee policy (line 9559)
Unable to extract attributizable elements from source db.
[ 75% 498/656] //system/sepolicy:general_sepolicy.conf Transform policy to conf: general_sepolicy.conf [common]
[ 76% 499/656] //system/sepolicy:plat_sepolicy.conf Transform policy to conf: plat_sepolicy.conf [common]
```

* 解决方法

把`type init_paxconfig`定义到public,init_daemon_domain定义到private

## 编译报错4

* log

```
[ 75% 28/37] build out/target/product/uis8581e_5h10/obj/FAKE/treble_sepolicy_tests_26.0_intermediates/treble_sepolicy_tests_26.0
FAILED: out/target/product/uis8581e_5h10/obj/FAKE/treble_sepolicy_tests_26.0_intermediates/treble_sepolicy_tests_26.0
/bin/bash -c "(out/host/linux-x86/bin/treble_sepolicy_tests -l                 out/host/linux-x86/lib64/libsepolwrap.so  -f out/target/product/uis8581e_5h10/system/etc/selinux/plat_file_contexts  -f out/target/product/uis8581e_5h10/vendor/etc/selinux/vendor_file_contexts  -f out/target/product/uis8581e_5h10/system_ext/etc/selinux/system_ext_file_contexts                 -b out/target/product/uis8581e_5h10/obj/ETC/built_plat_sepolicy_intermediates/built_plat_sepolicy -m out/target/product/uis8581e_5h10/obj/FAKE/treble_sepolicy_tests_26.0_intermediates/26.0_mapping.combined.cil                 -o out/target/product/uis8581e_5h10/obj/FAKE/treble_sepolicy_tests_26.0_intermediates/built_26.0_plat_sepolicy -p out/target/product/uis8581e_5h10/obj/ETC/sepolicy_intermediates/sepolicy                 -u out/target/product/uis8581e_5h10/obj/ETC/built_plat_sepolicy_intermediates/base_plat_pub_policy.cil ) && (touch out/target/product/uis8581e_5h10/obj/FAKE/treble_sepolicy_tests_26.0_intermediates/treble_sepolicy_tests_26.0 )"
SELinux: The following public types were found added to the policy without an entry into the compatibility mapping file(s) found in private/compat/V.v/V.v[.ignore].cil, where V.v is the latest API level.
init_paxconfig init_paxconfig_exec

See examples of how to fix this:
https://android-review.googlesource.com/c/platform/system/sepolicy/+/781036
https://android-review.googlesource.com/c/platform/system/sepolicy/+/852612

[ 78% 29/37] build out/target/product/uis8581e_5h10/obj/FAKE/treble_sepolicy_tests_29.0_intermediates/treble_sepolicy_tests_29.0
FAILED: out/target/product/uis8581e_5h10/obj/FAKE/treble_sepolicy_tests_29.0_intermediates/treble_sepolicy_tests_29.0
/bin/bash -c "(out/host/linux-x86/bin/treble_sepolicy_tests -l                 out/host/linux-x86/lib64/libsepolwrap.so  -f out/target/product/uis8581e_5h10/system/etc/selinux/plat_file_contexts  -f out/target/product/uis8581e_5h10/vendor/etc/selinux/vendor_file_contexts  -f out/target/product/uis8581e_5h10/system_ext/etc/selinux/system_ext_file_contexts                 -b out/target/product/uis8581e_5h10/obj/ETC/built_plat_sepolicy_intermediates/built_plat_sepolicy -m out/target/product/uis8581e_5h10/obj/FAKE/treble_sepolicy_tests_29.0_intermediates/29.0_mapping.combined.cil                 -o out/target/product/uis8581e_5h10/obj/FAKE/treble_sepolicy_tests_29.0_intermediates/built_29.0_plat_sepolicy -p out/target/product/uis8581e_5h10/obj/ETC/sepolicy_intermediates/sepolicy                 -u out/target/product/uis8581e_5h10/obj/ETC/built_plat_sepolicy_intermediates/base_plat_pub_policy.cil ) && (touch out/target/product/uis8581e_5h10/obj/FAKE/treble_sepolicy_tests_29.0_intermediates/treble_sepolicy_tests_29.0 )"
SELinux: The following public types were found added to the policy without an entry into the compatibility mapping file(s) found in private/compat/V.v/V.v[.ignore].cil, where V.v is the latest API level.
init_paxconfig init_paxconfig_exec
```

* 解决方法

过滤cil

```
--- a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/30.0/30.0.ignore.cil
+++ b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/30.0/30.0.ignore.cil
@@ -198,4 +198,6 @@
     tp_ver_default
     tp_ver_default_exec
     systoold
-    systoold_exec))
+    systoold_exec
+    init_paxconfig
+    init_paxconfig_exec))
diff --git a/idh.code/system/sepolicy/private/compat/30.0/30.0.ignore.cil b/idh.code/system/sepolicy/private/compat/30.0/30.0.ignore.cil
index 6f70501b616..d608a7a2d9e 100755
--- a/idh.code/system/sepolicy/private/compat/30.0/30.0.ignore.cil
+++ b/idh.code/system/sepolicy/private/compat/30.0/30.0.ignore.cil
@@ -198,4 +198,6 @@
     tp_ver_default
     tp_ver_default_exec
     systoold
-    systoold_exec))
+    systoold_exec
+    init_paxconfig
+    init_paxconfig_exec))
```

# 运行报错

* dmesg

`Could not get process context`

```
[   31.140301] c0init: Command 'start init_paxconfig' action=sys.boot_completed=1 (/vendor/etc/init/hw/init.AF6.common.rc:31) took 1ms and failed: Could not start service: Could not get process context
[   31.140487] c0init: processing action (sys.boot_completed=1 && sys.bootstat.first_boot_completed=0) from (/system/etc/init/bootstat.rc:79)
[   31.141062] c0init: starting service 'exec 17 (/system/bin/bootstat --record_boot_complete --record_boot_reason --record_time_since_factory_reset -l)'...
[   31.141495] c5type=1401 audit(1703841009.511:166): op=security_compute_sid invalid_context="u:r:init_paxconfig:s0" scontext=u:r:init:s0 tcontext=u:object_r:init_paxconfig_exec:s0 tclass=process
[   31.147802] c0init: processing action (sys.boot_completed=1) from (/system/etc/init/flags_health_check.rc:7)
```

* 解决

`system/sepolicy/private/init_paxconfig.te` private去掉 `typeattribute init_paxconfig coredomain;`

`system/sepolicy/public/init_paxconfig.te` public加上 `domain`

因为 private的`init_daemon_domain(init_paxconfig)` 本身就定义了domain

public 不能有`coredomain`, init_paxconfig.sh 属于vendor进程

# 最终解决

由于init_paxconfig.sh用到了pidof等命令,他回去/proc/pid搜索所有进程,所以会涉及到大量的selinux search ,read修改.

`permissive init_paxconfig;`

# 最终修改

```
commit b6bb3e6eef550e09ac4e29b902c212dc356c0746
Date:   Fri Dec 29 19:27:07 2023 +0800

    [Title]:Fix bug#0050931,DES/TDES/AES加\解密速度比参考值差15%-50%，比对比机差2%-10%
    
    [Summary]: paxservice 绑定大核运行
    
    [Test Plan]: 1.回归测试
    
    [Module]: paxservice
    
    [date]: 2023-12-29

diff --git a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/26.0/26.0.ignore.cil b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/26.0/26.0.ignore.cil
index 98d5840f6c3..47c5ac81e85 100644
--- a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/26.0/26.0.ignore.cil
+++ b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/26.0/26.0.ignore.cil
@@ -225,7 +225,9 @@
     wpantund_exec
     wpantund_service
     wpantund_tmpfs
-    wm_trace_data_file))
+    wm_trace_data_file
+    init_paxconfig
+    init_paxconfig_exec))
 
 ;; private_objects - a collection of types that were labeled differently in
 ;;     older policy, but that should not remain accessible to vendor policy.
diff --git a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/27.0/27.0.ignore.cil b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/27.0/27.0.ignore.cil
index 427f4d4d186..0aa4e870fa2 100644
--- a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/27.0/27.0.ignore.cil
+++ b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/27.0/27.0.ignore.cil
@@ -248,7 +248,9 @@
     wpantund_service
     wpantund_tmpfs
     zram_config_prop
-    zram_control_prop))
+    zram_control_prop
+    init_paxconfig
+    init_paxconfig_exec))
 
 ;; private_objects - a collection of types that were labeled differently in
 ;;     older policy, but that should not remain accessible to vendor policy.
diff --git a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/28.0/28.0.ignore.cil b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/28.0/28.0.ignore.cil
index e7ddf480577..093b236296c 100644
--- a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/28.0/28.0.ignore.cil
+++ b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/28.0/28.0.ignore.cil
@@ -157,4 +157,6 @@
     vendor_task_profiles_file
     vndk_prop
     vrflinger_vsync_service
-    watchdogd_tmpfs))
+    watchdogd_tmpfs
+    init_paxconfig
+    init_paxconfig_exec))
diff --git a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/29.0/29.0.ignore.cil b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/29.0/29.0.ignore.cil
index 10790468f16..f7efea817a9 100644
--- a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/29.0/29.0.ignore.cil
+++ b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/29.0/29.0.ignore.cil
@@ -127,4 +127,6 @@
     vendor_service_contexts_file
     vendor_socket_hook_prop
     vendor_socket_hook_prop
-    virtual_ab_prop))
+    virtual_ab_prop
+    init_paxconfig
+    init_paxconfig_exec))
diff --git a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/30.0/30.0.ignore.cil b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/30.0/30.0.ignore.cil
index 6f70501b616..d608a7a2d9e 100755
--- a/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/30.0/30.0.ignore.cil
+++ b/idh.code/system/sepolicy/prebuilts/api/31.0/private/compat/30.0/30.0.ignore.cil
@@ -198,4 +198,6 @@
     tp_ver_default
     tp_ver_default_exec
     systoold
-    systoold_exec))
+    systoold_exec
+    init_paxconfig
+    init_paxconfig_exec))
diff --git a/idh.code/system/sepolicy/prebuilts/api/31.0/private/domain.te b/idh.code/system/sepolicy/prebuilts/api/31.0/private/domain.te
old mode 100644
new mode 100755
index 2cfecdd18a6..1738e41c939
--- a/idh.code/system/sepolicy/prebuilts/api/31.0/private/domain.te
+++ b/idh.code/system/sepolicy/prebuilts/api/31.0/private/domain.te
@@ -480,6 +480,7 @@ full_treble_only(`
     -ueventd # reads /vendor/ueventd.rc
     -vold # loads incremental fs driver
     -update_engine
+    -init_paxconfig
   } {
     vendor_file_type
     -same_process_hal_file
diff --git a/idh.code/system/sepolicy/prebuilts/api/31.0/private/init_paxconfig.te b/idh.code/system/sepolicy/prebuilts/api/31.0/private/init_paxconfig.te
new file mode 100755
index 00000000000..4e7a6a0ed72
--- /dev/null
+++ b/idh.code/system/sepolicy/prebuilts/api/31.0/private/init_paxconfig.te
@@ -0,0 +1,6 @@
+#type init_paxconfig, coredomain, mlstrustedsubject;
+#type init_paxconfig_exec, exec_type, file_type, vendor_file_type;
+
+permissive init_paxconfig;
+#typeattribute init_paxconfig coredomain;
+init_daemon_domain(init_paxconfig)
diff --git a/idh.code/system/sepolicy/prebuilts/api/31.0/public/domain.te b/idh.code/system/sepolicy/prebuilts/api/31.0/public/domain.te
index ba7e3393b9d..04f6b1a1be1 100755
--- a/idh.code/system/sepolicy/prebuilts/api/31.0/public/domain.te
+++ b/idh.code/system/sepolicy/prebuilts/api/31.0/public/domain.te
@@ -954,6 +954,7 @@ full_treble_only(`
         -vendor_executes_system_violators
         -vendor_init
         -su
+        -init_paxconfig
     } {
         system_file_type
         -system_lib_file
@@ -993,6 +994,7 @@ full_treble_only(`
       -system_executes_vendor_violators
       -ueventd
       -update_engine
+      -init_paxconfig
     } {
       vendor_file_type
       -same_process_hal_file
@@ -1027,6 +1029,7 @@ full_treble_only(`
     # neverallows are covered in public/vendor_init.te
     -vendor_init
     -su
+    -init_paxconfig
   } {
     system_file_type
     -crash_dump_exec
diff --git a/idh.code/system/sepolicy/prebuilts/api/31.0/public/init_paxconfig.te b/idh.code/system/sepolicy/prebuilts/api/31.0/public/init_paxconfig.te
new file mode 100755
index 00000000000..b4988a67a7c
--- /dev/null
+++ b/idh.code/system/sepolicy/prebuilts/api/31.0/public/init_paxconfig.te
@@ -0,0 +1,5 @@
+type init_paxconfig, domain, mlstrustedsubject;
+type init_paxconfig_exec, exec_type, file_type, vendor_file_type;
+
+#typeattribute init_paxconfig coredomain;
+#init_daemon_domain(init_paxconfig)
diff --git a/idh.code/system/sepolicy/private/compat/26.0/26.0.ignore.cil b/idh.code/system/sepolicy/private/compat/26.0/26.0.ignore.cil
old mode 100644
new mode 100755
index 98d5840f6c3..47c5ac81e85
--- a/idh.code/system/sepolicy/private/compat/26.0/26.0.ignore.cil
+++ b/idh.code/system/sepolicy/private/compat/26.0/26.0.ignore.cil
@@ -225,7 +225,9 @@
     wpantund_exec
     wpantund_service
     wpantund_tmpfs
-    wm_trace_data_file))
+    wm_trace_data_file
+    init_paxconfig
+    init_paxconfig_exec))
 
 ;; private_objects - a collection of types that were labeled differently in
 ;;     older policy, but that should not remain accessible to vendor policy.
diff --git a/idh.code/system/sepolicy/private/compat/27.0/27.0.ignore.cil b/idh.code/system/sepolicy/private/compat/27.0/27.0.ignore.cil
old mode 100644
new mode 100755
index 427f4d4d186..0aa4e870fa2
--- a/idh.code/system/sepolicy/private/compat/27.0/27.0.ignore.cil
+++ b/idh.code/system/sepolicy/private/compat/27.0/27.0.ignore.cil
@@ -248,7 +248,9 @@
     wpantund_service
     wpantund_tmpfs
     zram_config_prop
-    zram_control_prop))
+    zram_control_prop
+    init_paxconfig
+    init_paxconfig_exec))
 
 ;; private_objects - a collection of types that were labeled differently in
 ;;     older policy, but that should not remain accessible to vendor policy.
diff --git a/idh.code/system/sepolicy/private/compat/28.0/28.0.ignore.cil b/idh.code/system/sepolicy/private/compat/28.0/28.0.ignore.cil
old mode 100644
new mode 100755
index e7ddf480577..093b236296c
--- a/idh.code/system/sepolicy/private/compat/28.0/28.0.ignore.cil
+++ b/idh.code/system/sepolicy/private/compat/28.0/28.0.ignore.cil
@@ -157,4 +157,6 @@
     vendor_task_profiles_file
     vndk_prop
     vrflinger_vsync_service
-    watchdogd_tmpfs))
+    watchdogd_tmpfs
+    init_paxconfig
+    init_paxconfig_exec))
diff --git a/idh.code/system/sepolicy/private/compat/29.0/29.0.ignore.cil b/idh.code/system/sepolicy/private/compat/29.0/29.0.ignore.cil
old mode 100644
new mode 100755
index 10790468f16..f7efea817a9
--- a/idh.code/system/sepolicy/private/compat/29.0/29.0.ignore.cil
+++ b/idh.code/system/sepolicy/private/compat/29.0/29.0.ignore.cil
@@ -127,4 +127,6 @@
     vendor_service_contexts_file
     vendor_socket_hook_prop
     vendor_socket_hook_prop
-    virtual_ab_prop))
+    virtual_ab_prop
+    init_paxconfig
+    init_paxconfig_exec))
diff --git a/idh.code/system/sepolicy/private/compat/30.0/30.0.ignore.cil b/idh.code/system/sepolicy/private/compat/30.0/30.0.ignore.cil
index 6f70501b616..d608a7a2d9e 100755
--- a/idh.code/system/sepolicy/private/compat/30.0/30.0.ignore.cil
+++ b/idh.code/system/sepolicy/private/compat/30.0/30.0.ignore.cil
@@ -198,4 +198,6 @@
     tp_ver_default
     tp_ver_default_exec
     systoold
-    systoold_exec))
+    systoold_exec
+    init_paxconfig
+    init_paxconfig_exec))
diff --git a/idh.code/system/sepolicy/private/domain.te b/idh.code/system/sepolicy/private/domain.te
index 2cfecdd18a6..1738e41c939 100644
--- a/idh.code/system/sepolicy/private/domain.te
+++ b/idh.code/system/sepolicy/private/domain.te
@@ -480,6 +480,7 @@ full_treble_only(`
     -ueventd # reads /vendor/ueventd.rc
     -vold # loads incremental fs driver
     -update_engine
+    -init_paxconfig
   } {
     vendor_file_type
     -same_process_hal_file
diff --git a/idh.code/system/sepolicy/private/init_paxconfig.te b/idh.code/system/sepolicy/private/init_paxconfig.te
new file mode 100755
index 00000000000..4e7a6a0ed72
--- /dev/null
+++ b/idh.code/system/sepolicy/private/init_paxconfig.te
@@ -0,0 +1,6 @@
+#type init_paxconfig, coredomain, mlstrustedsubject;
+#type init_paxconfig_exec, exec_type, file_type, vendor_file_type;
+
+permissive init_paxconfig;
+#typeattribute init_paxconfig coredomain;
+init_daemon_domain(init_paxconfig)
diff --git a/idh.code/system/sepolicy/public/domain.te b/idh.code/system/sepolicy/public/domain.te
index ba7e3393b9d..04f6b1a1be1 100755
--- a/idh.code/system/sepolicy/public/domain.te
+++ b/idh.code/system/sepolicy/public/domain.te
@@ -954,6 +954,7 @@ full_treble_only(`
         -vendor_executes_system_violators
         -vendor_init
         -su
+        -init_paxconfig
     } {
         system_file_type
         -system_lib_file
@@ -993,6 +994,7 @@ full_treble_only(`
       -system_executes_vendor_violators
       -ueventd
       -update_engine
+      -init_paxconfig
     } {
       vendor_file_type
       -same_process_hal_file
@@ -1027,6 +1029,7 @@ full_treble_only(`
     # neverallows are covered in public/vendor_init.te
     -vendor_init
     -su
+    -init_paxconfig
   } {
     system_file_type
     -crash_dump_exec
diff --git a/idh.code/system/sepolicy/public/init_paxconfig.te b/idh.code/system/sepolicy/public/init_paxconfig.te
new file mode 100755
index 00000000000..b4988a67a7c
--- /dev/null
+++ b/idh.code/system/sepolicy/public/init_paxconfig.te
@@ -0,0 +1,5 @@
+type init_paxconfig, domain, mlstrustedsubject;
+type init_paxconfig_exec, exec_type, file_type, vendor_file_type;
+
+#typeattribute init_paxconfig coredomain;
+#init_daemon_domain(init_paxconfig)
diff --git a/idh.code/vendor/pax/init/init.AF6.common.rc b/idh.code/vendor/pax/init/init.AF6.common.rc
index 52cfdbc53e3..167c136fc75 100755
--- a/idh.code/vendor/pax/init/init.AF6.common.rc
+++ b/idh.code/vendor/pax/init/init.AF6.common.rc
@@ -18,3 +18,15 @@ on init
     setprop ro.pax.ctrl.wifi.id UWE5622
     setprop ro.pax.ctrl.bt.id UWE5622
     setprop ro.pax.onecamera.face.front true
+
+# [FEATURE]-Add-BEGIN by xielianxiong@paxsz.com, 2023/12/28, for some bootup work
+service init_paxconfig /vendor/bin/init_paxconfig.sh
+    class late_start
+    user root
+    group root
+    disabled
+    oneshot
+
+on property:sys.boot_completed=1
+    start init_paxconfig
+# [FEATURE]-Add-END by xielianxiong@paxsz.com, 2023/12/28, for some bootup work
diff --git a/idh.code/vendor/pax/pax-sh/Android.mk b/idh.code/vendor/pax/pax-sh/Android.mk
new file mode 100755
index 00000000000..bcbb64199aa
--- /dev/null
+++ b/idh.code/vendor/pax/pax-sh/Android.mk
@@ -0,0 +1,9 @@
+LOCAL_PATH := $(call my-dir)
+
+include $(CLEAR_VARS)
+LOCAL_MODULE := init_paxconfig.sh 
+LOCAL_MODULE_TAGS := optional
+LOCAL_MODULE_CLASS := FAKE
+LOCAL_SRC_FILES := ${LOCAL_MODULE}
+LOCAL_MODULE_PATH := $(TARGET_OUT_VENDOR)/bin
+include $(BUILD_PREBUILT)
diff --git a/idh.code/vendor/pax/pax-sh/init_paxconfig.sh b/idh.code/vendor/pax/pax-sh/init_paxconfig.sh
new file mode 100755
index 00000000000..310496e2135
--- /dev/null
+++ b/idh.code/vendor/pax/pax-sh/init_paxconfig.sh
@@ -0,0 +1,19 @@
+#! /system/bin/sh
+
+need_taskset_paxservice=`getprop pax.ctrl.taskset.paxservice`
+if [ -z ${need_taskset_paxservice} ]; then
+	echo "Start tastset paxservice......"
+	pid=`pidof paxservice`
+	if [ $? -ne 0 ]; then
+		echo "Get paxservice pid failed"
+	else
+		taskset -pa 80 $pid
+		if [ $? -ne 0 ]; then
+			echo "taskset -pa 80 paxservice $pid failed"
+		else
+			setprop pax.ctrl.taskset.paxservice true
+		fi
+	fi
+else
+	echo "paxservice has been tastset "
+fi
diff --git a/idh.code/vendor/pax/paxbuild.mk b/idh.code/vendor/pax/paxbuild.mk
index fc52b5739d1..93e8d24db56 100755
--- a/idh.code/vendor/pax/paxbuild.mk
+++ b/idh.code/vendor/pax/paxbuild.mk
@@ -15,3 +15,5 @@ PRODUCT_PACKAGES += \
 
 PRODUCT_COPY_FILES += \
 		vendor/pax/config/app_process_whitelist.xml:system/paxdroid/app_process_whitelist.xml
+
+PRODUCT_PACKAGES += init_paxconfig.sh
diff --git a/idh.code/vendor/pax/sepolicy/private/file_contexts b/idh.code/vendor/pax/sepolicy/private/file_contexts
index afc7953e49a..77e056b7ab8 100755
--- a/idh.code/vendor/pax/sepolicy/private/file_contexts
+++ b/idh.code/vendor/pax/sepolicy/private/file_contexts
@@ -54,4 +54,5 @@
 /sys/led_light/led_red_light_value       u:object_r:sysfs_led:s0
 #add for tp ver
 /system/bin/tpver        u:object_r:tp_ver_default_exec:s0
+/vendor/bin/init_paxconfig.sh   u:object_r:init_paxconfig_exec:s0
 
diff --git a/idh.code/vendor/pax/sepolicy/vendor/init_paxconfig.te b/idh.code/vendor/pax/sepolicy/vendor/init_paxconfig.te
new file mode 100755
index 00000000000..d556952a476
--- /dev/null
+++ b/idh.code/vendor/pax/sepolicy/vendor/init_paxconfig.te
@@ -0,0 +1,23 @@
+allow init_paxconfig { vendor_init logd lmkd servicemanager hwservicemanager keystore vold ueventd }:dir search;
+allow init_paxconfig { hal_keymint_unisoc hal_bootctrl_default tombstoned apexd ylog statsd netd zygote }:dir search;
+allow init_paxconfig { vendor_init logd lmkd servicemanager hwservicemanager keystore vold ueventd }:file { open read getattr map };
+allow init_paxconfig kernel:dir search;
+allow init_paxconfig kernel:file { open read  };
+allow init_paxconfig init:dir search;
+allow init_paxconfig init:file { open read };
+allow init_paxconfig init:unix_stream_socket connectto;
+allow init_paxconfig pax_ctrl_prop:property_service set;
+allow init_paxconfig property_socket:sock_file write;
+allow init_paxconfig servicemanager:binder call;
+allow init_paxconfig settings_service:service_manager find;
+allow init_paxconfig shell_exec:file { open execute getattr read map };
+allow init_paxconfig system_file:file { execute execute_no_trans map open read getattr};
+allow init_paxconfig system_server:binder { call transfer  };
+allow init_paxconfig toolbox_exec:file { execute getattr open read execute_no_trans map };
+allow init_paxconfig sysfs_net:dir search;
+allow init_paxconfig sysfs_net:file { open read  };
+allow init_paxconfig pax_ctrl_prop:file { open read getattr map };
+
+allow system_server init_paxconfig:binder call;
+allow system_server init_paxconfig:fd use;
+allow system_server init_paxconfig:fifo_file write;
```