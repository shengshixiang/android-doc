# 概要

项目开机说开机时间长,展锐uis8581e,A12

# 正常开机60秒,标准少于40秒

* dmesg

可以看到,6s启动zygote,看起来还算正常,10s开启开机动画服务bootanim,11s启动paxservice,12s 上层开启sp

34s开机动画服务退出,耗时23s,太长,第34秒设置sys.boot_completed=1,



```
[    6.865522] c4init: processing action (zygote-start) from (/system/etc/init/hw/init.rc:999)
[    6.867335] c4init: processing action (zygote-start) from (/system/etc/init/installd.rc:1)
[    6.867719] c4init: starting service 'installd'...
[    6.874119] c1init: processing action (firmware_mounts_complete) from (/system/etc/init/hw/init.rc:478)
[    6.874524] c1init: processing action (early-boot) from (/vendor/etc/init/hw/init.uis8581e_5h10.rc:21)
[    6.874890] c1init: start_waiting_for_property("vendor.all.modules.ready", "1"): already set
[    6.875020] c1init: processing action (early-boot) from (/init.paxdroid.rc:49)

...

[   10.530040] c5init: starting service 'bootanim'...
[   10.536638] c5init: Control message: Processed ctl.start for 'bootanim' from pid: 626 (/system/bin/surfaceflinger)
[   10.536738] c5init: processing action (boot) from (/vendor/etc/init/init.leddrv.rc:4)

...

[   11.856338] c2init: starting service 'paxdroid_logd'...
[   11.863923] c0init: starting service 'paxservice'...
[   11.871236] c5init: starting service 'cameraserver'...
[   11.877365] c5init: starting service 'idmap2d'...
[   11.883464] c5init: starting service 'incidentd'...
[   11.891548] c5init: starting service 'mediaextractor'...

...


[   12.272821] c6power off sp
[   12.283658] c3power on sp
[   12.284382] c5init: starting service 'vendor.nsproxy'...

...

[   34.371985] c4binder: undelivered transaction 34615, process died.
[   34.374225] c0init: Service 'bootanim' (pid 697) exited with status 0 oneshot service took 23.841000 seconds in background
[   34.374325] c0init: Sending signal 9 to service 'bootanim' (pid 697) process group...
[   34.374709] c0libprocessgroup: Killing process group -697 in uid 1003 as part of process cgroup 697
[   34.374889] c0libprocessgroup: Successfully killed process cgroup uid 1003 pid 697 in 0ms
[   34.819556] c4init: Command 'swapon_all /vendor/etc/fstab.enableswap' action=sys.boot_completed=1 (/vendor/etc/init/hw/init.ram.rc:70) took 206ms and succeeded

```

* uboot

    > 去掉电量计sgm41528init初始化,优化400ms
    > 去掉取得sp配置文件后,延时1s, 优化1s
    > usb开机多2s,USB SERIAL CONFIGED,应该也是pc直接dump,识别不了usb的原因, 后面提cq
    > 去掉 cw2015 cw_init ,优化400ms

