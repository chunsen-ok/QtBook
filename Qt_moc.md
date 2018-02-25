# Using the Meta-Object Compiler(moc)

## Contents
* [Usage](#index-1)
* [Writing Make Rules for Invoking moc](#index-2)
* [Command-Line Options](#index-3)
* [Diagnostics](#index-4)
* [Limitaions](#index-5)
    * [Multiple Inheritance Requires QObejct to Be First](#index-51)
    * [Funtion Pointers Cannot Be Signal or Slot Parameters](#index-52)
    * [Enums and Typedefs Must Be Fully Qualified for Signal and Slot Parameters](#index-53)
    * [Nested Classes Cannot Have Signals or Slots](#index-54)
    * [Signal/Slot return types cannot be references](#index-55)
    * [Only Signals and Slots May Appear in ths signals and slots Sections of a Class](#index-56)

元对象编译器，即moc，是用于处理Qt C++扩展的程序。

moc工具读取C++头文件。如果找到一个或者多个类的声明中包含了Q_OBJECT宏，moc会为这样的类生成元对象代码。元对象代码的作用是为这些类的信号-槽机制，运行时类型信息以及动态属性系统提供支持。

moc生成的C++源文件必须与其关联的类的实现一起编译、链接。

如果在工程中使用qmake创建makefiles，文件中的构建规则会在需要的时候被包含进moc，所以开发者不必主动调用moc。更多关于moc的后端信息，参考<[Why Dose Qt Use Moc for Signals and Slots?](#index)>

<div id="index-1"/>

## Usage
moc典型的用法是将一个包含类定义的文件作为输入：

```
    class MyClass: public QObejct
    {
        Q_OBJECT
    public:
        MyClass(QObject* parent = 0);
        ~MyClass();
    signals:
        void mySignal();
    public slots:
        void mySlot();
    };
```

除了上面的信号与槽函数，moc还会为项下面的例子所示那样，为对象实现属性的定义。Q\_PROPERTY()宏用于声明对象属性，Q\_ENUM()宏用于声明声明可以在属性系统中使用的枚举类型。

在下面这个例子中，我们声明了一个枚举类型Priority和该类型的属性priority，它拥有一个捕捕获函数prioritu()和设置函数setPriority()。

```
    class MyClass: public QObejct
    {
        Q_OBJECT
        Q_PROPERTY(Priority priority READ priority WRITE setPriority)
        Q_ENUM(Priority)
    public:
        enum Priority { High, Low, VeryHigh, VeryLow };

        MyClass(QObject* parent=0);
        ~MyClass();

        void setPriority(Priority priority) { m_priority = priority; }
        Priority priority() const { return m_priority; }
    private:
        Priority m_priority;
    };
```

Q\_FLAGS()宏用于声明作为标志的枚举。其他的宏，如Q\_CLASSINFO()，允许你添加其他名称-值对到类的元对象系统中：

```
    class MyClass: public QObejct
    {
        Q_OBJECT
        Q_CLASSINFO("Author","Oscar Peterson")
        Q_CLASSINFO("Status","Active")
    public:
        MyClass(QObject* parent=0);
        ~MyClass();
    };
```

moc生成的输出文件必须被编译和链接，正如其他的C++源代码一样。否则，在最后的链接阶段会导致构建错误。如果你使用qmake来构建应用，这些工作都是自动完成的。只要qamke运行起来，它就会解析工程的头文件并为那些声明了Q_OBJECT的类生成构建规则以及调用moc。

如果在头文件myclass.h中发现了Q\_OBJECT宏的声明，moc的输出文件会命名乘moc\_myclass.cpp。该文件和普通源文件一样需要编译，然后如果是在Windows系统中，将生成moc\_myclass.obj。接下来该对象文件会被包含进对象列表文件，并在最后的构建阶段链接到一起。

<div id="index-2"/>

## Writing Make Rules for Invoking moc

<div id="index-3"/>

## Command-Line Options

<div id="index-4"/>

## Diagnostics

<div id="index-5"/>

## Limitations
moc不会处理所有的C++代码。最主要的一个问题是模板类不能声明Q_OBJECT宏。例如：

```
    class SomeTemplate<int> : public QFrame
    {
        Q_OBEJCT
        //...
    signals:
        void mySignal();
    };
```

这样的声明方式是不合法的。所有这些内容都有更好的可替代方案，所有我们觉得没有必要移除这样的限制（做不来？？）。

<div id="index-51"/>

### Multiple Inheritance Requires QObject to Be First
如果你在使用多重继承，moc会假设第一个被继承的类是QObject类的子类。而且，必须保证只有第一个被继承的类是QObject。

```
    // 正确
    class SomeClass: public QObejct, public OtherClass
    {
        //...
    };
```

使用QObject时不能使用虚继承。


<div id="index-52"/>
<div id="index-53"/>
<div id="index-54"/>
<div id="index-55"/>
<div id="index-56"/>


