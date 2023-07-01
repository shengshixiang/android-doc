# push不提示空间满

使用dd if=/dev/zero bs=8192 count=3000000 of=/sdcard/32Gb.file,填满 /sdcard/ /data空间后

使用adb push 还可以正常push文件,不提示

```
adb: error: failed to copy 'C:\Users\xielianxiong\Desktop\Downloads\PayDroid_12.0.0_Ginkgo_V23.1.00_20230526_Release.paydroid' to '/sdcard/1.2G_001': remote couldn't create file: No space left on device
```

# 原因

原因是把 userdata的文件系统从f2fs 改成了 ext4