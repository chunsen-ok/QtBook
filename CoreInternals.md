# Core Internals

## Contents
* [对象，属性和事件(Objects,Properties,and Events)](index-1)
* [容器类(Container Classes)](index-2)
* [国际化(Internationalization)](index-3)
* [进程间通信(Inter-Process Communication)](index-4)
* [多线程(Threading)](index-5)
* [平台支持(Platform Support)](index-6)

Qt中提供了一套丰富的基础功能，主要包含在Qt Core模块中。Qt利用这些基础功能为顶层UI和应用提供了各种开发组件。下面的话题解释了最重要的功能，并演示如何使用它们来实现Qt还没有提供的特定的功能。

<div id="index-1">

## Objects,Properties,and Events

QObject类是Qt对象模型的基础，同时也是很多Qt类的父类。对象模型中引入了很多机制，如元对象系统(meta-object system)，能实现在运行时内省(run-time introspection),操作(manipulation)和调用(invocation)对象的属性和方法。 同时它还是Qt事件系统的基础，Qt事件系统是QObject派生类之间的一种底层的通信方式。另一种更上层的通信方式就是Qt的信号-槽机制。

以上这些特性还可以同状态机框架结合使用。状态机提供了一种定义好的且可预知的方式来管理应用的各种状态。另一种可以创建状态机的方式是使用Qt SCXML扩展模块利用状态表XML(SCXML)文件来创建。

另外，QObject中使用QObject::startTimer()提供了一种简单的计时机制。QTimer则提供了更上层的计时器接口。

* [对象模型(Object Model)]()
* [元对象系统(The Meta-Object System)]()
* [属性系统(The Property System)]()
* [事件系统(The Event System)]()
* [信号-槽机制(Signals & Slots)]()
* [状态机框架(The State Machine Framework)]()
* [计时器(Timers)]()

<div id="index-2">

## Container Classes



<div id="index-3">

## Internationalization



<div id="index-4">

## Inter-Process Communication




<div id="index-5">

## Threading
Qt提供了与平台无关的管理线程和并行代码的功能。

* [Threading Basics](QtThreading.md)




<div id="index-6">

## Platform Support
Qt编写的代码可以不做任何改动而在不同的平台上编译和部署。如果需要使用平台特定的功能和系统库，在Qt依旧可以很方便的将两者结合起来。

Qt使用Qt平台抽象(QPA)将窗口系统集成到目标平台上。QPA是一个窗口系统的抽象，可以方便快捷得将Qt迁移到一个新的平台上去。例如Wayland协议系统正是如此。Qt可以同Wayland作为一个轻量级的窗口系统迁移到嵌入式硬件平台中使用，并支持多进程的图形用户界面。

Qt平台抽象会用到Qt的插件系统。插件系统提供了Qt在特定功能（如添加对图像格式的支持，数据库驱动等等）上进行扩展的接口，以及开发者开发自己的支持第三方插件的可扩展Qt应用的支持。

* [Qt Platform Abstraction]()
* [Implementing Atomic Operations]() - for new architecture
* [How to Create Plugins]()
* [Endian Conversion Functions]() - functions for handling endianness from the QtEndian header

