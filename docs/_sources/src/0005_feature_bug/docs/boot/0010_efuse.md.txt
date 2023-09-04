# 概要

高通2290 Android 12 有两个项目,一个项目用的是移远方案,64位,开启efuse成功

另外一个项目用的是广和通方案,32位,modem等版本都不一样,开fuse遇到一些问题

# rpmb key

熔丝会用熔丝的key去 provision the RPMB key

手动去写google key,也会去provision the RPMB key

所以如果先写googlekey ,那熔丝的 key就写不进去, 开机比对rpmb key失败,就会失败

# 开启fuse

烧录 sec.elf 到secdata分区,由于之前已经做好的签名,简单描述

先把签名的 套件改好后, 进入目录 QCM2290.LA.2.0/common/sectools, 

python sectools.py fuseblower -p agatti -g -d -a --sign

执行命令,生成sec.elf

然后使用fastboot flash secdata sec.elf 或者直接把 xml文件,secdata添加文件下载sec.elf

# 签名open ssl 修改

原理就是修改open ssl源码,把私钥加密部分,通过https 去服务器加密.签名文件,按照厂商给的sdk生成

替换证书,替换openssl,替换公司的加密算法

sectools -> openssl -> pmk -> pmk.py -> https

```
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/bin/LIN/openssl
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/bin/LIN/pmk
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/bin/LIN/pmk.py
M       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/config/agatti/agatti_fb_kp_secimage.xml
M       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/config/agatti/agatti_fuseblower_USER.xml
M       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/config/agatti/agatti_secimage.xml
M       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/gen_key_cert.sh
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/config.xml
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/make_keys.sh
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/oem_attestca.crt
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/oem_attestca.csr
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/oem_rootca.crt
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/opensslroot.cfg
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/paxopenssl1
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/paxopenssl3
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/public.pem
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/qpsa_attestca.cer
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/qpsa_attestca.key
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/qpsa_rootca.cer
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/qpsa_rootca.key
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/sha384rootcert.txt
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/v3.ext
A       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local/oem_certs/v3_attest.ext
M       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/sectools.py
M       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/sectools_builder.py
```

* QCM2290.LA.2.0/common/sectools/bin/LIN/pmk

```
--- /dev/null
+++ b/M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/bin/LIN/pmk
@@ -0,0 +1,10 @@
+#!/bin/bash
+set -e
+
+echo `dirname ${BASH_SOURCE[0]}`
+cd `dirname ${BASH_SOURCE[0]}`
+
+echo $@
+pmk.py $@
+
+cd -
```

* QCM2290.LA.2.0/common/sectools/bin/LIN/pmk.py

```
--- /dev/null
+++ b/M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/bin/LIN/pmk.py
@@ -0,0 +1,67 @@
+#!/usr/bin/env python2
+
+import json
+import binascii
+import subprocess
+import os
+import ssl
+import urllib
+import urllib2
+import sys
+
+if __name__ == '__main__':
+
+    if (len(sys.argv) == 3):
+        data_path = sys.argv[2]
+
+        if os.path.exists(data_path):
+
+            file = open(data_path,"rb")
+            data = file.read()
+            file.close()
+
+            outfile = data_path.split(".")[0] + "_SIG.bin"
+
+            file = open("/etc/pax_sign/sign.conf", "r")
+            file_content = file.read()
+            str = json.loads(file_content)
+            server_url = str['server_url']
+            cert_path = str['cert_path']
+            print("server_url: " + server_url)
+            print("cert_path: " + cert_path)
+
+            ascii_data = binascii.b2a_hex(data)
+
+            src_json_data = {'data' : ascii_data}
+            print(src_json_data)
+            src_json_data = urllib.urlencode(src_json_data)
+            print(src_json_data)
+
+            context = ssl.create_default_context()
+            context.check_hostname = False
+            context.verify_mode = ssl.CERT_NONE
+            context.load_cert_chain(cert_path)
+
+            opener = urllib2.build_opener(urllib2.HTTPSHandler(context=context))
+            response = opener.open(server_url, data = src_json_data.encode("utf-8"))
+            ret_json_data = json.loads(response.read().decode("utf-8"))
+            print(ret_json_data)
+
+            if ret_json_data['success'] is True:
+                print (ret_json_data['data'])
+                signed_data = binascii.a2b_hex(ret_json_data['data'])
+                # print (signed_data)
+
+                # file = open("client_encrypt.bin", "wb")
+                # file.write(signed_data)
+                # file.close()
+
+                file = open(outfile, "wb")
+                file.write(signed_data)
+                file.close()
+            else:
+                signed_data = None
+                print (ret_json_data['message'])
+                print ("data return error")
+                exit(-1)
+
```

