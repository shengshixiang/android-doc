# 概要

本文介绍使用高通工具Qcom V.16 查询at命令方法

# 方法

* setprop sys.usb.config diag,serial_cdev,rmnet,adb 打开高通端口,可以看到端口是210

    ![0002_0001](images/0002_0001.png)

* 打开Qcom,open port

    ![0002_0002](images/0002_0002.png)

* AT+CIMI 读取IMSI

    ![0002_0003](images/0002_0003.png)

* AT+ICCID 读取 ICCID

    ![0002_0004](images/0002_0004.png)

* AT+QNVR=447,0  读取BT地址

    ![0002_0005](images/0002_0005.png)

* AT+QNVR=4678,0  读取wifi地址

    ![0002_0006](images/0002_0006.png)

* AT+EGMR=0,7   读取imei 1,

    ![0002_0007](images/0002_0007.png)