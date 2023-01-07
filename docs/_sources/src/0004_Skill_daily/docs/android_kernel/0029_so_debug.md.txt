# README

so 的一些报错,堆栈分析

# log

```
01-01 00:36:54.200  1171  1171 F DEBUG   : *** *** *** *** *** *** *** *** *** *** *** *** *** *** *** ***
01-01 00:36:54.200  1171  1171 F DEBUG   : Build fingerprint: 'qti/unknown/unknown:12/SKQ1.220119.001/eng.xielx.20220824.220204:userdebug/test-keys'
01-01 00:36:54.200  1171  1171 F DEBUG   : Revision: '0'
01-01 00:36:54.200  1171  1171 F DEBUG   : ABI: 'arm64'
01-01 00:36:54.200  1171  1171 F DEBUG   : Timestamp: 1970-01-01 00:36:52.802167809-0500
01-01 00:36:54.200  1171  1171 F DEBUG   : Process uptime: 0s
01-01 00:36:54.200  1171  1171 F DEBUG   : Cmdline: /system/bin/paxservice
01-01 00:36:54.200  1171  1171 F DEBUG   : pid: 971, tid: 1162, name: paxservice  >>> /system/bin/paxservice <<<
01-01 00:36:54.200  1171  1171 F DEBUG   : uid: 0
01-01 00:36:54.200  1171  1171 F DEBUG   : signal 11 (SIGSEGV), code 2 (SEGV_ACCERR), fault addr 0x7c96c5b43c
01-01 00:36:54.200  1171  1171 F DEBUG   :     x0  0000000000000000  x1  00000000ffffffff  x2  0000000000000010  x3  0000000000000000
01-01 00:36:54.200  1171  1171 F DEBUG   :     x4  0000007c96c6ebc0  x5  00000079866a7c10  x6  0000007c96c6fd80  x7  0000000000000008
01-01 00:36:54.200  1171  1171 F DEBUG   :     x8  0000007c96c74000  x9  0000000000000002  x10 0000000000000001  x11 0000000000000000
01-01 00:36:54.200  1171  1171 F DEBUG   :     x12 0000000000000000  x13 0000000000000000  x14 0000000000000001  x15 0000000000000000
01-01 00:36:54.200  1171  1171 F DEBUG   :     x16 0000007c96c6da40  x17 0000007c96c56ff4  x18 0000007985b6a000  x19 0000007c96c6fd80
01-01 00:36:54.200  1171  1171 F DEBUG   :     x20 0000000000000001  x21 0000000000000000  x22 0000007c96c6e000  x23 0000000000000008
01-01 00:36:54.200  1171  1171 F DEBUG   :     x24 00000079866a8000  x25 0000007c96c6e020  x26 00000000ffffffff  x27 00000000000000ff
01-01 00:36:54.200  1171  1171 F DEBUG   :     x28 00000000000000ff  x29 00000079866a7ba0
01-01 00:36:54.200  1171  1171 F DEBUG   :     lr  0000007c96c443e4  sp  00000079866a7b40  pc  0000007c96c5b43c  pst 0000000080000000
01-01 00:36:54.200  1171  1171 F DEBUG   : backtrace:
01-01 00:36:54.200  1171  1171 F DEBUG   :       #00 pc 000000000004143c  /system/lib64/libpaxspdev.so!libpaxspdev.so (__CortexA53843419_3D000+0) (BuildId: 8756492e5eb335ae63fa68f924e8d3b3)
01-01 00:36:54.200  1171  1171 F DEBUG   :       #01 pc 000000000002a3e0  /system/lib64/libpaxspdev.so (receive_handler+1348) (BuildId: 8756492e5eb335ae63fa68f924e8d3b3)
01-01 00:36:54.201  1171  1171 F DEBUG   :       #02 pc 000000000003d16c  /system/lib64/libpaxspdev.so (trans_recv_callback_thread_handler+212) (BuildId: 8756492e5eb335ae63fa68f924e8d3b3)
01-01 00:36:54.201  1171  1171 F DEBUG   :       #03 pc 00000000000b6a24  /apex/com.android.runtime/lib64/bionic/libc.so (__pthread_start(void*)+264) (BuildId: 369edc656806aeaf384cbeb8f7a347af)
01-01 00:36:54.201  1171  1171 F DEBUG   :       #04 pc 00000000000532bc  /apex/com.android.runtime/lib64/bionic/libc.so (__start_thread+68) (BuildId: 369edc656806aeaf384cbeb8f7a347af)
```

# 拆解

## 000000000004143c

从log可以看到backtrace: #00 pc 000000000004143c  /system/lib64/libpaxspdev.so!libpaxspdev.so

地址是0x4143c,so是libpaxspdev.so

* ./prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-addr2line -f -e out/target/product/qssi/symbols/system/lib64/libpaxspdev.so 0x4143c

    > __CortexA53843419_3D000
    > paramcfg.c:?

## 000000000002a3e0

再拆解 #01 pc 000000000002a3e0  /system/lib64/libpaxspdev.so (receive_handler+1348) 

* ./prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-addr2line -f -e out/target/product/qssi/symbols/system/lib64/libpaxspdev.so 0x2a3e0

    > receive_handler
    > paxdroid/external/pax/lib/librunthosspdev/libspc/nrf_rpc/nrf_rpc.c:502

## 000000000003d16c

* ./prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-addr2line -f -e out/target/product/qssi/symbols/system/lib64/libpaxspdev.so 0x3d16c

    > trans_recv_callback_thread_handler
    > paxdroid/external/pax/lib/librunthosspdev/libspc/transport/trans.c:119

# addr2line

![0029_0001.png](images/0029_0001.png)
