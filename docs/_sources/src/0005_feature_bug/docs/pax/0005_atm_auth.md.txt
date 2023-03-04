# README

M9200是商业设备,sp带打印机,要在ap端添加授权机制,添加写入sn号等需要授权的功能,例如还有客户资源包等

# 调试备注

## 机器要打开acm功能

* persist.vendor.usb.config=adb,acm0,acm1,usb连接电脑,要显示两个usb端口

## 定义pax.ctrl.usb.plug属性

* usb插入的时候,拔出的时候,把pax.ctrl.usb.plug赋值in或out,控制 auth_bpadownload的程序开启或者关闭

## 波特率

* M9200是非标波特率,750000,需要注意波特率修改的地方,但是应该用不到

# 一些参数,指针备注,方便调试代码

* ro.platform.series = ATM

* AuthPara->destPortBaud = ro.auth.baudrate = 750000

* ro.rpc.baudrate = 750000

* AuthPara->destPortPath = /dev/paxPortRPC

* AuthPara->srcPortBaud = 115200;

* AuthPara->srcPortChannel = 50; == /dev/paxPortDeamon == /dev/ttyGS1 == TTY_DEVICE_DAEMON_VCOM

* have_sp_auth =0;

* AuthOps->OpenAuth = serial_pipe.c  -> OpenPipe

* AuthOps->ReadAuth = serial_pipe.c  ->  CloseAuth

* AuthOps->WriteAuth = serial_pipe.c  ->  WritePipe

* AuthOps->FlushAuth = serial_pipe.c  ->  FlushPipe

* AuthOps->CloseAuth = serial_pipe.c  ->  ClosePipe

* auth_step = AUTH_STEP_HANDSHAKE = 1

* #define AUTHINFO_SYS_ATTR_SERIAL_PATH         "/sys/class/authinfo/sp_authinfo"

* #define AUTHINFO_SYS_ATTR_SERIAL_PIPE    	  "SerialPipe"

* #define AUTHINFO_SYS_ATTR_READCMD_PIPE    	  "ReadCmdPipe" 

* #define AUTHINFO_SYS_ATTR_SERIAL_PIPE_STATUS  "SerialPipeStatus" 

* #define MAIN_PROP_INDEX_SERIAL_PIPE   	13

* #define MAIN_PROP_INDEX_SERIALPIPESTATUS   	14

* #define MAIN_PROP_INDEX_READCMDPIPE     16       //20170508

* #define SUB_PROP_INDEX_READ_CMD           33

* #define SUB_PROP_INDEX_SERIAL_PIPE_STATUS 51

* #define SUB_PROP_INDEX_SERIAL_PIPE        52

* is_serial_pipe_open = 0;

* SERIAL_PIPE_APP_CAN_WRITE = 1,

* SERIAL_PIPE_APP_CAN_READ = 2,

* SERIAL_PIPE_KERNEL_CAN_WRITE = 3,

* SERIAL_PIPE_KERNEL_CAN_READ = 4,

* SERIAL_PIPE_RESET         = 5,   /*equal to SERIAL_PIPE_APP_CAN_WRITE*/

* SERIAL_PIPE_INVAILD = 0xff,

# 商业设备授权流程

* 写/sys/class/authinfo/sp_authinfo/SerialPipeStatus MAIN_PROP_INDEX_SERIALPIPESTATUS SUB_PROP_INDEX_SERIAL_PIPE_STATUS SERIAL_PIPE_RESET

* 设置底层 serial_pipe_status = 5 = SERIAL_PIPE_RESET

* 开启交互线程 auth_packet_loop_work

* 发现runthos留了一个原有的接口,用于调用原来旧的monitor的数据交互流程,只要定义pax.ctrl.compatible.monitor_authdownload,就可以启用monitor_auth_packet_loop_work_s

```
property_get("pax.ctrl.compatible.monitor_authdownload", context, "false");
if (NULL != strstr(context, "true")) {
    // auth with monitor SP protocal
    LOGD("auth with monitor SP protocal");
    pthread_create(&authDown_read, NULL, monitor_auth_packet_loop_work_s, NULL);
} else {
    // auth with runthOS SP protocal
    LOGD("auth with runthOS SP protocal");
    pthread_create(&authDown_read, NULL, auth_packet_loop_work, NULL);
}
```

# 总结

* 打开 pax.ctrl.compatible.monitor_authdownload 后,授权成功,解一下selinux相关权限就可以