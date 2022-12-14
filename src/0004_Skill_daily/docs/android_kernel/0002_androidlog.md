# 捉取开机的logcat
* adb wait-for-device && adb logcat > 1.txt

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
::获取系统的cup信息
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