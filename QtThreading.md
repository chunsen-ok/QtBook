#Qt Threading

## Threading Basics

* [What Are Threads?](index-1)
    * [GUI Thread and Worker Thread](index-11)
    * [Simultaneous Access to Data](index-12)
* [Using Threads](index-2)
* [Qt Thread Basics](index-3)
* [Examples](index-4)
* [Digging Deeper](index-5)

<div id="index-1">

## What Are Threads?

<div id="index-11">

### GUI Thread and Worker Thread
如前所述，每一个程序启动的时候都有一个线程，我们成为“主线程”（在Qt应用中就是我们所熟知的“GUI线程”）。Qt的GUI必须在该线程中运行。所有的部件类及其一些相关的类，如QPixmap类不能在第辅助线程中工作。一个辅助线程通常被称为工人线程("worker thread")，因为它主要用来处理从主线程卸载(offload)下来的工作。

<div id="index-12">

## 同时访问数据(Simultaneous Access to Data)

simultaneous 同时发生的，同步的，同时的



<div id="index-2">

## Using Threads
有两种比较典型的使用线程的场景：  
* 通过多核处理器可以使得处理更快
* 通过写在GUI线程或者需要及时反应的线程中的耗时处理过程交给工人线程(worker thread)。


