# Graphics View Framework

* [The Graphics View Architecture](#index-1)

Graphics View provides a surface for managing and interacting with a large number of custom-made 2D graphical items, and a view widget for visualizing the items, with support for zooming and rotation.
The framework includes an event propagation architecture that allows precise double-precision interaction capabilities for the items on the scene. Items can handle key events, mouse press, move, release and double click events, and they can also track mouse movement.
Graphics View uses a BSP (Binary Space Partitioning) tree to provide very fast item discovery, and as a result of this, it can visualize large scenes in real-time, even with millions of items.
Graphics View was introduced in Qt 4.2, replacing its predecessor, QCanvas.
图形视图框架提供了整合管理大量自定义2D图形项的机制。使用视图部件显示图形项，支持缩放和旋转。  

## The Graphics View Architecture

### The Scene
QGraphicsScene类提供图形视图场景。其作用是：
1 提供管理大量可视项的高效接口
2 传播事件到每一个可视项
3 管理可视项状态，如选择，焦点等
4 提供未转化的渲染功能；主要用于打印
场景类是作为QGraphicsItem对象的容器使用。这些Item对象使用QGraphicsScene::addItem()函数添加到场景中。使用搜索可视项的函数来检索可视项。QGraphicsScene::items()函数及其重载函数返回所有项，包括通过点、矩形、多边形或者通用矢量路径插入的项。QGraphicsScene::itemAt()函数返回在指定点最上层的项。所有的可视项查找函数都以降序返回检索的可视项。 （即以堆栈模型返回检索的可视项，最先返回的是在堆栈最上方的可视项。）

QGraphicsScene类以事件传播结构为每一个项调度场景事件，并且负责管理两项之间的事件传播。如果场景在一个点上接收到了一个鼠标点击事件，它会将事件发送到任何在这个点上的可视项。

QGraphicsScence类还管理了项的特定状态，例如选择和聚焦状态。可使用setSelectionArea()函数，指定一个专门的形状来选择特定项。这个功能也可以在QGraphicsView中作为自定义形状选择的基础。要获取当前已经选中的所有项，使用selectedItem()函数。其他由QGraphicsScene管理的项状态还有项是否被键盘输入聚焦。可以通过setFocusItem()和setFocus()函数将焦点设置到指定的项上。可以使用focusItem()函数返回当前获得焦点的项。

最后，QGraphicsScene类还可以将场景的部分渲染到绘图设备上，使用render()函数即可。

### The View
QGraphicsView类提供了视图部件，用于显示场景的内容。可以将多个视图绑定到同一个场景上，实现将多个不同的视角(viewport)应用到一个相同的数据集上。视图部件是一个可滚动的区域，并且提供了滚动条用于在大场景中导航。要开启OpenGL的支持，可调用QGraphicsView::setViewport()，将QGLWdiget类设置为视角。

视图会接收键盘和鼠标的输入事件，并在发送事件到可视项之前，将其转换为场景事件（将坐标转换为合适的场景坐标）。

通过QGraphicsView::transform()函数使用转换矩阵，视图可以转换场景的坐标系统。这样视图就可以支持跟高级的导航特定，如缩放和旋转。为了方便起见，QGraphicsView还提供了在视图和场景间转换坐标的函数：mapToScene()和mapFromScene().

### The Item
QGraphicsItem类是场景中图形项的基本类型。图形视图框架提供了几种常用的典型图形，如矩形(QGraphicsRectItem)，椭圆(QGraphicsEllipseItem)，和文本项(QGraphicsTextItem)，但是在创建自定义的图形项时QGraphicsItem具有更大的威力。相比于其他项，QGraphicsItem支持一下特性：  
* 支持鼠标事件
* 键盘输入焦点和按键事件
* 抓取释放(Drag and Drop)
* 通过父-子关系，和QGraphicsItemGroup组合
* 碰撞检测

Item也使用本地坐标系统，和视图类一样，Item也提供了许多在场景和项之间，项与项之间进行坐标映射的函数。而且，Item也可以使用transform()函数通过转换矩阵将自身的坐标系统进行转换。这样可以很方便地对一个项进行自身旋转和缩放。

一个项可以通过将其他项作为子类，来包含其他项。父项的所有转换关系都会被子项继承。

QGraphicsItem类还支持碰撞检测，使用shape()函数和collidesWith()都是虚函数。通过从shape()函数返回的项的形状和坐标QPainterPath，QGraphicsItem会处理所有的碰撞。如果你想提供自己的碰撞检测，也可以通过实现collidesWith()函数来完成。

## The Graphics View Coordinate System
图形是图框架的坐标系基于笛卡尔坐标系；可视项的位置和几何形状有两组数字表示：x坐标和y坐标。当使用没有转换的视图查看场景的时候，一个场景上的一个单元(unit)表示屏幕上对应的一个像素。

注意：Qt中的Y轴朝下。倒置Y轴坐标系统（y向上增长）在图形视图框架是不支持的。

在图形视图中有三种有效的坐标系统：可视项坐标，场景坐标，视图坐标。为了简化开发者的实现，图形视图框架提供了各种在这三种坐标之间相互映射的函数。

当进行渲染的时候，图形视图框架的场景坐标对应QPainter的逻辑坐标，视图坐标和目标设备的坐标一致。在Qt GUI模块的[Coordinate System](QtGUI.md)文档中，你可以了解到逻辑坐标和设备坐标之间的关系。

### Item Coordinates
可视项有一套自己的坐标系统。他们的坐标原点通常在几何图形中间。在可视项中的几何图元的坐标系统通常和可视项的点，线，或者矩形图形相联系。

当创建可视项的时候，可视项坐标是你唯一需要考虑的东西；QGraphicsScene和QGraphicsView会为你执行所有的转换。例如，如果你接受到鼠标或者抓取事件，事件的位置提供的是可视项的坐标。当一个点在可视项中时，QGraphicsItem::contains()函数会返回true，否则就返回false。作为contains()函数的点位置是该可视项的坐标系统中的坐标。

所有可视项的位置都是基于其父对象的坐标系统来描述的。场景是作所有无父对象的可视项的父类。最顶层的可视项的位置也是在场景的坐标系中。

由于可视项的位置和转换和其父对象关联，那子对象的坐标不会受到父对象的坐标转换的影响。尽管父类坐标的转换会隐式地转换子类坐标系。即子坐标系原点在父坐标系中处于(10,0)位置，不管父坐标系如何转换，子坐标系原点的位置始终处于父坐标系的(10,0)位置。子坐标系统会随着父坐标系统的旋转缩放等变换一起变化。

除了QGraphicsItem::pos()之外，QGraphicsItem的函数都是在其局部坐标系上进行操作。

## Scene Coordinates
场景是表示所有可视项的基本坐标系统。场景坐标系描述了所有顶级可视项在场景中的位置。并且包含了所有从视图发送到场景中的场景事件。每一个在场景中的可视项都有一个场景位置和一个矩形边框。场景位置描述了可视项在场景坐标系中的位置，场景矩形边框则是决定QGraphicsScene如何发现场景中区域发生了什么变化的基础。场景中发生的改变通过QGraphicsScene::changed()信号进行通知，其参数是一个场景中矩形区域列表。

## View Coordinates
视图坐标是其关联部件的坐标。视图坐标中每一个单元对应一个像素。比较特别的是，视图坐标是和部件或者视口相关联的，并且不会收到场景坐标变换的影响。视图坐标的的原点在左上角，Y轴从上至下增加。而可视项和场景坐标系都是原点在中心位置，并且Y轴向上增长。所有的鼠标事件，包括抓放事件都是先被视图作为视图事件接收到，你必须将事件的坐标值映射为场景坐标，才能最终发送给可视项进行事件响应。

## Coordinate Mapping
通常在场景中处理可视项的时候，将坐标和形状从场景映射到可视项，从一个可视项到另一个可视项，或者从视图到场景是通常需要进行的转换。例如，当在QGraphicsView的视口上使用鼠标点击时，可以使用QGraphicsView::mapToScene()将坐标映射到场景，然后跟着调用QGraphicsScene::itemAt()用来获取在鼠标点击位置的可视项的索引。如果你想知道该可视项在视图的视口中的位置，可以使用QGraphicsItem::mapToScene()然后接着使用QGraphicsView::mapFromScene()。最后，如果想知道在视图的椭圆中是哪个可视项，可以将QPainterPath作为参数传入mapToScene()，然后将映射后的路径作为QGraphicsScene::items()的参数。

你可以使用QGraphicsItem::mapToScene()和QGraphicsItem::mapFromScene()映射坐标和形状到可视项，或者反过来，从可视项的场景中映射坐标和形状。此外，还可以使用QGraphicsItem::mapToParent()和QGraphicsItem::mapFromParent()同可视项的父对象进行映射。使用QGraphicsItem::mapToItem()和QGraphicsItem::mapFromItem()可以在相互独立的可视项之间进行相互映射。图形视图框架中的所有映射函数都可以映射点，矩形，多边形和路径。

在视图中也有同样的映射函数，QGraphicsView::mapToScene()和QGraphicsView::mapFromScene()函数，可以同场景进行相互映射。要使视图和可视项间进行映射，需要先转换到场景中，然后再映射到目标对象。

## 关键特性(Key Features)







