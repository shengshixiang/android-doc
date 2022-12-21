# 描述

pax_branch,加上gms包后,计算器输入!4444= ,ftest crash

# log
```
12-19 07:52:49.787  8236  8236 D AndroidRuntime: Shutting down VM
12-19 07:52:49.789  8236  8236 E AndroidRuntime: FATAL EXCEPTION: main
12-19 07:52:49.789  8236  8236 E AndroidRuntime: Process: com.pax.ft, PID: 8236
12-19 07:52:49.789  8236  8236 E AndroidRuntime: java.lang.RuntimeException: Unable to instantiate application com.pax.ft.App package com.pax.ft: java.lang.ClassNotFoundException: Didn't find class "com.pax.ft.App" on path: DexPathList[[zip file "/data/app/~~ha7pvEEnHFbbmD8MhLI7jg==/com.pax.ft-Krjn8Aa9ai7fWsQZNQOwQQ==/base.apk"],nativeLibraryDirectories=[/data/app/~~ha7pvEEnHFbbmD8MhLI7jg==/com.pax.ft-Krjn8Aa9ai7fWsQZNQOwQQ==/lib/arm64, /data/app/~~ha7pvEEnHFbbmD8MhLI7jg==/com.pax.ft-Krjn8Aa9ai7fWsQZNQOwQQ==/base.apk!/lib/arm64-v8a, /system/lib64, /system_ext/lib64]]
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.app.LoadedApk.makeApplication(LoadedApk.java:1364)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.app.ActivityThread.handleBindApplication(ActivityThread.java:6705)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.app.ActivityThread.access$1500(ActivityThread.java:248)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.app.ActivityThread$H.handleMessage(ActivityThread.java:2054)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.os.Handler.dispatchMessage(Handler.java:106)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.os.Looper.loopOnce(Looper.java:201)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.os.Looper.loop(Looper.java:288)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.app.ActivityThread.main(ActivityThread.java:7880)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at java.lang.reflect.Method.invoke(Native Method)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at com.android.internal.os.RuntimeInit$MethodAndArgsCaller.run(RuntimeInit.java:548)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at com.android.internal.os.ZygoteInit.main(ZygoteInit.java:1009)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: Caused by: java.lang.ClassNotFoundException: Didn't find class "com.pax.ft.App" on path: DexPathList[[zip file "/data/app/~~ha7pvEEnHFbbmD8MhLI7jg==/com.pax.ft-Krjn8Aa9ai7fWsQZNQOwQQ==/base.apk"],nativeLibraryDirectories=[/data/app/~~ha7pvEEnHFbbmD8MhLI7jg==/com.pax.ft-Krjn8Aa9ai7fWsQZNQOwQQ==/lib/arm64, /data/app/~~ha7pvEEnHFbbmD8MhLI7jg==/com.pax.ft-Krjn8Aa9ai7fWsQZNQOwQQ==/base.apk!/lib/arm64-v8a, /system/lib64, /system_ext/lib64]]
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at dalvik.system.BaseDexClassLoader.findClass(BaseDexClassLoader.java:218)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at java.lang.ClassLoader.loadClass(ClassLoader.java:379)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at java.lang.ClassLoader.loadClass(ClassLoader.java:312)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.app.AppComponentFactory.instantiateApplication(AppComponentFactory.java:76)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.app.Instrumentation.newApplication(Instrumentation.java:1178)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	at android.app.LoadedApk.makeApplication(LoadedApk.java:1356)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	... 10 more
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 	Suppressed: java.io.IOException: Failed to open dex files from /data/app/~~ha7pvEEnHFbbmD8MhLI7jg==/com.pax.ft-Krjn8Aa9ai7fWsQZNQOwQQ==/base.apk because: Invalid file
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at dalvik.system.DexFile.openDexFileNative(Native Method)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at dalvik.system.DexFile.openDexFile(DexFile.java:371)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at dalvik.system.DexFile.<init>(DexFile.java:113)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at dalvik.system.DexFile.<init>(DexFile.java:86)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at dalvik.system.DexPathList.loadDexFile(DexPathList.java:438)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at dalvik.system.DexPathList.makeDexElements(DexPathList.java:397)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at dalvik.system.DexPathList.<init>(DexPathList.java:166)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at dalvik.system.BaseDexClassLoader.<init>(BaseDexClassLoader.java:134)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at dalvik.system.BaseDexClassLoader.<init>(BaseDexClassLoader.java:109)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at dalvik.system.PathClassLoader.<init>(PathClassLoader.java:107)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at com.android.internal.os.ClassLoaderFactory.createClassLoader(ClassLoaderFactory.java:88)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at com.android.internal.os.ClassLoaderFactory.createClassLoader(ClassLoaderFactory.java:117)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at android.app.ApplicationLoaders.getClassLoader(ApplicationLoaders.java:123)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at android.app.ApplicationLoaders.getClassLoaderWithSharedLibraries(ApplicationLoaders.java:60)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at android.app.LoadedApk.createOrUpdateClassLoaderLocked(LoadedApk.java:971)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at android.app.LoadedApk.getClassLoader(LoadedApk.java:1062)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at android.app.LoadedApk.getResources(LoadedApk.java:1310)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at android.app.ContextImpl.createAppContext(ContextImpl.java:3015)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at android.app.ContextImpl.createAppContext(ContextImpl.java:3007)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		at android.app.ActivityThread.handleBindApplication(ActivityThread.java:6633)
12-19 07:52:49.789  8236  8236 E AndroidRuntime: 		... 9 more
```

