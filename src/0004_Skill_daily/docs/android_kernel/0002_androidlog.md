# README

android包括 kernel的一些log输出技巧

# 捉取开机的logcat

* adb wait-for-device && adb logcat > 1.txt

# 捉取kernel log

* adb logcat -b kernel > kernel.log

* adb shell dmesg > dmesg.log

# 捉取radio log

* adb shell logcat -b radio

搜索CellSignalStrengthLte 判断信号强度

* 高通的logkit 默认没有打开radio log,需要在config里面打开radio log

* logcat event 也需要在Logkit的config 打开

# android c++ log

c++包含的LOG 文件,输出到logcat

* QSSI.12/system/libbase/include/android-base/logging.h

# android使用ALOGE方法

* Android.mk包含三个库

    * LOCAL_SHARED_LIBRARIES:= libcutils libutils liblog

* c文件

    * 包含 #include <utils/Log.h>

    * #undef LOG_TAG

    * #define LOG_TAG "test"

# 修改kernel log串口 输出级别

* echo 8 > /proc/sys/kernel/printk

* adb shell cat /proc/sys/kernel/printk

# 捉取android 的详细log

文件已上传files/allin1_log.bat

## 具体命令如下
```
@echo off
::V2.0 2022-1-6 by oyx

::各个系统不同，可以根据需求添加或者删除不必要的目录下的数据获取

echo 版本号：Get Android All Log V2.0

echo 当前时间是：%time% 即 %time:~0,2%点%time:~3,2%分%time:~6,2%秒%time:~9,2%厘秒@

set date_time="%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%_%time:~6,2%%time:~9,2%"
::设置显示的文件夹名称
set Folder="Logs_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%_%time:~6,2%%time:~9,2%"
echo 日志文件夹：%Folder%
md %Folder%

::获取root权限，下面pull一些隐私目录的数据需要root权限
adb root
adb remount

::创建文件夹
md %Folder%\device
::获取系统的所有app服务
adb shell ps > %Folder%\device\ps.txt
::获取系统的cup等占用情况
adb shell top  -n 1 > %Folder%\device\top.txt
::获取系统的cup前十个占用最多的进程信息
adb shell top  -n 1 -H -m 10 -s cpu > %Folder%\device\top2.txt
::获取系统的进程内核信息
adb shell cat /proc/cmdline > %Folder%\device\cmdline.txt
::获取系统的进程内存占用信息
adb shell cat /proc/meminfo > %Folder%\device\meminfo.txt
::获取系统的cpu信息
adb shell cat /proc/cpuinfo > %Folder%\device\cpuinfo.txt
::获取系统的prop属性信息
adb shell getprop > %Folder%\device\getprop.txt
::获取系统的内存大小信息
adb shell df -h > %Folder%\device\df.txt
::获取网络信息
adb shell ifconfig -a > %Folder%\device\network.txt
::获取ko
adb shell lsmod > %Folder%\device\lsmod.txt

::获取系统的当前界面截图
adb shell screencap /mnt/sdcard/Pictures/screen_0.png
adb shell "screencap -p -d 1 > /sdcard/screen_1.png"
adb pull /mnt/sdcard/Pictures/screen_0.png %Folder%\screen_0.png
adb pull /mnt/sdcard/Pictures/screen_1.png %Folder%\screen_1.png

::获取系统的dumpsys信息，包含dumpsys package XXX的信息
md %Folder%\dumpsys
adb shell dumpsys > %Folder%\dumpsys\dumpsys.txt

::获取系统的缓存日志
adb shell  logcat -b all -v threadtime -d > %Folder%\logcat_all.txt
adb shell  logcat -v threadtime -d > %Folder%\logcat.txt
adb shell bugreport > %Folder%\bugreport.txt

::获取内核日志
adb shell dmesg > %Folder%\kernel.txt
adb shell "echo t > /proc/sysrq-trigger"
adb shell dmesg > %Folder%\kernel_t.txt

::获取系统的各目录下的日志，根据不同系统进适配

::系统Android日志
adb pull   /data/log/android_logs       %Folder%\android_logs
::Dalvik、状态监视调试器、C层代码以及libc的一些问题导致的错误日志
adb pull   /data/tombstones             %Folder%\tombstones
::系统ANR异常日志
adb pull   /data/anr                    %Folder%\anr
::系统内核日志
adb pull   /sys/fs/pstore               %Folder%\pstore
::系统内核应用程序崩溃数据
adb pull   /data/system/dropbox         %Folder%\dropbox
::系统日志
adb pull   /data/log/reliability        %Folder%\reliability_system
adb pull   /data/vendor/log/reliability %Folder%\reliability_vendor
::系统settings下的system、secure、global等属性
adb pull /data/system/users/0           %Folder%\settings

::获取系统的recovery信息
adb pull /cache/recovery %Folder%\

echo.
echo ==========log抓取完成==========
pause
```

