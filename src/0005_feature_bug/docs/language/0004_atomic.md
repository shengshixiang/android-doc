# README

原子操作,atomic

# 解析

* 原子操作

　　所谓原子操作，就是该操作绝不会在执行完毕前被任何其他任务或事件打断，也就说，它的最小的执行单位，不可能有比它更小的执行单位，因此这里的原子实际是使用了物理学里的物质微粒的概念。

* atomic_inc

atomic_inc(&v)对变量v用锁定总线的单指令进行不可分解的"原子"级增量操作，避免v的值由于中断或多处理器同时操作造成不确定状态。

# 其他

* atomic_read(atomic_t * v);
   该函数对原子类型的变量进行原子读操作，它返回原子类型的变量v的值。 

* atomic_set(atomic_t * v, int i);
　　该函数设置原子类型的变量v的值为i。 

* void atomic_add(int i, atomic_t *v);
　　该函数给原子类型的变量v增加值i。 
　
* atomic_sub(int i, atomic_t *v);
　  该函数从原子类型的变量v中减去i。 

* int atomic_sub_and_test(int i, atomic_t *v);
   该函数从原子类型的变量v中减去i，并判断结果是否为0，如果为0，返回真，否则返回假。 

* void atomic_inc(atomic_t *v);
   该函数对原子类型变量v原子地增加1。 

* void atomic_dec(atomic_t *v);
   该函数对原子类型的变量v原子地减1。 

* int atomic_dec_and_test(atomic_t *v);
   该函数对原子类型的变量v原子地减1，并判断结果是否为0，如果为0，返回真，否则返回假。 

* int atomic_inc_and_test(atomic_t *v);
   该函数对原子类型的变量v原子地增加1，并判断结果是否为0，如果为0，返回真，否则返回假。 

* int atomic_add_negative(int i, atomic_t *v);
   该函数对原子类型的变量v原子地增加I，并判断结果是否为负数，如果是，返回真，否则返回假。 

* int atomic_add_return(int i, atomic_t *v);
   该函数对原子类型的变量v原子地增加i，并且返回指向v的指针。 

* int atomic_sub_return(int i, atomic_t *v);
   该函数从原子类型的变量v中减去i，并且返回指向v的指针。 

* int atomic_inc_return(atomic_t * v);
   该函数对原子类型的变量v原子地增加1并且返回指向v的指针。 

* int atomic_dec_return(atomic_t * v);
   该函数对原子类型的变量v原子地减1并且返回指向v的指针。 