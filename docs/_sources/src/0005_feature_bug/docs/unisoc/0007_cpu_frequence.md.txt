# 概要

项目经理说uis8581e平台cpu主频有1.8G,但是实测只有1.6G

# 查看主频命令

* adb shell cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_available_frequencies

![0007_0001](images/0007_0001.png)

# 修改方法

* overlaydts里面添加

```
--- a/idh.code/bsp/kernel/kernel5.4/arch/arm64/boot/dts/sprd/uis8581e-5h10-overlay-pax-AF6-v00-v00.dts
+++ b/idh.code/bsp/kernel/kernel5.4/arch/arm64/boot/dts/sprd/uis8581e-5h10-overlay-pax-AF6-v00-v00.dts
@@ -403,4 +403,44 @@
        };
 };
 
+&cpufreq_clus1 {
+    operating-points-SC9863A-1 = <
+        /* kHz  uV */
+        1800000 1150000
+        1600000 1050000
+        1500000 1015625
+        1400000 978125
+        1225000 915625
+        1050000 900000
+        768000  900000>;
+    operating-points-SC9863A-1-65 = <
+        /* kHz    uV */
+        1800000 1171875
+        1600000    1071875
+        1500000    1034375
+        1400000    1000000
+        1225000    934375
+        1050000    900000
+        768000    900000>;
+};
 
+&cpufreq_fcm {
+    operating-points-SC9863A-1 = <
+        /* kHz    uV */
+        1250000 1150000
+        1250000    1050000
+        1172000    1015625
+        1095000    978125
+        959000    915625
+        824000    900000
+        768000    900000>;
+    operating-points-SC9863A-1-65 = <
+        /* kHz    uV */
+        1250000 1171875
+        1250000    1071875
+        1172000    1034375
+        1095000    1000000
+        959000    934375
+        824000    900000
+        768000    900000>;
+};
```


# 修改后

```
C:\Users\starmenxie>pax_adb shell cat /sys/devices/system/cpu/cpu7/cpufreq/scaling_available_frequencies
768000 1050000 1225000 1400000 1500000 1600000 1800000
```