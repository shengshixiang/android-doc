# REAEDME

默认关闭selinux的方法

# 方法一

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