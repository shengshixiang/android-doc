# README

linux kernel 内核 函数 function 常用的一些函数用法备注

# device_may_wakeup

device_may_wakeup是一个Linux内核函数，它可以控制系统中设备是否可以唤醒系统，也就是可以通过某种方式激活系统的状态，从而使系统能够从休眠状态恢复到正常的工作状态。这个函数有助于实现设备的省电功能，可以让系统更加省电。

# device_init_wakeup

device_init_wakeup(&client->dev, true);

device_init_wakeup（）函数用于初始化给定设备的唤醒功能，比如：如果该设备能够被唤醒，希望硬件层将其标记为“可以被唤醒”，或者标记为“不能被唤醒”，当设备被唤醒时，中断唤醒功能可以被触发来唤醒硬件并给定设备。 device_init_wakeup的主要作用是让内核能够识别设备的唤醒初始化状态，以便内核在特定情况下能够将设备唤醒。

# enable_irq_wake

使能唤醒系统功能

enable_irq_wake是Linux内核中的一个函数，用于将特定的硬件中断唤醒进程。硬件中断唤醒功能可以使特定的硬件中断进入休眠，但是仍然可以唤醒进程。它使得硬件可以在不唤醒整个处理器的情况下唤醒进程。

# disable_irq_wake

关闭唤醒系统功能

disable_irq_wake函数是一个Linux内核函数，用于禁用某一中断的唤醒功能，以避免某种中断发生时唤醒设备。该函数可以禁用中断唤醒，也可以禁止某种中断在某种情况下发生时唤醒设备。

# device_init_wakeup

linux kernel中的device_init_wakeup函数的作用是将设备的wakeup属性初始化为指定的值，并让设备可以唤醒系统。这个函数会检查设备的支持的唤醒事件，以及设备的总线（I2C，SPI等）是否支持唤醒。它会在设备初始化时调用，以便系统能够判断其是否支持唤醒功能。

# probe -EPROBE_DEFER 

probe return -EPROBE_DEFER ,会 重复进入probe

可以用于等待某一个服务起来后,重复进入probe

-EPROBE_DEFER 返回值由Linux内核定义，它代表内核请求稍后重试此调用。它表明这个源不能现在提供它应该提供的服务，但可能在将来可用。内核模块应该尝试重新构造这次调用，直到它得到正常的结果，或者如果它仍然失败而出现 EPROBE_DEFER，则内核模块应该重新尝试重新构造这次调用。

# init_waitqueue_head

wait_queue_head_t read_wq;

init_waitqueue_head(&nfc_dev->read_wq);

init_waitqueue_head 用于初始化等待队列。它将等待队列的 head 初始化为一个空的双向链表，并将其他与等待队列有关的变量初始化为 0。

# mutex_init

struct mutex read_mutex;

mutex_init(&nfc_dev->read_mutex);

mutex_init() 函数是Linux Kernel提供的一种机制，可以用来同步临界资源的互斥访问。它的作用是初始化一个互斥锁，该锁可以用于控制访问临界资源。它可以确保在任何特定时间点，只有一个线程可以访问特定的临界资源。

# spin_lock_init


spin_lock_init函数可以将一个spin_lock类型的对象初始化，一般在使用spin_lock之前都需要先初始化。spin_lock_init函数的作用就是将spin_lock中的lock字段置为未锁定的状态(0)，表示可以被锁定。

## spin lock 与 mutex 区别

* mutex_lock是一个互斥锁，它只能将线程锁定在用户态，而spin_lock_irqsave可以将线程锁定在内核态。

* mutex_lock适用于单处理器系统，而spin_lock_irqsave适用于多处理器系统。

* mutex_lock在持有锁时会睡眠，而spin_lock_irqsave不会。

* mutex_lock的切换是可中断的，而spin_lock_irqsave的切换是不可中断的。

* mutex_lock可以保证排他性，而spin_lock_irqsave可以保证原子性。

```
spin lock一般用在中断
spin_lock_init(&i2c_dev->irq_enabled_lock);
int i2c_disable_irq(struct nfc_dev *dev)
{
	unsigned long flags;

	spin_lock_irqsave(&dev->i2c_dev.irq_enabled_lock, flags);
	if (dev->i2c_dev.irq_enabled) {
		disable_irq_nosync(dev->i2c_dev.client->irq);
		dev->i2c_dev.irq_enabled = false;
	}
	spin_unlock_irqrestore(&dev->i2c_dev.irq_enabled_lock, flags);

	return 0;
}
```

```
ssize_t nfc_i2c_dev_read(struct file *filp, char __user *buf, size_t count,
			 loff_t *offset)
{
	int ret;
	mutex_lock(&nfc_dev->read_mutex);
	ret = i2c_read(nfc_dev, nfc_dev->read_kbuf, count, 0);
	if (ret > 0) {
		read_printf(nfc_dev->read_kbuf, ret);
		if (copy_to_user(buf, nfc_dev->read_kbuf, ret)) {
			pr_warn("%s: failed to copy to user space\n", __func__);
			ret = -EFAULT;
		}
	}
	mutex_unlock(&nfc_dev->read_mutex);
	return ret;
}
```

# wait_event_interruptible_timeout

wait_event_interruptible_timeout() 是一个软中断可等待的函数，它的本质是调用 prepare_to_wait() 函数把进程放入等待队列，然后调用 schedule() 函数让出 CPU，若超过一定的时间，wait_event_interruptible_timeout() 就会调用 schedule_timeout() 函数超时退出。它可以用来让进程睡眠一段时间，等待其他事件发生。

# wait_event_interruptible

wait_event_interruptible()用于等待某一条件变为真. 该函数使进程进入睡眠态直到某个条件发生. 如果发生这个条件，就会返回0，否则返回负值(如果进程被信号中断，就会返回-ERESTARTSYS).

该函数通常用于等待某种事件，比如设备的驱动程序可以使用它来等待设备的某些状态的变更，进程间通信中也会使用它来等待某种消息.

## wait_event_interruptible 和 wait_event_interruptible_timeout 区别

wait_event_interruptible_timeout 在等待一个条件满足时，有了超时时间限制，等待时间超过指定的超时时间还没有满足条件就会返回。 wait_event_interruptible 没有超时时间限制，可以一直等待满足条件，直到条件满足才会返回。