```
[00001131] sgm41528init
[00001133] i2c1, sprd_i2c_init() freq=100000
[00001137] i2c1, sprd_i2c_init() freq=100000
[00001343] Timed out in wait_for_ack: status=210202
[00001569] Timed out in wait_for_ack: status=210202
[00001592] sgm41528/bq25882 is not found, not register ops!!!

...

[00002042] sp quit boot cmd
[00003046] notifySpQuitBootCmd done
[00003049] authinfo:

...

[00003439] 		regu_ldo 000000009f1086c8 (vddusb33) 3300 = 1200 +2100mv (trim=210 step=10000uv)
[00003720] musb-hdrc: peripheral reset irq lost!
[00003842] USB SERIAL CONFIGED
[00005846] usb calibrate port open timeout6457,4456,2000
[00005850] 		regu_ldo 000000009f1086c8 (vddusb33) 3300 = 1200 +2100mv (trim=210 step=10000uv)

...

[00003473] [tuoxie][cw_init-287]-start
[00003476] cw2015_config_info[0] = 0XB5.
[00003480] cw2015_config_info[1] = 0X45.
[00003484] cw2015_config_info[2] = 0XC9.
[00003487] cw2015_config_info[3] = 0X67.
[00003491] cw2015_config_info[4] = 0X84.
[00003495] cw2015_config_info[5] = 0XFD.
[00003498] cw2015_config_info[6] = 0X6B.
[00003502] cw2015_config_info[7] = 0X6D.
[00003506] cw2015_config_info[8] = 0X42.
[00003509] cw2015_config_info[9] = 0X59.
[00003513] cw2015_config_info[10] = 0XCD.
[00003517] cw2015_config_info[11] = 0XB4.
[00003520] cw2015_config_info[12] = 0X73.
[00003524] cw2015_config_info[13] = 0XE1.
[00003528] cw2015_config_info[14] = 0X6F.
[00003531] cw2015_config_info[15] = 0XBE.
[00003535] cw2015_config_info[16] = 0XE1.
[00003539] cw2015_config_info[17] = 0X13.
[00003543] cw2015_config_info[18] = 0X98.
[00003546] cw2015_config_info[19] = 0X44.
[00003550] cw2015_config_info[20] = 0XD0.
[00003554] cw2015_config_info[21] = 0XAB.
[00003557] cw2015_config_info[22] = 0X3A.
[00003561] cw2015_config_info[23] = 0X4E.
[00003565] cw2015_config_info[24] = 0X16.
[00003569] cw2015_config_info[25] = 0XF.
[00003572] cw2015_config_info[26] = 0X9C.
[00003576] cw2015_config_info[27] = 0X97.
[00003580] cw2015_config_info[28] = 0X27.
[00003583] cw2015_config_info[29] = 0XB7.
[00003587] cw2015_config_info[30] = 0X3E.
[00003591] cw2015_config_info[31] = 0X9D.
[00003595] cw2015_config_info[32] = 0X9F.
[00003598] cw2015_config_info[33] = 0XAD.
[00003602] cw2015_config_info[34] = 0XCF.
[00003606] cw2015_config_info[35] = 0XE7.
[00003609] cw2015_config_info[36] = 0XAE.
[00003613] cw2015_config_info[37] = 0X15.
[00003617] cw2015_config_info[38] = 0X6D.
[00003621] cw2015_config_info[39] = 0XED.
[00003624] cw2015_config_info[40] = 0X68.
[00003628] cw2015_config_info[41] = 0XB1.
[00003632] cw2015_config_info[42] = 0XCB.
[00003635] cw2015_config_info[43] = 0X34.
[00003639] cw2015_config_info[44] = 0X59.
[00003643] cw2015_config_info[45] = 0X9.
[00003647] cw2015_config_info[46] = 0X69.
[00003650] cw2015_config_info[47] = 0X3E.
[00003654] cw2015_config_info[48] = 0XCB.
[00003658] cw2015_config_info[49] = 0XFB.
[00003661] cw2015_config_info[50] = 0X9E.
[00003665] cw2015_config_info[51] = 0XC4.
[00003669] cw2015_config_info[52] = 0XFA.
[00003673] cw2015_config_info[53] = 0X43.
[00003676] cw2015_config_info[54] = 0X3C.
[00003680] cw2015_config_info[55] = 0XCE.
[00003684] cw2015_config_info[56] = 0X3C.
[00003687] cw2015_config_info[57] = 0XE7.
[00003691] cw2015_config_info[58] = 0X9A.
[00003695] cw2015_config_info[59] = 0X17.
[00003699] cw2015_config_info[60] = 0XD.
[00003702] cw2015_config_info[61] = 0X5F.
[00003706] cw2015_config_info[62] = 0X38.
[00003710] cw2015_config_info[63] = 0X1D.
[00003713] i2c1, sprd_i2c_init() freq=100000
[00003922] Timed out in wait_for_ack: status=210402
[00003926] I2C_CTL = 0x82107
[00003929] I2C_ADDR_CFG = 0xc4
[00003932] I2C_COUNT = 0x2
[00003934] I2C_STATUS = 0x210402
[00003937] ADDR_DVD0 = 0x33004c
[00003940] ADDR_DVD1 = 0x0
[00003942] ADDR_STA0_DVD = 0x68

```

* uboot log 2

去掉电量计优化后,发现 平台还是有500ms的延时

```
[00001115] sprd dual backlight power on. pwm_index=1 pwm_index2=0 brightness=25
[00001122] uboot consume time:1122ms, lcd init consume:116ms, backlight on time:1743ms 
[00001619] ERR!!!:chg op is NULL....
[00001622] ERR!!!:chg op is NULL....
[00001625] ERR!!!:chg op is NULL....
[00001628] ERR!!!:chg op is NULL....
[00001632] ERR!!!:chg op is NULL....
[00001635] ERR!!!:chg op is NULL....
[00001638] ERR!!!:chg op is NULL....
[00001642] [gpio keys] init!
```

* 关闭打印uboot log

```
--- a/idh.code/bsp/bootloader/u-boot15/common/console.c
+++ b/idh.code/bsp/bootloader/u-boot15/common/console.c
@@ -539,8 +539,12 @@ __weak int log2pc(char *log, int len)
 extern int testMD_flag;
 int printf(const char *fmt, ...)
 {
+#ifdef DEBUG
        if(testMD_flag == 1)
                return 0;
+#endif
        va_list args;
        uint i;
        char printbuffer[CONFIG_SYS_PBSIZE];


```

# 第一次刷机开机106秒,标准少于90s