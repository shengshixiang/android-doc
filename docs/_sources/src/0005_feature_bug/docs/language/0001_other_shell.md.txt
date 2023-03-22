# README

shell的一些用法

# 数组

* 动态的定义数组变量，并使用命令的输出结果作为数组的内容

```

语法如下
array=( $(命令) )
或者：
array=( `命令` )

示例如下
[root@localhost backup]# mkdir array/ -p
[root@localhost backup]# touch array/{1..3}.txt
[root@localhost backup]# ls -l array
总用量 0
-rw-r--r--. 1 root root 0 6月 16 11:28 1.txt
-rw-r--r--. 1 root root 0 6月 16 11:28 2.txt
-rw-r--r--. 1 root root 0 6月 16 11:28 3.txt
[root@localhost backup]# array=($(ls array))
[root@localhost backup]# echo ${array[*]}
1.txt 2.txt 3.txt

```