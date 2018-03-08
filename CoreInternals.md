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


