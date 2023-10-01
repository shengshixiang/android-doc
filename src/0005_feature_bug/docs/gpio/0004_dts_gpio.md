# 概要

对于驱动人员,dts是跟硬件打交道,配置硬件的一些信息,那gpio的dts描述,第三个参数,需要理解一下

# gpio设置输出

* gpio_set_value(45,0);gpio_set_value(45,1);

改函数配置的是gpio的逻辑电平,1为高,0为低

* nxp,pn7160-power = <&tlmm 45 GPIO_ACTIVE_HIGH>;

    * GPIO_ACTIVE_HIGH, 那逻辑电平gpio_set_value(45,1);, 对应实际就是高电平,high

    * GPIO_ACTIVE_LOW, 那逻辑电平gpio_set_value(45,1);, 对应实际就是低电平,low

# 总结

在应用层, gpio_set_value为high,就可以避免实际硬件是高有效,还是低有效,只要通过dts的GPIO_ACTIVE_HIGH跟GPIO_ACTIVE_LOW 去配置就可以