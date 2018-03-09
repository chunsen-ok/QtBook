# Qt Core - The State Machine Framework

## Contents

* [状态机框架中的类(Classes in the State Machine Framwork)](#index-1)
* [简单状态机(A Simple State Machine)](#index-2)
* [在状态入口和出口做有意义的工作(Doing Usefule work on State Entry and Exit)](#index-3)
* [状态机的结束(State Machines That Finish)](#index-4)
* [使用历史状态来保存和重装当前状态(Using History States to Save and Restore the Current State)](#index-5)
* [使用并行状态来避免状态数量的暴涨(Using Parallel States to Avoid a Combinational Explosion of States)](#index-6)
* [检测组合状态的结束(Detecting that a Composite State has finished)](#index-7)
* [无目标转换(Targetless Transitions)](#index-8)
* [事件、转换和Guards(Events,Transitions and Guards)](#index-9)
* [使用重装策略实现属性自动重装(Using Restore Policy To Automatically Restore Properties)](#index-10)
* [属性赋值动画(Animating Properties Assignments)](#index-11)
* [检测搜索属性是否都设置为了同一状态(Detecting That All Properties Have Been Set In A State)](#index-12)
* [在动画结束前退出状态会发生什么(What Happens If A State Is Exited Before The Animation Has Finished)](#index-13)
* [默认动画(Default Animation)](#index-14)
* [嵌套状态机(Nesting State Machines)](#index-15)

状态机框架中提供的类可用于创建和执行状态图(state graphs)。这些概念和表示法(notation)是基于Harel的论文《[StateCharts:A visual formalism for complex systems](http://www.wisdom.weizmann.ac.il/~dharel/SCANNED.PAPERS/Statecharts.pdf)》。同时，该论文也是UML状态图的基础。状态机执行的语义(semantics)基础是状态表XML(SCXML).

状态表提供了一种图形化的建模方式描述一个系统如何对外部信号做出反应。通过定义系统可能存在的状态，以及系统在各状间切换的方式来响应外部信号。事件驱动的系统（例如Qt应用）中的一个关键点就是系统的行为通常不仅仅取决于最后和当前的时间，而且也取决于之前的状态。利用状态表，这种信息可以很容易地表达出来。

状态机框架提供的API和执行模型可以高效地将状态表的元素和语义嵌入到Qt应用中。该框架和Qt的元对象系统紧密结合；例如，状态之间的转换可以通过信号促发，状态还可以设置QObject对象的属性和调用QObject对象的方法。Qt的事件系统则用于驱动状态机。

状态机框架中的状态图表是一种层次化的结构。状态可以被嵌套在其他状态中，状态机的当前组成的配置又有一系列当前激活的状态组成。状态机中所有具有合法配置的状态都将拥有一个共同的祖先。

<div id="index-1"/>

## 状态机框架中的类(Classes in the State Machine Framwork)

以下类是Qt提供的用于创建事件驱动的状态机。

| Class | Description |
| :---  | :--- |
| QAbstractState | 状态机的状态的基类 |
| QAbstractTransition ||
|||
|||
|||
|||
|||
|||
|||
|||
|||
|||
|||
|||
|||
|||
