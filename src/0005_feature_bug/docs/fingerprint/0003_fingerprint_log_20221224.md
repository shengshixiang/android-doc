# README

指纹的一些log分析

# log
```
行 107: 12-25 05:50:28.134     0     0 I fortsense-fsfp_ctl-245: fsfp_ctl_device_irq(irq = 195, ..) toggled.
行 107: 12-25 05:50:28.134     0     0 I fortsense-fsfp_ctl-245: fsfp_ctl_device_irq(irq = 195, ..) toggled.
行 108: 12-25 05:50:28.134     0     0 I fortsense-fsfp_ctl-237: fsfp_ctl_device_event(..) enter.
行 108: 12-25 05:50:28.134     0     0 I fortsense-fsfp_ctl-237: fsfp_ctl_device_event(..) enter.
行 109: 12-25 05:50:28.136  1177  1342 I  1177  1342 [fsfp-hal-device] : (847) got device falling edge interrupt, signal the semaphore.
行 110: 12-25 05:50:28.137  1177  1639 I  1177  1639 [fsfp-hal-v1.4.0.10] : (2475) got the device interrupt. 0
行 111: 12-25 05:50:28.158  1177  1639 I  1177  1639 [fsfp-client-qs] : (316) ---8<---- TA LOG BEGINS ---------
行 112: 12-25 05:50:28.158  1177  1639 I  1177  1639 [fsfp-ic] : (6977) ifgr_cur.sum: 126+11//130+2/131+13/131+17/138+17/118+1/119+3/118+16/127+18, 12/4/5, 126/126/36/0/0, 74/68
行 113: 12-25 05:50:28.158  1177  1639 I  1177  1639 [fsfp-tee-v1.4.0.10] : (2549) 'sf_interrupt_query' leave, time: 1ms, query int status: opstate SF_OPERATION_STATE_AUTH, device SF_DEVICE_STAT_WAITING_IMAGE, irq SF_DEVICE_STAT_IMAGE_READY
行 114: 12-25 05:50:28.158  1177  1639 I  1177  1639 [fsfp-client-qs] : (333) --------- TA LOG FINISH ---->8---
行 115: 12-25 05:50:28.158  1177  1639 I  1177  1639 [fsfp-hal-v1.4.0.10] : (3392) (1344) 'notifyCallback' enter, msg type: 1 acquired_info = 0
行 117: 12-25 05:50:28.159  1177  1639 I  1177  1639 [fsfp-hal-v1.4.0.10] : (3392) (1344) 'notifyCallback' enter, msg type: 1 acquired_info = 1002
行 124: 12-25 05:50:28.364  1177  1639 I  1177  1639 [fsfp-client-qs] : (316) ---8<---- TA LOG BEGINS ---------
行 125: 12-25 05:50:28.364  1177  1639 I  1177  1639 [fsfp-ic] : (4899) enter SF_DEVICE_MODE_AUTOAGC_SCAN mode.
行 126: 12-25 05:50:28.364  1177  1639 I  1177  1639 [fsfp-ic] : (3842) 'ic_get_finger_status' finger: touch
行 127: 12-25 05:50:28.364  1177  1639 I  1177  1639 [fsfp-tee-v1.4.0.10] : (806) 'do_read_multi_sensor_data_check' consumed time 0//8/29/9//46 ms, check valid: 1/-1/0/0/SF_FINGER_TOUCH//N
行 128: 12-25 05:50:28.364  1177  1639 I  1177  1639 [fsfp-algo] : (516) retry0 api_algo_get_fingerquality(0x17860d1c) = 36. erea 72
行 129: 12-25 05:50:28.364  1177  1639 I  1177  1639 [fsfp-algo] : (530) retry0 api_algo_fingerfeature_handle(..) consumed time       80 ms.
行 130: 12-25 05:50:28.364  1177  1639 I  1177  1639 [fsfp-algo] : (1044) api_algo_vertify_feature, alg_ver: 2048506_2108230, idx = 0/1, fid =  962279844, score =  60, study = 0/1, enroll_frame: 17/ 5
行 131: 12-25 05:50:28.365  1177  1639 I  1177  1639 [fsfp-algo] : (1121) retry0 api_algo_vertify_feature totally consumed time ( 55 +   0) =       55 ms.
行 132: 12-25 05:50:28.365  1177  1639 I  1177  1639 [fsfp-tee-v1.4.0.10] : (997) retry0 do_authenticate: score =  60, fid = 962279844, study = 0(Y), authenticate total time: 182 ms.
行 133: 12-25 05:50:28.365  1177  1639 I  1177  1639 [fsfp-tee-v1.4.0.10] : (2655) 'sf_interrupt_process' leave, time: 185ms, err = 0
行 134: 12-25 05:50:28.365  1177  1639 I  1177  1639 [fsfp-client-qs] : (333) --------- TA LOG FINISH ---->8---
行 135: 12-25 05:50:28.365  1177  1639 I  1177  1639 [fsfp-hal-v1.4.0.10] : (2720) AUTHENTICATION in TA consumed time 21/206//228 ms.
行 136: 12-25 05:50:28.365  1177  1639 I  1177  1639 [fsfp-hal-v1.4.0.10] : (3392) (1459) 'notifyCallback' enter, msg type: 1 acquired_info = 0
行 138: 12-25 05:50:28.365  1177  1639 I  1177  1639 [fsfp-hal-v1.4.0.10] : (3408) (1463) 'notifyCallback' enter, msg type: 5 gid = 0 fid = 962279844(962279844)
行 147: 12-25 05:50:28.374     0     0 I fortsense-fsfp_ctl-245: fsfp_ctl_device_irq(irq = 195, ..) toggled.
行 147: 12-25 05:50:28.374     0     0 I fortsense-fsfp_ctl-245: fsfp_ctl_device_irq(irq = 195, ..) toggled.
行 148: 12-25 05:50:28.374     0     0 I fortsense-fsfp_ctl-237: fsfp_ctl_device_event(..) enter.
行 148: 12-25 05:50:28.374     0     0 I fortsense-fsfp_ctl-237: fsfp_ctl_device_event(..) enter.
```

# 解锁速度

* 解锁速度的log,搜索 AUTHENTICATION in TA consumed time

```
[fsfp-hal-v1.4.0.10] : (2720) AUTHENTICATION in TA consumed time 21/206//228 ms.
```