# Qt Widgets Module
Qt Widgets模块提供了一系列用于创建传统桌面风格的用户交互界面的UI元素。参考[User Interfaces](#...)掌握有关使用部件的信息。

## 内容
* [开始(Getting Started)](#index1)
* [部件(Widgets)](#index2)
* [风格(Styles)](#index3)
* [布局(Layouts)](#index4)
* [模型/视图类(Model/View Classes)](#index5)
* [图形视图(Graphics View)](#index6)
* [教程(Tutorials)](#index7)
* [示例(Examples)](#index8)
* [API参考(API Reference)](#index9)

<div id="index1"/>

## 开始(Getting Started)
要使用该模块，须包含模块文件：

```
#include <QtWidgets>
```

并在.pro文件中添加命令，以链接该模块：

```
QT += widgets
```

<div id="index2"/>

## 部件(Widgets)
部件(Widgets)是Qt中用于创建UI的组件模块。部件(Widgets)可以显示数据和状态信息，接收用户输入，为其他需要组织在一起的部件提供容器。所有没有嵌入父类部件的部件就是一个窗口（即一个顶层部件即是一个窗口）。  
QWidget类提供了处理事件输入，渲染屏幕的基础功能。所有Qt提供的UI元素都直接或者间接继承了QWidget类。可以通过继承QWidget或者其子类，然后重载特定功能的函数来实现自定义部件。  
* [Window and Dialog Widgets](#index2-1)
* [Application Main Window](#index2-2)
* [Dialog Windows](#index2-3)
* [KeyBoard Focus in Widgets](#index2-4)


<font color="ff8888">以上索引内容未完成</font>

<div id="index3"/>

## 风格(Styles)
* [Styles](#index3-1)
* [Qt Style Sheets](#index3-2)

风格绘制表示部件和封装GUI的外观。Qt的内置部件几乎都是使用QStyle类执行绘制，以确保它们看起来和本地应用的部件风格一致。  
Qt样式表是一种可用于自定义部件外观的强大机制，另外几乎所有样式都可以通过继承QStyle类实现自定义样式。 

<font color="ff8888">以上索引内容未完成</font>

<div id="index4"/>

## 布局(Layouts)
* [Layouts](Layouts.md)

布局是一种优雅而灵活的组织子部件的方式。每个部件通过sizeHint和sizePolicy属性将自己的尺寸要求告知布局，然后布局根据需求生成指定的尺寸大小。  
Qt Designer是一个强大的创建和管理部件的工具。

<font color="ff8888">以上索引内容未完成</font>

<div id="index5"/>

## 模型/视图类(Model/view Classes)
* [model/view Programming](ModelViewArchitecture.md)

模型/视图结构提供了一种用于管理展示给用户的数据的方式。数据驱动的应用使用结构化的列表和图表将数据拆分开来。

### Model/View编程介绍(Introduction to Model/View Programming)
Qt中有大量使用模型/视图结构的视图类来管理数据数据之间的关系以及展示给用户的方式。The separation of functionality introduced by this architecture gives developers greater flexibility to customize the presentation of items, and provides a standard model interface to allow a wide range of data sources to be used with existing item views. In this document, we give a brief introduction to the model/view paradigm, outline the concepts involved, and describe the architecture of the item view system. Each of the components in the architecture is explained, and examples are given that show how to use the classes provided. 

#### 模型/视图结构(The model/view Architecture)
模型-视图-控制器(MVC)是一种设计模式，最早起源于Smalltalk，这种设计模式在开发用户界面中用途广泛。在《设计模式》一书中，Gamma et al.写到：

```
MVC由三部分组成。模型是应用对象，视图表示展示数据的屏幕，控制器则定义了用户界面如何相应用户输入。在MVC之前，用户界面设计将所有对象放在一起。MVC则将他们分开提升了灵活性和可重用性。
```

模型和数据源进行沟通，并提供了其他组件访问数据的接口。视图从模型获取模型中数据项的索引。在标准视图中，委托负责渲染数据项。委托可以通过模型的索引和模型通信。

通常，模型/视图的类被分成三部分，模型，视图和委托。每一部分的类都被定义为抽象类，并提供了基本的接口和一些默认的设置。抽象不能直接使用，需要通过派生类来定义自己的完整功能。

模型，视图，委托使用信号与槽进行相互通信：  
* 模型的信号告知视图数据源中数据的改变；
* 视图的信号提供展示给用户的数据项的信息；
* 委托的信号则在编辑数据时告知模型和视图当前编辑器的状态信息；

##### 模型(Models)
所有的数据项模型都是基于QAbstractItemModel。该类定义了视图和委托访问数据的接口。模型自身并不存储数据；数据可以被存放在任何其他单独的数据结构中，文件，数据库或者其他来源。

QAbstractItemModel提供了足够灵活的接口来处理数据，并提供给table,list,tree形式的视图。但是在实际实现特定类型的模型中时，QAbstractListModel和QAbstractTableModel更方便一些。他们提供了更多相关模型的功能接口。

Qt提供了几种模型类：
* QStringListModel: 以顺序表的形式管理QString数据项；
* QStandardItemModel: 用于管理更为复杂的属性结构的数据项；
* QFileSystemModel: 提供了本地文档系统中的文件和路径信息；
* QSqlQueryModel,QSqlTableModel,QSqlRelationalTableModel: 用于管理数据库中的数据项。

#### 视图(Views)
Qt中提供了几种完全实现的视图类（即可以直接定义实例的类）: 
* QListView：以列表形式显示数据项；
* QTableView: 以表的形式显示数据项；
* QTreeView: 以具有层级关系的方式显示数据项。

所有这些视图类都是基于QAbstractItemView类。尽管这些类都可以直接使用，但你也可以继承这些类并实现自定义的视图类型。

#### 委托(Delegates)



<div id="index6"/>

## 图形视图(Graphics View)
* [图形视图框架(Graphics View Framework)](#index6-1)

图形视图框架用于管理和整合大量自定义2D图形项，视图部件可以显示这些项，并支持缩放，旋转。

<div id="index7"/>

## 教程(Tutorials)
* [Widgets Tutorial](#index7-1)
* [Model/View Tutorial](#index7-2)

<div id="index8"/>

## 示例(Examples)

<div id="index9"/>

## API参考(API Reference)

<font color="#ff8888" size="24">到这里了...</font>
