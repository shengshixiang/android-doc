# 概要

uboot阶段配置展锐gpio

# 代码

除了执行`sprd_gpio_request`,还要添加默认`sprd_gpio_direction_output`输出配置

```
	sprd_gpio_request(NULL, sp_power_info_t->gpio_num);
	if(sp_power_info_t->notneed_init_first == 1){
		sprd_gpio_direction_output(NULL,sp_power_info_t->gpio_num, sp_power_info_t->effective_level);
	}else{
		sprd_gpio_direction_output(NULL,sp_power_info_t->gpio_num, sp_power_info_t->effective_level ? 0: 1);
	}
	printf("pax_porting_sp_power_init GPIO_SP_POWER %d,notneed_init_first = %d,effective_level = %d,\r\n",
		sp_power_info_t->gpio_num,sp_power_info_t->notneed_init_first,sp_power_info_t->effective_level);
```

# 报错

否则设置gpio 输出的时候,汇报`dir wrong`

```
[00002212] power sp: 1
[00002214] GPIO_29 dir wrong!can't set input value
```

# gpio默认状态

看pinmap是否有默认配置上拉.没有上拉,一般都是低