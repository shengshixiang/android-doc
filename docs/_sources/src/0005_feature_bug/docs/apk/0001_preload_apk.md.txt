# README

预置apk

# 高通android12 预置可卸载apk到/vendor/priv-app/目录

* 合入patch

```
diff --git a/QSSI.12/frameworks/base/services/core/java/com/android/server/pm/PackageAbiHelperImpl.java b/QSSI.12/frameworks/base/services/core/java/com/android/server/pm/PackageAbiHelperImpl.java
index d851e6c..c2e9f21 100644
--- a/QSSI.12/frameworks/base/services/core/java/com/android/server/pm/PackageAbiHelperImpl.java
+++ b/QSSI.12/frameworks/base/services/core/java/com/android/server/pm/PackageAbiHelperImpl.java
@@ -474,7 +474,7 @@ final class PackageAbiHelperImpl implements PackageAbiHelper {
         // We shouldn't extract libs if the package is a library or if extractNativeLibs=false
         boolean extractLibs = !AndroidPackageUtils.isLibrary(pkg) && pkg.isExtractNativeLibs();
         // We shouldn't attempt to extract libs from system app when it was not updated.
-        if (pkg.isSystem() && !isUpdatedSystemApp) {
+        if ((pkg.isSystem() || pkg.getPath().startsWith("/vendor/priv-app")) && !isUpdatedSystemApp) {
             extractLibs = false;
         }
         return extractLibs;
diff --git a/QSSI.12/frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java b/QSSI.12/frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java
index 4925c73..273e685 100644
--- a/QSSI.12/frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java
+++ b/QSSI.12/frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java
@@ -7343,9 +7343,11 @@ public class PackageManagerService extends IPackageManager.Stub
             for (int i = 0, size = mDirsToScanAsSystem.size(); i < size; i++) {
                 final ScanPartition partition = mDirsToScanAsSystem.get(i);
                 if (partition.getPrivAppFolder() != null) {
-                    scanDirTracedLI(partition.getPrivAppFolder(), systemParseFlags,
-                            systemScanFlags | SCAN_AS_PRIVILEGED | partition.scanFlag, 0,
-                            packageParser, executorService);
+                     if(!partition.getPrivAppFolder().getPath().equals("/vendor/priv-app")){
+                        scanDirTracedLI(partition.getPrivAppFolder(), systemParseFlags,
+                                systemScanFlags | SCAN_AS_PRIVILEGED | partition.scanFlag, 0,
+                                packageParser, executorService);
+                     }
                 }
                 scanDirTracedLI(partition.getAppFolder(), systemParseFlags,
                         systemScanFlags | partition.scanFlag, 0,
@@ -7463,6 +7465,10 @@ public class PackageManagerService extends IPackageManager.Stub
 
             }
 
+            scanDirTracedLI(new File("/vendor/priv-app"), systemParseFlags,
+            SCAN_BOOTING | SCAN_INITIAL | SCAN_AS_PRIVILEGED | SCAN_AS_VENDOR, 0,
+            packageParser, executorService);
+
             packageParser.close();
 
             List<Runnable> unfinishedTasks = executorService.shutdownNow();
@@ -12008,11 +12014,13 @@ public class PackageManagerService extends IPackageManager.Stub
                 ? new File(parsedPackage.getPath()).lastModified()
                 : getLastModifiedTime(parsedPackage);
         final VersionInfo settingsVersionForPackage = getSettingsVersionForPackage(parsedPackage);
-        if (ps != null && !forceCollect
+        if (ps != null && ((parsedPackage.getPath().startsWith("/vendor/priv-app")
+                && parsedPackage.getPath() != ps.getPathString())
+                || (!forceCollect
                 && ps.getPathString().equals(parsedPackage.getPath())
                 && ps.timeStamp == lastModifiedTime
                 && !isCompatSignatureUpdateNeeded(settingsVersionForPackage)
-                && !isRecoverSignatureUpdateNeeded(settingsVersionForPackage)) {
+                && !isRecoverSignatureUpdateNeeded(settingsVersionForPackage)))) {
             if (ps.signatures.mSigningDetails.signatures != null
                     && ps.signatures.mSigningDetails.signatures.length != 0
                     && ps.signatures.mSigningDetails.signatureSchemeVersion
@@ -12242,6 +12250,10 @@ public class PackageManagerService extends IPackageManager.Stub
             }
         }
 
+        if(parsedPackage.getPath().startsWith("/vendor/priv-app") && !pkgAlreadyExists && !isFirstBoot() && !mIsUpgrade){
+            return null;
+        }
+
         final boolean newPkgChangedPaths = pkgAlreadyExists
                 && !pkgSetting.getPathString().equals(parsedPackage.getPath());
         final boolean newPkgVersionGreater =
@@ -12338,7 +12350,7 @@ public class PackageManagerService extends IPackageManager.Stub
                             mUserManager.getUserIds(), 0, null, false, null);
                 }
                 pkgSetting = null;
-            } else if (newPkgVersionGreater) {
+            } else if (newPkgVersionGreater && !parsedPackage.getPath().startsWith("/vendor/priv-app")) {
                 // The application on /system is newer than the application on /data.
                 // Simply remove the application on /data [keeping application data]
                 // and replace it with the version on /system.
diff --git a/UM.9.14/device/qcom/lahaina/lahaina.mk b/UM.9.14/device/qcom/lahaina/lahaina.mk
index b33adc5..cce7350 100755
--- a/UM.9.14/device/qcom/lahaina/lahaina.mk
+++ b/UM.9.14/device/qcom/lahaina/lahaina.mk
@@ -131,7 +131,7 @@ BOARD_HAVE_BLUETOOTH := false
 BOARD_HAVE_QCOM_FM := false
 
 # privapp-permissions whitelisting (To Fix CTS :privappPermissionsMustBeEnforced)
-PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=enforce
+PRODUCT_PROPERTY_OVERRIDES += ro.control_privapp_permissions=disable
 
 TARGET_DEFINES_DALVIK_HEAP := true
 $(call inherit-product, device/qcom/vendor-common/common64.mk)
```

* 将app拷贝到目录UM.9.14/package/apps

```
Android.mk
LOCAL_PATH := $(my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := SogouInput
LOCAL_MODULE_CLASS := APPS
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := $(COMMON_ANDROID_PACKAGE_SUFFIX)
LOCAL_PRODUCT_MODULE := true
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_SRC_FILES := $(LOCAL_MODULE).apk
LOCAL_MODULE_PATH := $(PRODUCT_OUT)/vendor/priv-app
include $(BUILD_PREBUILT)
```

* 添加编译PRODUCT_PACKAGES

```
+PRODUCT_PACKAGES += \
+       SogouInput      \
```

* notice,可卸载放在UM,不要放在qssi