# 概要

测试同事,低温-10度复测,交易时间.

从大概12点开始测试,发现机器16:06:15.106多久关机了..让看app交易数据,发现中间有一段没有交易

测试说可能wifi断了.

本来想统计一下log,根据 curr:-505 ma 看看交易的平均功耗.但是发现机器14:43:07.268 就没log了.

机器在起来的时候,时间已经变成16:20:50了,中间有一个小时没有log,查看起来的log,发现关机原因,跟reboot原因都比较奇怪

```
	行 10387: 08-18 12:15:38.815 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:97,cap_rm:4588 mah, vol:4182 mv, temp:26, curr:-505 ma, ui_soc:97]
```

# log

```
行 223: 01-03 05:01:25.724 I/qcom,qpnp-power-on 1c40000.qcom,spmi(    0): qcom,pm2250@0:qcom,power-on@800: PMIC@SID0 Power-on reason: Triggered from Hard Reset and 'cold' boot
行 224: 01-03 05:01:25.725 I/qcom,qpnp-power-on 1c40000.qcom,spmi(    0): qcom,pm2250@0:qcom,power-on@800: PMIC@SID0: Power-off reason: Triggered from PS_HOLD (PS_HOLD/MSM Controlled Shutdown)
行 7622: 01-03 05:01:35.267 W/CamX    (  609): [ WARN][CSL    ] camxcslhwinternal.cpp:3152 CSLHwInternalFDIoctl() Ioctl failed for FD:8 with error reason Invalid argument
行 8165: 01-03 05:01:36.716 I/bootstat(  888): Service started: /system/bin/bootstat --set_system_boot_reason 
行 8176: 01-03 05:01:36.793 I/bootstat(  888): Canonical boot reason: shutdown,battery
行 8177: 01-03 05:01:36.793 I/bootstat(  888): Canonical boot reason: shutdown,battery
行 8193: 01-03 05:01:36.878 I/bootstat(  888): Last reboot reason read from /metadata/bootstat/persist.sys.boot.reason : shutdown,battery. Last reboot reason read from persist.sys.boot.reason : shutdown,battery
行 8193: 01-03 05:01:36.878 I/bootstat(  888): Last reboot reason read from /metadata/bootstat/persist.sys.boot.reason : shutdown,battery. Last reboot reason read from persist.sys.boot.reason : shutdown,battery
行 8193: 01-03 05:01:36.878 I/bootstat(  888): Last reboot reason read from /metadata/bootstat/persist.sys.boot.reason : shutdown,battery. Last reboot reason read from persist.sys.boot.reason : shutdown,battery
行 8193: 01-03 05:01:36.878 I/bootstat(  888): Last reboot reason read from /metadata/bootstat/persist.sys.boot.reason : shutdown,battery. Last reboot reason read from persist.sys.boot.reason : shutdown,battery
行 8194: 01-03 05:01:36.878 I/bootstat(  888): Normalized last reboot reason : shutdown,battery
行 9297: 08-18 16:20:51.287 W/systool_paxdroid_lateinit(  960): cannot open /cache/pax-recovery/recovery.reason, reason:[No such file or directory]
行 9297: 08-18 16:20:51.287 W/systool_paxdroid_lateinit(  960): cannot open /cache/pax-recovery/recovery.reason, reason:[No such file or directory]
```

# 分析

对比下面列出的几种情况,所以肯定是因为电池原因关机了.后面又自动重启了.如果时间准的话,还是格了很久才重启

* 对比正常关机,按键开机

Power-on reason ,记录了争取的开机原因,Power Key Press
Canonical boot reason,记录了正确的关机原因,userrequested
Power-off reason,PS_HOLD (PS_HOLD/MSM Controlled Shutdown),这个看起来,自动重启,shell重启,按键重启都是一样 

