# 概要

有时候需要用到wifi adb场景

# 前提条件

连上wifi,开发者选项,打开 wifi 调试

![0006_0001](images/0006_0001.jpg)

# 使用方法

* adb connect 192.168.0.150:37539

    ![0006_0002](images/0006_0002.jpg)

* 端口号使用使用 ``adb tcpip 6666`` 修改

* adb disconnect 192.168.0.150:37539

* wifi: adb tcpip 5555

* 切usb: adb usb

# 链接失败

* 关闭selinux权限验证

# pari device with QR code

在新版android studio 的device manager里面,点击pair using Wi-Fi菜单,会弹出二维码

接着在开发者选项里面,选择Pair device with QR code扫码连接

![0006_0003](images/0006_0003.png)

# Pair device with paring code

* 点击菜单,生成pair code

    ![0006_0004](images/0006_0004.jpg)

* adb pair 192.168.0.150:42927

    接着输入pair code

    ![0006_0005](images/0006_0005.jpg)

* adb connect 192.168.0.150:37767