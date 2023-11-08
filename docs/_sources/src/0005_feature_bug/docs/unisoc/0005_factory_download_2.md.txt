# 概要

AF6项目裸板回来,ap 跟 sp下载有点问题,

整理一下下载步骤

# 下载sp boot

* 使用兆讯工具MH2101 ISP.exe 下载sp boot, \\\\starmenxie-pc\shareH\software\AF6\bringup\runthos-sp-boot-chunfen-1.1.00.830b2f9eR_3M_no_hwlk.hex

![0005_0001](images/0005_0001.png)

# 下载sp配置文件跟os

使用R60Loader.exe 或者其他下载sp的工具,下载sp os 跟配置文件

* \\\\starmenxie-pc\shareH\software\AF6\bringup\T_AF6-0AW-RD6-02EU_Config_2963200_SIG_V1.0.ini

* \\\\starmenxie-pc\shareH\software\AF6\bringup\runthos-sp-chunfen-1.0.04.f5a03ee1T_AF6_victor_1.5M.bin

![0005_0002](images/0005_0002.png)

![0005_0003](images/0005_0003.png)

![0005_0004](images/0005_0004.png)

# 下载pac

使用ResearchDownload_R25.21.1401工具下载pac包

* \\\\starmenxie-pc\shareH\software\AF6\bringup\PayDroid_AF6_bringup_4.pac

* 勾选格式化下载, **``注意,就第一次选择勾选格式化下载,第二次下载就不用勾选``**

    ![0005_0006](images/0005_0006.png)

* 去掉备份参数, **``注意,就勾选格式化的时候需要去掉备份参数,其他情况不用去掉备份参数``**

    ![0005_0005](images/0005_0005.png)

* 如果下载提示cfg提示报错

    ap跟sp通讯之间可能还是不稳定需要去掉勾选cfg再下载一次

    ![0005_0008](images/0005_0008.png)

* 下载成功

    ![0005_0007](images/0005_0007.png)

# 下载paydroid包

* \\\\starmenxie-pc\shareH\software\AF6\bringup\PayDroid_AF6_bringup_3.paydroid

* 按住音量上键,插拔usb,机器自动进入bootloader下载模式

![0005_0009](images/0005_0009.png)

* 下载paydroid包

![0005_0010](images/0005_0010.png)

# 烧录license

* 电脑插入展锐的u盾

* 打开simba R8.23.3054_P1工具,选择烧录license seq文件 ,\\\\starmenxie-pc\shareH\software\AF6\bringup\Authorization_A12.seq

* 点击simba开启

![0005_0011](images/0005_0011.png)

* 下载成功

![0005_0012](images/0005_0012.png)

# 启动机器

* 插拔usb,机器启动成功

![0005_0013](images/0005_0013.png)