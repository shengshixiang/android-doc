# linux devices

查看linux的一些设备信息

# spi设备

查看spi设备节点有没有注册成功

* cat /sys/bus/spi/devices/spi0.0/modalias

# 中断

查看中断注册上 没有

* adb shell "cat /proc/interrupts |grep sf-irq"