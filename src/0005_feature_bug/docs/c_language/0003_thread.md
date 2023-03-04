# README

线程函数相关操作

# pthread_create

pthread_create是类Unix操作系统（Unix、Linux、Mac OS X等）的创建线程的函数。

它的功能是创建线程（实际上就是确定调用该线程函数的入口点），在线程创建以后，就开始运行相关的线程函数。

pthread_create的返回值:若成功，返回0；若出错，返回出错编号。

# pthread_join

函数pthread_join用来等待一个线程的结束,线程间同步的操作。

描述 ：pthread_join()函数，以阻塞的方式等待thread指定的线程结束。

当函数返回时，被等待线程的资源被收回。如果线程已经结束，那么该函数会立即返回。

并且thread指定的线程必须是joinable的。

参数 ：thread: 线程标识符，即线程ID，标识唯一线程。

retval: 用户定义的指针，用来存储被等待线程的返回值。

返回值 ： 0代表成功。 失败，返回的则是错误号。

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <string.h>
 
void printids(const char *s)
{
    pid_t pid;
    pthread_t tid;
    pid = getpid();
    tid = pthread_self();
    printf("%s pid %u tid %u (0x%x)\n", s, (unsigned int) pid,
            (unsigned int) tid, (unsigned int) tid);
}
 
void *thr_fn(void *arg)
{
    printids("new thread: ");
    return NULL;
}
 
int main(void)
{
    int err;
    pthread_t ntid;
    err = pthread_create(&ntid, NULL, thr_fn, NULL);
    if (err != 0)
        printf("can't create thread: %s\n", strerror(err));
    printids("main thread:");
    pthread_join(ntid,NULL);
    return EXIT_SUCCESS;
}

# pthread_cond_signal

pthread_cond_signal函数的作用是发送一个信号给另外一个正在处于阻塞等待状态的线程,使其脱离阻塞状态,继续执行.

如果没有线程处在阻塞等待状态,pthread_cond_signal也会成功返回。

# waitpid

waitpid会暂时停止进程的执行，直到有信号来到或子进程结束。

```
与wait函数相比，系统调用二者的作用是完全相同的，但是waitpid多出了两个可由用户控制的参数pid和options。
pid：从参数的名字上可以看出来这是一个进程的ID。但是这里pid的值不同时，会有不同的意义。
1.pid > 0时，只等待进程ID等于pid的子进程，只要该子进程不结束，就会一直等待下去；
2.pid = -1时，等待任何一个子进程的退出，此时作用和wait相同；
3.pid = 0时，等待同一个进程组中的任何子进程；
4.pid < -1时，等待一个指定进程组中的任何子进程，这个进程组的ID等于pid的绝对值。
```

# fork

在执行函数fork()时，创建了一个子进程，此时是两个进程同时运行。fork()返回两次，子进程返回值为0，所以执行 printf("child pid: %d\n", getpid()); 父进程返回子进程id（pid>0）,所有执行printf("pid: %d\n", pid);printf("father pid: %d\n", getpid());。两个进程执行顺序不定。

```
/*linux下：*/
 
#include <stdio.h>
#include <unistd.h>
 
int main() {
    pid_t pid;
    pid = fork();
    if(pid  == 0) //返回子进程
    {
        printf("child pid: %d\n", getpid());
    } else {
        printf("pid: %d\n", pid);//父进程中返回子进程的pid
        printf("father pid: %d\n", getpid());
    }
}
```

```
pid: 5989
father pid: 5988
child pid: 5989
```