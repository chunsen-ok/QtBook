# Qt Development Tools
Qt是跨平台的应用程序和用户交互界面的开发工具。

使用Qt进行开发的最简便的方式是下载并安装Qt 5.它包含了Qt库，示例，文档和必备的开发工具，例如Qt Creator继承开发环境。

Qt Creator为一个完整的应用开发流程提供了足够的工具，从创建工程到将应用部署到目标平台。Qt Creator会自动进行一些任务，根据开发者的选择创建一些必要的工程文件。而且，它还可以加速开发过程中的任务，如在编写代码时，能够提供语意提醒，语法检查，代码完善，重构动作以及其他有用的特性。

Qt Creator中整合了一下Qt开发工具：  
* Qt Designer 用于为Qt Widgets设计和构建图形用户界面。开发者可以在可视化编辑器中整合和定义自己的部件或者对话框，并且可以通过多种不同的方式即进行测试。Qt Designer可以在Qt Creator中的设计模式下打开。
* qmake 为不同平台构建应用。你也可以使用其他构建工具，例如CMake,Qbs或者Autotools。当使用qmake或者CMake的时候，开发这需要在项目模式下指定构建系统。当使用Qbs或者Autotools的时候，在Qt Creator中打开.qbs或者.am文件。
* Qt Linguist ......
* Qt Assistant ......

除此之外，还可以使用一下工具：

| Tool                                | Description |
| :---------------------------------- | :---------- |
| makeqbf                             | 为嵌入式设备创建预渲染字体 |
| Meta-Object Compiler(moc)           | 为QObject子类生成元对象信息 |
| User Interface Compiler(uic)        | 根据用户界面文件生成C++代码 |
| Resource Compiler(rcc)              | 在构建过程中将资源嵌入到Qt应用中 |
| Qt D-Bus XML compiler(qbbusxml2cpp) | |
| D-Bus Viewer                        | |
| Qt Quick Compiler                   | QML编译器，可以在没有部署QML源码的目标平台中构建Qt Quick应用 |
| Qt VS Tools                         | |
