# 高通捉取sensor log

由于高通的sensor 在adsp端,需要用高通工具qxdm捉,但是qxdm工具一般不外发.

所以采取如下方法捉取log

# 方法

## 制作default_logmask.cfg 文件

* 打开QXDM按照下面方法进行F5进入下面页面，sensors选择SNS 和QDSP6即可,文件已上传保留[efault_logmask.cfg](files/default_logmask.cfg)

    ![0003_0001](images/0003_0001.png)

    ![0003_0002](images/0003_0002.png)

    ![0003_0003](images/0003_0003.png)

## 设备上捉取sensor log

### Push efault_logmask.cfg file to device

* adb root

* adb shell mkdir /sdcard/diag_logs/

* adb push default_logmask.cfg /sdcard/diag_logs/

### 开启log

* /vendor/bin/diag_mdlog -f /sdcard/diag_logs/default_logmask.cfg -o /sdcard/diag_logs/ &

### 复现问题

* 打开sensor 等复现问题步骤

### pull log

* adb pull /sdcard/diag_logs/ 0530_sensor_log_1

# 解析log

* 打开qxdm工具,选取pull出来的qmdl文件

    ![0003_0004](images/0003_0004.png)

* 解析出来的log如下

    ![0003_0005](images/0003_0005.png)

# 捉sensor初始化的log

* adb root

* adb shell stop sensors

* adb shell "echo 'related' > /sys/bus/msm_subsys/devices/subsys2/restart_level"

* /vendor/bin/diag_mdlog -f /sdcard/diag_logs/default_logmask.cfg -o /sdcard/diag_logs/ &

* adb shell start sensors

## 直接使用qxdm 捉初始化log

QXDM的命令行输入如下命令

* send_data 75 37 03 48 00            //该命令只是重启sensor，以便抓取sensor启动时的log

![0003_0006](images/0003_0006.png)