* QCM2290.LA.2.0/common/sectools/config/agatti/agatti_fb_kp_secimage.xml

```
     <general_properties>
         <selected_signer>local_v2</selected_signer>
         <selected_encryptor></selected_encryptor>
-        <selected_cert_config>fibocom_OEM_KEYS_SC126</selected_cert_config>
+        <selected_cert_config>oem_certs</selected_cert_config>
         <cass_capability>secboot_sha2_pss_subca2</cass_capability>
         <!--
         The following CASS capability is also supported
@@ -63,14 +63,9 @@
         <num_certs_in_certchain>3</num_certs_in_certchain>
 
         <hmac>false</hmac>
-        <dsa_type>ecdsa</dsa_type>
-        <ecdsa_curve>secp384r1</ecdsa_curve>
-        <hash_algorithm>sha384</hash_algorithm>
-        <!-- agatti also supports RSA to use this uncomment this and comment dsa_type, ecdsa_curve and hash_algorithm
         <dsa_type>rsa</dsa_type>
         <rsa_padding>pss</rsa_padding>
         <hash_algorithm>sha256</hash_algorithm>
-        -->
         <segment_hash_algorithm>sha384</segment_hash_algorithm>
     </general_properties>
```

* QCM2290.LA.2.0/common/sectools/config/agatti/agatti_fuseblower_USER.xml

```
         <entry ignore="false">
             <description>SHA384 hash of the root certificate used for signing</description>
             <name>root_cert_sha384_hash0_file</name>
-            <value>./../../resources/data_prov_assets/Signing/Local/fibocom_OEM_KEYS_SC126/qpsa_rootca.cer</value>
+            <value>./../../resources/data_prov_assets/Signing/Local/oem_certs/qpsa_rootca.cer</value>
         </entry>
         <entry ignore="false">
             <description>PK Hash is in Fuse for SEC_BOOT1 : Apps</description>
```

* QCM2290.LA.2.0/common/sectools/config/agatti/agatti_secimage.xml

```
     <general_properties>
         <selected_signer>local_v2</selected_signer>
         <selected_encryptor>unified_encryption_2_0</selected_encryptor>
-        <selected_cert_config>fibocom_OEM_KEYS_SC126</selected_cert_config>
+        <selected_cert_config>oem_certs</selected_cert_config>
         <cass_capability>secboot_sha2_pss_subca2</cass_capability>
         <!--
         The following CASS capability is also supported
@@ -70,14 +70,9 @@
         <UIE_key>default</UIE_key>
         <uie_key_switch_enable>disable</uie_key_switch_enable>
         <hmac>false</hmac>
-        <dsa_type>ecdsa</dsa_type>
-        <ecdsa_curve>secp384r1</ecdsa_curve>
-        <hash_algorithm>sha384</hash_algorithm>
-        <!-- agatti also supports RSA. To configure this use:
         <dsa_type>rsa</dsa_type>
         <rsa_padding>pss</rsa_padding>
         <hash_algorithm>sha256</hash_algorithm>
-        -->
         <segment_hash_algorithm>sha384</segment_hash_algorithm>
     </general_properties>
```

* QCM2290.LA.2.0/common/sectools/gen_key_cert.sh

这个是生成证书脚本

```
 ROOT_DIR=`pwd`/../../../..
 
-OEM_KEYS=fibocom_OEM_KEYS_SC126
+OEM_KEYS=oem_certs
 
 CERT_DIR=$ROOT_DIR/qcm2290-iot-spf-2.0/QCM2290.LA.2.0/common/sectools/resources/data_prov_assets/Signing/Local
```