# 分析
* base.apk
> 看起来像解析base.apk的时候出问题,但是base.apk没做其他东西,只有固件签名
> 第一感觉,就是把apk去掉尾巴的固件签名,验证,问题不复现.
> 就是添加了pax的签名,导致解析apk的时候出现问题,运行出现问题
> 但是没有gms包的版本没有,所以是不是gms包替换了一些什么东西.导致出问题

# 解决
* 调用流程如下
    ```
    at dalvik.system.DexFile. (Native Method)
    at dalvik.system.DexFile.openDexFile(DexFile.java:371)
    at dalvik.system.DexFile.<init>(DexFile.java:113)
    at dalvik.system.DexFile.<init>(DexFile.java:86)
    at dalvik.system.DexPathList.loadDexFile(DexPathList.java:438)
    at dalvik.system.DexPathList.makeDexElements(DexPathList.java:397)
    at dalvik.system.DexPathList.<init>(DexPathList.java:166)
    at dalvik.system.BaseDexClassLoader.<init>(BaseDexClassLoader.java:134)
    at dalvik.system.BaseDexClassLoader.<init>(BaseDexClassLoader.java:109)
    at dalvik.system.PathClassLoader.<init>(PathClassLoader.java:107)
    at com.android.internal.os.ClassLoaderFactory.createClassLoader(ClassLoaderFactory.java:88)
    at com.android.internal.os.ClassLoaderFactory.createClassLoader(ClassLoaderFactory.java:117)
    at android.app.ApplicationLoaders.getClassLoader(ApplicationLoaders.java:123)
    at android.app.ApplicationLoaders.getClassLoaderWithSharedLibraries(ApplicationLoaders.java:60)
    at android.app.LoadedApk.createOrUpdateClassLoaderLocked(LoadedApk.java:971)
    at android.app.LoadedApk.getClassLoader(LoadedApk.java:1062)
    at android.app.LoadedApk.getResources(LoadedApk.java:1310)
    at android.app.ContextImpl.createAppContext(ContextImpl.java:3015)
    at android.app.ContextImpl.createAppContext(ContextImpl.java:3007)
    at android.app.ActivityThread.handleBindApplication(ActivityThread.java:6633)
    ```

    > 从 ActivityThread.java的handleBindApplication > art/runtime/native/dalvik_system_DexFile.cc DexFile_openDexFileNative
    > -> oat_file_manager.cc,OpenDexFilesFromOat 

* 打开VLOG,添加log,
    ```
    +++ b/QSSI.12/art/libartbase/base/logging.h
    @@ -108,7 +108,8 @@ bool PrintFileToLog(const std::string& file_name, android::base::LogSeverity lev
    
    // Variant of LOG that logs when verbose logging is enabled for a module. For example,
    // VLOG(jni) << "A JNI operation was performed";
    -#define VLOG(module) if (VLOG_IS_ON(module)) LOG(INFO)
    +//#define VLOG(module) if (VLOG_IS_ON(module)) LOG(INFO)
    +#define VLOG(module) LOG(INFO)
    
    // Holder to implement VLOG_STREAM.
    class VlogMessage {
    diff --git a/QSSI.12/art/runtime/oat_file_manager.cc b/QSSI.12/art/runtime/oat_file_manager.cc
    old mode 100644
    new mode 100755
    index 542ea092ffc..38e61319ece
    --- a/QSSI.12/art/runtime/oat_file_manager.cc
    +++ b/QSSI.12/art/runtime/oat_file_manager.cc
    @@ -184,7 +184,7 @@ std::vector<std::unique_ptr<const DexFile>> OatFileManager::OpenDexFilesFromOat(
    std::vector<std::unique_ptr<const DexFile>> dex_files;
    std::unique_ptr<ClassLoaderContext> context(
        ClassLoaderContext::CreateContextForClassLoader(class_loader, dex_elements));
    -
    +  LOG(WARNING) << "victor,oat_file_manager.cc, OpenDexFilesFromOat go in here," ;
    // If the class_loader is null there's not much we can do. This happens if a dex files is loaded
    // directly with DexFile APIs instead of using class loaders.
    ```

    > 打开log后,没有log出来.被谷歌apex替换了东西?

