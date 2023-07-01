# 主题

熔丝后,单独编译kernel, fastboot flash boot,启动失败

# log显示如下

* 第一次log提示

**avb_slot_verify.c:256: ERROR: boot_a: Hash of data does not match digest in descriptor.**

```
[2023/5/16 9:56:07] Total Image Read size : 4096 Bytes
[2023/5/16 9:56:07] Invalid vendor_boot partition. Skipping
[2023/5/16 9:56:07] Load Image vbmeta_a total time: 2 ms 
[2023/5/16 9:56:07] Load Image vbmeta_system_a total time: 1 ms 
[2023/5/16 9:56:07] Load Image boot_a total time: 65 ms 
[2023/5/16 9:56:07] avb_slot_verify.c:256: ERROR: boot_a: Hash of data does not match digest in descriptor.
[2023/5/16 9:56:07] No bootable slots found enter fastboot mode
[2023/5/16 9:56:07] VB2: boot state: red(3)
[2023/5/16 9:56:37] Start EBS        [33751] 
[2023/5/16 9:56:37] BDS: LogFs sync skipped, Unsupported
[2023/5/16 9:56:37] Write: NumHalfSectors 0x2, ReliableWriteCount 0x2 
```

* 接着自动重启,log提示

**Err: line:1655 FindBootableSlot() status: Load Error**

```
[2023/5/16 9:56:41] GetVmData: No Vm data present! Status = (0x3)
[2023/5/16 9:56:41] VM Hyp calls not present
[2023/5/16 9:56:41] Slot _a is unbootable, trying alternate slot
[2023/5/16 9:56:41] Err: line:1655 FindBootableSlot() status: Load Error
[2023/5/16 9:56:41] Err: line:1656 LoadImageAndAuth() status: Load Error
[2023/5/16 9:56:41] LoadImageAndAuth failed: Load Error
[2023/5/16 9:56:41] Launching fastboot
```

# 分析

因为烧录efuse后,对vbmeta等有强制校验,所以需要关闭 avb

# 关闭avb方法

* 开发者选项,打开OEM unlocking菜单

* adb reboot bootloader

* fastboot flashing unlock

* 按音量下键,选中 UNLOCK THE BOOTLOADER菜单

* 按power键,确认,机器自动重启

* adb disable-verity

* adb reboot 生效

* 开使fastboot flash boot

# reboot log

关闭avb,flash 其他image后,可以顺利开机,但是log还是会有avb的提醒报错,但是可以允许开机

```
[2023/5/16 10:17:19] Booting from slot (_a)
[2023/5/16 10:17:19] Booting Into Mission Mode
[2023/5/16 10:17:19] Loading Image Start : 3580 ms
[2023/5/16 10:17:19] Loading Image Done : 3582 ms
[2023/5/16 10:17:19] Total Image Read size : 4096 Bytes
[2023/5/16 10:17:19] Invalid vendor_boot partition. Skipping
[2023/5/16 10:17:19] Load Image vbmeta_a total time: 2 ms 
[2023/5/16 10:17:19] avb_vbmeta_image.c:206: ERROR: Hash does not match!
[2023/5/16 10:17:19] avb_slot_verify.c:575: ERROR: vbmeta_a: Error verifying vbmeta image: HASH_MISMATCH
[2023/5/16 10:17:19] Load Image vbmeta_system_a total time: 2 ms 
[2023/5/16 10:17:19] Load Image boot_a total time: 327 ms 
[2023/5/16 10:17:19] avb_slot_verify.c:256: ERROR: boot_a: Hash of data does not match digest in descriptor.
[2023/5/16 10:17:19] Load Image dtbo_a total time: 84 ms 
[2023/5/16 10:17:19] VB2: Authenticate complete! boot state is: orange
[2023/5/16 10:17:19] VB2: boot state: orange(1)
[2023/5/16 10:17:19] Memory Base Address: 0x40000000
[2023/5/16 10:17:19] Decompressing kernel image total time: 455 ms
```