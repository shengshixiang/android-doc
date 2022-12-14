@echo off
::V2.0 2022-1-6 by oyx

::����ϵͳ��ͬ�����Ը���������ӻ���ɾ������Ҫ��Ŀ¼�µ����ݻ�ȡ

echo �汾�ţ�Get Android All Log V2.0

echo ��ǰʱ���ǣ�%time% �� %time:~0,2%��%time:~3,2%��%time:~6,2%��%time:~9,2%����@

set date_time="%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%_%time:~6,2%%time:~9,2%"
::������ʾ���ļ�������
set Folder="Logs_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%_%time:~6,2%%time:~9,2%"
echo ��־�ļ��У�%Folder%
md %Folder%

::��ȡrootȨ�ޣ�����pullһЩ��˽Ŀ¼��������ҪrootȨ��
adb root
adb remount

::�����ļ���
md %Folder%\device
::��ȡϵͳ������app����
adb shell ps > %Folder%\device\ps.txt
::��ȡϵͳ��cup��ռ�����
adb shell top  -n 1 > %Folder%\device\top.txt
::��ȡϵͳ��cupǰʮ��ռ�����Ľ�����Ϣ
adb shell top  -n 1 -H -m 10 -s cpu > %Folder%\device\top2.txt
::��ȡϵͳ�Ľ����ں���Ϣ
adb shell cat /proc/cmdline > %Folder%\device\cmdline.txt
::��ȡϵͳ�Ľ����ڴ�ռ����Ϣ
adb shell cat /proc/meminfo > %Folder%\device\meminfo.txt
::��ȡϵͳ��cup��Ϣ
adb shell cat /proc/cpuinfo > %Folder%\device\cpuinfo.txt
::��ȡϵͳ��prop������Ϣ
adb shell getprop > %Folder%\device\getprop.txt
::��ȡϵͳ���ڴ��С��Ϣ
adb shell df -h > %Folder%\device\df.txt
::��ȡ������Ϣ
adb shell ifconfig -a > %Folder%\device\network.txt
::��ȡko
adb shell lsmod > %Folder%\device\lsmod.txt

::��ȡϵͳ�ĵ�ǰ�����ͼ
adb shell screencap /mnt/sdcard/Pictures/screen_0.png
adb shell "screencap -p -d 1 > /sdcard/screen_1.png"
adb pull /mnt/sdcard/Pictures/screen_0.png %Folder%\screen_0.png
adb pull /mnt/sdcard/Pictures/screen_1.png %Folder%\screen_1.png

::��ȡϵͳ��dumpsys��Ϣ������dumpsys package XXX����Ϣ
md %Folder%\dumpsys
adb shell dumpsys > %Folder%\dumpsys\dumpsys.txt

::��ȡϵͳ�Ļ�����־
adb shell  logcat -b all -v threadtime -d > %Folder%\logcat_all.txt
adb shell  logcat -v threadtime -d > %Folder%\logcat.txt
adb shell bugreport > %Folder%\bugreport.txt

::��ȡ�ں���־
adb shell dmesg > %Folder%\kernel.txt
adb shell "echo t > /proc/sysrq-trigger"
adb shell dmesg > %Folder%\kernel_t.txt

::��ȡϵͳ�ĸ�Ŀ¼�µ���־�����ݲ�ͬϵͳ������

::ϵͳAndroid��־
adb pull   /data/log/android_logs       %Folder%\android_logs
::Dalvik��״̬���ӵ�������C������Լ�libc��һЩ���⵼�µĴ�����־
adb pull   /data/tombstones             %Folder%\tombstones
::ϵͳANR�쳣��־
adb pull   /data/anr                    %Folder%\anr
::ϵͳ�ں���־
adb pull   /sys/fs/pstore               %Folder%\pstore
::ϵͳ�ں�Ӧ�ó����������
adb pull   /data/system/dropbox         %Folder%\dropbox
::ϵͳ��־
adb pull   /data/log/reliability        %Folder%\reliability_system
adb pull   /data/vendor/log/reliability %Folder%\reliability_vendor
::ϵͳsettings�µ�system��secure��global������
adb pull /data/system/users/0           %Folder%\settings

::��ȡϵͳ��recovery��Ϣ
adb pull /cache/recovery %Folder%\

echo.
echo ==========logץȡ���==========
pause

