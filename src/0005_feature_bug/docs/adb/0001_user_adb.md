# user版本,默认allow adb使用

有些定制化需求,可能需要user版本,不需要弹窗,直接可以使用adb

# 修改方法

```
diff --git a/QSSI.12/build/make/core/main.mk b/QSSI.12/build/make/core/main.mk
index f6c69c336de..9836ec68dda 100755
--- a/QSSI.12/build/make/core/main.mk
+++ b/QSSI.12/build/make/core/main.mk
@@ -372,11 +372,11 @@ enable_target_debugging := true
 tags_to_install :=
 ifneq (,$(user_variant))
   # Target is secure in user builds.
-  ADDITIONAL_SYSTEM_PROPERTIES += ro.secure=1
+  ADDITIONAL_SYSTEM_PROPERTIES += ro.secure=0
   ADDITIONAL_SYSTEM_PROPERTIES += security.perf_harden=1
 
   ifeq ($(user_variant),user)
-    ADDITIONAL_SYSTEM_PROPERTIES += ro.adb.secure=1
+    ADDITIONAL_SYSTEM_PROPERTIES += ro.adb.secure=0
   endif
 
   ifeq ($(user_variant),userdebug)
@@ -384,7 +384,7 @@ ifneq (,$(user_variant))
     tags_to_install += debug
   else
     # Disable debugging in plain user builds.
-    enable_target_debugging :=
+    #enable_target_debugging :=
   endif
 
   # Disallow mock locations by default for user builds
@@ -406,7 +406,7 @@ ifeq (true,$(strip $(enable_target_debugging)))
   ADDITIONAL_SYSTEM_PROPERTIES += dalvik.vm.lockprof.threshold=500
 else # !enable_target_debugging
   # Target is less debuggable and adbd is off by default
-  ADDITIONAL_SYSTEM_PROPERTIES += ro.debuggable=0
+  ADDITIONAL_SYSTEM_PROPERTIES += ro.debuggable=1
 endif # !enable_target_debugging
 
 ## eng ##
diff --git a/QSSI.12/device/qcom/qssi/base.mk b/QSSI.12/device/qcom/qssi/base.mk
index 51be605385d..3f43c9a2429 100755
--- a/QSSI.12/device/qcom/qssi/base.mk
+++ b/QSSI.12/device/qcom/qssi/base.mk
@@ -850,7 +850,7 @@ endif
 
 ifeq ($(TARGET_BUILD_VARIANT),user)
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
-    ro.adb.secure=1
+    ro.adb.secure=0
 endif
 
 # OEM Unlock reporting
diff --git a/QSSI.12/device/qcom/qssi_32/base.mk b/QSSI.12/device/qcom/qssi_32/base.mk
index 9bd9019a721..de6daa39ef4 100755
--- a/QSSI.12/device/qcom/qssi_32/base.mk
+++ b/QSSI.12/device/qcom/qssi_32/base.mk
@@ -948,7 +948,7 @@ endif
 
 ifeq ($(TARGET_BUILD_VARIANT),user)
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
-    ro.adb.secure=1
+    ro.adb.secure=0
 endif
 
 # OEM Unlock reporting
diff --git a/QSSI.12/device/qcom/qssi_32go/base.mk b/QSSI.12/device/qcom/qssi_32go/base.mk
index 60ba9192f67..2f0ee22f855 100755
--- a/QSSI.12/device/qcom/qssi_32go/base.mk
+++ b/QSSI.12/device/qcom/qssi_32go/base.mk
@@ -941,7 +941,7 @@ endif
 
 ifeq ($(TARGET_BUILD_VARIANT),user)
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
-    ro.adb.secure=1
+    ro.adb.secure=0
 endif
 
 # OEM Unlock reporting
diff --git a/UM.9.15/build/make/core/main.mk b/UM.9.15/build/make/core/main.mk
index 3bfd8326ed0..00eac37ba42 100644
--- a/UM.9.15/build/make/core/main.mk
+++ b/UM.9.15/build/make/core/main.mk
@@ -263,11 +263,11 @@ enable_target_debugging := true
 tags_to_install :=
 ifneq (,$(user_variant))
   # Target is secure in user builds.
-  ADDITIONAL_DEFAULT_PROPERTIES += ro.secure=1
+  ADDITIONAL_DEFAULT_PROPERTIES += ro.secure=0
   ADDITIONAL_DEFAULT_PROPERTIES += security.perf_harden=1
 
   ifeq ($(user_variant),user)
-    ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=1
+    ADDITIONAL_DEFAULT_PROPERTIES += ro.adb.secure=0
   endif
 
   ifeq ($(user_variant),userdebug)
@@ -275,7 +275,7 @@ ifneq (,$(user_variant))
     tags_to_install += debug
   else
     # Disable debugging in plain user builds.
-    enable_target_debugging :=
+    #enable_target_debugging :=
   endif
 
   # Disallow mock locations by default for user builds
@@ -297,7 +297,7 @@ ifeq (true,$(strip $(enable_target_debugging)))
   ADDITIONAL_BUILD_PROPERTIES += dalvik.vm.lockprof.threshold=500
 else # !enable_target_debugging
   # Target is less debuggable and adbd is off by default
-  ADDITIONAL_DEFAULT_PROPERTIES += ro.debuggable=0
+  ADDITIONAL_DEFAULT_PROPERTIES += ro.debuggable=1
 endif # !enable_target_debugging
 
 ## eng ##
diff --git a/UM.9.15/device/qcom/common/base.mk b/UM.9.15/device/qcom/common/base.mk
index 403e76d0468..33b37af1a5d 100644
--- a/UM.9.15/device/qcom/common/base.mk
+++ b/UM.9.15/device/qcom/common/base.mk
@@ -1185,7 +1185,7 @@ endif
 
 ifeq ($(TARGET_BUILD_VARIANT),user)
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
-    ro.adb.secure=1
+    ro.adb.secure=0
 endif
 
 # OEM Unlock reporting
diff --git a/UM.9.15/device/qcom/common/minimal_config.mk b/UM.9.15/device/qcom/common/minimal_config.mk
index cbcb2c50a36..fb0cccf194b 100644
--- a/UM.9.15/device/qcom/common/minimal_config.mk
+++ b/UM.9.15/device/qcom/common/minimal_config.mk
@@ -123,7 +123,7 @@ SKIP_BOOT_JARS_CHECK := true
 
 ifeq ($(TARGET_BUILD_VARIANT),user)
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
-    ro.adb.secure=1
+    ro.adb.secure=0
 endif
 
 # OEM Unlock reporting
diff --git a/UM.9.15/device/qcom/vendor-common/base.mk b/UM.9.15/device/qcom/vendor-common/base.mk
index 521ee5ef954..3cfefdeadb2 100644
--- a/UM.9.15/device/qcom/vendor-common/base.mk
+++ b/UM.9.15/device/qcom/vendor-common/base.mk
@@ -1049,7 +1049,7 @@ endif
 
 ifeq ($(TARGET_BUILD_VARIANT),user)
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
-    ro.adb.secure=1
+    ro.adb.secure=0
 endif
 
 # OEM Unlock reporting

```