# 本文简介

介绍一些pax的一些简单功能跟属性定义

# persist.system.No.DebugIcon

setprop persist.system.No.DebugIcon true, 桌面不显示 Debug图标,不管调试态与否

# pax.ctrl.log

setprop pax.ctrl.log 1 , 打开一些pax的log开关

# pax_adb syslog

pax_adb syslog > log.txt  , 有时候不能授权,不能用adb logcat ,可以用该命令捉到一些log,可能不全

# pax.persist.permission.check

* adb shell setprop pax.persist.permission.check 0

设置这个属性,可以跳过paydroidtester因为没有ic卡,ped等属性导致的测试失败

否则就要在AndroidManifest.xml里面添加权限配置

```
public static final String ICC_P = "com.pax.permission.ICC";
public static final String PICC_P = "com.pax.permission.PICC";
public static final String MAG_P = "com.pax.permission.MAGCARD";
public static final String PRN_P = "com.pax.permission.PRINTER";
public static final String PED_P = "com.pax.permission.PED";
public static final String SYSSIG = "com.pax.permission.SYSSIG";
```