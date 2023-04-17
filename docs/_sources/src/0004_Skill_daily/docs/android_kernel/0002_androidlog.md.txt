# README

android包括 kernel的一些log输出技巧

# 捉取开机的logcat

* adb wait-for-device && adb logcat > 1.txt

# 捉取kernel log

* adb logcat -b kernel > kernel.log

* adb shell dmesg > dmesg.log

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

```
UM.9.15/kernel/msm-4.19/include/linux/printk.h

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


```

```
UM.9.15/kernel/msm-4.19/include/linux/kern_levels.h

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