```
01-03 06:33:34.766     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0 Power-on reason: Triggered from KPD (Power Key Press) and 'cold' boot
01-03 06:33:34.766     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0: Power-off reason: Triggered from PS_HOLD (PS_HOLD/MSM Controlled Shutdown)
01-03 06:33:46.609   897   897 I bootstat: Canonical boot reason: shutdown,userrequested
```

* adb reboot 重启

看起来,只要重启,都是 ```Power-on reason: Triggered from Hard Reset and 'cold' boot```

```Canonical boot reason: reboot,shell``` 这几个记录了真正的重启原因

```
01-03 06:37:52.767     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0 Power-on reason: Triggered from Hard Reset and 'cold' boot
01-03 06:37:52.767     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0: Power-off reason: Triggered from PS_HOLD (PS_HOLD/MSM Controlled Shutdown)
01-03 06:38:04.393   906   906 I bootstat: Canonical boot reason: reboot,shell
```

* 长按power键,选择重启

用户要求的重启```reboot,userrequested```
自动重启 ``` Power-on reason: Triggered from Hard Reset and 'cold' boot```
正常关机流程 ```Power-off reason: Triggered from PS_HOLD (PS_HOLD/MSM Controlled Shutdown)```

```
01-03 06:44:52.770     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0 Power-on reason: Triggered from Hard Reset and 'cold' boot
01-03 06:44:52.771     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0: Power-off reason: Triggered from PS_HOLD (PS_HOLD/MSM Controlled Shutdown)
01-03 06:45:04.370   897   897 I bootstat: Canonical boot reason: reboot,userrequested
```

* 抠电池,手动按键开机

记录按键开机,不明原因关机

