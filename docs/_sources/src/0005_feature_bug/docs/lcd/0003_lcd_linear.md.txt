# 高通2290平台设置屏线性亮度

测试提出bug,设置调亮度,亮度曲线不平滑,需要做线性优化

# 屏亮度节点

* cat /sys/class/backlight/panel0-backlight/brightness

* 其他参数

> A6650:/ # ls /sys/class/backlight/panel0-backlight/
> actual_brightness  bl_power  brightness  device  max_brightness  power  subsystem  type  uevent

# 问题点

* 亮度调跳到最大,

> cat /sys/class/backlight/panel0-backlight/brightness
> 255

* 亮度调跳到中间

> cat /sys/class/backlight/panel0-backlight/brightness
> 25

# 修改方法

* QSSI.12/frameworks/base/packages/SettingsLib/src/com/android/settingslib/display/BrightnessUtils.java

```
+++ b/QSSI.12/frameworks/base/packages/SettingsLib/src/com/android/settingslib/display/BrightnessUtils.java
@@ -22,6 +22,9 @@ public class BrightnessUtils {
 
     public static final int GAMMA_SPACE_MIN = 0;
     public static final int GAMMA_SPACE_MAX = 65535;
+//[feature]-add-begin xielianxiong@paxsz.com,20230411,for pwm display linear
+    public static final boolean ENABLE_LINEAR = true;
+//[feature]-add-end xielianxiong@paxsz.com,20230411,for pwm display linear
 
     // Hybrid Log Gamma constant values
     private static final float R = 0.5f;
@@ -76,20 +79,26 @@ public class BrightnessUtils {
      */
     public static final float convertGammaToLinearFloat(int val, float min, float max) {
         final float normalizedVal = MathUtils.norm(GAMMA_SPACE_MIN, GAMMA_SPACE_MAX, val);
-        final float ret;
-        if (normalizedVal <= R) {
-            ret = MathUtils.sq(normalizedVal / R);
-        } else {
-            ret = MathUtils.exp((normalizedVal - C) / A) + B;
-        }
+//[feature]-add-begin xielianxiong@paxsz.com,20230411,for pwm display linear
+        if(ENABLE_LINEAR){
+            return MathUtils.lerp(min, max, normalizedVal);
+        }else{
+            final float ret;
+            if (normalizedVal <= R) {
+                ret = MathUtils.sq(normalizedVal / R);
+            } else {
+                ret = MathUtils.exp((normalizedVal - C) / A) + B;
+            }
 
-        // HLG is normalized to the range [0, 12], ensure that value is within that range,
-        // it shouldn't be out of bounds.
-        final float normalizedRet = MathUtils.constrain(ret, 0, 12);
+            // HLG is normalized to the range [0, 12], ensure that value is within that range,
+            // it shouldn't be out of bounds.
+            final float normalizedRet = MathUtils.constrain(ret, 0, 12);
 
-        // Re-normalize to the range [0, 1]
-        // in order to derive the correct setting value.
-        return MathUtils.lerp(min, max, normalizedRet / 12);
+            // Re-normalize to the range [0, 1]
+            // in order to derive the correct setting value.
+            return MathUtils.lerp(min, max, normalizedRet / 12);
+        }
+//[feature]-add-end xielianxiong@paxsz.com,20230411,for pwm display linear
     }
 
     /**
@@ -128,14 +137,21 @@ public class BrightnessUtils {
      */
     public static final int convertLinearToGammaFloat(float val, float min, float max) {
         // For some reason, HLG normalizes to the range [0, 12] rather than [0, 1]
-        final float normalizedVal = MathUtils.norm(min, max, val) * 12;
-        final float ret;
-        if (normalizedVal <= 1f) {
-            ret = MathUtils.sqrt(normalizedVal) * R;
-        } else {
-            ret = A * MathUtils.log(normalizedVal - B) + C;
-        }
+//[feature]-add-begin xielianxiong@paxsz.com,20230411,for pwm display linear
+        if(ENABLE_LINEAR){
+            final float normalizedVal = MathUtils.norm(min, max, val) ;
+            return Math.round(MathUtils.lerp(GAMMA_SPACE_MIN, GAMMA_SPACE_MAX, normalizedVal));
+        }else{
+            final float normalizedVal = MathUtils.norm(min, max, val) * 12;
+            final float ret;
+            if (normalizedVal <= 1f) {
+                ret = MathUtils.sqrt(normalizedVal) * R;
+            } else {
+                ret = A * MathUtils.log(normalizedVal - B) + C;
+            }
 
-        return Math.round(MathUtils.lerp(GAMMA_SPACE_MIN, GAMMA_SPACE_MAX, ret));
+            return Math.round(MathUtils.lerp(GAMMA_SPACE_MIN, GAMMA_SPACE_MAX, ret));
+//[feature]-add-end xielianxiong@paxsz.com,20230411,for pwm display linear
+        }
     }
```