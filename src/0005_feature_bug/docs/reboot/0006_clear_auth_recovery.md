# 概要

没有电池的机器,展锐平台A12,清除调试态后,自动恢复出厂设置

# LOG

挂载data分区失败,进入recovery

`cryptfs mountFstab /dev/block/by-name/userdata /data Failed`
`init: Rebooting into recovery`

```
[    5.150322]c5 [  T351] vdc: Command: cryptfs mountFstab /dev/block/by-name/userdata /data Failed: Status(-8, EX_SERVICE_SPECIFIC): '0: '
[    5.161080]c7 [  T273] SENSOR_DRV: 273: sprd_sensor_parse_gpio_dt L 131: invalid gpio: i=4, gpio=-2, name=mipi-switch-mode-gpios
[    5.161087]c7 [  T273] SENSOR_DRV: 273: sprd_sensor_parse_gpio_dt L 131: invalid gpio: i=5, gpio=-2, name=switch-mode-gpios
[    5.161094]c7 [  T273] SENSOR_DRV: 273: sprd_sensor_parse_gpio_dt L 131: invalid gpio: i=6, gpio=-2, name=cam-id-gpios
[    5.184793]c7 [  T273] SENSOR_DRV: 273: sprd_sensor_parse_gpio_dt L 131: invalid gpio: i=7, gpio=-2, name=iovdd-gpios
[    5.184803]c7 [  T273] SENSOR_DRV: 273: sprd_sensor_parse_gpio_dt L 131: invalid gpio: i=8, gpio=-2, name=avdd-gpios
[    5.206519]c7 [  T273] SENSOR_DRV: 273: sprd_sensor_parse_gpio_dt L 131: invalid gpio: i=9, gpio=-2, name=dvdd-gpios
[    5.217269]c6 [    T1] init: vdc call failed with error code: 25
[    5.227543]c7 [  T273] SENSOR_DRV: 273: sprd_sensor_parse_gpio_dt L 131: invalid gpio: i=10, gpio=-2, name=mot-gpios
[    5.257100]c6 [    T1] init: Control message: Could not find 'aidl/android.system.keystore2.IKeystoreService/default' for ctl.interface_start from pid: 296 (/system/bin/servicemanager)
[    5.344207]c7 [  T273] cam_porting: 273 88 cam_syscon_get_args_by_name : fail to get syscon isp_ahb_reset 2, (____ptrval____)
[    5.344995]c5 [    T1] selinux: SELinux: Could not get canonical path for /data/misc/keystore restorecon: No such file or directory.
[    5.355468]c7 [  T273] cam_porting: 273 88 cam_syscon_get_args_by_name : fail to get syscon isp_vau_reset 2, (____ptrval____)
[    5.355477]c7 [  T273] cam_porting: 273 88 cam_syscon_get_args_by_name : fail to get syscon sys_h2p_db_soft_rst 2, (____ptrval____)
[    5.367297]c5 [    T1] selinux: 
[    5.489954]c5 [  T317] vold: keystore2 Communication with Keystore earlyBootEnded failed error: -129
[    5.510135]c6 [  T273] sprd_vsp 62200000.video-codec: Read Vsp Dts vsp-dev-eb-syscon regmap fail
[    5.530211]c6 [  T273] sprd-jpg 62300000.jpeg-codec: sprd_jpg probe with genpd
[    5.548893]c7 [  T367] apexd: Failed to migrate sessions to /metadata partition : Can't read /data/apex/sessions : No such file or directory
[    5.589118]c5 [    T1] selinux: SELinux: Could not get canonical path for /data/system/environ restorecon: No such file or directory.
[    5.601141]c5 [    T1] selinux: 
[    5.644925]c7 [  T273] sprd_cpu_cooling: sensor names not found
[    5.651018]c7 [  T273] sprd_cpu_cooling: sensor names not found
[    5.658644]c6 [  T367] apexd: Can't open /system_ext/apex for reading : No such file or directory
[    5.667653]c6 [  T367] apexd: Can't open /product/apex for reading : No such file or directory
[    5.676316]c6 [  T367] apexd: Can't open /vendor/apex for reading : No such file or directory
[    5.810827]c7 [  T273] ap watchdog sprd_wdt_fiq start: timeout = 40, pretimeout = 20
[    5.882286]c5 [  T273] [saudio] saudio: snd_saudio_probe: no sprd,ap_addr_to_cp in dt node
[    5.890662]c5 [  T273] [saudio] saudio: snd_saudio_probe: 0 in dt node
[    5.898316]c6 [  T273] [saudio] saudio: snd_saudio_probe: no sprd,ap_addr_to_cp in dt node
[    5.900335]c2 [  T437] sprd-sblock: sblock-5-13 not ready!
[    5.900338]c2 [  T437] [saudio] Error: sblock_receive dst 5, channel 13 result is -5
[    5.906499]c6 [  T273] [saudio] saudio: snd_saudio_probe: 0 in dt node
[    5.922834]c1 [  T447] sprd-sblock: sblock-5-17 not ready!
[    5.922837]c1 [  T447] [saudio] Error: sblock_receive dst 5, channel 17 result is -5
[    5.945988]c3 [  T317] cutils: Failed to mkdir(/data/misc/vold/user_keys): No such file or directory
[    5.955234]c6 [  T317] vold: Failed to prepare /data/misc/vold/user_keys: No such file or directory
[    5.964794]c5 [  T445] vdc: Command: cryptfs init_user0 Failed: Status(-8, EX_SERVICE_SPECIFIC): '0: '
[    5.974709]c7 [  T273] [ASoC:BOARD] warning: [asoc_sprd_card_probe] Get agcp ahb grp failed!(-19)
[    5.984032]c6 [    T1] init: Exec service failed, status 25: Rebooting into recovery, reason: init_user0_failed
[    5.984070]c7 [  T273] [ASoC:BOARD] ERR: asoc_sprd_card_sub_parse_of get dai name for 'cpu' failed!(-517)
[    6.006529]c7 [  T273] vbc-rxpx-codec-sc27xx sound@0: asoc_sprd_card_parse_of: Parsing dai link 0 failed(-517)!
[    6.016515]c7 [  T273] [ASoC:BOARD] ERR: vbc_rxpx_codec_sc27xx_probe, asoc_sprd_card_probe failed!
[    6.037424]c5 [   T38] [ASoC:BOARD] warning: [asoc_sprd_card_probe] Get agcp ahb grp failed!(-19)
[    6.046300]c5 [   T38] [ASoC:BOARD] ERR: asoc_sprd_card_sub_parse_of get dai name for 'cpu' failed!(-517)
[    6.055762]c5 [   T38] vbc-rxpx-codec-sc27xx sound@0: asoc_sprd_card_parse_of: Parsing dai link 0 failed(-517)!
[    6.055765]c5 [   T38] [ASoC:BOARD] ERR: vbc_rxpx_codec_sc27xx_probe, asoc_sprd_card_probe failed!
[    6.062235]c6 [    T1] init: Rebooting into recovery
```

