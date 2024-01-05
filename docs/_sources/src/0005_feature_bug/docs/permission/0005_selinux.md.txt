# 概要

selinux用的越来越多,需要归类总结一下

# selinux的类型

## contexts

定义具体的文件,属性,service等属组,直接操作级

* file_contexts

标记file的类型,`idh.code/vendor/pax/sepolicy/private/file_contexts`

paxservice       属于 paxservice_exec
systool_server   属于 systoold_exec
camera_led_green 属于 led_device
led_light_value  属于 sysfs_led
tpver            属于 tp_ver_default_exec
auth_bpadownload 属于 auth_bpadownload_exec

```
/system/bin/paxservice            u:object_r:paxservice_exec:s0
/system/bin/systool_server        u:object_r:systoold_exec:s0
/system/bin/paxdroid_logservice   u:object_r:paxdroid_logd_exec:s0
/system/bin/auth_bpadownload   u:object_r:auth_bpadownload_exec:s0
/dev/camera_led_green    u:object_r:led_device:s0
/dev/camera_led_red      u:object_r:led_device:s0
/sys/led_light/led_light_value           u:object_r:sysfs_led:s0
/sys/led_light/led_green_light_value     u:object_r:sysfs_led:s0
/sys/led_light/led_red_light_value       u:object_r:sysfs_led:s0
#add for tp ver
/system/bin/tpver        u:object_r:tp_ver_default_exec:s0
```

* property_contexts

标记属性的类型,`idh.code/vendor/pax/sepolicy/private/property_contexts`

pax.ctrl. 开头的属性 属于 pax_ctrl_prop 类型
pax.      开头的属性 属于 system_prop   类型

```
pax.ctrl.                       u:object_r:pax_ctrl_prop:s0
pax.                            u:object_r:system_prop:s0
pax.soc.                        u:object_r:system_prop:s0
com.pax.                        u:object_r:system_prop:s0
pax.sp.                         u:object_r:system_prop:s0
persist.pax.                    u:object_r:system_prop:s0
```

* service_contexts

标记service的类型,`idh.code/vendor/pax/sepolicy/private/service_contexts`

systool_binder      服务 属于 systool_binder_service       类型
PaxVpnService       服务 属于 PaxVpnService_service        类型
WiFiDetectService   服务 属于 PaxEthManagerService_service 类型

```
systool_binder                            u:object_r:systool_binder_service:s0
PaxVpnService                             u:object_r:PaxVpnService_service:s0
PaxEthManagerService                      u:object_r:PaxEthManagerService_service:s0
WiFiDetectService                         u:object_r:WiFiDetectService_service:s0
```

## te

*.te文件,定义具体的属组属性

* 合起来定义,file.te

mlstrustedobject 代表受信任的,不区分app

定义了 sysfs_authinfo 属于基础的 fs_type, sysfs_type
定义了 sysfs_led      属于基础的 fs_type, sysfs_type, mlstrustedobject;


`idh.code/vendor/pax/sepolicy/public/file.te`

```
1 type sysfs_authinfo, fs_type, sysfs_type;
2 type pax_lock_file, system_file_type, file_type;
3 type sysfs_base, fs_type, sysfs_type;
4 type sysfs_raw_scan, fs_type, sysfs_type;
5 type pax_prt_temp, domain;
6 type pax_prt_temp_exec, exec_type,file_type;
7 type sysfs_led, fs_type, sysfs_type, mlstrustedobject;
```

* 单独定义,led_device.te

定义 led_device 属于基础的 dev_type 并且受信任 dev_type

`idh.code/vendor/pax/sepolicy/public/led_device.te`

```
type led_device, dev_type, mlstrustedobject;
```

* 可运行属组,auth_bpadownload.te

配置运行的exce 域

`idh.code/vendor/pax/sepolicy/private/auth_bpadownload.te`

配置auth_bpadownload 属于 coredomain 域,并且初始化

由于所有进程都是init启动,默认和init是相同的权限,所以需要用init_daemon_domain()将进程的域切换到自己的进程域

```
1 typeattribute auth_bpadownload coredomain;
2 init_daemon_domain(auth_bpadownload)
```

`idh.code/vendor/pax/sepolicy/public/auth_bpadownload.te`

配置 auth_bpadownload_exec 属于 exec_type,可运行

```
1 type auth_bpadownload, domain, mlstrustedsubject;
2 type auth_bpadownload_exec, exec_type, file_type, system_file_type;
```

# selinux快速编译

selinux编译

* mmm -j12 system/sepolicy 2>&1 | tee selinux.log