* 验证
    * 在原来的流程 QSSI.12/system/libziparchive/zip_archive.cc,添加自己的log,看看 有没有复现
    ```
    +++ b/QSSI.12/system/libziparchive/zip_archive.cc
    @@ -256,7 +256,7 @@ static ZipError FindCentralDirectoryInfo(const char* debug_file_name,
    */
   const off64_t calculated_length = eocd_offset + sizeof(EocdRecord) + eocd->comment_length;
   if (calculated_length != file_length) {
    -    ALOGW("Zip: %" PRId64 " extraneous bytes at the end of the central directory",
    +    ALOGW("Zip: %" PRId64 " victor,extraneous bytes at the end of the central directory",
           static_cast<int64_t>(file_length - calculated_length));
     //[FEATURE]-Modify-START by xielianxiong@paxsz.com, 2021/12/23, for pax sign apk,284
    ```
    > 可以看到如下,谷歌那一部分没有用到system/libziparchive/zip_archive.cc
    ```
    12-19 07:53:26.862  8437  8437 W ziparchive: Zip: 284 extraneous bytes at the end of the central directory
    12-19 07:53:26.862  8437  8437 W com.pax.ft: Invalid file
    12-19 07:53:26.874  8437  8437 W ziparchive: Zip: 284 victor,extraneous bytes at the end of the central directory
    ```

    * 在QSSI.12/vendor/partner_modules/ 搜索bytes at the end of the central directory
    > Binary file QSSI.12/vendor/partner_modules/ArtPrebuilt/com.google.android.art.apks matches
    > 所以相信是谷歌com.google.android.art.apks 替换了 原来的com.android.art

    * 查看QSSI.12/vendor/partner_modules/ArtPrebuilt/Android.bp 文件,可以看到overlay相关字眼
    ```
    module_apex_set {
    name: "com.google.android.art",
    apex_name: "com.android.art",
    owner: "google",
    // Override both AOSP APEX variants, to ensure only com.google.android.art
    // is installed regardless which APEX the logic in runtime_libart.mk has 
    // picked.
    overrides: [
        "com.android.art",
        "com.android.art.debug",
    ],  
    filename: "com.google.android.art.apex",
    set: "com.google.android.art.apks",
    prefer: true,
    soong_config_variables: {
       module_build_from_source: {
           prefer: false
       }   
    },  
    // Make fragment related files from the apex file available for use by the 
    // build when using prebuilts, e.g. for running the boot jars package check
    // and hidden API flag validation among other uses.
    exported_bootclasspath_fragments: ["art-bootclasspath-fragment"],
    ```
    > android 原生的art 应该是如下路径 
    > QSSI.12/art/build/apex/Android.bp-art_apex {
    > QSSI.12/art/build/apex/Android.bp:    name: "com.android.art",

* 修复
    * 把google的art 去掉,QSSI.12/vendor/partner_modules/build/mainline_modules_s.mk
    ```
    +++ b/QSSI.12/vendor/partner_modules/build/mainline_modules_s.mk
    @@ -126,18 +126,20 @@ PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    endif
    -MAINLINE_COMPRESS_APEX_ART ?= true
    -ifeq ($(MAINLINE_COMPRESS_APEX_ART),true)
    -PRODUCT_PACKAGES += \
    +#[feature]-delete-begin xielianxiong@paxsz.com,for pax firmsign apk not work OK
    +#MAINLINE_COMPRESS_APEX_ART ?= true
    +#ifeq ($(MAINLINE_COMPRESS_APEX_ART),true)
    +#PRODUCT_PACKAGES += \
    com.google.android.art_compressed
    -PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    +#PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/apex/com.google.android.art_compressed.apex
    -else
    -PRODUCT_PACKAGES += \
    +#else
    +#PRODUCT_PACKAGES += \
    com.google.android.art
    -PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    +#PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/apex/com.google.android.art.apex
    -endif
    +#endif
    +#[feature]-delete-begin xielianxiong@paxsz.com,for pax firmsign apk not work OK
 
    ```

    * 替换了之后,之前在com.android.art加的log也出来了
    ```	行 1346611: 12-19 07:54:42.849  7765  7765 W com.pax.ft: victor,oat_file_manager.cc, OpenDexFilesFromOat go in here,```
    
# 总结

> 去掉了谷歌的com.google.android.art后,问题就修复了.
> 因为android是一个开放的系统,大家都会对各个模块定制,谷歌为了统一的用户体验.
> 加入了gms包的项目,都会替换mainline,就是apex,对android原生的一些模块进行替换,例如这次的com.android.art
