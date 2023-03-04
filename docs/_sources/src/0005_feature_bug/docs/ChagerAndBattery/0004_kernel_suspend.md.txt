# README

KENREL 内核休眠流程

# 流程

* 灭屏-> call notifiers -> freeze 任务 -> prepare -> suspend -> suspend_late -> suspend_noirq -> cpu 1-n offline -> 系统核离线 -> Soc 平台级离线

* 亮屏 -> Soc 平台级上线 -> 系统级核心上线 -> cpu 1-n 上线 -> resume_noirq -> resume_early -> resume -> complete -> Thaw 解冻任务 -> call notifiers

![0004_0001](images/0004_0001.png)