* QCM2290.LA.2.0/common/sectools/sectools.py b/M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/sectools.py

```
--- a/M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/sectools.py
+++ b/M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/sectools.py
@@ -29,6 +29,11 @@ from sectools import SECTOOLS_TOOL_NAME
 from sectools import SECTOOLS_TOOL_VERSION
 from sectools.common.utils.c_logging import logger
 
+SECTOOLS_DIR = os.path.dirname(os.path.realpath(__file__))
+os.environ['PATH'] = SECTOOLS_DIR + "/bin/LIN/:" + os.environ['PATH']
+print('PATH:')
+print(os.environ['PATH'])
+
 
 # List of features
 FEATURES_LIST = []
```

* QCM2290.LA.2.0/common/sectools/sectools_builder.py

```
 sys.path.append(SECTOOLS_DIR)
 sys.path.insert(1, os.path.join(SECTOOLS_DIR, 'ext'))
 
+os.environ['PATH'] = SECTOOLS_DIR + "/bin/LIN/:" + os.environ['PATH']
+print('PATH:')
+print(os.environ['PATH'])
+
 from sectools.common.utils import c_path
 from sectools.common.utils.c_base import CoreOptionParser
```

# 替换sdk文件

因为sdk很多都没有开源,所以需要把供应商给的底包文件,替换sdk文件,

prog_firehose_ddr.elf,rpm.mbn,tz.mbn,hyp.mbn,devcfg.mbn,km41.mbn,uefi_sec.mbn,

storsec.mbn,featenabler.mbn,rtic.mbn,adsp.mbn,wlanmdsp.mbn,venus.mbn,qupv3fw.elf

很多文件时一样的,这次只有几支文件不一样

```
M       M9200_Unpacking_Tool/BOOT.XF.4.1/boot_images/QcomPkg/SocPkg/AgattiPkg/Bin/LAA/RELEASE/prog_firehose_ddr.elf
D       M9200_Unpacking_Tool/QCM2290.LA.2.0/common/sectools/resources/build/fileversion2/sec.elf
M       M9200_Unpacking_Tool/RPM.BF.1.10/rpm_proc/build/ms/bin/agatti/sdm_ddr4/rpm.mbn
M       M9200_Unpacking_Tool/TZ.XF.5.1/trustzone_images/build/ms/bin/FAYAANAA/devcfg.mbn
```

# 签名modem

cd QCM2290.LA.2.0/common/sectools

./sign_images.sh

可以把脚本,写道自己的编译脚本里面

```
@@ -309,6 +264,19 @@ function build_modem()
 {
        select_modem_version
        copy_unpack_tool
+
+ # TODO: sign images
+    sectoolPath=${UNPACK_TOOL_DEST_DIR}/QCM2290.LA.2.0/common/sectools
+    if [ -d "${sectoolPath}" ]; then
+        echo "sectools dir exit"
+
+        pushd ${sectoolPath}
+        ./sign_images.sh
+        popd
+    else
+        echo "sectools dir not exit"
+    fi
+
        pushd $UNPACK_TOOL_DEST_DIR
        cd QCM2290.LA.2.0/common/build
        python build.py --imf
```

# 拷贝相关文件到下载目录

