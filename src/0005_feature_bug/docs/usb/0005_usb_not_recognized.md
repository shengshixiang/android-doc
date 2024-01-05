# 概要

测试反馈,经过NeptunePass两个apk测试后,usb不识别

具体必现手段未知

# 现象

插入usb,有电池图标,插入耳机可以识别,插入电脑usb,不识别

# 分析

插入耳机识别,证明cc跟耳机通道都是好的

猜测usb模式被配置错误

# 手段

计算器,输入!3646633= ,切换usb模式  只有部分项目有,一些项目没有

果然adb口出来

# Log

通过syslog捉取log分析

发现usb口被配置成none,所以导致usb不识别

```
[2023-12-01 17:09:26].799 I/init    (    0): processing action (sys.usb.config=adb,acm0,acm1 && sys.usb.configfs=1 && sys.usb.ffs.ready=1 && sys.usb.mode=pax) from (/vendor/etc/init/hw/init.qcom.usb.rc:1763)
[2023-12-01 17:13:31].050 I/init    (    0): processing action (sys.usb.config=none && sys.usb.configfs=1) from (/vendor/etc/init/hw/init.qcom.usb.rc:154)
[2023-12-01 17:13:31].065 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f4' action=sys.usb.config=none && sys.usb.configfs=1 (/vendor/etc/init/hw/init.qcom.usb.rc:158) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-01 17:13:31].065 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f5' action=sys.usb.config=none && sys.usb.configfs=1 (/vendor/etc/init/hw/init.qcom.usb.rc:159) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-01 17:13:31].066 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f6' action=sys.usb.config=none && sys.usb.configfs=1 (/vendor/etc/init/hw/init.qcom.usb.rc:160) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-01 17:13:31].066 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f7' action=sys.usb.config=none && sys.usb.configfs=1 (/vendor/etc/init/hw/init.qcom.usb.rc:161) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-01 17:13:31].067 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f8' action=sys.usb.config=none && sys.usb.configfs=1 (/vendor/etc/init/hw/init.qcom.usb.rc:162) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-01 17:13:31].067 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f9' action=sys.usb.config=none && sys.usb.configfs=1 (/vendor/etc/init/hw/init.qcom.usb.rc:163) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-01 17:13:31].068 I/init    (    0): processing action (sys.usb.config=none && sys.usb.configfs=1) from (/system/etc/init/hw/init.usb.configfs.rc:1)
[2023-12-01 17:13:31].070 I/init    (    0): Command 'write /config/usb_gadget/g1/UDC none' action=sys.usb.config=none && sys.usb.configfs=1 (/system/etc/init/hw/init.usb.configfs.rc:2) took 2ms and failed: Unable to write to file '/config/usb_gadget/g1/UDC': Unable to write file contents: No such device
[2023-12-01 17:13:31].070 I/init    (    0): Sending signal 9 to service 'adbd' (pid 1160) process group...
[2023-12-04 11:12:51].306 I/init    (    0): processing action (sys.usb.config=diag,serial_cdev,rmnet,dpl,qdss,adb && sys.usb.configfs=1 && sys.usb.ffs.ready=1) from (/vendor/etc/init/hw/init.qcom.usb.rc:1123)
[2023-12-04 11:12:51].309 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f1' action=sys.usb.config=diag,serial_cdev,rmnet,dpl,qdss,adb && sys.usb.configfs=1 && sys.usb.ffs.ready=1 (/vendor/etc/init/hw/init.qcom.usb.rc:1125) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-04 11:12:51].310 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f2' action=sys.usb.config=diag,serial_cdev,rmnet,dpl,qdss,adb && sys.usb.configfs=1 && sys.usb.ffs.ready=1 (/vendor/etc/init/hw/init.qcom.usb.rc:1126) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-04 11:12:51].310 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f3' action=sys.usb.config=diag,serial_cdev,rmnet,dpl,qdss,adb && sys.usb.configfs=1 && sys.usb.ffs.ready=1 (/vendor/etc/init/hw/init.qcom.usb.rc:1127) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-04 11:12:51].310 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f4' action=sys.usb.config=diag,serial_cdev,rmnet,dpl,qdss,adb && sys.usb.configfs=1 && sys.usb.ffs.ready=1 (/vendor/etc/init/hw/init.qcom.usb.rc:1128) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-04 11:12:51].310 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f5' action=sys.usb.config=diag,serial_cdev,rmnet,dpl,qdss,adb && sys.usb.configfs=1 && sys.usb.ffs.ready=1 (/vendor/etc/init/hw/init.qcom.usb.rc:1129) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-04 11:12:51].310 I/init    (    0): Command 'rm /config/usb_gadget/g1/configs/b.1/f6' action=sys.usb.config=diag,serial_cdev,rmnet,dpl,qdss,adb && sys.usb.configfs=1 && sys.usb.ffs.ready=1 (/vendor/etc/init/hw/init.qcom.usb.rc:1130) took 0ms and failed: unlink() failed: No such file or directory
[2023-12-04 11:12:51].360 I/OpenGLRenderer(10587): Davey! duration=9223201932954ms; Flags=2, FrameTimelineVsyncId=12290805, IntendedVsync=170103900772043, Vsync=170103900772043, InputEventId=0, HandleInputStart=170103900772043, AnimationStart=170103900772043, PerformTraversalsStart=170103900772043, DrawStart=170103900772043, FrameDeadline=170103934105375, FrameInterval=0, FrameStartTime=16666666, SyncQueued=170103905160421, SyncStart=170103905162765, IssueDrawCommandsStart=170103905732505, SwapBuffers=170103907269588, FrameCompleted=9223372036854775807, DequeueBufferDuration=33698, QueueBufferDuration=2233438, GpuCompleted=9223372036854775807, SwapBuffersCompleted=170103910910369, DisplayPresentTime=0, 
[2023-12-04 11:12:51].362 I/adbd    (10625): USB event: FUNCTIONFS_BIND
```