# kernel dmesg 与 kmsg区别

dmesg 打印内核启动过程的所有信息,/proc/kmsg也是打印内核的信息

但是与dmesg 有不同， 第一次执行/proc/kmsg 打印到目前位置的所有内核信息，再次执行/proc/kmsg,

不打印打印过了的信息，打印第一次执行之后的信息，下面举个例子：

第一次执行dmesg打印：

A

B 

C

第一次执行/proc/kmsg打印：

A

B 

C

第二次执行dmesg打印：

A

B 

C

D

第2次执行/proc/kmsg打印：

D

依次类推。

# pr_info log解析

* UM.9.15/kernel/msm-4.19/include/linux/printk.h

```

#define pr_emerg(fmt, ...) \
    printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)

#define pr_alert(fmt, ...) \
    printk(KERN_ALERT pr_fmt(fmt), ##__VA_ARGS__)

#define pr_crit(fmt, ...) \
    printk(KERN_CRIT pr_fmt(fmt), ##__VA_ARGS__)

#define pr_err(fmt, ...) \
    printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)

#define pr_warning(fmt, ...) \
    printk(KERN_WARNING pr_fmt(fmt), ##__VA_ARGS__)

#define pr_warn pr_warning

#define pr_notice(fmt, ...) \
    printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)

#define pr_info(fmt, ...) \
    printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)

#define pr_cont(fmt, ...) \
    printk(KERN_CONT fmt, ##__VA_ARGS__)

#define pr_debug(fmt, ...) \
    dynamic_pr_debug(fmt, ##__VA_ARGS__)
#elif defined(DEBUG)
#define pr_debug(fmt, ...) \
    printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
#else
#define pr_debug(fmt, ...) \
    no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
#endif

```

* UM.9.15/kernel/msm-4.19/include/linux/device.h

```
#define dev_emerg(dev, fmt, ...)                    \
    _dev_emerg(dev, dev_fmt(fmt), ##__VA_ARGS__)
#define dev_crit(dev, fmt, ...)                     \
    _dev_crit(dev, dev_fmt(fmt), ##__VA_ARGS__)
#define dev_alert(dev, fmt, ...)                    \
    _dev_alert(dev, dev_fmt(fmt), ##__VA_ARGS__)
#define dev_err(dev, fmt, ...)                      \
    _dev_err(dev, dev_fmt(fmt), ##__VA_ARGS__)
#define dev_warn(dev, fmt, ...)                     \
    _dev_warn(dev, dev_fmt(fmt), ##__VA_ARGS__)
#define dev_notice(dev, fmt, ...)                   \
    _dev_notice(dev, dev_fmt(fmt), ##__VA_ARGS__)
#define dev_info(dev, fmt, ...)                     \
    _dev_info(dev, dev_fmt(fmt), ##__VA_ARGS__)

#if defined(CONFIG_DYNAMIC_DEBUG)
#define dev_dbg(dev, fmt, ...)                      \
    dynamic_dev_dbg(dev, dev_fmt(fmt), ##__VA_ARGS__)
#elif defined(DEBUG)
#define dev_dbg(dev, fmt, ...)                      \
    dev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__)
#else
#define dev_dbg(dev, fmt, ...)                      \
({                                  \
    if (0)                              \
        dev_printk(KERN_DEBUG, dev, dev_fmt(fmt), ##__VA_ARGS__); \
})
#endif
```