```Canonical boot reason: reboot``,只有reboot信息

```
01-01 08:00:05.762     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0 Power-on reason: Triggered from KPD (Power Key Press) and 'cold' boot
01-01 08:00:05.762     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0: Unknown power-off reason
01-01 08:00:18.593   922   922 I bootstat: Canonical boot reason: reboot
```

* 正常关机,插入usb,提示充电界面后,再按power键开机

只记录了 用户关机,重启原因,只记录了第一次插入usb开机,没有记录 按键开机了.

```
01-01 08:04:44.763     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0 Power-on reason: Triggered from Hard Reset and 'cold' boot
01-01 08:04:44.763     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0: Power-off reason: Triggered from PS_HOLD (PS_HOLD/MSM Controlled Shutdown)
01-01 08:04:55.705   886   886 I bootstat: Canonical boot reason: shutdown,userrequested
```

* 掉电,插入适配器开机

没有关机原因,外界适配器开机

```
01-01 08:00:07.771     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0 Power-on reason: Triggered from CBL (External Power Supply) and 'cold' boot
01-01 08:00:07.771     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0: Unknown power-off reason
01-01 08:00:19.991   900   900 I bootstat: Canonical boot reason: reboot
```

* 直流电源调到,2.5V自动掉电,插入电池,按power键开机

跟掉电关机时间一样

```
行 205: 01-01 08:00:05.763     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0 Power-on reason: Triggered from KPD (Power Key Press) and 'cold' boot
行 206: 01-01 08:00:05.763     0     0 I qcom,qpnp-power-on 1c40000.qcom,spmi: qcom,pm2250@0:qcom,power-on@800: PMIC@SID0: Unknown power-off reason
01-01 08:00:18.009   909   909 I bootstat: Canonical boot reason: reboot
```

* shutdown,battery

没电关机,也是这个reason

# 高通关机类别

```
* SOFT (Software)；
* PS_HOLD (PS_HOLD/MSM Controlled Shutdown)；
* PMIC_WD (PMIC Watchdog)；
* GP1 (Keypad_Reset1)；
* GP2 (Keypad_Reset2)；
* KPDPWR_AND_RESIN (Power Key and Reset Line)；
* RESIN_N (Reset Line/Volume Down Key)；
* KPDPWR_N (Long Power Key Hold)；
* CHARGER (Charger ENUM_TIMER, BOOT_DONE)；
* TFT (Thermal Fault Tolerance)；
* UVLO (Under Voltage Lock Out)；
* OTST3 (Over Temp
```

# 分析结论

08-18低温测试分析结果

* log 记录时间 从 08-18 12:14:55开始

* 从log分析,大概14:43:07 后就没有log出来
    > 关机前,显示电池电量还有20%,容量大概930mah,电池电压,3661mv

* out-logcat7.txt文件分析,

从摘要的log分析,``机器因为电池原因发生了shutdown跟重启``

```
01-03 05:01:25.724 I/qcom,qpnp-power-on  Power-on reason: Triggered from Hard Reset and 'cold' boot
01-03 05:01:25.725 I/qcom,qpnp-power-on  Power-off reason: Triggered from PS_HOLD (PS_HOLD/MSM Controlled Shutdown)
01-03 05:01:36.793 I/bootstat(  888): Canonical boot reason: shutdown,battery
```

* 机器重启前,接近测试3小时,计算平均功耗 -636ma

* 由于可能机器重启,丢了一些log,从后续的out-logcat9.txt开始,电量继续减少

最终低电关机

```
行 303205: 08-18 15:45:29.921 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:8,cap_rm:354 mah, vol:3531 mv, temp:-1, curr:-740 ma, ui_soc:8]
行 304764: 08-18 15:45:38.121 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:8,cap_rm:353 mah, vol:3508 mv, temp:-1, curr:-782 ma, ui_soc:8]
行 306305: 08-18 15:45:46.308 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:8,cap_rm:352 mah, vol:3564 mv, temp:-1, curr:-572 ma, ui_soc:8]
行 306640: 08-18 15:45:54.510 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:8,cap_rm:351 mah, vol:3516 mv, temp:-1, curr:-737 ma, ui_soc:8]
```

* out-logcat10.txt

```
08-18 16:06:06.913 I/PAX_BAT (    0): [status:Discharging, health:Good, present:1, tech:Li-ion, capcity:0,cap_rm:0 mah, vol:3462 mv, temp:-1, curr:-684 ma, ui_soc:0]
08-18 16:06:06.914 E/icnss   (    0): Battery percentage read failure
08-18 16:06:06.922 W/healthd (    0): battery l=0 v=3462 t=-1.0 h=2 st=3 c=-684000 fc=2690000 cc=16 chg=
08-18 16:06:06.934 D/BatteryService( 1378): Processing new values: info={.chargerAcOnline = false, .chargerUsbOnline = false, .chargerWirelessOnline = false, .maxChargingCurrent = 0, .maxChargingVoltage = 0, .batteryStatus = DISCHARGING, .batteryHealth = GOOD, .batteryPresent = true, .batteryLevel = 0, .batteryVoltage = 3462, .batteryTemperature = -10, .batteryCurrent = -684000, .batteryCycleCount = 16, .batteryFullCharge = 2690000, .batteryChargeCounter = 0, .batteryTechnology = Li-ion}, chargerVoltage = 5000000, chargerCurrent = 500000, soh =100, batteryManufactuer = iconergy
08-18 16:06:06.934 D/BatteryService( 1378): , batterySerialNumber = , mBatteryLevelCritical=true, mPlugType=0 

08-18 16:06:07.036 Shutdown intent checkpoint recorded intent=com.android.internal.intent.action.REQUEST_SHUTDOWN from package=android
08-18 16:06:07.037 START u0 {act=com.android.internal.intent.action.REQUEST_SHUTDOWN flg=0x10000000 cmp=android/com.android.internal.app.ShutdownActivity (has extras)} from uid 1000
```

* 疑惑点

从out-logcat7.txt开始,时间已经是08-18 16:20:53.005,

但是后面out-logcat7.txt的时间又变成15:25:01.123

搜索logcat7.txt,明明设置了时间```Setting time of day to sec=1692346889```

缺失的logcat8.txt导致一些信息看不了