# 分析

可能项目没有电池,所以data分区写入一半,就重启,导致data分区损坏

不论ext4,f2fs文件系统,在展锐A12,8581e平台上都是有这个问题

清除固件调试后,更容易复现

# 验证

使用带电池机器,清除调试态看下

使用带电池机器,没有复现到

# loglevel

把启动loglevel改成7,复现捉log

* idh.code/bsp/bootloader/u-boot15/common/loader/sprd_fdt_support.c

enable = 1,强行修改

```
--- a/idh.code/bsp/bootloader/u-boot15/common/loader/sprd_fdt_support.c
+++ b/idh.code/bsp/bootloader/u-boot15/common/loader/sprd_fdt_support.c
@@ -2218,14 +2218,14 @@ int fdt_fixup_loglevel(void *fdt)
                                }
                        }
 #else
-            if(enable){
-              printf("dbg loglevel \n");
-              /* ret = fdt_chosen_bootargs_replace(fdt, v_copy, "loglevel=5"); */
-            }else{
-              printf("no loglevel 0\n");
-              ret = fdt_chosen_bootargs_replace(fdt, v_copy, "loglevel=0");
-            }
-
+            if(enable){
+              printf("dbg loglevel 7,\n");
+              ret = fdt_chosen_bootargs_replace(fdt, v_copy, "loglevel=7");
+            }else{
+              printf("no loglevel 0,\n");
+              ret = fdt_chosen_bootargs_replace(fdt, v_copy, "loglevel=0");
+            }
+
             if (ret < 0)
               errorf("set logleve failed!\n");
 #endif
```

# LOG

ext4,loglevel=7后,还是提示data分区损坏直接原因是Keystore元数据解密失败,导致data分区挂载失败,添加log复现问题

` [   18.040754]c7 [  T305] vold: keystore2 Keystore createOperation returned service specific error: -33
-33是INVALID KEY BLOB，元数据解密失败，导致data分区挂载失败。`