* UM.9.15/kernel/msm-4.19/include/linux/kern_levels.h

```

5 #define KERN_SOH    "\001"      /* ASCII Start Of Header */
  6 #define KERN_SOH_ASCII  '\001'
  7 
  8 #define KERN_EMERG  KERN_SOH "0"    /* system is unusable */
  9 #define KERN_ALERT  KERN_SOH "1"    /* action must be taken immediately */
 10 #define KERN_CRIT   KERN_SOH "2"    /* critical conditions */
 11 #define KERN_ERR    KERN_SOH "3"    /* error conditions */
 12 #define KERN_WARNING    KERN_SOH "4"    /* warning conditions */
 13 #define KERN_NOTICE KERN_SOH "5"    /* normal but significant condition */
 14 #define KERN_INFO   KERN_SOH "6"    /* informational */
 15 #define KERN_DEBUG  KERN_SOH "7"    /* debug-level messages */
```

* log打印分析

    * probe的时候,串口log,adb logcat 都一样, pr_emerg,pr_alert,pr_crit,pr_err,pr_warn,pr_notice,pr_info,pr_cont,都有打印,pr_debug没有打印

    * cat /sys/pax_tp_gesture/tp_gesture 的时候,串口log pr_emerg,pr_alert,pr_crit,pr_err,都有打印,pr_warn以上没有打印,adb logcat 全部打印,除了pr_debug

证明probe的时候,pritk 优先级比较高,开完机才降低优先级


* 默认值 /proc/sys/kernel/printk

    4       6       1       7

* /proc/sys/kernel/printk

把他改成 6       6       1       7后, 串口log就输出了pr_notice,pr_warn,pr_err,pr_crit,pr_alert,pr_emerg 跟KERN_INFO 等级刚好对应

* pr_debug

动态打印,可以看到默认值如下,没有打印出 pr_debug信息

```
A6650:/ # cat /sys/kernel/debug/dynamic_debug/control | grep  pax_tp_gesture
drivers/misc/pax/pax_tp_gesture/pax_tp_gesture.c:54 [pax_tp_gesture]tp_gesture_show =_ "victor,pr_debug,begin\012"
```

* echo "file pax_tp_gesture.c +p" > /sys/kernel/debug/dynamic_debug/control

输入这个命令后,动态log就打印出来了

```
A6650:/ # cat /sys/kernel/debug/dynamic_debug/control | grep  pax_tp_gesture
drivers/misc/pax/pax_tp_gesture/pax_tp_gesture.c:54 [pax_tp_gesture]tp_gesture_show =p "victor,pr_debug,begin\012"

04-09 18:49:28.594     0     0 D         : victor,pr_debug,begin
```

* echo -n "file pax_tp_gesture.c +pfmlt" > /sys/kernel/debug/dynamic_debug/control

输入该命令后,pr_debug输出了,并且附带很多输出

```
A6650:/ # cat /sys/kernel/debug/dynamic_debug/control | grep  pax_tp_gesture
drivers/misc/pax/pax_tp_gesture/pax_tp_gesture.c:54 [pax_tp_gesture]tp_gesture_show =pmflt "victor,pr_debug,begin\012"
A6650:/ #

04-09 18:55:25.922     0     0 D [5077] pax_tp_gesture: tp_gesture_show:54: victor,pr_debug,begin
```

    * p,打印pr_debug

    * f,表示把调用pr_debug的函数名也打印出来

    * m,表示把模块名也打印出来；

    * l,行号

    * t,进程号

* echo -n "file pax_tp_gesture.c -pfmlt" > /sys/kernel/debug/dynamic_debug/control

代表删掉参数,不输出pr_debug

* user版本,dynamic_debug 宏没开,/sys/kernel/debug/dynamic_debug/control 目录没有

可以mount 目录出来,但是验证失败,估计CONFIG_DEBUG_FS=y 没有定义

* 定义DEBUG宏

在需要打印dev_dbg调试信息的驱动文件开头定义DEBUG宏, 注意必须是在<linux/device.h> 或者<linux/paltforam_device.h>前面定义.

