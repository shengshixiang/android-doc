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

# 判断

* log报错 ./build-qssi_only.sh: line 19: [: =: unary operator expected

    ```
    if [ $2 = "qssi_32go" ]; then
    20     if [[ $# -gt 0 && $1 = "release" ]]; then
    21         echo ---lunch qssi_32go user---
    22         lunch qssi_32go-user
    23     else
    24         echo ---lunch qssi_32go userdebug---
    25         lunch qssi_32go-userdebug
    26     fi
    27 else
    ```

* 原因

    当$2 = 空的时候, 就变成 if [  = "qssi_32go" ]; then.所以报错

* 解决方法

    * 改成, if [[ $2 = "qssi_32go" ]]; then

    * 或者,if  if [ x$2 = x"qssi_32go" ]; then

# shell if [] 条件

文件表达式
if [ -f file ] 如果文件存在
if [ -d … ] 如果目录存在
if [ -s file ] 如果文件存在且非空
if [ -r file ] 如果文件存在且可读
if [ -w file ] 如果文件存在且可写
if [ -x file ] 如果文件存在且可执行

整数变量表达式
if [ int1 -eq int2 ] 如果int1等于int2
if [ int1 -ne int2 ] 如果不等于
if [ int1 -ge int2 ] 如果>=
if [ int1 -gt int2 ] 如果>
if [ int1 -le int2 ] 如果<=
if [ int1 -lt int2 ] 如果<

字符串变量表达式
If [ $a = $b ] 如果string1等于string2
字符串允许使用赋值号做等号
if [ $string1 != $string2 ] 如果string1不等于string2
if [ -n $string ] 如果string 非空(非0），返回0(true)
if [ -z $string ] 如果string 为空
if [ $sting ] 如果string 非空，返回0 (和-n类似)

s​h​e​l​l​中​条​件​判​断​i​f​中​的​-​z​到​-​d​的​意​思
[ -a FILE ] 如果 FILE 存在则为真。
[ -b FILE ] 如果 FILE 存在且是一个块特殊文件则为真。

[ -c FILE ] 如果 FILE 存在且是一个字特殊文件则为真。

[ -d FILE ] 如果 FILE 存在且是一个目录则为真。

[ -e FILE ] 如果 FILE 存在则为真。
[ -f FILE ] 如果 FILE 存在且是一个普通文件则为真。

[ -g FILE ] 如果 FILE 存在且已经设置了SGID则为真。
[ -h FILE ] 如果 FILE 存在且是一个符号连接则为真。

[ -k FILE ] 如果 FILE 存在且已经设置了粘制位则为真。 [

[ -p FILE ] 如果 FILE 存在且是一个名字管道(F如果O)则为真。

[ -r FILE ] 如果 FILE 存在且是可读的则为真。

[ -s FILE ] 如果 FILE 存在且大小不为0则为真。
[ -t FD ] 如果文件描述符 FD 打开且指向一个终端则为真。

[ -u FILE ] 如果 FILE 存在且设置了SUID (set user ID)则为真。

[ -w FILE ] 如果 FILE 如果 FILE 存在且是可写的则为真。

[ -x FILE ] 如果 FILE 存在且是可执行的则为真。

[ -O FILE ] 如果 FILE 存在且属有效用户ID则为真。

[ -G FILE ] 如果 FILE 存在且属有效用户组则为真。 
[ -L FILE ] 如果 FILE 存在且是一个符号连接则为真。
[ -N FILE ] 如果 FILE 存在 and has been mod如果ied since it was last read则为真。
[ -S FILE ] 如果 FILE 存在且是一个套接字则为真。
[ FILE1 -nt FILE2 ] 如果 FILE1 has been changed more recently than FILE2,or 如果 FILE1 exists and FILE2 does not则为真。
[ FILE1 -ot FILE2 ] 如果 FILE1 比 FILE2 要老, 或者 FILE2 存在且 FILE1 不存在则为真。
[ FILE1 -ef FILE2 ] 如果 FILE1 和 FILE2 指向相同的设备和节点号则为真。

[ -o OPTIONNAME ] 如果 shell选项 “OPTIONNAME” 开启则为真。

[ -z STRING ] “STRING” 的长度为零则为真。

# set

* set +e：在该命令后遇到非零的返回值时，会继续向下执行

    > 错误,继续执行

* set -e：在该命令后遇到非零的返回值时，会直接退出

    > 错误,立即停止

# =~

* =~支持正则表达式，同时支持变量比较相等。==只能支持比较变量相不相等

# while [ $# -gt 0 ] ; do

    $#为shell中的一个特殊变量，代表传入参数的个数，-gt是大于的意思，该行的意思是“当传入参数个数大于0时”进入循环

    shift 类似于左移,参数移

# eval

可以看到 eval的作用,就是命令执行一遍

```
xielx@u295:~$ cat test.txt
im a boy
xielx@u295:~$ evaltest="cat test.txt"
xielx@u295:~$ echo evaltest
evaltest
xielx@u295:~$ echo $evaltest
cat test.txt
xielx@u295:~$ eval echo $evaltest
cat test.txt
xielx@u295:~$ eval $evaltest
im a boy
xielx@u295:~$ 
```

# shopt

shopt是另一个可以改变shell行为的内建（builtin）命令，格式如下

* “-s”：打开/设置optname。

* “-u”：关闭/取消optname。

* “-p”：以shopt命令的输入格式显示optname的状态。

* “-q”：quiet模式，不输出optname及其状态，只是可以通过shopt命令的退出状态来查看某个optname是否打开或关闭。

* “-o”：限制optname为内建命令set的选项“-o”支持的那些值。

# 变量

* $#    ,传给脚本的参数个数

* $0    ,脚本本身的名字

* $1    ,传递给该shell脚本的第一个参数

* $2    ,传递给该shell脚本的第二个参数

* $@    ,传给脚本的所有参数的列表

* $*    ,以一个单字符串显示所有向脚本传递的参数，与位置变量不同，参数可超过9个

* $$    ,脚本运行的当前进程ID号

* $?    ,显示最后命令的退出状态，0表示没有错误，其他表示有错误

# dirname

去掉路径的前缀

xielx@u295:~/ssdCode/pmk/script$ dirname pmk
.
xielx@u295:~/ssdCode/pmk/script$ dirname ~/ssdCode/pmk/script/pmk
/home/xielx/ssdCode/pmk/script

```
path=$(cd `dirname $0`;pwd)
echo $path
path2=$(dirname $0)
echo $path2

当前脚本存在路径：/home/software
sh path.sh

/home/software
.

解释：
dirname $0 只是获取的当前脚本的相对路径.
cd `dirname $0`;pwd  先cd到当前路径然后pwd，打印成绝对路径
```

# pwd

获取当前绝对路径

# reallink

readlink是linux用来找出符号链接所指向的位置

```
例1：
readlink -f /usr/bin/awk
结果：
/usr/bin/gawk #因为/usr/bin/awk是一个软连接，指向gawk
例2：
readlink -f /home/software/log
/home/software/log  #如果没有链接，就显示自己本身的绝对路径
```

```
path.sh
#!/bin/bash
path=$(dirname $0)
path2=$(readlink -f $path)
echo path2
sh path.sh
/home/software
解释：
readlink -f $path 如果$path没有链接，就显示自己本身的绝对路径
```

# ${}、##和%%

介绍下Shell中的${}、##和%%使用范例，本文给出了不同情况下得到的结果。
假设定义了一个变量为：

```
代码如下:
file=/dir1/dir2/dir3/my.file.txt
可以用${ }分别替换得到不同的值：
${file#*/}：删掉第一个 / 及其左边的字符串：dir1/dir2/dir3/my.file.txt
${file##*/}：删掉最后一个 /  及其左边的字符串：my.file.txt
${file#*.}：删掉第一个 .  及其左边的字符串：file.txt
${file##*.}：删掉最后一个 .  及其左边的字符串：txt
${file%/*}：删掉最后一个  /  及其右边的字符串：/dir1/dir2/dir3
${file%%/*}：删掉第一个 /  及其右边的字符串：(空值)
${file%.*}：删掉最后一个  .  及其右边的字符串：/dir1/dir2/dir3/my.file
${file%%.*}：删掉第一个  .   及其右边的字符串：/dir1/dir2/dir3/my
记忆的方法为：
# 是 去掉左边(（)键盘上#在 $ 的左边)
%是去掉右边（键盘上% 在$ 的右边）
单一符号是最小匹配；两个符号是最大匹配
${file:0:5}：提取最左边的 5 个字节：/dir1
${file:5:5}：提取第 5 个字节右边的连续5个字节：/dir2
也可以对变量值里的字符串作替换：
${file/dir/path}：将第一个dir 替换为path：/path1/dir2/dir3/my.file.txt
${file//dir/path}：将全部dir 替换为 path：/path1/path2/path3/my.file.txt
```