* cp -f Unpacking_Tool_FIBO/BOOT.XF.4.1/boot_images/QcomPkg/SocPkg/AgattiPkg/Bin/LAA/RELEASE/prog_firehose_ddr.elf ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/RPM.BF.1.10/rpm_proc/build/ms/bin/agatti/sdm_ddr4/rpm.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/TZ.XF.5.1/trustzone_images/build/ms/bin/FAYAANAA/tz.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/TZ.XF.5.1/trustzone_images/build/ms/bin/FAYAANAA/hyp.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/TZ.XF.5.1/trustzone_images/build/ms/bin/FAYAANAA/devcfg.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/TZ.APPS.2.0/qtee_tas/build/ms/bin/FAYAANAA/km41.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/TZ.APPS.2.0/qtee_tas/build/ms/bin/FAYAANAA/uefi_sec.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/TZ.APPS.2.0/qtee_tas/build/ms/bin/FAYAANAA/storsec.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/TZ.APPS.2.0/qtee_tas/build/ms/bin/FAYAANAA/featenabler.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/TZ.APPS.2.0/qtee_tas/build/ms/bin/FAYAANAA/rtic.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/ADSP.VT.5.4.1/adsp_proc/obj/qdsp6v5_ReleaseG/agatti.adsp.prod/adsp.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/WLAN.HL.3.3.7/wlan_proc/build/ms/bin/QCAHLAWPDLIOT/signed/wlanmdsp.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/WLAN.HL.3.3.7/wlan_proc/build/ms/bin/QCAHLAWPDLIOT/signed/wlanmdsp.mbn ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/QCM2290.LA.2.0/common/core_qupv3fw/agatti/qupv3fw.elf ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/QCM2290.LA.2.0/common/build/emmc/bin/asic/NON-HLOS.bin ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/QCM2290.LA.2.0/common/build/bin/dspso.bin ./QSSI.12/vendor/paxsz/PayDroid/M9200/
* cp -f Unpacking_Tool_FIBO/QCM2290.LA.2.0/common/build/bin/multi_image.mbn ./M9200_emmc_download_images/

# 修改xml

* QSSI.12/vendor/paxsz/PayDroid/M9200/rawprogram0_update_unsparse_m9200.xml

添加下载对应的分区,tz.mbn,rpm.mbn,hyp.mbn,km41.mbn,NON-HLOS.bin,dspso.bin,uefi_sec.mbn,featenabler.mbn,qupv3fw.elf,storsec.mbn,multi_image.mbn

# 拷贝sensor

* rm -f UM.9.15/vendor/qcom/proprietary/prebuilt_HY11/target/product/bengal_32go/vendor/firmware/adsp*
* cp -f Unpacking_Tool_FIBO/QCM2290.LA.2.0/common/build/emmc/bin/asic/pil_split_bins/adsp* UM.9.15/vendor/qcom/proprietary/prebuilt_HY11/target/product/bengal_32go/vendor/firmware/

# 查看是否烧录efuse

* fastboot getvar secure

# 遇到问题

* 不下载问题

log如下. 该问题是验不过,忘记调用签名逻辑

```
2023-07-10 16:47:32.576    Program Path:W:\ssdCode\m9200\M9200_emmc_download_images\prog_firehose_ddr.elf
2023-07-10 16:47:32.577    ***** Working Folder:C:\Users\xielianxiong\AppData\Roaming\Qualcomm\QFIL\COMPORT_19
2023-07-10 16:49:03.086    Binary build date: Jun 25 2019 @ 03:16:15
2023-07-10 16:49:03.087    QSAHARASERVER CALLED LIKE THIS: 'C:\Program Files (x86)\Qualcomm\QPST\bin\QSaharaServer.ex'Current working dir: C:\Users\xielianxiong\AppData\Roaming\Qualcomm\QFIL\COMPORT_19
2023-07-10 16:49:03.088    Sahara mappings:
2023-07-10 16:49:03.089    2: amss.mbn
2023-07-10 16:49:03.090    6: apps.mbn
2023-07-10 16:49:03.090    8: dsp1.mbn
2023-07-10 16:49:03.091    10: dbl.mbn
2023-07-10 16:49:03.092    11: osbl.mbn
2023-07-10 16:49:03.092    12: dsp2.mbn
2023-07-10 16:49:03.092    16: efs1.mbn
2023-07-10 16:49:03.093    17: efs2.mbn
2023-07-10 16:49:03.093    20: efs3.mbn
2023-07-10 16:49:03.094    21: sbl1.mbn
2023-07-10 16:49:03.094    22: sbl2.mbn
2023-07-10 16:49:03.095    23: rpm.mbn
2023-07-10 16:49:03.095    25: tz.mbn
2023-07-10 16:49:03.096    28: dsp3.mbn
2023-07-10 16:49:03.096    29: acdb.mbn
2023-07-10 16:49:03.097    30: wdt.mbn
2023-07-10 16:49:03.097    31: mba.mbn
2023-07-10 16:49:03.098    13: W:\ssdCode\m9200\M9200_emmc_download_images\prog_firehose_ddr.elf
2023-07-10 16:49:03.098    
2023-07-10 16:49:03.099    16:47:32: Requested ID 13, file: "W:\ssdCode\m9200\M9200_emmc_download_images\prog_firehose_ddr.elf"
2023-07-10 16:49:03.099    
2023-07-10 16:49:03.100    16:49:03: ERROR: function: sahara_rx_data:276 Unable to read packet header. Only read 0 bytes.
```