* pr_,与dev_的区别

pr_err,dev_err 基本表现一致, logcat都有, 但是dev_dbg,跟pr_debug也要打开/sys/kernel/debug/dynamic_debug/control 才有

串口的pr_debug跟 dev_dbg 还要 设置/proc/sys/kernel/printk >=8 才会出来

pr_info,dev_info等信息,probe的时候会打印

区别在于,dev_dbg 会把dev driver,跟devname,dts 的设备名字打出来,pr_err只会输出log

```

[  118.787070] authinfoDriverName soc:pax_authinfo_dts_1: victor_dev,dev_emerg,authinfo_suspend
[  118.787074] victor_dev,pr_emerg,authinfo_suspend
```

driver name就是authinfoDriverName,
dev name 就是 soc:pax_authinfo_dts

```
static struct platform_driver authinfo_driver = {
    .driver = {
        .name   = "authinfoDriverName",
        .owner  = THIS_MODULE,
        .pm = &authinfo_pm,
        .of_match_table = authinfo_match_table,
    },   
    .probe = authinfo_probe,
    .remove = authinfo_remove,
    .shutdown = authinfo_shutdown,
};

&soc {
 // [FEATURE]-Add-BEGIN by xielianxiong@paxsz.com, 2022/08/15, for ap sp uart
       pax_authinfo_dts_2:pax_authinfo_dts_1 {
       }
```

```
#define pr_err(fmt, ...) \
304     printk(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)

#define dev_err(dev, fmt, ...)                      \
1548     _dev_err(dev, dev_fmt(fmt), ##__VA_ARGS__)

#define define_dev_printk_level(func, kern_level)       \
void func(const struct device *dev, const char *fmt, ...)   \
{                               \
    struct va_format vaf;                   \
    va_list args;                       \
                                \
    va_start(args, fmt);                    \
                                \
    vaf.fmt = fmt;                      \
    vaf.va = &args;                     \
                                \
    __dev_printk(kern_level, dev, &vaf);            \
                                \
    va_end(args);                       \
}                               \
EXPORT_SYMBOL(func);

define_dev_printk_level(_dev_emerg, KERN_EMERG);
define_dev_printk_level(_dev_alert, KERN_ALERT);
define_dev_printk_level(_dev_crit, KERN_CRIT);
define_dev_printk_level(_dev_err, KERN_ERR);
define_dev_printk_level(_dev_warn, KERN_WARNING);
define_dev_printk_level(_dev_notice, KERN_NOTICE);
define_dev_printk_level(_dev_info, KERN_INFO);

#endif


static void __dev_printk(const char *level, const struct device *dev,
            struct va_format *vaf)
{
    if (dev)
        dev_printk_emit(level[1] - '0', dev, "%s %s: %pV",
                dev_driver_string(dev), dev_name(dev), vaf);
    else 
        printk("%s(NULL device *): %pV", level, vaf);
}
```

# Android log分析

可以制作一个简单的自动化log分析工具

* 崩溃

    > 搜索,Fatal > Crash > Android Runtime > Shutting down VM > Exception > Error

* ANR

    > 搜索,timeout,Anr

* 开机阶段

    > 搜索,Starting phase
    > PHASE_SYSTEM_SERVICE_READY

# 捉高通qxdm log, 捉log

* push [default_logmask.cfg](files/default_logmask.cfg) 到 /sdcard/diag_logs/

    > adb root
    > adb shell mkdir /sdcard/diag_logs/
    > adb push default_logmask.cfg /sdcard/diag_logs/

* 开始捉qxdm log

    > diag_mdlog -f /sdcard/diag_logs/default_logmask.cfg -o /sdcard/diag_logs/ &

* 拉取log,*.qmdl log file

    > adb pull /sdcard/diag_logs/ .

* 使用高通qxdm分析log,一般都没有,需要license

#  LOG_NDEBUG

在文件最top，定义 #define LOG_NDEBUG 0 ，可以输出 ALOGV,默认是关闭,

具体定义在 android/system/core/liblog/include/log/log.h