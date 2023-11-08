# 概要

项目用到了led灯,在/dev/添加了两个设备

如果直接修改selinux的话,就会直接对 device:chr_file 操作,影响放得比较大

# 修改

* vendor/pax/sepolicy/private/file_contexts

新增led文件属组,属于led_device组

```
 #for sp_capture dev
 /dev/sp_capture         u:object_r:sp_capture_device:s0
+/dev/led_green_light    u:object_r:led_device:s0
+/dev/led_red_light      u:object_r:led_device:s0
```

* vendor/pax/sepolicy/public/led_device.te

添加led_device.te 归类,dev_type,并且配置为mlstrustedobject,否则还要配置具体的app调用

```
+type led_device, dev_type, mlstrustedobject;
```

* vendor/pax/sepolicy/vendor/platform_app.te

配置对应platform_app 操作权限

```
allow platform_app led_device:chr_file { open ioctl create write setattr append getattr read lock unlink};
```

* vendor/pax/sepolicy/vendor/system_app.te

配置对应system_app操作权限

```
allow system_app led_device:chr_file { open ioctl create write setattr append getattr read lock unlink};
```

# 问题

* log

platform_app:s0:c512,c768,代表selinux主体,platform_app有各种类别的uid,需要单独配置

```
[1970-01-01 08:10:45].115 W/pool-2-thread-8( 3654): type=1400 audit(0.0:2051): avc: denied { write } for name="led_green_light" dev="tmpfs" ino=79 scontext=u:r:platform_app:s0:c512,c768 tcontext=u:object_r:led_device:s0 tclass=chr_file permissive=0 app=com.pax.ftlite
[1970-01-01 08:10:45].119 W/DBG     ( 3654): FileUtils-> FileNotFoundException:
[1970-01-01 08:10:45].119 W/DBG     ( 3654): java.io.FileNotFoundException: dev/led_green_light: open failed: EACCES (Permission denied)
[1970-01-01 08:10:45].119 W/DBG     ( 3654): 	at libcore.io.IoBridge.open(IoBridge.java:575)
[1970-01-01 08:10:45].119 W/DBG     ( 3654): 	at java.io.FileOutputStream.<init>(FileOutputStream.java:236)
[1970-01-01 08:10:45].119 W/DBG     ( 3654): 	at com.xxx.util.FileUtils.writex(FileUtils.java:311)
[1970-01-01 08:10:45].119 W/DBG     ( 3654): 	at com.pax.ftlite.module.LedTest.AF6Led(LedTest.java:902)
[1970-01-01 08:10:45].119 W/DBG     ( 3654): 	at com.pax.ftlite.module.LedTest.access$100(LedTest.java:73)
[1970-01-01 08:10:45].119 W/DBG     ( 3654): 	at com.pax.ftlite.module.LedTest$2.dox(LedTest.java:115)
```

* seapp_context 

可以在主体文件,参照以下修改

```
user=_app seinfo=omg_flashlight domain=platform_app name=com.omg.flashlight type=app_data_file
```

* vendor/pax/sepolicy/public/led_device.te

或者直接客体,修改成可信任的

```
type led_device, dev_type, mlstrustedobject;
```