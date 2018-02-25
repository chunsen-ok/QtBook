# Qt Core Module
Qt的核心模块，包含了被其他模块依赖和使用的非图形类。

## 内容(Contents)
* [开始(Getting Started)](#index1)  
* [核心功能机制(Core Functionalities)](#index2)
    * [元对象系统(The Meta-Object System)](#index2-1)
    * [属性系统(The Property System)](#index2-2)
    * [对象模型(Object Model)](#index2-3)
    * [对象树和所有权(Object Tree & Ownership)](#index2-4)
    * [信号与槽(Signals & Slots)](#index2-5)
* [线程和并发编程(Threading and Concurrent Programming)](#index3)
* [输入/输入、资源和容器(Input/Output,Resources,and Containers)](#index4)
* [其他框架(Additional Frameworks)](#index5)
* [许可(Licenses and Attributions)](#index6)
* [参考(Reference)](#index7)
* [<font color="#ff8888">进行到...</font>](#workingNowIndex)


<div id="index1"/>

## 开始(Getting Started)
Qt中其他所有模块都依赖于该模块。使用#include<QtCore>指令可以使用该模块中定义的类。如果是使用qmake来构建工程，Qt Core模块将自动包含到工程中。

<div id="index2"/>

## 核心功能机制(Core Functionalities)
Qt向C++中添加了以下特性：  
* 实现对象间无缝通信的信号与槽机制
* 可查询和可设计的对象属性
* 以层次化和可查询方式组织的对象树结构
* 通过智能指针管理的对象所有权
* 跨越库边界的动态转换(a dynamic cast that across library boundaries)  

以下提供了更多关于Qt核心特性的内容：  
* [元对象系统(The Meta-Object System)](#index2-1)
* [属性系统(The Property System)](#index2-2)
* [对象模型(Object Model)](#index2-3)
* [对象树和所有权(Object Tree & Ownership)](#index2-4)
* [信号与槽(Signals & Slots)](#index2-5)

<div id="index2-1"/>

### 元对象系统(The Meta-Object System)
元对象系统提供了对象间通信的信号与槽机制、运行时类型信息(RTTI,run-time type information)和动态属性系统。  
元对象系统的建立基于以下三点：  
1. QObject类是所有使用元对象系统功能的类的基类。
2. 类通过在私有成员片段中声明Q_OBJECT宏来开启类的元对象系统功能。
3. 元对象编译器(moc,Meta-Object Compiler)会为每一个QObject子类生成必要的代码以支持元对象特性。  

moc读取一个C++源文件时，如果发现一个或者多个类包含了Q_OBJECT宏，moc就会为该类生成其他的C++源文件，该源文件中包含了与对应类元对象相关的代码。这些源文件会包含到类的源文件中，或者一般是和类的实现一起编译、连接。  
元对象代码中提供了以下特性：  
* QObject::metaObject()返回与类关联的元对象。
* QMetaObject::className()可以在程序运行中以字符串形式返回类名，不需要本地C++编译器支持RTTI功能。
* QObject::inherits()用于判断该对象是否从QObject对象树中某个类派生而来。
* QObject::tr()和QObject::trUtf8()为国际化管理提供字符转换。
* QObject::setProperty()和QObject::property()可以通过名称动态设置和获取类属性。
* QMetaObject::newIntance()可以为类构造新的实例。

还可以使用qobject\_cast()函数对QObject类进行动态类型转换。qobject\_cast()函数的行为和标准C++的dynamic\_cast()是差不多的，前者的好处是不需要编译器提供RTTI支持且可以跨越库边界进行工作(across dynamic library boundaries)。qobject_cast()会尝试将参数转换为尖括号中指明的指针类型，如果类型可以转换，将返回一个非零指针，否则就将返回空指针。  
例如，自定义一个派生自QWidget的类MyWidget，并在类中声明Q_OBJECT宏以开启元对象特性：  

```
QObject* obj = new MyWidget;  
```

obj变量是QObject*类型，但实际上它指向的是MyWdidget类型对象。所以我们可以将其转换为合适的类型：  

```
QWidget* widget = qobject_cast<QWidget*>(obj);
```

从QObject转换为QWidget类型是可以的。因为obj实际指向的是MyWidget类型，该类型是QWidget的子类。既然obj是指向MyWidge类型的，我们自然也可以将其转换为MyWidget*类型：

```
MyWidget* myWidget = qobject_cast<MyWidget*>(obj);
```

对象转换为MyWidget类型也是可以的，因为qobject_cast()函数以相同方式对待Qt内建(built-in)类型和自定义类型。

```
QLabel *label = qobject_cast<QLabel*>(obj);
```

上面试图转换为QLabel*类型，但这样的转换是无效的。表达式将会返回空指针。通过返回值我们可以在运行时根据返回值类型来处理不同的对象：

```
if(QLabel* label = qobject_cast<QLabel*>(obj)) {  
    label->setText(tr("Ping"));
} else if(QPushButton* button = qobject_cast<QPushButton*>(obj)) {
    button->setText(tr("Pong!"));
}
```

也可以从QObject派生类而不使用Q\_OBJECT宏，这样该派生类就不能使用元对象系统的特性，moc在编译代码也不会为该类生成元对象代码。从元对象系统的视角来看，一个继承了QObject，却没使用声明Q\_OBJECT宏的类，相当于该类祖先中最近的声明了Q_OBJECT宏的类。这意味着通过元对象功能获取的信息将是该祖先类的信息。

例如：

```
class Test1 : public QObject
{
    Q_OBJECT
public:
};

class Test2 : public Test1 { };

class Test3 : public Test2 { };
```

在上面的例子中，Test1,Test2,Test3三个类都直接或者间接从QObject类派生而来，因此它们都可以通过声明Q\_OBJECT宏来开启元对象特性。但是只有Test1声明了Q\_OBJECT,因此如果试图对Test2或者Test3使用元对象功能，如QMetaObject::className()，实际返回的是Test1的类名。

因此，定义了一个QObject子类，应当同时为其声明Q_OBEJCT宏，无论该类是否会使用信号与槽、属性等元对象机制。

<div id="index2-2"/>

### 属性系统(The Property System)

* [声明属性的要求(Requirements for Declaring Propertyies)](#index2-2-1)
* [使用元对象系统读写属性(Reading and Writing Properties with the Meta-Object System)](#index2-2-2)
* [示例(A Simple Example)](#index2-2-3)
* [动态属性(Dynamic Properties)](#index2-2-4)
* [属性和自定义类型(Properties and Custom Types)](#index2-2-5)
* [添加其他信息到类中(Adding Additional Information to a Class)](#index2-2-6)

Qt提供了一套复杂的类似于编译器供应商提供的属性系统。但是作为一个与编译器和平台无关的库，Qt并不依赖于非标准的编译器特定，像__property或者[property]之类的。Qt的解决方案可以在任何Qt支持的平台上使用标准C++工作。

<div id="index2-2-1"/>

#### 声明属性的要求(Requirements for Declaring Propertyies)
要为类声明属性，需要继承QObject并在类中声明Q_PROPERTY()宏。

```
Q_PROPERY( type name 
    (READ getFunction [WRITE setFunction] | MEMBER memberName [(READ getFunction | WRITE setFunction)]) 
    [RESET resetFunction]
    [NOTIFY notifySignal]
    [REVISION int]
    [DESIGNABLE bool]
    [SCRIPTABLE bool]
    [STORED bool]
    [CONSTANT]
    [FINAL] )
```

下面的例子是从QWidget类中摘取的一些典型的属性声明。

```
Q_PROPERTY(bool focus READ hasFocus)
Q_PROPERTY(bool enabled READ isEnabled WRITE setEnabled)
Q_PROPERTY(QCursor cursor READ cursor WRITE setCursor RESET unsertCurosr)
```

接下来的例子展示了如何使用MEMBER关键字将类成员变量导出为Qt属性。注意，此情况下必须声明一个NOTIFY信号以允许QML属性绑定。

```
class Example : public QObject
{
    Q_PROPERTY(QColor color MEMBER m_color NOTIFY colorChanged)
    Q_PROPERTY(qreal spacing MEMBER m_spacing NOTIFY spacingChanged)
    Q_PROPERTY(QString text MEMBER m_text NOTIFY textChanged)
    ...
signals:
    void colorChanged();
    void spacingChnaged();
    void textChanged(const QString &newText);
private:
    QColor m_color;
    qreal m_spacing;
    QString m_text;
};
```

属性的行为就像类数据成员，但是它还支持了额外的元对象系统的特性。  
* <font color="#ff8888">READ</font>访问符函数要求没有声明MEMBER变量。该访问符的作用是读取属性的值。最好的方式，应该使用一个const函数来完成做这件事，而且也应当返回属性类型的值或者该类型的const引用。例如，QWidget::focus是一个只读属性，它是通过READ访问函数QWidget::hasFocus()来访问的。
* <font color="#ff8888">WRITE</font>访问符函数是可选的。WRITE访问符声明的函数是用于设置属性的值。函数必须返回void并提供一个参数，或者属性类型的指针或者引用。例如QWidget::enabled属性就就拥有WRITE函数QWidget::setEnabled()。只读属性不需要WRITE函数。例如QWidget::focus属性就没有WRITE函数。
* <font color="#ff8888">MEMBER</font>变量关联在没有READ访问函数的时候必须声明。通过该关键字可以在不使用WRITE和READ的情况下读写类成员变量。除了MEMBER变量关联，当然也可以通过READ和WRITE来读写（但不能两者同时使用），以控制对变量的访问。
* <font color="#ff8888">RESET</font>函数也是可选的。它适用于为属性提供上下文定义的默认值(contxt specific default value)。例如，QWidget::cursor属性既有READ和WRITE函数，QWidget::cursor()和QWidget::setCursor()，也有RESET函数，QWidget::unsetCursor()，如果没有调用QWidget::setCursor()就会将属性值重置为上下文定义的值。RESET函数必须返回void，且没有参数。
* <font color="#ff8888">NOTIFY</font>信号是可选的。如果定义了，就应该为其声明一个类中存在的信号，在属性值发生改变的时候发出该信号。如果声明了MEMBER函数，NOTIFY必须有一个或者零个与属性类型一致的参数。该参数会将属性最新的值传递给该信号的信号处理函数。NOTIFY信号应该确保在确实改变了属性值是才被发送。这样可以避免在QML中对绑定属性的重新计算。Qt会在必要的时候，为MEMBER属性没有显示指定发送信号的情况下自动发送该信号。
* <font color="#ff8888">REVISION</font>数字是可选的。如果包含该关键字，它将定义属性和提示信号用于哪个特定的版本的API（通常用于QML中）。如果没有包含该该数值，默认为0。
* <font color="#ff8888">DESIGNABLE</font>变量用于指定该属性在GUI设计工具的属性编辑器中是否可见（例如，Qt Desinger）。绝大多数的属性都是可设计的（默认为true）。可以指定一个bool成员函数，来取代true或者false。
* <font color="#ff8888">SCRIPTABLE</font>变量用于指定该属性是否可以通过脚本引擎访问（默认为true）。可以通过指定bool函数来取代true或者false。
* <font color="#ff8888">STORED</font>变量用于指定该属性是独立存在还是取决于其他值。同时该变量还指定了在保存对象状态时是否保存属性的值。STORED变量默认是true，但是，例如QWidget::minimumWidth()就将STORED设置为false，因为该属性的值是从QWidget::minimumSize()获取的。
* <font color="#ff8888">USER</font>变量用于指定该属性是被指定为面向用户还是用户可编辑的。一般来说，每一个类只有一个UER属性(默认false)。例如，QAbstractButton::checked是可编辑属性。注意，通过QItemDelegate获取和设置空间的UER属性。
* <font color="#ff8888">CONSTANT</font>关键字存在，则说明将该属性的值是常量。对于给定的对象实例，READ函数必须返回和属性常量一样的值。每一个对象的该属性可能有不同的常量值。该常量属性不能拥有WRITE函数和NOTIFY信号。
* <font color="#ff8888">FINAL</font>关键字存在，用于指明该属性不该被派生类重写。这样做可以在一些类中执行优化操作，但moc不会强制执行。一定要注意不能重写一个声明了FINAL关键字的属性。该关键字类似于标准C++的final关键。

READ,WRITE,RESET函数都能被继承，也可以是虚函数。当他们在多重继承中被继承的时候，他们必须来自于第一个被继承的类。属性的类型可以是任何QVariant类支持的类型，或者是用户定义类型。下面的例子中，QData是被当作用户自定义类型来使用的。

```
Q_PROPERTY(QDate date READ getDate WRITE setDate)
```

因为QDate是用户定义类型，你必须在使用属性声明前包含<QDate>头文件。由于历史原因，QMap和QList属性类型需要使用QVariantMap和QVariantList类型替代。

<div id="index2-2-2">

#### 使用元对象系统读写属性(Reading and Writing Properties with the Meta-Object System)
属性的读写可以通过通用的函数QObject::property()和QObject::setProperty()来操作，这样只需要知道类的属性名称即可，不需要类的其他信息。在下面的代码片段中，调用QAbstractButton::setDown()和QObject::setProperty()都可以设置属性"down".

```
QPushButton *button = new QPushButton;
QOBject *object = button;

button->setDown(true);
object->setProperty("down",true);
```

上面两种方式中，通过WRITE函数访问属性，即第一种方式更好，因为这样更快也能在编译时提供更好的诊断，但是使用这种方式在编译时需要知道类的信息。通过属性名访问属性，可以在编译时不知道类的情况下访问类。你可以在运行时获得类的属性，通过QObject,QMetaObject和QMetaProperties.

```
QObject *object = ...
const QMetaObject *metaobject = object->metaObject();
int count = metaobject->propertyCount();
for(int i = 0; i < count; ++i) {
    QMetaProperty metaproperty = metaobject->property(i);
    const char *name = metaproperty.name();
    QVariant value = objecct->property(name);
    ...
}
```

在上面的代码中，QMetaObject::property()用于获取在未知类中定义的所有属性。属性名通过metadata获取，属性的值则通过QObject::property()传入指定属性名来获取。

<div id="index2-2-3">

#### 示例(A Simple Example)
假设我们定义了一个类MyClass，该类从QObject类派生，并在私有段成员段中定义了Q_OBJECT宏。我们想定义一个属性来保存一个优先级的值。属性名称是priority，类型是美剧类型Priority，该枚举类型定义在类中。  
我们使用Q\_PROPERTY()宏在MyClass的私有成员段中定义属性。我们需要READ函数priority(),WRITE函数setPriority()。我们的枚举类型必须使用元对象系统的Q\_ENUM()宏来注册到元对象系统中。通过注册该枚举类型，我们就可以在QObject::setProperty()枚举类型的枚举值了。MyClass类的定义如下：

```
class MyClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(Priority priority READ priority WRITE setPriority NOTIFY priorityChanged);

public:
    Priority { VeryHigh, High, Low, VeryLow };
    Q_ENUM(Priority)

    MyClass(QObject* parent=0);
    ~MyClass();

    void setPriority(Priority priortiy) {
        if(m_priority == priortiy)
            return;
        m_priority = priority;
        emit priorityChanged(m_priority);
    }

    Priority priority() const { return m_priority; };
signals:
    void priorityChanged(Priority);
private:
    Priority m_priority;
};
```

READ函数是常量类型并返回属性类型的值。WRITE函数则返回void并有一个属性类型的参数。这些都是moc强制要求的方式。  
下面的代码中定义了一个MyClass类指针，还有一个指向MyClass实例的QObject指针。我们有两种方式设置priortiy属性：

```
MyClass *myinstance = new MyClass;
QObject *object = myinstance;

myinstance->setPriority(MyClass::VeryHigh);
object->setProperty("priority",“VeryHigh”);
```

在本例中，属性是一个在类中定义的美剧类型，并使用Q_ENUM()宏注册到元对象系统中。这样就使得该枚举值可以通过字符串在QObject::setProperty()函数中作为参数传递属性值。如果该枚举类型是在其他类中定义的，就需要加上类作用域声明符，如OtherClass::VeryHigh.  
与Q\_ENUM()类似的宏Q\_FLAG(),也可以注册枚举类型到元对象系统中。但是Q\_FLAG()是用于标记一系列标志，例如可以通过位或运算符一起使用的各种标志位。I/O类可能会有Read和Write标志，它们可以通过QObject::setProperty()按照Read|Write的方式传递属性值。Q\_FLAG()应该用于注册此种类型的枚举类型。

<div id="index2-2-4"/>

#### 动态属性(Dynamic Properties)
QObject::setProperty()也可以用于在程序运行时为类的实例动态添加属性。当该函数传入参数是一个属性名和属性值的时候，如果该属性名已经存在且属性值类型正确，则属性值会直接保存在该已经存在的属性中同时函数返回true。如果属性值类型不合适，则属性不会发生任何改变，函数返回false。但是如果该属性本来不存在，一个新的属性就会创建，而函数仍旧返回false。也就是说，你无法通过函数返回false来确定该对象原来是否存在该属性，除非事先已经知道存在与否。  
注意动态属性是添加到对应的类的基类中，例如动态属性是被添加到QObject类而不是QMetaObject类中。要从实例中移除动态属性，可以通过属性名和一个非法的QVariant值传入到QObject::setProperty()中。QVariant的默认构造函数会构造一个非法的QVariant。  
动态属性的值可以通过QObject::property()函数查询，这和通过Q_PROPERTY()宏定义的属性是一样的。

<div id="index2-2-5">

#### 属性和自定义类型(Properties and Custom Types)
用于定义属性的自定义类型需要通过Q\_DECLARE\_METATYPE()宏注册，这样才可以将它们的值存储在QVariant对象中。这样就可以通过Q_PROPERTY()宏定义的静态属性和动态属性中使用该类型了。

<div id="index2-2-6">

#### 添加其他信息到类中(Adding Additional Infomation to a Class)
Q_CLASSINFO()宏可以添加其他属性名-值对形式信息到类的元对象总，例如：

```
Q_CLASSINFO("Version","1.0.0")
```

和其他元数据一样，类信息可以在运行时通过元对象访问。参考QMetaObject::classInfo().

<div id="index2-3"/>

### 对象模型(Object Model)
* [重要的类(Important Classes)](#index2-3-1)
* [Qt对象：标识与值](#index2-3-2)

标准C++对象模型提供了非常高效的对象范式(object paradigm)的运行时支持。但是它的静态性针对特定领域时显得不够灵活。图形用户接口编程就是一个要求兼具运行时效率和顶层灵活性的领域。Qt就结合C++的速度和Qt对象模型的灵活性于一体，满足了图形用户接口编程的这两方面要求。  
Qt添加了以下特性到C++:  
* 满足对象间无缝通信的信号与槽机制
* 可查询和可设计的的对象属性
* 强大的事件和事件过滤
* 上下文关联的字符串转换和国际化
* 通过定时器多任务整合到事件驱动的GUI中
* 当守护指针指向的对象被销毁的时候，指针自动置为0；而C++指针则会变成悬空指针
* 跨越库边界的动态类型转换
* 支持创建自定义类型

许多Qt特性都是通过标准C++功能实现的，只需要继承QObject即可。其他一些特性，如对象间通信的机制和动态属性系统，则需要Qt自己的元对象编译器(moc)提供的元对象系统的支持。
元对象系统是对C++的扩展，以使该语言更好地支持GUI编程。

<div id="index2-3-1"/>

#### 重要的类(Important Classes)
下表中的类是Qt对象模型的基础：  
| 类 | 说明 |
| :--- | :--- |
| QMetaClassInfo | 有关类的额外的信息 |
| QMetaEnum | 枚举值的元数据 |
| QMetaMethod | 成员函数的元数据 |
| QMetaProperty | 属性的元数据 |
| QMetaType | 管理元对象系统中的命名类型 |
| QObject | 所有Qt类的基类 |
| QSignalBlocker | Exception-safe wrapper around QObject::blockSignals() |
| QObjectCleanupHandler | 监视多个QObject的生命周期 |
| QMetaObject |包含了Qt对象的元信息 |
| QPointer | 为QObject对象提供守护指针(guarded pointer)的模板类 |
| QSignalMapper | Bundles signals from identifiable senders |
| QVariant | 类似联合体的Qt数据类型，支持Qt大多数常用的数据类型 |

<div id="index2-3-2">

#### Qt对象：标识与值(Qt Objects:Identity vs Value)
Qt的对象模型需要我们将Qt对象看作实体(identities)，而不是值。值是拷贝和赋值的；实体是通过克隆的。克隆意味着创建一个新的实体，并不是完全的赋值原来的对象。例如，双胞胎是两个不同的实体。他们可能看起来一样，但他们有不同的名字，位置以及可能完全不同的社会关系。  
克隆一个实体是比赋值或者赋值复杂得多的操作。我们可以看一看在Qt对象模型中这意味着什么：  

一个Qt对象...  
* 应该有一个独一无二的QObject::objectName().如果我们拷贝一个Qt对象，我们拷贝什么名字？
* 在对象体系中有一个位置。如果我们拷贝Qt对象，我们该把拷贝的位置放到哪里？
* 可以和其他Qt对象通过发射或者接收信号相连接。如果我们拷贝该Qt对象，如何将这些连接转化到拷贝的对象？
* 可以在运行时动态添加属性，而该属性没有在C++类中声明。如果我们拷贝Qt对象，拷贝对象应该包含这些动态创建的属性吗？
* 基于这些原因，应该将Qt对象视作实体，而非值。实体是可以克隆，而不能赋值和赋值的，而且克隆一个实体远比复制或者赋值操作复杂。<font color="#DD4444">因此，所有的QObject类及其子类都禁用了复制构造函数和赋值操作符。</font>

<div id="index2-4"/>

### 对象树和所有权(Object Tree & Ownership)
* [Overview](#index2-4-1)
* [QObject对象构造和析构顺序(Construction/Destruction Order of QObjects)](#index2-4-2)

<div id="index2-4-1"/>

#### Overview
QObject类型组织在对象树中。当使用其他QObject类作为父类创建一个Object对象的时候，该创建的子类会添加到父类的children()列表中，当父对象被删除的时候，子对象也会被自动删除。这种方式非常适合于对GUI对象。例如，一个QShortCut对象(键盘快方式)是其关联的窗口的子类，当用户关闭窗口的时候，快捷方式也会被销毁。  
QQuickItem类，从QObject类派生而来，是Qt Quick模块中所有可视元素的基类，但是与QObject父类不同，该类使用的是可视父类的概念。一个项的可视父类不一定和其对象父类相同。参考[Concepts-Visual Parent in Qt Quick](QtQuick.md/#VisualParent-index)了解更多细节。  
QWidget类，是Qt Widgets模块的基础类，扩展了父-子关系体系。一个子类一般也会编程一个子部件，例如，子部件显示在父类的坐标系统中，并且会被父类的边界裁剪。当应用删除一个消息对话框时，消息框的按钮，标签等也会被删除，这正是我们需要的行为。因为按钮和标签是消息框的子类。  
你也可以手动删除一个子对象。删除的自对象会从父类的子对象列表中移除。例如，当用户删除一个工具栏的时候，会导致应用删除一个QToolBar对象，这种情况下工具栏的QMainWindow父类对象需要侦测到变化并据此重新配置屏幕空间。  
调试函数QObject::dumpObjectTree()和QObject::dumpObjectInfo()在应用行为看起来出现异常时通常对发现问题所在非常有用。

<div id="index2-4-2"/>

#### QObject对象构造和析构顺序(Construction/Destruction Order of QObjects)
当QObject对象在堆中创建的时候(如使用new关键字)，可以以任何顺序构造一颗树，然后，这棵树中的对象可以按任何顺序销毁。当任何QObject对象从树中删除的时候，如果该对象有一个父类，析构函数会自动将对象从父类孩子列表中删除。如果该对象有孩子对象，析构函会自动删除每一个孩子对象。不管这棵树的顺序如何，任何对象都自会被删除一次。  
当QObject对象在栈中创建的时候，会发生同样的行为。正常来讲，析构的顺序不会出现什么问题。思考下面的片段：

```
int main()
{
    QWidget window;
    QPushButton quit("Quit", &window);
    ...
}
```

父类和子类都是QObject对象。因为QPushButton从QWidget派生而来，而QWidget从QObject派生。这段代码是完全正确的：quit对象的析构函数不会被调用两次，因为C++语言标准指出局部对象的析构函数是以构造函数调用相反的顺序调用的。因此，子类对象quit的析构函数会先调用，然后才是父类对象window的析构函数调用。 
但是想一下如果吧两者定义的顺序调换户发生什么：

```
int main()
{
    QPushButton quit("Quit");
    QWidget window;
    quit.setParent(&window);
    ...
}
```

这种情况，析构的顺序引发问题。父类的析构函数会先调用，因为它的构造函数最后调用。然后才会调用子类对象的析构函数，但是因为quit对象是一个局部变量，这是不正确的。随后当quit到作用域外时，它的析构函数会被再次调用，这时是正确的，但是此时对象已经被销毁了。

<div id="index2-5"/>

### 信号与槽(Signals & Slots)
* [简介(Introduction)](#index2-5-1)
* [信号与槽(Signals and Slots)](#index2-5-2)
* [信号(Signals)](#index2-5-3)
* [槽(Slots)](#index2-5-4)
* [示例(A Small Example)](#index2-5-5)
* [实例(A Real Example)](#index2-5-6)
* [信号与槽的默认参数(Signals and Slots With Default Arguments)](#index2-5-7)
* [信号与槽的高级用法(Advanced Signals and Slots Usage)](#index2-5-8)
    * [在Qt中使用第三方库的信号与槽(Using Qt With 3rd Party Signals and Slots)](#index2-5-8-1)

信号与槽用于对象间通信。信号与槽机制是Qt的核心特性。信号与槽由Qt的元对象系统提供。

<div id="index2-5-1"/>

#### 简介(Introduction)
在GUI编程中，当我们改变一个部件时，可能需要通知另外的部件。更常见的是，我们希望任何类型的对象能够和其他对象进行通信。例如，当我们点击一个关闭按钮，我们可能想要调用窗口的close()函数。  
其他一些软件工具包通过回调函数来实现对象间的通信。回调函数是指向函数的指针，如果你想让某个函数提示你一些事件，可以将指向该函数的指针作为参数传入其他处理函数。处理函数会在适当的时候通过指针调用该函数。回调函数的缺点在于不够直观，还可能遇到很多类型上的问题。

<div id="index2-5-2"/>

#### 信号与槽(Signals and Slots)
在Qt中，我们使用一种回调的替代方案：使用信号与槽。当一个事件发生的时候，信号会被发射。Qt的部件类(widgets)有已经预定义了的信号，但是我们可以为部件子类添加新的信号。槽是一个函数，用于相应和处理信号。在部件类中，同样存在预定义的槽函数，但通常我们需要定义自己的曹函数，根据自己的特定方式处理信号。  

![信号与槽示意图](SignalsSlots.png)  

信号与槽机制是类型安全的：信号的签名式和与之连接的槽的签名式必须匹配。（实际上槽函数的签名式可以比信号的签名式更短，因为它可以忽略一些多余的参数。）编译器可以发现基于函数指针的语法是否匹配，使用基于SIGNAL()和SLOT()的字符串的语法时，则在运行时检查是否匹配。信号与槽的关联度很低：一个类发射信号，并不知道也不关心谁会接收信号。但是信号与槽机制会保证已连接的信号与槽中，槽总会在信号发出后被调用。信号与槽可以传递任何数量，任何类型的参数，它们是绝对类型安全的。  
所有直接或者简介继承QObject的类都可以使用信号与槽机制。信号可以在任何其他类想注意到的地方添加并发射。这是所有类间进行通信的方式。这种机制并不需要关心谁发射或者接收到了信号。这是真正的信息封装，并且可以确保对象可以作为软件组件来使用。  
槽函数可以用于接收信号，但同时它们也是普通的类成员函数。正如一个对象不知道是否有其他对象接收它的信号，一个槽函数也不知道它是否有信号连接了该槽函数。这样可以确保Qt能够创建真正的独立组件。  
你可以随便连接多少信号到一个槽函数，反过来，一个信号也可以连接多个槽函数。甚至直接将一个信号连接到另外一个信号也是允许的。（这样无论第一个信号合适发射，第二个信号都会立马发射。）  
通过以上几种使用方式，信号与槽可以组成一个非常强大的组件编程机制。

<div id="index2-5-3"/>

#### 信号(Signals)
在一个类的内部状态发生变化时可以发送一个信号，其他对象可能会需要了解到这种变化。声明为共有权限的信号可以在任何地方使用和发送，但建议是只在定义了该信号的类或者子类中发出该信号。  
当信号发出时，与之相连的槽函数通常会立即执行，就像正常的函数调用一样。当发生槽函数对信号的相应时，信号与槽机制通常是独立于GUI事件循环的。在emit之后的语句会在所有槽函数都返回之后才执行(Excution of the code following the emit statement will occur once all slots have returnd)。这种情形不同于队列连接(queued connections)；在这种情况下，emit关键字之后的代码会立即继续执行，槽函数会在之后的某个时候执行。  
如果一个信号连接了几个槽函数，槽函数会按照连接的顺序一个接一个执行。  
信号会自动通过moc配置，一定不能在.cpp文件中为信号添加实现，信号也必须只能返回void。  
关于参数的注意事项：据经验来看，信号与槽的参数声明为更通用的类型可以使他们变得更加可复用。举例来说，如果QScrollBar::valueChanged()信号的参数类型假设是QScrollBar::Range，则该信号就只能用于连接专门为处理QScrollBar信号的槽函数了。这样信号函数既无法连接到其他可以处理值变化的槽函数，该槽函数也无法连接到其他的信号了。

<div id="index2-5-4"/>

#### 槽(Slots)
当槽函数连接的信号发出时，该槽函数就会被调用。槽函数就是普通的C++成员函数，而且可以通过普通方式调用；他们的唯一不同就是槽函数可以被信号触发调用。  
槽函数作为正常的成员函数使用时，遵循标准C++的成员函数调用规则。然而，作为槽函数，通过信号-槽连接，他们可以被任何组件调用，无论其访问等级如何。这意味着从任何类中发射的信号都可以使得与其不相关的类的私有槽函数可以被调用。  
你可以将槽函数定义为虚函数，实践证明这样做有相当大的用途。  
<font color="#dd4444">与回调函数相比，信号与槽要更慢一些，但是其灵活性更高。总的来说，发射信号到调用连接的槽函数要比通过回调函数调用慢近十倍。</font>这主要是因为需要定位到信号连接的对象，然后安全地遍历所有连接（例如需要保证发射信号期间序列中所有接收者没有被销毁），并且将所有参数整理为统一风格。十倍的调用花销听起来很多，但相比于new和delete操作，它的花销已经算很小了。例如你需要操作字符串，vector或者list都需要在表尾执行new或者delete操作，信号与槽的开销只占了很小的一部分。  
有些第三方库可能已经定义了被称为signals和slots的变量，这将会导致编译器警告或者报错。可以使用#undef来避免这个问题。

<div id="index2-5-5"/>

#### 示例(A Simple Example)
首先定义一个简单的C++类：  

```
class Counter
{
public:
    Counter() { m_value = 0; }

    int value() const { return m_value; }
    void setValue(int value);
private:
    int m_value;
};
```

然后定义一个简单的基于QObject的类：

```
#include <QObject>

class Counter : public QObejct
{
    Q_OBJECT
public:
    Counter() { m_value = 0; }
    
    int value() const { return m_value; }
public slots:
    void setValue(int value);
signals:
    void valueChanged(int value);
private:
    int m_value;
};
```

从QObject类派生的版本与标准C++版本的类有着相同的内部状态，并且也提供了了访问该状态的公共方法，但是从QObject派生的类使用了信号与槽，这使得其可以实现组件编程。该类可以通过发出信号valueChanged()，告诉外部世界它的内部状态发生了改变，它还有一个槽函数可以获取其他类发送的信号。  
所有要使用信号与槽机制的类必须继承QObject类，并在类中声明Q_OBJECT宏。  
槽函数是类设计者实现的。下面是我们的类的槽函数setValue()可能的实现：

```
void Counter::setValue(int value)
{
    if(m_value != value) {
        m_value = value;
        emit valueChanged(value);
    }
}
```

emit关键字会发射valueChanged()信号，它会将新的值传递给连接的槽函数。  
在下面的代码片段中，我们创建了两个Counter对象。我们将使用QObejct::connect()函数把第一个对象的valueChanged()信号和第二个对象的槽函数setValue()相连接：  

```
Counter a, b;
QObject::connect(&a,&Counter::valueChanged,&b,&Counter::setValue);
a.setValue(12);
b.setValue(48);
```

调用a.setValue(12)会使a发射valueChanged(12)信号，b则会接收到该信号并调用setValue(12)槽函数。然后b也会发射valueChanged(12)信号，但是没有任何槽函数与之相连，所以该信号不会被任何函数接收处理。  
注意setValue()函数仅在m\_value != value时重新设置m\_value的值并发射信号。这样可以防止循环连接，不断发射和接收信号。  
默认情况下，所有连接的信号一旦触发都会被发射。信号重复发射可能是重复的。你可以使用disconnect()函数断开任意一个指定的信号-槽的连接。如果为connect()指定Qt::UniqueConnection类型的参数，就可以只在指定信号-槽没有连接过的时候建立。如果连接已经存在了，connenct()函数将返回false。这样可以保证一对信号-槽只会建立一次连接。  
本例模仿了对象间在不需要知道任何信息的时候建立的连接。对象间只需要连接到一起即可。可以通过QObject::connect()函数的简单形式调用或者使用uic的自动连接特性即可。  

<div id="index2-5-6"/>

#### 实例(A Real Example)
下面定义了一个简单的部件类：

```
#ifndef _LCDNUMBER_H_
#define _LCDNUMBER_H_

#include <QFrame>

class LcdNumber : public QFrame
{
    Q_OBJECT

```
LcdNumber通过QFrame继承了QObject类。  
Q_OBJECT宏会在预处理器中展开并添加由moc实现的成员函数；如果在编译时出现"undefined reference vtable for LcdNumber"的错误,你可能忘记了运行moc或者没有包含moc输出文件。

```
public:
    LcdNumber(QWidget *parent = 0);
```

如果自定义的类继承了QWidget，一般都需要一个parent变量作为构造函数的参数，并将其传给基类的构造函数。 这里忽略了析构函数和一些成员函数；moc会忽略成员函数。

```
signals:
    void overflow();
```

LcdNumber中出现不可能的值的时候会发出信号。  
如果你不关心溢出，或者知道溢出的情况一定不会发生，你可以忽略overflow()信号，比如，不把任何槽函数与该信号相连。  
相反，如果你想要处理两种不同情况的溢出错误，你可以将信号连接到两个不同的槽函数。Qt会按照其连接顺序一次调用槽函数。  

```
public slots:
    void display(int num);
    void display(double num);
    void display(const QString & str);
    void setHexMode();
    void setDecMode();
    void setOctMode();
    void setBinMode();
    void SetSamllDecimalPoint(bool point);
};

#endif
```

槽函数用于接收其他部件状态改变的信号。LcdNumber用这些槽函数来显示数字。display()是LcdNumber的类接口，并且槽函数是公共的。  
可以将QScrollBar的valueChanged()信号连接到LcdNumber类的display()槽函数，这样LCD就可以持续显示滑块的变化了。  
display()函数被重载了；Qt会选择最恰当的版本来处理信号。如果使用回调函数，你必须自己找到不同的名称比自己跟踪函数的类型。

<div id="index2-5-7"/>

#### 信号与槽的默认参数(Signals and Slots With Default Arguments)
信号和槽函数的签名式可能包含参数，而且参数可以有默认值。比如QObject::destroyed():

```
void destroyed(QObject* = 0);
```

当删除一个QObject对象时，就会发射QObject::destroyed()信号。我们可能会引起悬空引用的的地方获取信号，这样我们可以适时清除该引用。一个合理的槽函数签名式可能是这样：

```
void objectDestroyed(QObject* obj = 0);
```

要连接信号和槽函数，需要使用QObject::connect()函数。信号-槽有多种连接方式。第一种是使用函数指针：

```
connenct(sender,&QObject::destroyed,this,&MyObject::objectDestroyed);
```

在QObject::connect()函数中使用函数指针有几点好处。第一，通过函数指针，可以让编译器检查信号的参数和槽函数的参数是否匹配。还可以在需要的时候隐式转换参数。  
不仅如此，还可以将信号连接到函数对象或者lambda表达式：

```
connect(sender,&QObject::destroyed,[=](){this->m_objects.remove(sender);});
```

使用QObject::connect()函数连接信号与槽的方式是使用SIGNAL()和SLOT()宏。使用SIGNAL()和SLOT()宏时是否包含参数的原则是，如果作为SIGNAL()宏的参数的函数的参数有默认值，则该函数参数的数量不能少于作为SLOT()的函数的参数。  
一下几种方式都是可以的：

```
connect(sender,SIGNAL(destroyed(QObject*)),this,SLOT(objectDestroyed(QObject*)));
connect(sender,SIGNAL(destroyed(QObject*)),this,SLOT(objectDestroyed()));
connect(sender,SIGNAL(destroyed()),this,SLOT(objectDestroyed()));
```

但是下面的方式是不能工作的：

```
connect(sender,SIGNAL(destroyed()),this,SLOT(objectDestroyed(QObject*)));
```

因为槽函数需要一个QObject*参数，但是信号却没有传递该参数。该连接会导致运行时错误。  
当使用SIGNAL()和SLOT()宏时，编译器不会检查参数是匹配。

<div id="index2-5-8"/>

#### 信号与槽的高级用法(Advanced Signals and Slots Usage)
在一些情况下你可能需要获取发送信号的对象的信息，Qt提供了QObject::sender()函数，可以获取指向发送信号的对象的指针。  
QsignalMapper类可以用于有多个信号连接到同一槽函数时，槽函数可能需要针对不同信号做出不同的处理的情形。  
假设你有三个按钮来选择打开何种文件："Tax File","Accounts File","Report File".  
为了能打开正确的文件，需要使用QSignalMapper::setMapping()函数来将所有QPushButton::clicked()信号映射到QsignalMapper对象。然后将QPushButton::clicked()信号连接到QSignalMapper::map()槽函数。

```
//signalMapper已经声明为自定义类的成员变量
signalMapper = new SignalMapper(this);
signalMapper->setMapping(taxFileButton,QString("taxfile.txt"));
signalMapper->setMapping(accountFileButton,QString("accountfile.txt"));
signalMapper->setMapping(reportFileButton,QString("reportfile.txt"));

connect(taxFileButton,&QPushButton::clicked,signalMapper,&QSignalMapper::map);
connect(accountFileButton,&QPushButton::clicked,signalMapper,&QSignalMapper::map);
connect(reportFileButton,&QPushButton::clicked,signalMapper,&QSignalMapper::map);
```

然后将mapped()信号和readFile()槽函数连接，根据mapped()传递的参数就可以打开不同的文件了。

```
connect(signalMapper,SIGNAL(mapped(QString)),this,SLOT(readFile(QString)));
```

<div id="index2-5-8-1"/>

##### 在Qt中使用第三方库的信号与槽(Using Qt With 3rd Party Signals and Slots)
在Qt中也可以使用第三方库的信号/槽机制。甚至可以在同一个工程中结合使用两种机制。只需要在qmake工程文件.pro中添加一行命令即可：

```
CONFIG += no_keywords
```

该命令告诉moc不要定义signals,slots,emit关键字，因为它们已经在我们要使用的第三方库中定义了，如Boost。接下来要在Qt工程中使用涉及这些Qt关键字的地方，可以使用对应的宏代替，如Q\_SIGNALS(或Q\_SIGNAL),Q\_SLOTS(Q\_SLOT),Q\_EMIT等。

<div id="index3"/>

<font color="grey">

## 线程和并发编程(Threading and Concurrent Programming)
Qt以平台无关的线程类、线程安全的事件发布、跨线程的信号槽连接的方式提供了对线程的支持。通过多线程编程方式可以实现不影响程序用户接口正常交互的情况下处理其他耗时的操作。  
在页面[Qt中的线程支持(Thread Support in Qt)](#index3-1)中包含了关于如何在应用中实现多线程的内容。其他并发编程类由[Qt Concurrent](#index3-2)模块提供。

</font>

<div id="index4"/>

## 输入/输入、资源和容器(Input/Output,Resources,and Containers)
Qt提供了一个管理应用文件和资源(Assets)的资源(Resources)系统，一系列容器和接收输入、打印输出的类。  
* [容器类(Container Classes)](#index4-1)
* [序列化Qt数据类型(Serializing Qt Data Types)](#index4-2)
* [隐式共享(Implicit Sharing)](#index4-3)

另外，Qt Core模块提供了独立于平台的在应用的可执行文件中存储二进制文件的机制。  
* [Qt资源系统(The Qt Resource System)](#index4-4)

<div id="index4-1"/>

### 容器类(Container Classes)
* [简介(Introduction)](#index4-1-1)
* [容器类(The Container Classes)](#index4-1-2)
* [迭代器类(The Iterator Classes)](#index4-1-3)
    * [Java风格迭代器(Java-Style Iterators)](#index4-1-3-1)
    * [STL风格迭代器(STL-Style Iterators)](#index4-2-3-2)
* [foreach关键字(The foreach Keyword)](#index4-1-4)
* [其他类容器类(Other Container-Like Classes)](#index4-1-5)
* [算法的复杂度(Algorithmic Complexity)](#index4-1-6)
* [增长策略(Growth Strategies)](#index4-1-7)

<div id="index4-1-1"/>

#### 简介(Introduction)
Qt库提供了各种基于模板的通用容器类。这些类可以用于存储指定类型的对象。例如，想要一个大小可以变化的QString数组，可以使用QVector<QString>.  

Qt的容器类比STL容器类更轻量、安全、容易使用。如果你不熟悉STL，或者更喜欢以Qt方式开发，你就可以使用这些类来代替STL类。  

Qt容器类是隐式分享(implicitly shared)的，他们具有可重入性(reentrancy)，速度优化，更少的内存消耗，更少的内联代码展开，生成更小的可执行文件。另外，这些类是线程安全的。所有线程都可以将其作为只读容器访问他们。  

要遍历存储在容器中的元素，你可以使用两种风格的迭代器：Java风格和STL风格的迭代器。Java风格的迭代器更容易使用且拥有更顶层的功能，而STL风格的迭代器的效率要略高一些，并且可以和STL通用算法兼容使用。  

Qt中还对foreach关键字的支持，可以便捷地遍历容器中的元素。  

<div id="index4-1-2"/>

#### 容器类(The Container Classes)
Qt中提供了一下几种序列容器：QList,QLinkedList,QVector,QStack,QQueue.对于大多数应用来讲，QList是最常用的一种容器。尽管其底层是数组顺序表实现的，但向其表头和表位都可以快速添加元素。如果确实需要一个链表，则可以使用QLinkedList；如果想让容器中的所有元素在一块连续存储空间中，则可以使用QVector。QStack和QQueue则适合于提供LIFO和FIFO功能。  

Qt中的关联容器有：QMap,QMultiMap,QHash,QMultiHash,QSet.“Multi”开头的容器可用于存放一个关键字对应多个值的元素。“Hash”容器使用hash函数代替二叉搜索在一个有序序列中执行更快速的查找操作。  

QCache和QContiguousCache类提供了在一块有限的存储空间中使用哈希查找执行高效查找的功能。  

| Class | Summary |
| :---  | :---    |
| QList<T> | 这是目前使用最为广泛的容器类了。它存储的值可以通过索引获得。QList的底层实现为数组，可以保证通过索引快速获访问元素。元素可以使用QList::append()添加到表位，也可以使用QList::append()添加到表头，或是使用QList::insert()插入表中任意位置。与其他容器相比，QList经过高度优化，在可执行文件中只展开很小一部分代码。QStringList类就是从QList<QString>类派生而来。|
| QLinkedList<T> | 该容器类似于QList，只是这个容器是通过迭代器来访问元素，而不是数组下标。在向表的中间部位插入大量元素的时候，QLinkedList<T>容器的性能更好，而且只要迭代器指向了该容器的一个元素，无论怎么插入元素，该迭代器使用有效，且一直指向该元素。（向QList中插入或者删除元素会导致迭代器失效） |
| QVector<T> | 该容器以连续空间存储所有元素。向容器头和中间插入会非常慢，因为需要将大量元素向后移动以留出空间插入新元素。|
| QStack<T> | 从QVector派生而来，用于“last in,first out”的使用堆栈的场景。|
| QQueue<T> | 从QList类派生而来，用于"first in,first out"的队列场景。|
| QSet<T> | 提供了可快速查找的单值数学序列 |
| QMap<Key,T> | 提供了一个关键字和值映射的字典(关联数组)。一般每个关键字都关联一个值。QMap以关键字的顺序存储数据；如果不在意数据的存储顺序，QHash则比QMap更快。|
| QMultiMap<Key,T> | 存储多值映射的数据。 |
| QHash<Key,T> | 该容器的API几乎与QMap完全一致，但其提供了更快速的查找方法。QHash以乱序存储数据。|
| QMultiHash<Key,T> | 用于多值映射的hash表。|

容器也可以被嵌套到其他的容器中。例如QMap<QString,QList<int>>这样的用法是完全可以的。在这里其关键字类型是QString的，获取的的值是QList<int>类型。




<div id="index4-1-3"/>
<div id="index4-1-3-1"/>
<div id="index4-1-3-2"/>
<div id="index4-1-4"/>
<div id="index4-1-5"/>
<div id="index4-1-6"/>
<div id="index4-1-7"/>

<p id="workingNowIndex" style="font-size:30px;color:#ff8888">本页面进行到这里了......</p>

<div id="index4-2"/>

### 序列化Qt数据类型(Serializing Qt Data Types)

<div id="index4-3"/>

### 隐式共享(Implicit Sharing)

<div id="index4-4"/>

### Qt资源系统(The Qt Resource System)

<div id="index5"/>

## 其他框架(Additional Frameworks)

Qt Core模块还提供了Qt的其他关键框架：  
* [动画框架(The Animation Framework)](#index5-1)
* [Json支持框架(JSON Support in Qt)](JsonSupportInQt.md)
* [状态机框架(The State Machine Framework)](#index5-3)
* [创建Qt插件(How to Create Qt Plugins)](#index5-4)
* [事件系统(The Event System)](#index5-5)


<div id="index6"/>

## 许可(Licenses and Attributions)

_未完成_

<div id="index7"/>

## 参考(Reference)

_未完成_

