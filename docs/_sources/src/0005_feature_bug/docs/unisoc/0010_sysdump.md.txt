# 概要

展锐平台sysdump 解析,没有电池项目,可能dump模式下,跟pc usb交互有点问题,识别不到展锐的端口

# sysdump

软件打开sysdump后,kernel等panic会停在sysdump界面,机器有插入sd卡的话,会直接把log信息导入到sdcard

机器没有插入sd卡的话,可以通过工具Logel.exe拉去log到PC

![sysdump图](images/0010_0001.png)

具体sysdump介绍,可以参考展锐官方文档 [SysDump简介V2.1.pdf](files/SysDump简介V2.1.pdf)

# sysdump解析步骤

* sysdump导出到sdcard的文件如图

![0010_0002](images/0010_0002.png)

* 生成vmcore

`cat sysdump.core.* > vmcore`

![0010_0003](images/0010_0003.png)

* 判断vmlinux跟vmcore是否匹配

![0010_0006](images/0010_0006.png)

* sysdump 解析

`./crash_arm64_sprd_v8.0.3++ -m vabits_actual=39 -m phys_offset=0x80000000 -m kimage_voffset=0xffffffbf90000000 vmcore vmlinux`

![0010_0004](images/0010_0004.png)


# 使用Logel工具,pc直连终端捉取dump

* 机器正常识别到驱动,机器dump后,打开pc工具Logel,会自动拉去dump

![0010_0005](images/0010_0005.png)

# vmlinux 匹配

使用如下命令,检查vmcore跟vmlinux是否匹配

* strings vmcore | grep "Linux version"

* strings vmlinux | grep "Linux version"

# 测试

可以使用`echo 'c' > proc/sysrq-trigger`手动进入dump模式

# Crash工具简介

详细使用可以参考文档`SysDump简介V2.1.pdf`

* help

![0010_0007](images/0010_0007.png)

* log > kernel.txt

log重定向到kernel.txt,方便查看

![0010_0008](images/0010_0008.png)

* ps

查看进程信息

![0010_0009](images/0010_0009.png)

* bt

查看backtrace

![0010_0010](images/0010_0010.png)