```
[   17.827033]c7 [    T1] init: [libfs_mgr]Invalid ext4 superblock on '/dev/block/by-name/userdata'
[   17.966442]c4 [  T273] WCN BASE: wcn_dev->file_length:1048576
[   17.973837]c4 [  T273] WCN BASE: rmap[3]:ctrl_reg[0]=0x4,read=0x0, set=0x300000
[   17.975505]c7 [    T1] init: [libfs_mgr]mount_with_alternatives(): skipping mount due to invalid magic, mountpoint=/data blk_dev=/dev/block/mmcblk0p90 rec[7].fs_type=ext4
[   17.980899]c4 [  T273] WCN BASE: utemp_val 0x300000  val 0x0
[   18.001597]c7 [    T1] init: Calling: /system/bin/vdc cryptfs mountFstab /dev/block/by-name/userdata /data
[   18.003369]c4 [  T273] WCN BASE: rmap[3]:ctrl_reg[0] = 0x4, val=0x300000
[   18.012404]c6 [  T168] WCN SDIO: marlin_power_wq start
[   18.018542]c4 [  T273] WCN BASE: rmap[0]:ctrl_reg[1]=0x3198,read=0x0, set=0x102
[   18.025186]c6 [  T168] hbc:4056-marlin_power_wq.
[   18.025190]c6 [  T168] hbc:3499-marlin_set_power:val = 1.
[   18.025193]c6 [  T168] WCN SDIO: marlin power state:0, subsys: [WCN_AUTO] power 1
[   18.025197]c6 [  T168] WCN SDIO: the first power on start
[   18.027939]c7 [  T305] vold: fscrypt_mount_metadata_encrypted: /data encrypt: 0 format: 0 with null
[   18.030297]c4 [  T273] WCN BASE: utemp_val 0x102  val 0x0
[   18.037566]c6 [  T168] hbc:3292-chip_power_on:.
[   18.037570]c6 [  T168] hbc:2611-marlin_chipen_vdd12:enable = 1.
[   18.040754]c7 [  T305] vold: keystore2 Keystore createOperation returned service specific error: -33
[   18.041213]c5 [  T341] vdc: Command: cryptfs mountFstab /dev/block/by-name/userdata /data Failed: Status(-8, EX_SERVICE_SPECIFIC): '0: '
[   18.042230]c4 [  T273] WCN BASE: rmap[0]:ctrl_reg[1] = 0x3198, val=0x102
```

# keymaster

添加keymaster的log打印,看看log有没有问题

* idh.code/system/vold/Keymaster.cpp

```
--- a/idh.code/system/vold/Keymaster.cpp
+++ b/idh.code/system/vold/Keymaster.cpp
@@ -17,6 +17,7 @@
 #include "Keymaster.h"
 
 #include <android-base/logging.h>
+#include <android-base/stringprintf.h>
 
 #include <aidl/android/hardware/security/keymint/SecurityLevel.h>
 #include <aidl/android/security/maintenance/IKeystoreMaintenance.h>
@@ -37,6 +38,7 @@ static constexpr const size_t UPDATE_INPUT_MAX_SIZE = 32 * 1024;  // 32 KiB
 
 // Keep this in sync with system/sepolicy/private/keystore2_key_contexts
 static constexpr const int VOLD_NAMESPACE = 100;
+using android::base::StringPrintf;
 
 namespace android {
 namespace vold {
@@ -56,7 +58,7 @@ static bool logKeystore2ExceptionIfPresent(::ndk::ScopedAStatus& rc, const std::
 
     auto exception_code = rc.getExceptionCode();
     if (exception_code == EX_SERVICE_SPECIFIC) {
-        LOG(ERROR) << "keystore2 Keystore " << func_name
+        LOG(ERROR) << "victor,add 20231031,keystore2 Keystore " << func_name
                    << " returned service specific error: " << rc.getServiceSpecificError();
     } else {
         LOG(ERROR) << "keystore2 Communication with Keystore " << func_name
@@ -135,6 +137,8 @@ bool Keymaster::generateKey(const km::AuthorizationSet& inParams, std::string* k
             .blob = std::nullopt,
     };
     ks2::KeyMetadata keyMetadata;
+
+    LOG(ERROR) << "victor,add 20231031,Keymaster::generateKey begin " ;
     auto rc = securityLevel->generateKey(in_key, std::nullopt, inParams.vector_data(), 0, {},
                                          &keyMetadata);
 
@@ -144,7 +148,15 @@ bool Keymaster::generateKey(const km::AuthorizationSet& inParams, std::string* k
         LOG(ERROR) << "keystore2 generated key blob was null";
         return false;
     }
-    if (key) *key = std::string(keyMetadata.key.blob->begin(), keyMetadata.key.blob->end());
+    if (key) {
+        *key = std::string(keyMetadata.key.blob->begin(), keyMetadata.key.blob->end());
+        LOG(ERROR) << "victor,add 20231031,key->length  = " << key->length();
+        for(std::string::size_type i = 0; i < key->length(); i++) {
+            LOG(ERROR) << StringPrintf("victor,generateKey key[%lu]=0x%x,",i,key->at(i));
+        }
+    }else{
+        LOG(ERROR) << "victor,add 20231031,Keymaster::generateKey key = null" ;
+    }
 
     zeroize_vector(keyMetadata.key.blob.value());
     return true;
@@ -195,9 +207,15 @@ KeymasterOperation Keymaster::begin(const std::string& key, const km::Authorizat
             .alias = std::nullopt,
             .nspace = VOLD_NAMESPACE,
     };
+
+    LOG(ERROR) << "victor,add 20231031 Keymaster::begin in ,key.length = " << key.length();
     keyDesc.blob =
             std::optional<std::vector<uint8_t>>(std::vector<uint8_t>(key.begin(), key.end()));
 
+    for(std::string::size_type i = 0; i < key.length(); i++) {
+        LOG(ERROR) << StringPrintf("victor,add 20231031 ,Keymaster::begin key[%lu]=0x%x,",i,key.at(i));
+    }
     ks2::CreateOperationResponse cor;
     auto rc = securityLevel->createOperation(keyDesc, inParams.vector_data(), true, &cor);
     if (logKeystore2ExceptionIfPresent(rc, "createOperation")) {
```

