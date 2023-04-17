# fct adb使用不了

加入gms包后,使用了apex ro.apex.updatable=true 功能,导致高通 2290 平台,进入fct后,adb使用不了

# 原因

进入fct后,adbd没有加载

# 修改方法

## 关闭ro.apex.updatable

使用low_ram配置的/mainline_modules_low_ram,打开FLATTEN_APEX

```
--- a/QSSI.12/device/qcom/qssi/qssi.mk
+++ b/QSSI.12/device/qcom/qssi/qssi.mk
@@ -346,10 +346,10 @@ ifeq ($(strip $(BUILD_GMS)), true)
 endif
 
 # Add Google Mainline
-TARGET_FLATTEN_APEX := false
+TARGET_FLATTEN_APEX := true
 MAINLINE_INCLUDE_WIFI_MODULE := false
-PRODUCT_PROPERTY_OVERRIDES += ro.apex.updatable = true
-$(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules.mk)
+PRODUCT_PROPERTY_OVERRIDES += ro.apex.updatable = false
+$(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules_low_ram.mk)

--- a/UM.9.15/device/qcom/bengal/bengal.mk
+++ b/UM.9.15/device/qcom/bengal/bengal.mk
@@ -286,10 +286,10 @@ ifeq ($(strip $(BUILD_GMS)), true)
 endif
 
 # Add Google Mainline
-TARGET_FLATTEN_APEX := false
+TARGET_FLATTEN_APEX := true
 MAINLINE_INCLUDE_WIFI_MODULE := false
-PRODUCT_PROPERTY_OVERRIDES += ro.apex.updatable = true
-$(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules.mk)
+PRODUCT_PROPERTY_OVERRIDES += ro.apex.updatable = false
+$(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules_low_ram.mk)
 
 #----------------------------------------------------------------------
 # wlan specific
diff --git a/UM.9.15/device/qcom/qssi/qssi.mk b/UM.9.15/device/qcom/qssi/qssi.mk
index ebe508f20e0..de8b9622f69 100644
--- a/UM.9.15/device/qcom/qssi/qssi.mk
+++ b/UM.9.15/device/qcom/qssi/qssi.mk
@@ -285,10 +285,10 @@ ifeq ($(strip $(BUILD_GMS)), true)
 endif
 
 # Add Google Mainline
-TARGET_FLATTEN_APEX := false
+TARGET_FLATTEN_APEX := true
 MAINLINE_INCLUDE_WIFI_MODULE := false
-PRODUCT_PROPERTY_OVERRIDES += ro.apex.updatable = true
-$(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules.mk)
+PRODUCT_PROPERTY_OVERRIDES += ro.apex.updatable = false
+$(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules_low_ram.mk)
```

## 添加adbd

* 添加user版本,默认开启adb allow功能,文章1,

* QSSI.12/build/make/core/Makefile

```
 # Phony target to check PRODUCT_COPY_FILES copy pairs don't contain ELF files
-.PHONY: check-elf-prebuilt-product-copy-files
-check-elf-prebuilt-product-copy-files:
-
-check_elf_prebuilt_product_copy_files := true
-ifneq (,$(filter true,$(BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES)))
-check_elf_prebuilt_product_copy_files :=
-endif
-check_elf_prebuilt_product_copy_files_hint := \
-    found ELF prebuilt in PRODUCT_COPY_FILES, use cc_prebuilt_binary / cc_prebuilt_library_shared instead.
+#.PHONY: check-elf-prebuilt-product-copy-files
+#check-elf-prebuilt-product-copy-files:
+
+#check_elf_prebuilt_product_copy_files := true
+#ifneq (,$(filter true,$(BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES)))
+#check_elf_prebuilt_product_copy_files :=
+#endif
+#check_elf_prebuilt_product_copy_files_hint := \
+#    found ELF prebuilt in PRODUCT_COPY_FILES, use cc_prebuilt_binary / cc_prebuilt_library_shared instead.
```

* QSSI.12/device/qcom/qssi/qssi.mk

```
--- a/QSSI.12/device/qcom/qssi/qssi.mk
+++ b/QSSI.12/device/qcom/qssi/qssi.mk
@@ -313,3 +313,7 @@ $(call inherit-product-if-exists, vendor/partner_modules/build/mainline_modules.
 ###################################################################################
 $(call inherit-product-if-exists, vendor/qcom/defs/product-defs/system/*.mk)
 ###################################################################################
+# add by ming for fct to use adb
+PRODUCT_COPY_FILES += \
+    device/qcom/qssi/adbd/adbd:$(PRODUCT_OUT)/system/bin/adbd \
+    device/qcom/qssi/adbd/libadb_protos.so:$(PRODUCT_OUT)/system/lib64/libadb_protos.so
```

* 在 QSSI/device/qcom/qssi/adbd 放入编译好的 libadb_protos.so,adbd