* 找不到tz问题

```
RPM Image Loaded，Start
Mem dump cmd, entry
Mem dump cmd,exit
Error code 26000112 at boot_elf_loader.c Line 1502
```

对应代码,

BOOT.XF.4.1/boot_images/QcomPkg/XBLLoader/boot_extern_sec_img_interface.c

```
smc_status = boot_fastcall_tz(TZ_PIL_SEC_IMG_VALIDATE_ELF_ID,
210                                   TZ_PIL_SEC_IMG_VALIDATE_ELF_ID_PARAM_ID,
211                                   format,
212                                   (uint32) elf_hdr,
213                                   elf_hdr_size,
214                                   0,
215                                   &result);
```

原因,就是格式化下载,但是xml没有烧录tz.mbn,所以flash里面根本没有tz镜像

* 调用abl失败问题

xbl成功运行,但是abl没有被call,卡死在xbl结尾

原因是,之前RPM 验签失败,把RPM img配置成 AUTH=FLASE了

看起来是RPM 掉用 abl

最后,在sbl1_config.c, 把RPM 还远成 AUTH=TRUE就可以了

# 流程

因为fuse跟xbl强相关,所以稍微整理一下xbl的流程

* sbl1_mc.c -> sbl1_main_ctl

```
boot_config_process_bl(&bl_shared_data, SBL1_IMG, sbl1_config_table);
```

* boot_config.c -> boot_config_process_bl

```
boot_config_process_entry(bl_shared_data,curr_entry);
```

```
boot_config_process_entry(bl_shared_data_type * bl_shared_data,
                          boot_configuration_table_entry * boot_config_entry)
{
  /*------------------------------------------------------------------
   Local Variables 
  ------------------------------------------------------------------*/
  mi_boot_image_header_type qc_image_header;
  uint32 config_start_time=0;
  sec_img_auth_error_type populate_sbl_info;
  bl_error_boot_type sec_img_auth_error_status = BL_ERR_IMG_SECURITY_FAIL;
  boot_images_entry * qsee_interface_image_entry = NULL;
  uint32 bytes_read = 0;
  sec_img_auth_elf_info_type sbl_elf_info;
  sec_img_auth_whitelist_area_param_t sbl_white_list_param;
  
  /*------------------------------------------------------------------
   Perform Pre-Procedures 
  ------------------------------------------------------------------*/
  BL_VERIFY(boot_config_entry != NULL, BL_ERR_NULL_PTR_PASSED|BL_ERROR_GROUP_BOOT );

  boot_do_procedures(bl_shared_data, boot_config_entry->pre_procs);

  /*------------------------------------------------------------------
   Preliminary check if loading should be canceled 
  ------------------------------------------------------------------*/
  if(boot_config_entry->boot_load_cancel != NULL)
  {
    if( boot_config_entry->boot_load_cancel(bl_shared_data) == TRUE )
    {
      boot_config_entry->load = FALSE;
    }
  }
  
```

* sbl1_config.c

