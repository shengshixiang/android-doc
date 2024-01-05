# 概要

展锐8581e,A12,安装apk,打开apk,然后断电,开机,遇到概率性开机卸载apk问题

# Log

`ziparchive: Zip: EOCD not found, /data/app/~~WAyJO5vkXilf4OtPKEbEYg==/com.ray.gpgpstester-CLy2bYvKmNj1AYthD23Q7w==/base.apk is not zip`

```
01-01 08:00:24.249   992   992 D PackageManager: PMS scan package: /data/app/~~UOUUz6_jtbUcB5nrJm2tWw==
01-01 08:00:24.251   992  1047 D ziparchive: Zip: EOCD not found, /data/app/~~WAyJO5vkXilf4OtPKEbEYg==/com.ray.gpgpstester-CLy2bYvKmNj1AYthD23Q7w==/base.apk is not zip
01-01 08:00:24.252   992  1047 E system_server: Failed to open APK '/data/app/~~WAyJO5vkXilf4OtPKEbEYg==/com.ray.gpgpstester-CLy2bYvKmNj1AYthD23Q7w==/base.apk': Invalid file
01-01 08:00:24.253   992   992 W PaxKeyCompat: replace fingerprint md5Value=B500BFC66BA72B90B9CA1F05A5299B48
01-01 08:00:24.253   992   992 W PackageManager: verifySignatures ignoring signature for com.pax.paxscans
01-01 08:00:24.253   992   992 W PaxKeyCompat: replace fingerprint md5Value=B500BFC66BA72B90B9CA1F05A5299B48
01-01 08:00:24.253   992   992 W PackageManager: reconcilePackagesLocked() set removeAppKeySetData to false for com.pax.paxscans
01-01 08:00:24.255   992   992 D PackageManager: PMS scan package: /data/app/~~DQR2R5J6fOsU4fQbKJWQcQ==
01-01 08:00:24.257   601   707 D ENGPC:  : [tid:0]try_connect: connect cp_time_sync_server socket error(Connection refused), try_num=16
01-01 08:00:24.257   601   707 D ENGPC:  : 

01-01 08:00:24.257   601   707 D ENGPC:  :  [tid:0]timesync: total_conn=1
01-01 08:00:24.257   601   707 D ENGPC:  : 

01-01 08:00:24.260   992   992 D PackageManager: PMS scan package: /data/app/~~FJzEXiCLOv5QHGAzMSY-0Q==
01-01 08:00:24.264   515   819 I audio_hw:Alsa_Util:  usb card check not foundbuffer: 0
01-01 08:00:24.264   515   819 I audio_hw_primary: headphonestate:headphonestate=0
01-01 08:00:24.264   992   992 D PackageManager: PMS scan package: /data/app/~~fl4ODZfzT3L6etwVAnONkQ==
01-01 08:00:24.268   992   992 D PackageManager: PMS scan package: /data/app/~~WAyJO5vkXilf4OtPKEbEYg==
01-01 08:00:24.268   992   992 W PackageManager: Failed to parse /data/app/~~WAyJO5vkXilf4OtPKEbEYg==: Failed to parse /data/app/~~WAyJO5vkXilf4OtPKEbEYg==/com.ray.gpgpstester-CLy2bYvKmNj1AYthD23Q7w==/base.apk
01-01 08:00:24.269   992   992 W PackageManager: Deleting invalid package at /data/app/~~WAyJO5vkXilf4OtPKEbEYg==
01-01 08:00:24.294   992   992 I PackageManager: Finished scanning non-system apps. Time: 71 ms, packageCount: 8 , timePerPackage: 8 , cached: 8
```

# 修改代码

报错的时候,不要删除base.apk,把base.apk拖出来跟原装apk对比,发现base.apk数据全是0

* idh.code/frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java

```
--- a/idh.code/frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java
+++ b/idh.code/frameworks/base/services/core/java/com/android/server/pm/PackageManagerService.java
@@ -12476,8 +12476,8 @@ public class PackageManagerService extends IPackageManager.Stub
             if ((scanFlags & SCAN_AS_SYSTEM) == 0
                     && errorCode != PackageManager.INSTALL_SUCCEEDED) {
                 logCriticalInfo(Log.WARN,
-                        "Deleting invalid package at " + parseResult.scanFile);
-                removeCodePathLI(parseResult.scanFile);
+                        "victor01,Deleting invalid package at " + parseResult.scanFile);
+                //removeCodePathLI(parseResult.scanFile);
             }
         }
     }
@@ -12527,8 +12527,8 @@ public class PackageManagerService extends IPackageManager.Stub
         if ((scanFlags & SCAN_AS_SYSTEM) == 0
                 && errorCode != PackageManager.INSTALL_SUCCEEDED) {
             logCriticalInfo(Log.WARN,
-                    "Deleting invalid package at " + parseResult.scanFile);
-            removeCodePathLI(parseResult.scanFile);
+                    "victor02,Deleting invalid package at " + parseResult.scanFile);
+            //removeCodePathLI(parseResult.scanFile);
         }
     }
```

# 结论

可以看到,由于掉电的时候,文件系统把base.apk 回写flash 之前,就掉电,导致base.apk数据异常

开机的时候,检测异常apk,所以直接卸载

# 优化方法

adb install 完成apk安装后, 再手动执行一下 adb shell sync 命令,看看是否有优化

* adb install 完成apk安装后

* adb shell sync


# 是否每次开机都会丢

只要第一次开机没丢,apk就以后都不会丢. 因为base.apk 第一次检测到是完整的,代表它在flash上的数据就是完成的

# 解决方法

基本无解, 因为无论什么方法,都会有写数据到flash,突然遇到掉电问题.

咨询了一下公司其他不带电池项目, 也曾遇到同样问题.

咨询了一下,展锐, 强行修改, 可能还会带来其他更大的隐患问题.

# 不掉电,点击重启按钮

原则上是不会丢应用的