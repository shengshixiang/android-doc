# microcom

android 12 使用microcom调试串口

* 默认波特率
```
speeds[] = {50, 75, 110, 134, 150, 200, 300, 600, 1200, 1800, 2400,
                    4800, 9600, 19200, 38400, 57600, 115200, 230400, 460800,
                    500000, 576000, 921600, 1000000, 1152000, 1500000, 2000000,
                    2500000, 3000000, 3500000, 4000000};
```

# 命令

* Microcom -t 5000 -s 115200 /dev/ttyGS0

    * -t timeout
    * -s 波特率
    * /dev/ttyGS0 串口设备


* Ctrl+] 推出microcom

# 修改

* 启用硬件流控,并把收到的数据 打到标准输出,并且收到数据之前先打印 read data begin, 收完后,read data end

```
+++ b/QSSI.12/external/toybox/lib/tty.c
@@ -92,7 +92,8 @@ int set_terminal(int fd, int raw, int speed, struct termios *old)
   // Any key unblocks output, swap CR and NL on input
   termio.c_iflag = IXANY|ICRNL|INLCR;
   if (toys.which->flags & TOYFLAG_LOCALE) termio.c_iflag |= IUTF8;
-
+  termio.c_iflag &= ~IXON; //不使用軟件流控制
+  termio.c_iflag &= ~IXOFF; //不使用軟件流控制
   // Output appends CR to NL, does magic undocumented postprocessing
   termio.c_oflag = ONLCR|OPOST;
 
@@ -105,6 +106,7 @@ int set_terminal(int fd, int raw, int speed, struct termios *old)
   // "extended" behavior: ctrl-V quotes next char, ctrl-R reprints unread chars,
   // ctrl-W erases word
   termio.c_lflag = ISIG|ICANON|ECHO|ECHOE|ECHOK|ECHOCTL|ECHOKE|IEXTEN;
+  termio.c_cflag |= CRTSCTS; //使用硬件流控制
 
   if (raw) cfmakeraw(&termio);

diff --git a/QSSI.12/external/toybox/toys/net/microcom.c b/QSSI.12/external/toybox/toys/net/microcom.c
old mode 100644
new mode 100755
index 963445c2e8e..af454806dab
--- a/QSSI.12/external/toybox/toys/net/microcom.c
+++ b/QSSI.12/external/toybox/toys/net/microcom.c
@@ -32,6 +32,8 @@ static void restore_states(int i)
   if (TT.stok) tcsetattr(0, TCSAFLUSH, &TT.old_stdin);
   tcsetattr(TT.fd, TCSAFLUSH, &TT.old_fd);
 }
+char tips_begin[] = "read data from connecttion begin,\n";
+char tips_end[] = "\nread data from connecttion end,\n";
 
 void microcom_main(void)
 {
@@ -59,10 +61,13 @@ void microcom_main(void)
   fds[0].events = fds[1].events = POLLIN;
 
   while (poll(fds, 2, -1) > 0) {
-
     // Read from connection, write to stdout.
     if (fds[0].revents) {
-      if (0 < (i = read(TT.fd, toybuf, sizeof(toybuf)))) xwrite(0, toybuf, i);
+      if (0 < (i = read(TT.fd, toybuf, sizeof(toybuf)))) {
+        xwrite(1, tips_begin, sizeof(tips_begin));
+        xwrite(1, toybuf, i);
+        xwrite(1, tips_end, sizeof(tips_end));
+      }
       else break;
     }
```

# ps

X:\code\a6650_2\QSSI.12\external\toybox\toys\net\microcom.c 有poll的用法