```
boot_configuration_table_entry sbl1_config_table[] = 
{
/* host_img_id host_img_type target_img_id target_img_type target_img_sec_type        load   auth   exec   jump   exec_func jump_func   pre_procs       post_procs         load_cancel              target_img_partition_id         target_img_str            boot_ssa_enabled enable_xpu xpu_proc_id sbl_qsee_interface_index seg_elf_entry_point whitelist_ptr */
  {SBL1_IMG, CONFIG_IMG_QC, GEN_IMG, CONFIG_IMG_ELF,     SECBOOT_APDP_SW_TYPE,        TRUE,  TRUE,  FALSE, FALSE, NULL, NULL,           apdp_pre_procs, apdp_post_procs,   apdp_load_cancel,        apdp_partition_id,              APDP_BOOT_LOG_STR,        FALSE, FALSE, 0x0, 0x0, 0x0,                    apdp_img_whitelist    },
  {SBL1_IMG, CONFIG_IMG_QC, GEN_IMG, CONFIG_IMG_ELF,     SECBOOT_OEM_MISC_SW_TYPE,    TRUE,  TRUE,  FALSE, FALSE, NULL, NULL,           NULL,           NULL,              oem_misc_load_cancel,    multi_image_partition_id,       OEM_MISC_BOOT_LOG_STR,    FALSE, FALSE, 0x0, 0x0, 0x0,                    oem_misc_img_whitelist},
  {SBL1_IMG, CONFIG_IMG_QC, GEN_IMG, CONFIG_IMG_ELF,     SECBOOT_QTI_MISC_SW_TYPE,    TRUE,  TRUE,  FALSE, FALSE, NULL, NULL,           NULL,           NULL,              qti_misc_load_cancel,    multi_image_qti_partition_id,   QTI_MISC_BOOT_LOG_STR,    FALSE, FALSE, 0x0, 0x0, 0x0,                    qti_misc_img_whitelist},
  {SBL1_IMG, CONFIG_IMG_QC, GEN_IMG, CONFIG_IMG_ELF,     SECBOOT_RPM_FW_SW_TYPE,      TRUE,  TRUE,  FALSE, FALSE, NULL, NULL,           rpm_pre_procs,  NULL,              rpm_load_cancel,         rpm_partition_id,               RPM_BOOT_LOG_STR,         FALSE, FALSE, 0x0, 0x0, 0x0,                    rpm_img_whitelist     },
  {SBL1_IMG, CONFIG_IMG_QC, GEN_IMG, CONFIG_IMG_ELF,     SECBOOT_QSEE_DEVCFG_SW_TYPE, TRUE,  TRUE,  FALSE, FALSE, NULL, NULL,           NULL,           NULL,              qsee_devcfg_load_cancel, qsee_devcfg_image_partition_id, QSEE_DEVCFG_BOOT_LOG_STR, FALSE, FALSE, 0x0, 0x0, 0x0,                    devcfg_img_whitelist  },
  {SBL1_IMG, CONFIG_IMG_QC, GEN_IMG, CONFIG_IMG_ELF,     SECBOOT_QSEE_SW_TYPE,        TRUE,  TRUE,  FALSE, FALSE, NULL, NULL,           NULL,           qsee_post_procs,   NULL,                    qsee_partition_id,              QSEE_BOOT_LOG_STR,        FALSE, FALSE, 0x0, 0x0, 0x0,                    qsee_img_whitelist    },
  {SBL1_IMG, CONFIG_IMG_QC, GEN_IMG, CONFIG_IMG_ELF,     SECBOOT_SEC_SW_TYPE,         TRUE,  TRUE,  FALSE, FALSE, NULL, NULL,           NULL,           NULL,              sec_load_cancel,         secdata_partition_id,           SEC_BOOT_LOG_STR,         FALSE, FALSE, 0x0, 0x0, 0x0,                    sec_img_whitelist     },
  {SBL1_IMG, CONFIG_IMG_QC, GEN_IMG, CONFIG_IMG_ELF,     SECBOOT_QHEE_SW_TYPE,        TRUE,  TRUE,  FALSE, FALSE, NULL, NULL,           NULL,           NULL,              NULL,                    qhee_partition_id,              QHEE_BOOT_LOG_STR,        FALSE, FALSE, 0x0, 0x0, 0x0,                    qhee_img_whitelist    },
  {SBL1_IMG, CONFIG_IMG_QC, GEN_IMG, CONFIG_IMG_ELF,     SECBOOT_WDT_SW_TYPE,         TRUE,  TRUE,  FALSE, TRUE,  NULL, sti_jump_func,  NULL,           NULL,              sti_load_cancel,         sti_partition_id,               STI_BOOT_LOG_STR,         FALSE, FALSE, 0x0, 0x0, 0x0,                    sti_img_whitelist     },
  {SBL1_IMG, CONFIG_IMG_QC, GEN_IMG, CONFIG_IMG_ELF,     SECBOOT_APPSBL_SW_TYPE,      TRUE,  TRUE,  FALSE, TRUE,  NULL, qsee_jump_func, NULL,           appsbl_post_procs, appsbl_load_cancel,      appsbl_partition_id,            APPSBL_BOOT_LOG_STR,      FALSE, FALSE, 0x0, 0x0, SCL_XBL_CORE_CODE_BASE, xbl_core_img_whitelist},
  {NONE_IMG, }
};
```

