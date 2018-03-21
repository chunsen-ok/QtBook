# Qt Widget - Layouts

## Contents
* [介绍(Introduction)](#index-1)
* [Qt的布局类(Qt's Layout Classes)](#index-2)
* [水平、垂直、网格和表单布局器(Horizontal,Vertical,Grid,and Form Layouts)](#index-3)
    * [在代码中对控件布局(Laying Out Widgets in Code)](#index-31)
    * [使用布局时的一点提示(Tips for Using Layouts)](#index-32)
* [添加控件到布局器中(Adding Widgets to a Layout)](#index-4)
    * [延展系数(Stretch Factors)](#index-41)
* [布局器中的自定义控件(Custom Widgets in Layouts)](#index-5)
* [布局器的问题(Layout Issues)](#index-6)
* [手动布局(Manual Layout)](#index-6)
* [如何编写自定义布局管理器(How to Write A Custom Layout Manager)](#index-7)
    * [头文件(card.h)](#index-71)
    * [实现文件(card.cpp)](#index-72)
    * [其他(Further Notes)](#index-73)
* [布局示例(Layout Examples)](#index-8)

Qt布局系统提供了简单强大的自动安排子控件的方法，使控件能够充分使用空间。

<div id="index-1"/>

## 介绍(Introduction)