# keymaster Log

添加keymaster log后,看起来跟key也没啥关系,因为key[213]=0x19都是对的


```
[   18.056475]c7 [  T307] vold: victor,add 20231031 ,Keymaster::begin key[211]=0xbc,
[   18.056485]c7 [  T307] vold: victor,add 20231031 ,Keymaster::begin key[212]=0x35,
[   18.056495]c7 [  T307] vold: victor,add 20231031 ,Keymaster::begin key[213]=0x19,
[   18.062180]c7 [  T307] vold: victor,add 20231031,keystore2 Keystore createOperation returned service specific error: -33
[   18.067548]c1 [  T159] WCN SDIO: : marlin_analog_power1v2_enable marlin 1V2 set COMPLETE
[   18.067548]c1 [  T159]  wcn_1v2 0
[   18.085379]c6 [  T341] vdc: Command: cryptfs mountFstab /dev/block/by-name/userdata /data Failed: Status(-8, EX_SERVICE_SPECIFIC): '0: '
[   18.090566]c5 [  T272] gnss_common_ctl gnss_common_ctl: gnss_common_ctl_probe V3.2 entry
[   18.098532]c7 [    T1] vdc: vdc terminated by exit(25)
[   18.103403]c6 [  T272] gnss_common_ctl gnss_common_ctl: gnss_common_ctl_probe multiple  ko


Line 3519: [   18.860575]c4 [  T314] vold: victor,add 20231031 ,Keymaster::begin key[213]=0x19,
	Line 5201: [   33.781343]c5 [  T314] vold: victor,add 20231031 ,Keymaster::begin key[213]=0x36,
	Line 6131: [   43.532185]c6 [  T314] vold: victor,add 20231031 ,Keymaster::begin key[213]=0xf1,
	Line 6583: [   46.548901]c6 [  T314] vold: victor,add 20231031 ,Keymaster::begin key[213]=0xed,
	Line 6810: [   48.232795]c6 [  T314] vold: victor,add 20231031 ,Keymaster::begin key[213]=0xed,
	Line 13135: [   18.196790]c6 [  T311] vold: victor,add 20231031 ,Keymaster::begin key[213]=0x19,
	Line 14167: [   23.876521]c6 [  T311] vold: victor,add 20231031 ,Keymaster::begin key[213]=0x36,
	Line 14952: [   34.296858]c6 [  T311] vold: victor,add 20231031 ,Keymaster::begin key[213]=0xed,
	Line 21941: [   18.056495]c7 [  T307] vold: victor,add 20231031 ,Keymaster::begin key[213]=0x19,
	Line 29194: [   23.134454]c7 [  T305] vold: victor,add 20231031 ,Keymaster::begin key[213]=0xfb,
	Line 30375: [   33.485311]c6 [  T305] vold: victor,add 20231031 ,Keymaster::begin key[213]=0xe9,
	Line 31281: [   37.147936]c5 [  T305] vold: victor,add 20231031 ,Keymaster::begin key[213]=0x9c,
	Line 31820: [   37.356179]c5 [  T305] vold: victor,add 20231031 ,Keymaster::begin key[213]=0x6a,
	Line 32156: [   42.821988]c7 [  T305] vold: victor,add 20231031 ,Keymaster::begin key[213]=0x6a,
```

# tos

在tos里面添加log,查看为什么`keystore2 Keystore createOperation returned service specific error: -33`

添加log的tos.bin是展锐提供,闭源

# metadata

刷机需要擦除metadata,不然一些key还是用上一版本的key

# 根本原因

机器locked状态改变后,重启,需要清除metadata,跟 userdata

因为metadata里面存了一些解密userdata的key, unlocked状态改变需要重新生成key

* 机器没有调试态, 机器从locked状态, 授权固件调试态,机器变成unlocked状态,这时候手动重启,或者掉电重启

* 机器从固件调试态,授权清除固件调试态,机器从unlocked状态,变成locked状态, 授权后自动重启

* fastboot erase metadata

* fastboot erase userdata