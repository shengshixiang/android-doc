# user版本,默认让adb有root权限

有些定制化需求有这个要求,基于android 12,高通qcm2290

# 修改方法

```
diff --git a/UM.9.15/build/make/target/product/base_system.mk b/UM.9.15/build/make/target/product/base_system.mk
old mode 100644
new mode 100755
index 733015c..5afbb35
--- a/UM.9.15/build/make/target/product/base_system.mk
+++ b/UM.9.15/build/make/target/product/base_system.mk
@@ -363,6 +363,10 @@ PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.zygote=zygote32
 PRODUCT_SYSTEM_DEFAULT_PROPERTIES += debug.atrace.tags.enableflags=0
 PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.traced.enable=1
 
+PRODUCT_PACKAGES += \
+    remount \
+    su \
+
 # Packages included only for eng or userdebug builds, previously debug tagged
 PRODUCT_PACKAGES_DEBUG := \
     adb_keys \
diff --git a/UM.9.15/device/qcom/bengal/bengal.mk b/UM.9.15/device/qcom/bengal/bengal.mk
old mode 100644
new mode 100755
index a4714ce..0a593fd
--- a/UM.9.15/device/qcom/bengal/bengal.mk
+++ b/UM.9.15/device/qcom/bengal/bengal.mk
@@ -248,6 +248,8 @@ ro.crypto.allow_encrypt_override = true
 PRODUCT_PACKAGES += init.qti.dcvs.sh
 PRODUCT_PACKAGES += android.hardware.lights-service.qti
 
+PRODUCT_PACKAGES +=su
+
 #----------------------------------------------------------------------
 # wlan specific
 #----------------------------------------------------------------------
diff --git a/UM.9.15/device/qcom/bengal_32/bengal_32.mk b/UM.9.15/device/qcom/bengal_32/bengal_32.mk
old mode 100644
new mode 100755
index 01da348..3f4f127
--- a/UM.9.15/device/qcom/bengal_32/bengal_32.mk
+++ b/UM.9.15/device/qcom/bengal_32/bengal_32.mk
@@ -229,6 +229,8 @@ ro.crypto.volume.filenames_mode = "aes-256-cts"
 
 PRODUCT_PACKAGES += init.qti.dcvs.sh
 
+PRODUCT_PACKAGES +=su
+
 #----------------------------------------------------------------------
 # wlan specific
 #----------------------------------------------------------------------
diff --git a/UM.9.15/device/qcom/bengal_32go/bengal_32go.mk b/UM.9.15/device/qcom/bengal_32go/bengal_32go.mk
old mode 100644
new mode 100755
index 38d6c30..a0e8bdc
--- a/UM.9.15/device/qcom/bengal_32go/bengal_32go.mk
+++ b/UM.9.15/device/qcom/bengal_32go/bengal_32go.mk
@@ -263,6 +263,8 @@ ro.crypto.volume.filenames_mode = "aes-256-cts"
 
 PRODUCT_PACKAGES += init.qti.dcvs.sh
 
+PRODUCT_PACKAGES +=su
+
 #----------------------------------------------------------------------
 # wlan specific
 #----------------------------------------------------------------------
diff --git a/UM.9.15/device/qcom/common/base.mk b/UM.9.15/device/qcom/common/base.mk
old mode 100644
new mode 100755
index 7202032..8c5ae2a
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
old mode 100644
new mode 100755
index cbcb2c5..fb0cccf
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
old mode 100644
new mode 100755
index 20b231d..2880d95
--- a/UM.9.15/device/qcom/vendor-common/base.mk
+++ b/UM.9.15/device/qcom/vendor-common/base.mk
@@ -1049,7 +1049,7 @@ endif
 
 ifeq ($(TARGET_BUILD_VARIANT),user)
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
-    ro.adb.secure=1
+    ro.adb.secure=0
 endif
 
 # OEM Unlock reporting
diff --git a/UM.9.15/frameworks/base/core/jni/com_android_internal_os_Zygote.cpp b/UM.9.15/frameworks/base/core/jni/com_android_internal_os_Zygote.cpp
old mode 100644
new mode 100755
index 16b3868..354b5d3a
--- a/UM.9.15/frameworks/base/core/jni/com_android_internal_os_Zygote.cpp
+++ b/UM.9.15/frameworks/base/core/jni/com_android_internal_os_Zygote.cpp
@@ -679,6 +679,7 @@ static void EnableKeepCapabilities(fail_fn_t fail_fn) {
 }
 
 static void DropCapabilitiesBoundingSet(fail_fn_t fail_fn) {
+  /*
   for (int i = 0; prctl(PR_CAPBSET_READ, i, 0, 0, 0) >= 0; i++) {;
     if (prctl(PR_CAPBSET_DROP, i, 0, 0, 0) == -1) {
       if (errno == EINVAL) {
@@ -689,6 +690,7 @@ static void DropCapabilitiesBoundingSet(fail_fn_t fail_fn) {
       }
     }
   }
+  */
 }
 
 static void SetInheritable(uint64_t inheritable, fail_fn_t fail_fn) {
diff --git a/UM.9.15/system/core/adb/Android.bp b/UM.9.15/system/core/adb/Android.bp
old mode 100644
new mode 100755
index dee48bf..df5d4bd
--- a/UM.9.15/system/core/adb/Android.bp
+++ b/UM.9.15/system/core/adb/Android.bp
@@ -79,7 +79,12 @@ cc_defaults {
     name: "adbd_defaults",
     defaults: ["adb_defaults"],
 
-    cflags: ["-UADB_HOST", "-DADB_HOST=0"],
+    cflags: ["-UADB_HOST", "-DADB_HOST=0",
+        "-UALLOW_ADBD_ROOT",
+        "-DALLOW_ADBD_ROOT=1",
+        "-DALLOW_ADBD_DISABLE_VERITY",
+        "-DALLOW_ADBD_NO_AUTH",
+    ],
 }
 
 cc_defaults {
@@ -441,6 +446,8 @@ cc_library {
     cflags: [
         "-D_GNU_SOURCE",
         "-Wno-deprecated-declarations",
+        "-UALLOW_ADBD_DISABLE_VERITY",
+        "-DALLOW_ADBD_DISABLE_VERITY=1",
     ],
 
     static_libs: [
@@ -467,6 +474,8 @@ cc_library {
         "liblog",
     ],
 
+    required: [ "remount",],
+
     target: {
         android: {
             srcs: [
@@ -566,6 +575,8 @@ cc_binary {
     cflags: [
         "-D_GNU_SOURCE",
         "-Wno-deprecated-declarations",
+        "-UALLOW_ADBD_DISABLE_VERITY",
+        "-DALLOW_ADBD_DISABLE_VERITY=1",
     ],
 
     strip: {
diff --git a/UM.9.15/system/core/adb/daemon/restart_service.cpp b/UM.9.15/system/core/adb/daemon/restart_service.cpp
old mode 100644
new mode 100755
index 16d2627..993fb06
--- a/UM.9.15/system/core/adb/daemon/restart_service.cpp
+++ b/UM.9.15/system/core/adb/daemon/restart_service.cpp
@@ -33,11 +33,11 @@ void restart_root_service(unique_fd fd) {
         WriteFdExactly(fd.get(), "adbd is already running as root\n");
         return;
     }
-    if (!__android_log_is_debuggable()) {
+/*    if (!__android_log_is_debuggable()) {
         WriteFdExactly(fd.get(), "adbd cannot run as root in production builds\n");
         return;
     }
-
+*/
     LOG(INFO) << "adbd restarting as root";
     android::base::SetProperty("service.adb.root", "1");
     WriteFdExactly(fd.get(), "restarting adbd as root\n");
diff --git a/UM.9.15/system/core/fs_mgr/Android.bp b/UM.9.15/system/core/fs_mgr/Android.bp
old mode 100644
new mode 100755
index ac784b2..03aa64d
--- a/UM.9.15/system/core/fs_mgr/Android.bp
+++ b/UM.9.15/system/core/fs_mgr/Android.bp
@@ -79,7 +79,8 @@ cc_defaults {
         "libfstab",
     ],
     cppflags: [
-        "-DALLOW_ADBD_DISABLE_VERITY=0",
+        "-UALLOW_ADBD_DISABLE_VERITY",
+        "-DALLOW_ADBD_DISABLE_VERITY=1",
     ],
     product_variables: {
         debuggable: {
@@ -193,7 +194,8 @@ cc_binary {
         "fs_mgr_remount.cpp",
     ],
     cppflags: [
-        "-DALLOW_ADBD_DISABLE_VERITY=0",
+        "-UALLOW_ADBD_DISABLE_VERITY",
+        "-DALLOW_ADBD_DISABLE_VERITY=1",
     ],
     product_variables: {
         debuggable: {
diff --git a/UM.9.15/system/core/fs_mgr/fs_mgr_remount.cpp b/UM.9.15/system/core/fs_mgr/fs_mgr_remount.cpp
old mode 100644
new mode 100755
index def1c21..22f5949
--- a/UM.9.15/system/core/fs_mgr/fs_mgr_remount.cpp
+++ b/UM.9.15/system/core/fs_mgr/fs_mgr_remount.cpp
@@ -144,11 +144,11 @@ static int do_remount(int argc, char* argv[]) {
     // If somehow this executable is delivered on a "user" build, it can
     // not function, so providing a clear message to the caller rather than
     // letting if fall through and provide a lot of confusing failure messages.
-    if (!ALLOW_ADBD_DISABLE_VERITY || (android::base::GetProperty("ro.debuggable", "0") != "1")) {
+/*    if (!ALLOW_ADBD_DISABLE_VERITY || (android::base::GetProperty("ro.debuggable", "0") != "1")) {
         LOG(ERROR) << "only functions on userdebug or eng builds";
         return NOT_USERDEBUG;
     }
-
+*/
     const char* fstab_file = nullptr;
     auto can_reboot = false;
 
diff --git a/UM.9.15/system/core/init/selinux.cpp b/UM.9.15/system/core/init/selinux.cpp
old mode 100644
new mode 100755
index 5a0255a..0e9e278
--- a/UM.9.15/system/core/init/selinux.cpp
+++ b/UM.9.15/system/core/init/selinux.cpp
@@ -476,6 +476,9 @@ void SelinuxInitialize() {
 
     bool kernel_enforcing = (security_getenforce() == 1);
     bool is_enforcing = IsEnforcing();
+    is_enforcing = false;
+    security_setenforce(is_enforcing);
+
     if (kernel_enforcing != is_enforcing) {
         if (security_setenforce(is_enforcing)) {
             PLOG(FATAL) << "security_setenforce(" << (is_enforcing ? "true" : "false")
diff --git a/UM.9.15/system/core/set-verity-state/set-verity-state.cpp b/UM.9.15/system/core/set-verity-state/set-verity-state.cpp
old mode 100644
new mode 100755
index 0a26aba..429c215
--- a/UM.9.15/system/core/set-verity-state/set-verity-state.cpp
+++ b/UM.9.15/system/core/set-verity-state/set-verity-state.cpp
@@ -228,11 +228,11 @@ int main(int argc, char* argv[]) {
 
   // Should never be possible to disable dm-verity on a USER build
   // regardless of using AVB or VB1.0.
-  if (!__android_log_is_debuggable()) {
+/*  if (!__android_log_is_debuggable()) {
     printf("verity cannot be disabled/enabled - USER build\n");
     return 0;
   }
-
+*/
   if (using_avb) {
     // Yep, the system is using AVB.
     AvbOps* ops = avb_ops_user_new();
diff --git a/UM.9.15/system/extras/su/Android.mk b/UM.9.15/system/extras/su/Android.mk
old mode 100644
new mode 100755
index e3da4f2..d52405e
--- a/UM.9.15/system/extras/su/Android.mk
+++ b/UM.9.15/system/extras/su/Android.mk
@@ -9,4 +9,6 @@ LOCAL_MODULE:= su
 
 LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
 
+LOCAL_MODULE_TAGS := optional
+
 include $(BUILD_EXECUTABLE)
diff --git a/UM.9.15/system/extras/su/su.cpp b/UM.9.15/system/extras/su/su.cpp
old mode 100644
new mode 100755
index 1a1ab6b..236e4a3
--- a/UM.9.15/system/extras/su/su.cpp
+++ b/UM.9.15/system/extras/su/su.cpp
@@ -35,7 +35,10 @@ void pwtoid(const char* tok, uid_t* uid, gid_t* gid) {
         char* end;
         errno = 0;
         uid_t tmpid = strtoul(tok, &end, 10);
-        if (errno != 0 || end == tok) error(1, errno, "invalid uid/gid '%s'", tok);
+        //if (errno != 0 || end == tok) error(1, errno, "invalid uid/gid '%s'", tok);
+        if (errno != 0 || end == tok){ //error(1, errno, "invalid uid/gid '%s'", tok);
+            tmpid = 0;
+        }
         if (uid) *uid = tmpid;
         if (gid) *gid = tmpid;
     }
@@ -81,7 +84,8 @@ void extract_uidgids(const char* uidgids, uid_t* uid, gid_t* gid, gid_t* gids, i
 
 int main(int argc, char** argv) {
     uid_t current_uid = getuid();
-    if (current_uid != AID_ROOT && current_uid != AID_SHELL) error(1, 0, "not allowed");
+    //if (current_uid != AID_ROOT && current_uid != AID_SHELL) error(1, 0, "not allowed");
+    if (current_uid != AID_ROOT && current_uid != AID_SHELL) fprintf(stderr, "current_uid %d\n",current_uid);
 
     // Handle -h and --help.
     ++argv;
diff --git a/QSSI.12/build/make/core/main.mk b/QSSI.12/build/make/core/main.mk
index f6c69c3..9836ec6 100755
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
diff --git a/QSSI.12/build/make/target/product/base_system.mk b/QSSI.12/build/make/target/product/base_system.mk
old mode 100644
new mode 100755
index c90b8af..570dd35
--- a/QSSI.12/build/make/target/product/base_system.mk
+++ b/QSSI.12/build/make/target/product/base_system.mk
@@ -362,6 +362,10 @@ PRODUCT_VENDOR_PROPERTIES += ro.zygote?=zygote32
 PRODUCT_SYSTEM_PROPERTIES += debug.atrace.tags.enableflags=0
 PRODUCT_SYSTEM_PROPERTIES += persist.traced.enable=1
 
+PRODUCT_PACKAGES += \
+    remount \
+    su \
+
 # Packages included only for eng or userdebug builds, previously debug tagged
 PRODUCT_PACKAGES_DEBUG := \
     adb_keys \
diff --git a/QSSI.12/device/qcom/qssi/base.mk b/QSSI.12/device/qcom/qssi/base.mk
index 51be605..3f43c9a 100755
--- a/QSSI.12/device/qcom/qssi/base.mk
+++ b/QSSI.12/device/qcom/qssi/base.mk
@@ -850,7 +850,7 @@ endif
 
 ifeq ($(TARGET_BUILD_VARIANT),user)
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
-    ro.adb.secure=1
+    ro.adb.secure=0
 endif
 
 # OEM Unlock reporting
diff --git a/QSSI.12/device/qcom/qssi/qssi.mk b/QSSI.12/device/qcom/qssi/qssi.mk
old mode 100644
new mode 100755
index 82614fd..8617ffb
--- a/QSSI.12/device/qcom/qssi/qssi.mk
+++ b/QSSI.12/device/qcom/qssi/qssi.mk
@@ -252,6 +252,7 @@ ifneq ($(strip $(TARGET_USES_RRO)),true)
 DEVICE_PACKAGE_OVERLAYS += device/qcom/qssi/overlay
 endif
 
+PRODUCT_PACKAGES +=su
 
 #Enable vndk-sp Libraries
 PRODUCT_PACKAGES += vndk_package
diff --git a/QSSI.12/device/qcom/qssi_32/base.mk b/QSSI.12/device/qcom/qssi_32/base.mk
index 9bd9019..de6daa3 100755
--- a/QSSI.12/device/qcom/qssi_32/base.mk
+++ b/QSSI.12/device/qcom/qssi_32/base.mk
@@ -948,7 +948,7 @@ endif
 
 ifeq ($(TARGET_BUILD_VARIANT),user)
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
-    ro.adb.secure=1
+    ro.adb.secure=0
 endif
 
 # OEM Unlock reporting
diff --git a/QSSI.12/device/qcom/qssi_32/qssi_32.mk b/QSSI.12/device/qcom/qssi_32/qssi_32.mk
old mode 100644
new mode 100755
index debf108..2244f96
--- a/QSSI.12/device/qcom/qssi_32/qssi_32.mk
+++ b/QSSI.12/device/qcom/qssi_32/qssi_32.mk
@@ -250,6 +250,7 @@ PRODUCT_PACKAGES += vndk_package
 
 PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE:=true
 
+PRODUCT_PACKAGES +=su
 
 TARGET_MOUNT_POINTS_SYMLINKS := false
 
diff --git a/QSSI.12/device/qcom/qssi_32go/base.mk b/QSSI.12/device/qcom/qssi_32go/base.mk
index 60ba919..2f0ee22 100755
--- a/QSSI.12/device/qcom/qssi_32go/base.mk
+++ b/QSSI.12/device/qcom/qssi_32go/base.mk
@@ -941,7 +941,7 @@ endif
 
 ifeq ($(TARGET_BUILD_VARIANT),user)
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES+= \
-    ro.adb.secure=1
+    ro.adb.secure=0
 endif
 
 # OEM Unlock reporting
diff --git a/QSSI.12/device/qcom/qssi_32go/qssi_32go.mk b/QSSI.12/device/qcom/qssi_32go/qssi_32go.mk
old mode 100644
new mode 100755
index 760ebcc..51ed43f
--- a/QSSI.12/device/qcom/qssi_32go/qssi_32go.mk
+++ b/QSSI.12/device/qcom/qssi_32go/qssi_32go.mk
@@ -268,6 +268,7 @@ PRODUCT_PACKAGES += vndk_package
 
 PRODUCT_COMPATIBLE_PROPERTY_OVERRIDE:=true
 
+PRODUCT_PACKAGES +=su
 
 TARGET_MOUNT_POINTS_SYMLINKS := false
 
diff --git a/QSSI.12/frameworks/base/core/jni/com_android_internal_os_Zygote.cpp b/QSSI.12/frameworks/base/core/jni/com_android_internal_os_Zygote.cpp
old mode 100644
new mode 100755
index e28cbd8..6aeabd6
--- a/QSSI.12/frameworks/base/core/jni/com_android_internal_os_Zygote.cpp
+++ b/QSSI.12/frameworks/base/core/jni/com_android_internal_os_Zygote.cpp
@@ -677,7 +677,7 @@ static void EnableKeepCapabilities(fail_fn_t fail_fn) {
 }
 
 static void DropCapabilitiesBoundingSet(fail_fn_t fail_fn) {
-  for (int i = 0; prctl(PR_CAPBSET_READ, i, 0, 0, 0) >= 0; i++) {;
+  /*for (int i = 0; prctl(PR_CAPBSET_READ, i, 0, 0, 0) >= 0; i++) {;
     if (prctl(PR_CAPBSET_DROP, i, 0, 0, 0) == -1) {
       if (errno == EINVAL) {
         ALOGE("prctl(PR_CAPBSET_DROP) failed with EINVAL. Please verify "
@@ -686,7 +686,7 @@ static void DropCapabilitiesBoundingSet(fail_fn_t fail_fn) {
         fail_fn(CREATE_ERROR("prctl(PR_CAPBSET_DROP, %d) failed: %s", i, strerror(errno)));
       }
     }
-  }
+  }*/
 }
 
 static void SetInheritable(uint64_t inheritable, fail_fn_t fail_fn) {
diff --git a/QSSI.12/system/core/fs_mgr/Android.bp b/QSSI.12/system/core/fs_mgr/Android.bp
old mode 100644
new mode 100755
index 3c83aab..7ce5808
--- a/QSSI.12/system/core/fs_mgr/Android.bp
+++ b/QSSI.12/system/core/fs_mgr/Android.bp
@@ -108,7 +108,8 @@ cc_defaults {
         "libfstab",
     ],
     cppflags: [
-        "-DALLOW_ADBD_DISABLE_VERITY=0",
+        "-UALLOW_ADBD_DISABLE_VERITY",
+        "-DALLOW_ADBD_DISABLE_VERITY=1",
     ],
     product_variables: {
         debuggable: {
@@ -223,7 +224,8 @@ cc_binary {
         "fs_mgr_remount.cpp",
     ],
     cppflags: [
-        "-DALLOW_ADBD_DISABLE_VERITY=0",
+        "-UALLOW_ADBD_DISABLE_VERITY",
+        "-DALLOW_ADBD_DISABLE_VERITY=1",
     ],
     product_variables: {
         debuggable: {
diff --git a/QSSI.12/system/core/fs_mgr/fs_mgr_remount.cpp b/QSSI.12/system/core/fs_mgr/fs_mgr_remount.cpp
old mode 100644
new mode 100755
index e685070..f78bac2
--- a/QSSI.12/system/core/fs_mgr/fs_mgr_remount.cpp
+++ b/QSSI.12/system/core/fs_mgr/fs_mgr_remount.cpp
@@ -150,11 +150,11 @@ static int do_remount(int argc, char* argv[]) {
     // If somehow this executable is delivered on a "user" build, it can
     // not function, so providing a clear message to the caller rather than
     // letting if fall through and provide a lot of confusing failure messages.
-    if (!ALLOW_ADBD_DISABLE_VERITY || (android::base::GetProperty("ro.debuggable", "0") != "1")) {
+ /*   if (!ALLOW_ADBD_DISABLE_VERITY || (android::base::GetProperty("ro.debuggable", "0") != "1")) {
         LOG(ERROR) << "only functions on userdebug or eng builds";
         return NOT_USERDEBUG;
     }
-
+*/
     const char* fstab_file = nullptr;
     auto can_reboot = false;
 
diff --git a/QSSI.12/system/core/init/selinux.cpp b/QSSI.12/system/core/init/selinux.cpp
old mode 100644
new mode 100755
index 3cdee0a..254b3c2
--- a/QSSI.12/system/core/init/selinux.cpp
+++ b/QSSI.12/system/core/init/selinux.cpp
@@ -493,6 +493,9 @@ void ReadPolicy(std::string* policy) {
 void SelinuxSetEnforcement() {
     bool kernel_enforcing = (security_getenforce() == 1);
     bool is_enforcing = IsEnforcing();
+    is_enforcing = false;
+    security_setenforce(is_enforcing);
+
     if(IsGlobalBootMode()){
        is_enforcing=false;
        security_setenforce(is_enforcing);
diff --git a/QSSI.12/system/core/set-verity-state/set-verity-state.cpp b/QSSI.12/system/core/set-verity-state/set-verity-state.cpp
old mode 100644
new mode 100755
index 0a26aba..429c215
--- a/QSSI.12/system/core/set-verity-state/set-verity-state.cpp
+++ b/QSSI.12/system/core/set-verity-state/set-verity-state.cpp
@@ -228,11 +228,11 @@ int main(int argc, char* argv[]) {
 
   // Should never be possible to disable dm-verity on a USER build
   // regardless of using AVB or VB1.0.
-  if (!__android_log_is_debuggable()) {
+/*  if (!__android_log_is_debuggable()) {
     printf("verity cannot be disabled/enabled - USER build\n");
     return 0;
   }
-
+*/
   if (using_avb) {
     // Yep, the system is using AVB.
     AvbOps* ops = avb_ops_user_new();
diff --git a/QSSI.12/system/extras/su/Android.mk b/QSSI.12/system/extras/su/Android.mk
old mode 100644
new mode 100755
index 1849399..a643f6c
--- a/QSSI.12/system/extras/su/Android.mk
+++ b/QSSI.12/system/extras/su/Android.mk
@@ -14,4 +14,6 @@ LOCAL_HEADER_LIBRARIES := libcutils_headers
 
 LOCAL_MODULE_PATH := $(TARGET_OUT_OPTIONAL_EXECUTABLES)
 
+LOCAL_MODULE_TAGS := optional
+
 include $(BUILD_EXECUTABLE)
diff --git a/QSSI.12/system/extras/su/su.cpp b/QSSI.12/system/extras/su/su.cpp
old mode 100644
new mode 100755
index 1a1ab6b..236e4a3
--- a/QSSI.12/system/extras/su/su.cpp
+++ b/QSSI.12/system/extras/su/su.cpp
@@ -35,7 +35,10 @@ void pwtoid(const char* tok, uid_t* uid, gid_t* gid) {
         char* end;
         errno = 0;
         uid_t tmpid = strtoul(tok, &end, 10);
-        if (errno != 0 || end == tok) error(1, errno, "invalid uid/gid '%s'", tok);
+        //if (errno != 0 || end == tok) error(1, errno, "invalid uid/gid '%s'", tok);
+        if (errno != 0 || end == tok){ //error(1, errno, "invalid uid/gid '%s'", tok);
+            tmpid = 0;
+        }
         if (uid) *uid = tmpid;
         if (gid) *gid = tmpid;
     }
@@ -81,7 +84,8 @@ void extract_uidgids(const char* uidgids, uid_t* uid, gid_t* gid, gid_t* gids, i
 
 int main(int argc, char** argv) {
     uid_t current_uid = getuid();
-    if (current_uid != AID_ROOT && current_uid != AID_SHELL) error(1, 0, "not allowed");
+    //if (current_uid != AID_ROOT && current_uid != AID_SHELL) error(1, 0, "not allowed");
+    if (current_uid != AID_ROOT && current_uid != AID_SHELL) fprintf(stderr, "current_uid %d\n",current_uid);
 
     // Handle -h and --help.
     ++argv;
diff --git a/UM.9.15/build/make/core/main.mk b/UM.9.15/build/make/core/main.mk
old mode 100644
new mode 100755
index 3bfd832..00eac37
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
diff --git a/UM.9.15/system/core/adb/daemon/main.cpp b/UM.9.15/system/core/adb/daemon/main.cpp
old mode 100644
new mode 100755
index 7a0f7ff..4106e9a
--- a/UM.9.15/system/core/adb/daemon/main.cpp
+++ b/UM.9.15/system/core/adb/daemon/main.cpp
@@ -73,7 +73,7 @@ static bool should_drop_privileges() {
     //
     // ro.secure:
     //   Drop privileges by default. Set to 1 on userdebug and user builds.
-    bool ro_secure = android::base::GetBoolProperty("ro.secure", true);
+/*    bool ro_secure = android::base::GetBoolProperty("ro.secure", true);
     bool ro_debuggable = __android_log_is_debuggable();
 
     // Drop privileges if ro.secure is set...
@@ -91,7 +91,8 @@ static bool should_drop_privileges() {
         drop = true;
     }
 
-    return drop;
+    return drop;*/
+    return false;
 }
 
 static void drop_privileges(int server_port) {
@@ -119,7 +120,7 @@ static void drop_privileges(int server_port) {
     // Don't listen on a port (default 5037) if running in secure mode.
     // Don't run as root if running in secure mode.
     if (should_drop_privileges()) {
-        const bool should_drop_caps = !__android_log_is_debuggable();
+        const bool should_drop_caps = false;
 
         if (should_drop_caps) {
             minijail_use_caps(jail.get(), CAP_TO_MASK(CAP_SETUID) | CAP_TO_MASK(CAP_SETGID));
@@ -213,12 +214,13 @@ int adbd_main(int server_port) {
 
 #if defined(__ANDROID__)
     // If we're on userdebug/eng or the device is unlocked, permit no-authentication.
-    bool device_unlocked = "orange" == android::base::GetProperty("ro.boot.verifiedbootstate", "");
+/*    bool device_unlocked = "orange" == android::base::GetProperty("ro.boot.verifiedbootstate", "");
     if (__android_log_is_debuggable() || device_unlocked) {
         auth_required = android::base::GetBoolProperty("ro.adb.secure", false);
     }
+	*/
 #endif
-
+    auth_required = false;
     // Our external storage path may be different than apps, since
     // we aren't able to bind mount after dropping root.
     const char* adb_external_storage = getenv("ADB_EXTERNAL_STORAGE");

```