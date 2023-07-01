# 问题

项目休眠后,唤醒,sp 唤醒比较快,然后向ap发送 ic卡是否在位的消息,由于ap串口唤醒晚,导致丢数据

# log

**tid:0x200038b8, trans_send(224) warning:timeout to recv ACK, re-send data(index:59)**

```
[2023/5/15 17:28:46] z_power_soc_deep_sleep,390: SOC go to active state.
[2023/5/15 17:28:46] sci do_resume[1601]
[2023/5/15 17:28:46] sci_pin_type_set,479,port err!
[2023/5/15 17:28:46] sci_pin_type_set,479,port err!
[2023/5/15 17:28:46] sci_pin_type_set,479,port err!
[2023/5/15 17:28:46] gpio_det_irq_handler,460,1 sci_controller_data->sci_detect_status:0 
[2023/5/15 17:28:46] I: device event #2 is set
[2023/5/15 17:28:46] 
[2023/5/15 17:28:46] D: enter dev_ctl_handler, line:597
[2023/5/15 17:28:46] 
[2023/5/15 17:28:46] D: dev_ctl_handler: command:8001
[2023/5/15 17:28:46] 
[2023/5/15 17:28:46] D: device name:ros_dev_system
[2023/5/15 17:28:46] 
[2023/5/15 17:28:46] D: enter dev_ctl_nrf_send, line:568
[2023/5/15 17:28:46] 
[2023/5/15 17:28:48] 7E E7 0B 00 B2 03 6F 4C 00 00 FF 02 04 64 04 00 
[2023/5/15 17:28:48] 00 00 F6 
[2023/5/15 17:28:48] tid:0x200038b8, trans_send(224) warning:timeout to recv ACK, re-send data(index:59)
[2023/5/15 17:28:48] tid:0x200036c0, trans_recv_thread_handler(216) warning:recv package index should be 60, but 61
[2023/5/15 17:28:48] D: enter dev_ctl_handler, line:597
[2023/5/15 17:28:48] 
[2023/5/15 17:28:48] D: dev_ctl_handler: command:1004
[2023/5/15 17:28:48] 
[2023/5/15 17:28:48] D: device name:ros_dev_icc
[2023/5/15 17:28:48] 
[2023/5/15 17:28:48] devio_icc_ctl(149)
[2023/5/15 17:28:48] devio_icc_ctl(151): OsIccDetect()=-2800
[2023/5/15 17:28:48] D: enter dev_ctl_nrf_send, line:568
[2023/5/15 17:28:48] 
[2023/5/15 17:28:52] D: enter dev_ctl_handler, line:597
[2023/5/15 17:28:52] 
[2023/5/15 17:28:52] D: dev_ctl_handler: command:8001
[2023/5/15 17:28:52] 
[2023/5/15 17:28:52] D: device name:ros_dev_system
```

# 原因

高通的串口使用runtime suspend  机制, 使用的时候,才去resume.

猜测是,kernel唤醒的时候, ap还没用到串口, 所以串口还没唤醒.

所以sp给串口发送ic卡的状态,ap是没有收到的, sp这边的现象就是没有收到ack

# 解决方法

串口这种双方通讯的,最好不要使用pm runtime机制,因为pm runtime会自动休眠,导致对方给你发信息你收不到.

并且,pm_runtime_set_autosuspend_delay(&pdev->dev, -1); 设置不自动休眠,那如果上层拿着串口的fd不释放,就会导致整个系统不休眠

所以采用 disable pm runtime的机制,如附件. [disable_runtime](files/msm_geni_serial.c)

# ps SIMPLE_DEV_PM_OPS 的定义

```
365 #define SIMPLE_DEV_PM_OPS(name, suspend_fn, resume_fn) \
366 const struct dev_pm_ops name = { \
367     SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
368 }

316 #ifdef CONFIG_PM_SLEEP
317 #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn) \
318     .suspend = suspend_fn, \
319     .resume = resume_fn, \
320     .freeze = suspend_fn, \
321     .thaw = resume_fn, \
322     .poweroff = suspend_fn, \
323     .restore = resume_fn,
324 #else
325 #define SET_SYSTEM_SLEEP_PM_OPS(suspend_fn, resume_fn)
326 #endif


static const struct dev_pm_ops msm_geni_serial_pm_ops = {
	.runtime_suspend = msm_geni_serial_runtime_suspend,
	.runtime_resume = msm_geni_serial_runtime_resume,
	.suspend_noirq = msm_geni_serial_sys_suspend_noirq,
	.resume_noirq = msm_geni_serial_sys_resume_noirq,
};
```