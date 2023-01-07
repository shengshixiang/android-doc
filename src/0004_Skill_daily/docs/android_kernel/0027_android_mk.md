# README

android mk,bp的使用介绍

# LOCAL_SHARED_LIBRARIES 与 LOCAL_LDLIBS，LOCAL_LDFLAGS的区别

如果是非系统的第三方库，貌似只能用LOCAL_LDFLAGS方式，LOCAL_LDLIBS方式不行

* LOCAL_LDLIBS: 

    > 链接的库不产生依赖关系，一般用于不需要重新编译的库，如库不存在，则会报错找不到。
    > 且貌似只能链接那些存在于系统目录下本模块需要连接的库。
    > 如果某一个库既有动态库又有静态库，那么在默认情况下是链接的动态库而非静态库。
    > 例如: LOCAL_LDLIBS += -lm –lz –lc -lcutils –lutils –llog …

* LOCAL_SHARED_LIBRARIES:

    > 会生成依赖关系，当库不存在时会去编译这个库

* LOCAL_LDFLAGS:

    > 这个编译变量传递给链接器一个一些额外的参数
    > 比如想传递给外面的库和库路径给ld，或者传递给ld linker的一些链接参数，-On，-EL{B}(大小端字节序)，那么就要加到这个上面
    > 如：LOCAL_LDFLAGS += -L(LOCALPATH)/lib/−lHWrecog–EBEL–On
    > 或者直接加上绝对路径库的全名：LOCALLDFLAGS+=(LOCALPATH)/lib/−lHWrecog–EBEL–On…
    > 或者直接加上绝对路径库的全名：LOCALLDFLAGS+=(LOCAL_PATH)/lib/libHWrecog.a –EB{EL} –O{n}