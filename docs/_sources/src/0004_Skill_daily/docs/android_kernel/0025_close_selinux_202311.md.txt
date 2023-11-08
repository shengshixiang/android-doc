# REAEDME

默认关闭的方法

# 方法一

* 展锐A12,高通A12,都验证可用

> system/core/init/selinux.cpp

* bool is_enforcing = IsEnforcing();

* is_enforcing = false;

# 方法二

* 把bootloader,androidboot.selinux=permissive 添加到cmdline

```
//#define CONFIG_SELINUX_DISABLE
#ifdef CONFIG_SELINUX_DISABLE
	const char *androidboot_selinux_value = "permissive";
#else
	const char *androidboot_selinux_value = "enforcing";
#endif
	bootargs_add("androidboot.selinux=", (char *)androidboot_selinux_value, cmdline);
	
```

# 注意

在cmdline里面添加androidboot.selinux= 只在debug版本有效

* system/core/init/selinux.cpp

ALLOW_PERMISSIVE_SELINUX 这个宏是debug版本定义的,只有在debug版本才去解析cmdline的参数

```
116 bool IsEnforcing() {
117     if (ALLOW_PERMISSIVE_SELINUX) {
118         return StatusFromProperty() == SELINUX_ENFORCING;
119     }
120     return true;
121 }
```

* system/core/init/Android.mk

`ALLOW_PERMISSIVE_SELINUX`

```
ifneq (,$(filter userdebug eng,$(TARGET_BUILD_VARIANT)))
init_options += \
    -DALLOW_FIRST_STAGE_CONSOLE=1 \
    -DALLOW_LOCAL_PROP_OVERRIDE=1 \
    -DALLOW_PERMISSIVE_SELINUX=1 \
    -DREBOOT_BOOTLOADER_ON_PANIC=1 \
    -DWORLD_WRITABLE_KMSG=1 \
    -DDUMP_ON_UMOUNT_FAILURE=1
else
init_options += \
    -DALLOW_FIRST_STAGE_CONSOLE=0 \
    -DALLOW_LOCAL_PROP_OVERRIDE=0 \
    -DALLOW_PERMISSIVE_SELINUX=0 \
    -DREBOOT_BOOTLOADER_ON_PANIC=0 \
    -DWORLD_WRITABLE_KMSG=0 \
    -DDUMP_ON_UMOUNT_FAILURE=0
endif
```