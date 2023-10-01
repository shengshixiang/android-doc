# 概要

展锐新项目,设计不带电池,需要插入usb直接启动

# 问题

* 指针获取不匹配

通过函数获取的指针 get_device_operation(); 跟函数来里面的指针打印,不匹配,不知道为什么

![0005_0001](images/0005_0001.png)

![0005_0002](images/0005_0002.png)

```
[2023/9/15 18:39:12] [00004746] victor,load_config in,config_loaded = 0,
[2023/9/15 18:39:12] [00004756] victor,load_config ret = 0,
[2023/9/15 18:39:12] [00004759] victor,begin get_device_operation =0000000000000000,
[2023/9/15 18:39:12] [00004765] victor,get_device_operation in,device_ops_adapter = 000000009f86d228,
[2023/9/15 18:39:12] [00004772] victor,device_ops_adapter->set_default_misc = 000000009f0931ac,
[2023/9/15 18:39:12] [00004779] victor get_device_operation end, device_operation_ptr = ffffffff9f86d228,
[2023/9/15 18:39:12] [00004786] "Synchronous Abort" handler, esr 0x96000004
[2023/9/15 18:39:12] [00004791] ELR:     9f08b3d8
[2023/9/15 18:39:12] [00004793] LR:      9f08b3cc
[2023/9/15 18:39:12] [00004796] x0 : 000000009f0bbeb6 x1 : 0000000000000000
[2023/9/15 18:39:12] [00004801] x2 : 0000000000000000 x3 : 000000000003ffd0
[2023/9/15 18:39:12] [00004806] x4 : 000000009de83f2d x5 : 000000000000000a
```

# 解决方法

只能把函数放到原来正常调用的文件,不在通过get_device_operation() 函数返回指针

```
int set_default_misc(void)
{
	if(device_ops_adapter && device_ops_adapter->set_default_misc){
		return device_ops_adapter->set_default_misc();
	}
	else
	{
        return -1;
	}
}
```

# 调试

* idh.code/bsp/bootloader/u-boot15/pax/devices/pax_device_uis8581e.c

先强制搞成A8600

```
device_operation * get_device_op(unsigned char *term_name)
{
	int i;
	init_term_device_operation_list();
	for(i = 0; i < LIST_MAX_LEN; i++)
	{
		//if(memcmp(term_name, term_device_operation_list[i].term_name, strlen(term_name)) == 0)
		printf("%s victor,term_name = %s,\n", __func__,term_device_operation_list[i].term_name);
		if(memcmp("A8600", term_device_operation_list[i].term_name, 5) == 0)
		{
			device_op_uis8581e = term_device_operation_list[i].term_device_op;
			printf("%s victor,i = %d,\n", __func__,i);
			break;
		}
	}

	if(i == LIST_MAX_LEN)
		return NULL;

	return device_op_uis8581e;
}
```