* boot_mc.c -> boot_do_procedures

```
void boot_do_procedures
(
  bl_shared_data_type *bl_shared_data,
  boot_function_table_type *procs
)
{
  boot_function_table_type *cur_proc;
  uint32 func_start_time=0;
  char func_name[BOOT_FUNCTION_LEN];

  BL_VERIFY( bl_shared_data != NULL, BL_ERR_NULL_PTR_PASSED|BL_ERROR_GROUP_BOOT );

  if (procs != NULL)
  {
    for ( cur_proc = procs; (boot_procedure_func_type)cur_proc->func != NULL; cur_proc++ )
    {
      func_start_time = boot_log_get_time();
      ((boot_procedure_func_type)cur_proc->func)( bl_shared_data );
      qsnprintf(func_name, BOOT_FUNCTION_LEN ,"%s", cur_proc->func_name);
      boot_log_delta_time(func_start_time,func_name);
    }
  }
} /* boot_do_procedures() */
```

* sbl1_config.c

```
boot_function_table_type apdp_pre_procs[] = 
{
  /* Initialize the flash device */
  {boot_flash_init, "boot_flash_init"},
  
  /* Initialize XBL config Lib */
  {sbl1_xblconfig_init, "sbl1_xblconfig_init"},
  
  /*Initialize feature configuration from xbl config image*/
  {sbl1_feature_config_init,"sbl1_feature_config_init"},
  
  /* Initialize the default CDT before reading CDT from flash */
  {boot_config_data_table_default_init, "boot_config_data_table_default_init"}, 

  /* Set default DDR params */
  {sbl1_ddr_set_default_params, "sbl1_ddr_set_default_params"},
  
  /* Copy the configure data table from flash */
  {boot_config_data_table_init, "boot_config_data_table_init"},
  
  /* Store platform id */
  {sbl1_hw_platform_pre_ddr, "sbl1_hw_platform_pre_ddr"},
  
  /* Initialize PMIC and railway driver */
  {sbl1_hw_pre_ddr_init, "sbl1_hw_pre_ddr_init"},

  /* Check if forced dload timeout reset cookie is set */
  {boot_dload_handle_forced_dload_timeout, "boot_dload_handle_forced_dload_timeout"},

  /* Configure ddr parameters based on eeprom CDT table data. */
  {sbl1_ddr_set_params, "sbl1_ddr_set_params"},

  /* Initialize DDR */
  {sbl1_ddr_init, "sbl1_ddr_init"},

  /* Train DDR if applicable */
  {sbl1_do_ddr_training, "sbl1_do_ddr_training"},

  /*----------------------------------------------------------------------
   Run deviceprogrammer if compiling the deviceprogrammer_ddr image.
   In XBL builds the function below is stubbed out (does nothing)
  ----------------------------------------------------------------------*/
  {sbl1_hand_control_to_devprog_ddr_or_ddi, "sbl1_hand_control_to_devprog_ddr_or_ddi"},

#ifndef FEATURE_DEVICEPROGRAMMER_IMAGE

  /* Initialize SBL1 DDR ZI region, relocate boot log to DDR */
  {sbl1_post_ddr_init, "sbl1_post_ddr_init"},

  {sbl1_hw_init_secondary, "sbl1_hw_init_secondary"},

#endif /*FEATURE_DEVICEPROGRAMMER_IMAGE*/

  /* Last entry in the table. */
  NULL
};

```