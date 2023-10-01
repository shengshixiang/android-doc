# 概要

展锐8581e,Android 12编译报错

# 145服务器

* No module named Crypto.Signature

```
FAILED: out/target/product/uis8581e_5h10/vendor/firmware/faceid.elf
/bin/bash -c "(rm -f out/target/product/uis8581e_5h10/vendor/firmware/faceid.elf ) && (cp out/target/product/uis8581e_5h10/obj/EXECUTABLES/faceid.elf_intermediates/faceid.elf out/target/product/uis8581e_5h10/vendor/firmware/faceid.elf ) && (rm /ssd/fubc/uis8581e_1/idh.code/out/target/product/uis8581e_5h10/vendor/firmware/faceid.elf; source vendor/sprd/proprietories-source/sprdtrusty/vendor/sprd/modules/faceid/sign_ta.sh /ssd/fubc/uis8581e_1/idh.code/vendor/sprd/proprietories-source/packimage_scripts/signimage/dynamicTA/signta.py f4bc36e68ec246e2a82ef7cb6cdc6f72 /ssd/fubc/uis8581e_1/idh.code/bsp/tools/secureboot_key/config/dynamic_ta_privatekey.pem /ssd/fubc/uis8581e_1/idh.code/vendor/sprd/proprietories-source/sprdtrusty/vendor/sprd/modules/faceid/lite/ta/sp9863a/faceid.elf /ssd/fubc/uis8581e_1/idh.code/out/target/product/uis8581e_5h10/vendor/firmware/faceid.elf )"
Traceback (most recent call last):
  File "/ssd/fubc/uis8581e_1/idh.code/vendor/sprd/proprietories-source/packimage_scripts/signimage/dynamicTA/signta.py", line 133, in <module>
    main()
  File "/ssd/fubc/uis8581e_1/idh.code/vendor/sprd/proprietories-source/packimage_scripts/signimage/dynamicTA/signta.py", line 41, in main
    from Crypto.Signature import PKCS1_PSS
ImportError: No module named Crypto.Signature
```

* 解决方法

pip install pycrypto

# 164服务器

* 编译完super_gsi64.img,卡住,不会继续编译modem

```
lpmake I 09-12 11:33:26 47847 47847 builder.cpp:1093] [liblp]Partition system_ext_a will resize from 0 bytes to 341676032 bytes
lpmake I 09-12 11:33:26 47847 47847 builder.cpp:1093] [liblp]Partition vendor_a will resize from 0 bytes to 659451904 bytes
lpmake I 09-12 11:33:26 47847 47847 builder.cpp:1093] [liblp]Partition product_a will resize from 0 bytes to 147750912 bytes
lpmake I 09-12 11:33:26 47847 47847 builder.cpp:1093] [liblp]Partition vendor_dlkm_a will resize from 0 bytes to 18841600 bytes
2023-09-12 11:33:38 - build_super_image.py - INFO    : Done writing image out/target/product/uis8581e_5h10/super.img
2023-09-12 11:33:38 - sparse_img.py - INFO    : Total of 160999 4096-byte output blocks in 15 input chunks.
2023-09-12 11:33:38 - sparse_img.py - INFO    : Total of 4600 4096-byte output blocks in 7 input chunks.
2023-09-12 11:33:38 - common.py - INFO    :   Running: "/home/wenj/uis8581e-a12-project/idh.code/out/host/linux-x86/bin/lpmake --metadata-size 65536 --super-name super --metadata-slots 3 --virtual-ab --device super:2983198720 --group group_unisoc_a:2979004416 --group group_unisoc_b:2979004416 --partition system_a:readonly:1700737024:group_unisoc_a --image system_a=vendor/sprd/partner/aosp-images/gsi_arm64-user-system.img --partition system_b:readonly:0:group_unisoc_b --partition vendor_a:readonly:659451904:group_unisoc_a --image vendor_a=out/target/product/uis8581e_5h10/vendor.img --partition vendor_b:readonly:0:group_unisoc_b --partition vendor_dlkm_a:readonly:18841600:group_unisoc_a --image vendor_dlkm_a=out/target/product/uis8581e_5h10/vendor_dlkm.img --partition vendor_dlkm_b:readonly:0:group_unisoc_b --sparse --output out/target/product/uis8581e_5h10/super_gsi64.img"
2023-09-12 11:33:48 - common.py - INFO    : lpmake I 09-12 11:33:38 47848 47848 builder.cpp:1093] [liblp]Partition system_a will resize from 0 bytes to 1700737024 bytes
lpmake I 09-12 11:33:38 47848 47848 builder.cpp:1093] [liblp]Partition vendor_a will resize from 0 bytes to 659451904 bytes
lpmake I 09-12 11:33:38 47848 47848 builder.cpp:1093] [liblp]Partition vendor_dlkm_a will resize from 0 bytes to 18841600 bytes
Invalid sparse file format at header magic
2023-09-12 11:33:48 - build_super_image.py - INFO    : Done writing image out/target/product/uis8581e_5h10/super_gsi64.img
```

* idh.code/build/make/core/main.mk

sprdmodem

```
# The droidcore-unbundled target depends on the subset of targets necessary to
# perform a full system build (either unbundled or not).
.PHONY: droidcore-unbundled
droidcore-unbundled: $(filter $(HOST_OUT_ROOT)/%,$(modules_to_install)) \
    $(INSTALLED_SYSTEMIMAGE_TARGET) \
    $(INSTALLED_RAMDISK_TARGET) \
    $(INSTALLED_PGPT_TARGET) \
    $(INSTALLED_CHIPRAM_TARGET) \
    $(INSTALLED_UBOOT_TARGET) \
    $(INSTALLED_SML_TARGET) \
    $(INSTALLED_TEECFG_TARGET) \
    $(INSTALLED_FILES_FILE_RAMDISK) \
    $(INSTALLED_FILES_JSON_RAMDISK) \
    $(INSTALLED_FILES_FILE_DEBUG_RAMDISK) \
    $(INSTALLED_FILES_JSON_DEBUG_RAMDISK) \
    $(INSTALLED_FILES_FILE_VENDOR_RAMDISK) \
    $(INSTALLED_FILES_JSON_VENDOR_RAMDISK) \
    $(INSTALLED_FILES_FILE_VENDOR_DEBUG_RAMDISK) \
    $(INSTALLED_FILES_JSON_VENDOR_DEBUG_RAMDISK) \
    $(INSTALLED_FILES_FILE_ROOT) \
    $(INSTALLED_FILES_JSON_ROOT) \
    $(INSTALLED_FILES_FILE_RECOVERY) \
    $(INSTALLED_FILES_JSON_RECOVERY) \
    $(INSTALLED_ANDROID_INFO_TXT_TARGET) \
    soong_docs \
    sprdmodem

```

* 原因

一直卡着,是因为第一次链接远程服务器,输入填入yes或者或者ssh密钥没配,但是有没有提示输出到shell

所以一直卡着,最后变成僵尸进程

```
zhangwj@jcrj-bianyi03:~$ scp ./tesx.txt  liush@192.168.0.182:~/unisoc_sign/tesx.txt
The authenticity of host '192.168.0.182 (192.168.0.182)' can't be established.
ECDSA key fingerprint is SHA256:0MnCGhTTEwC2RcPcMGP9EK//mFpY/Sy0pOVIhzV95Oc.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.0.182' (ECDSA) to the list of known hosts.
liush@192.168.0.182's password: 
zhangwj@jcrj-bianyi03:~$ 
```