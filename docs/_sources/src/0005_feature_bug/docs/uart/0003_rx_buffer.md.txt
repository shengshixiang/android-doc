# 概要

项目测试部反馈,测试ic卡加sam卡失败,IccCmdExchange_TOL7

# LOG

sp发送了4113加上8个字节的头数据, 总共发送4113+8=4121个数据

但是ap实际只收到4088+8=4096个数据

```
12-25 16:14:13.006   730   753 D ttyPosApi: victor_icc,select end ret = 0,
12-25 16:14:13.007   730   753 W transport: tid:0x20ec9cb0, trans_recv_thread_handler(206) warning:recevie data timeout, expected len:4113, but:4088,print trans_header begin,
12-25 16:14:13.007   730   753 W transport: 
12-25 16:14:13.007   730   753 W transport: tid:0x20ec9cb0, trans_recv_thread_handler(208) warning:
12-25 16:14:13.007   730   753 W transport: ,print_hex trans_header end print_hex data begin
12-25 16:14:13.007   730   753 W transport: 01 FF 00 FF 00 79 10 08 00 00 00 00 6D 00 00 00 
12-25 16:14:13.007   730   753 W transport: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
12-25 16:14:13.007   730   753 W transport: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
12-25 16:14:13.007   730   753 W transport: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
12-25 16:14:13.007   730   753 W transport: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
12-25 16:14:13.007   730   753 W transport: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
12-25 16:14:13.007   730   753 W transport: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 
```

# 分析

逻辑分析仪捉图形,发现sp发送的数据是好的

![0003_0001](images/0003_0001.png)

并且发现每次丢掉的数据都是尾巴数据,并且每次接收的log都是4088+8=4096

![0003_0002](images/0003_0002.png)

# 总结

结合以上分析,猜测是串口buffer只配置了4096个,导致每次只能接收4096

# 修改

* idh.code/bsp/kernel/kernel5.4/drivers/tty/serial/sprd_serial.c

```
//[feature]-modify-begin xielianxiong@paxsz.com,20231226 for big data for sp send one time
//#define SPRD_UART_RX_SIZE	(UART_XMIT_SIZE)
#define SPRD_UART_RX_SIZE      (UART_XMIT_SIZE*2)
//[feature]-modify-end xielianxiong@paxsz.com,20231226 for big data for sp send one time
```

* 捉kernel 开机,可以看到原来的UART_XMIT_SIZE 刚好等于4096,乘以2倍后,变成8192

```
[    3.922418] c7victor_icc[UART]sprd_uart_dma_init UART_XMIT_SIZE=4096, SPRD_UART_RX_SIZE = 8192,
```

# 复测

IccCmdExchange_TOL7 正常测试,pass

# 关于修改串口buffer的上层api接口(未经验证)

* 使用`ioctl(fd, TIOCSSERIAL, &serial);`接口

```
#include <linux/serial.h>
struct serial_struct serial; 
...
serial.xmit_fifo_size = FIFO_SIZE; // what is "xmit" ?? 
ioctl(fd, TIOCSSERIAL, &serial); 
...
```

* 完整例子

先使用`TIOCGSERIAL`获取原有的serial配置,再使用`TIOCSSERIAL`设置新的配置

```
#include <asm-generic/ioctl.h>
#include <termios.h>
#include <linux/serial.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
 
int SetUartBuffSize(char *dev_path) {  
  int ret;
  int fd =  open(dev_path, O_RDWR | O_NOCTTY | O_NONBLOCK);
  if(fd < 0){
    return -1;
  }
  struct serial_struct serial;
  ret = ioctl(fd, TIOCGSERIAL, &serial);
  if (ret != 0) {
    close(fd);
    return -2;
  }
  serial.xmit_fifo_size = 4096*2;
  ret = ioctl(fd, TIOCSSERIAL, &serial);
  if(ret != 0) {
    close(fd);
    return -3;
  }
  close(fd);
  return 0;
}
```