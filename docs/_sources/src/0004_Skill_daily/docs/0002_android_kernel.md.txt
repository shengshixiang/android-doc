# 调试技巧

## 高通平台死机dump log(移远)

* 需要打开高通的调制解调器 
    * setprop sys.usb.config diag,serial_cdev,rmnet,adb

* 打开电脑的设备管理器,调制解调器,属性,如下图,端口21

![0002_0001.png](images/0002_0001.png)

* 使用 QCOM_V1.6.exe 输入命令 at+qcfg="dumpenable",1 ,, 打开死机dump功能

    * at+qcfg="dumpenable" 查询是否开启dump功能
    * at+qcfg="dumpenable",0  //0表示死机后直接开机
    * at+qcfg="dumpenable",1  //1表示死机后进入dump

    * 用at命令写入的是保存在fsc分区, 可以预置fsc分区,然后fastboot flash fsc fsc.bin

* 打开 QPST Configuration Application, 插上usb,自动导出log,配合vmlinux,  捉到的log在help 可以看到目录

## 广和通平台死机dump

* 跟移远相差应该不大,但是有些具体命令,如下图

![0002_0002.png](images/0002_0002.png)

