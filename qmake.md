# qmake Manual
qmake工具能够简化开发工程的构建过程，并且一个文件就可以支持跨平台的开发。qmake可以自动生成Makefile文件，开发者只需要编辑很少的内容。qmake可以用于任何软件工程的开发，即使不是Qt。

qmake根据工程文件(.pro)的信息生成Makefile文件。工程文件是有开发者自己创建的，且通常比较简单。对于更加复杂的工程，则往往有着更复杂的工程文件。

qmake自动包含了支持moc和uic的Qt特性，用于支持Qt的开发配置。

qmake能够不改动工程文件而直接在Microsoft Visual Studio中使用。

## Table of Contents
* [1 Overview](#index-1)
* [2 Getting Started](#index-2)
* [3 Creating Project files](#index-3)
* [4 Building Common Project Types](#index-4)
* [5 Running qmake](#index-5)
* [6 Platform Notes](#index-6)
* [7 qmake Language](#indexc-7)
* [8 Advanced Usage](#index-8)
* [9 Using Precompiled Headers](#index-9)
* [10 Configuring qmake](#index-10)
* [11 Reference](#index-11)
    * [11.1 Variables](#index-11-1)
    * [11.2 ReplaceFunctions](#index-11-2)
        * [11.2.1 Built-in Replace Functions](#index-11-2-1)
    * [11.3 Test Functions](#index-11-3)
        * [11.3.1 Built-in Test Functions](#index-11-3-1)
        * [11.3.2 Test Function Library](#index-11-3-2)

# 1 Overview
The qmake tool provides you with a project-oriented system for managing the build process for applications, libraries, and other components. This approach gives you control over the source files used, and allows each of the steps in the process to be described concisely, typically within a single file. qmake expands the information in each project file to a Makefile that executes the necessary commands for compiling and linking. 

## 1.1 描述工程(Describing a Project)
工程由工程文件(.pro)描述。qmake使用工程文件中的命令信息来生成Makefile文件。工程文件中一般包含了头文件和源文件列表，通用配置信息，以及针对工程的细节描述。

一般进行Qt开发时，通过Qt的新建工程引导精灵就可以创建一个默认的工程文件了。然后开发者就可以针对自己的工程需要对这个工程文件进行修改。

工程文件还可以通过qmake直接输入命令生成。

通常情况下工程文件可以满足大多数平台的需求，但也有可能针对特定平台需要使用平台相关的变量。

## 1.2 构建工程(Building a Project)
对于简单的工程，可以只需要在自己工程的底层目录下使用qmake生成一个Makefile文件，然后使用make工具构建工程即可。

## 1.3 使用第三方库(Using Thrid Party Library)


## 1.4 预编译头文件(Precompiling Headers)
在大型工程中，使用预编译的头文件能加速工程的构建。

# 2 开始(Getting Started)
本教程讲解了qmake的基本使用。

## 2.1 从简单例子开始(Start Off Simple)


