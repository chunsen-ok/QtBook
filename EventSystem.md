# The Event System
* [How Events are Deliverd](#index1)
* [Event Types](#index2)
* [Event Handlers](#index3)
* [Event Filters](#index4)
* [Sending Events](#index5)

在Qt中，事件是一个对象，从抽象类QEvent类派生。事件表示应用内或者外部发生的活动结果。事件可以被所有QObject的子类接收和处理，事件在部件类中应用尤其重要。

## How Events are Deliverd
当事件发生时，Qt会创建一个表示该事件的恰当的事件对象，然后通过调用需要接收事件的实例的event()函数，将该事件发送到该特定的QObject实例中。

event()函数并不自行处理事件；根据发送的事件类型，该函数调用专门的事件处理函数，并返回是接收函数忽略函数函数的相应状态。

有些事件，如QMouseEvent和QKeyEvent，来自于系统；另有些事件，如QTimerEvent则来自于其他事件源；还有的来自于应用本身。

## Event Types
绝大多数事件都有对应的事件类，如QResizeEvent,QPaintEvent,QMouseEvent,QKeyEvent,QCloseEvent等等都是QEvent的子类并添加了各自的功能函数。例如，QResizeEvent添加了size()和oldSize()函数，可以获取部件的维度变化的具体值。

有些类支持多种事件类型。如QMouseEvent支持鼠标按键，双击，移动，以及其他和鼠标相关的操作事件。

每一个事件都有对应的类型，定义在QEvent::Type枚举中，通过该事件类型枚举我们可以据此获取运行时类型信息快速了解实际构造的事件对象。

虽然程序做出反应的原因多种多样且很复杂，但是Qt的事件发送机制是非常灵活的。在QCoreApplication::notify()的文档中有关于这方面的简要的完整叙述。在《Qt Quarterly》的文章<Another Look at Events>中也有提及。此处讲述的内容在95%的应用开发中已经足够了。

## Event Handlers





