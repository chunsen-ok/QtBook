# Qt Full Book
主要按照模块进行学习。  
翻译内容，标题、正文有感觉翻译不准的都带上英文。  
## 目录
* [Qt Modules](QtModules.md)
    * [Qt Core](QtCore.md)
        * [Implicit Sharing](ImplicitSharing.md)
        * [The Qt Resource System](ResourceSystem.md)
    * [Qt Widgets](QtWidgets.md)
        * [图形视图框架(Graphics View Framework)](GraphicsViewFramework.md)
        * [Qt样式表(Qt Style Sheets)](QtStyleSheets.md)
    * [Qt QML](QtQml/QtQml.md)
        * [QML Modules](QtQml/QmlModules.md)
    * [Qt Quick](QtQuick.md)
    * [Qt GUI](QtGUI.md)
        * [Coordinate System](QtGUI_CoordsSys.md)
    * [Qt Multimedia](QtMultimedia.md)
    * [Qt MultimediaWidgets](QtMultimediaWidgets.md)
    * [Qt Serial Port](QtSerialPort.md)
    * [Qt Charts](QtCharts.md)
    * [Qt SQL](QtSQL.md)
* [Overviews](Overviews.md)
    * [Core Internals](CoreInternals.md)
        * [The Event System](EventSystem.md)
        * [How to Create Qt Plugins](QtPlugins.md)
    * [Windowing System](WindowingSystem.md)
    * [Qt Application hierarchy](AppHierarchy.md)
    * [Qt Development Tools](DevTools.md)
        * [Using the Meta-Object Compiler(moc)](Qt_moc.md)
        * [qmake Manual](qmake.md)
* [Class Reference](QtClassReference.md)
* [Develop Reference](DevelopRefer.md)
* [Logs](Logs.md)
* [单词索引](UnknownWords.md)

## 进行中且未整理的内容

### Qt框架(Qt Framework)
通过直观的C++ API和使用类JavaScript的编程语言在Qt Quick中快速构建UI。

## Logs
### 2017-01-28 18:12
QML应用就是以QML语言及其标准库Qt Quick作为前端实现，C++及其库作为后端实现的Qt应用。
Qt QML模块中实现了QML语言及其语言引擎。而Qt Quick则是QML语言的标准库。里面由许多语言实现的标准类型和接口等，我们就可以直接使用这些类型或者借口而不用自己再重复实现。当然也可以实现自己的QML库。

