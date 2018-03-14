# Qt Core Interals - How to Create Qt Plugins

## Contents
* [上层API：编写Qt扩展(The High-Level API: Writing Qt Extensions)](#index-1)
* [底层API：扩展Qt应用(The Low-Level API: Extending Qt Applications)](#index-2)
* [定位插件(Locating Plugins)](#index-3)
* [静态插件(Static Plugins)](#index-4)
  * [关于链接静态插件的细节(Details of Linking Static Plugins)](#index-41)
  * [创建静态插件(Creating Static Plugins)](#index-42)
* [部署和调试插件(Deploying and Debugging Plugins)](#index-5)

Qt中提供了两种创建插件的方式：  
* 上层API用于编写Qt自身的扩展：自定义数据库驱动，图像格式，文本解码，自定义风格等等；
* 底层API用于扩展Qt应用。

例如，如果你想编写一个派生自QStyle的子类，并且通过Qt应用动态加载使用，你应该使用上层API。

一般上层API建立在底层API基础上，有的情况两种都需要使用。(Since the higher-level API is built on top of the lower-level API, some issues are common to both.)

如果你想在Qt Designer使用自定义插件，可以参考Qt Designer模块的文档。

<div id="index-1"/>

## 上层API：编写Qt扩展(The High-Level API: Writing Qt Extensions)
编写用于Qt自身的扩展插件是通过派生合适的基类，实现少量函数，添加一些宏实现的。

用于此类插件扩展的基类有很多。派生的插件被保存在标准插件的特定子路径下。如果插件没有在这些路径下，Q将无法找到它们。

下面的这张表总结了用于插件的基类。有些类是私有的（非私有的会注明），因此没有提供相应的文档。你可以使用它们，但是无法保证在以后的Qt版本中仍然可以使用。

| Base Class | Directory Name | Qt Module | Key Case Sensitivity |
| :--- | :--- | :--- | :--- |
| QAccessibleBridgePlugin | accessiblebridge | Qt GUI | Case Sensitive |
| [QImageIOPlugin](#非私有) | imageformats | Qt GUI | Case Sensitive |
| QPictureFormatPlugin | pictureformats | Qt GUI | Case Insensitive |
| QAudioSystemPlugin | audio | Qt Multimedia | Case Insensitive |
| QDeclarativePlugin | video/declarativevideobackend | Qt Multimedia | Case Insensitive |
| QGstBufferPoolPlugin | video/bufferpool | Qt Multimedia | Case Insensitive |
| QMediaPlaylistIOPlugin | playlistformats | Qt Multimedia | Case Insensitive |
| QMediaResourcePolicyPlugin | resourcepolicy | Qt Multimedia | Case Insensitive |
| [QMediaServiceProviderPlugin](#非私有) | mediaservice | Qt Multimedia | Case Insensitive |
| QSGVideoNodeFactorPlugin | video/videonode | Qt Multimedia | Case Insensitive |
| QBearerEngine | bearer | Qt Network | Case Sensitive |
| QPlatformInputContextPlugin | platforminputcontexts | Qt Platform Abstraction | Case Insensitive |
| QPlatformIntergrationPlugin | platformthemes | Qt Platform Abstraction | Case Insensitive |
| QPlatformThemePlugin | platformthemes | Qt Platform Abstraction | Case Insensitive |
| [QGeoPositionInfoSourceFactory](#非私有) | position | Qt Positioning | Case Sensitive |
| QPlatformPrinterSupportPlugin | printsupport | Qt Print Support | Case Insensitive |
| QSGContextPlugin | scenegraph | Qt Quick | Case Sensitive |
| [QScriptExtensionPlugin](#非私有) | script | Qt Script | Case Sensitive |
| [QSensorGesuturePluginInterface](#非私有) | sensorgestures | Qt Sensors | Case Sensitive |
| [QSensorPluginInterface](#非私有) | sensors | Qt Sensors | Case Sensitive |
| [QSqlDreiverPlugin](#非私有) | sqldrivers | Qt SQL | Case Sensitive |
| [QIconEngienPlugin](#非私有) | iconengines | Qt SVG | Case Insensitve |
| [QAccessiblePlugin](#非私有) | accessible | Qt Widgets | Case Sensitive |
| [QStylePlugin](#非私有) | sytles | Qt Widgets | Case Insensitve |

如果你有一个新的称为MyStyle的风格类，如果你想将其作为插件使用，该类的定义应当采用如下方式定义(mysytleplugin.h)：  
```
   class MyStylePlugin: public QStylePlugin
   {
      Q_OBJECT
      Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QStyleFactoryInterface" FILE "mystyleplugin.json")
    public:
      QStyle *create(const QString &key);
   }
```

确保类方法的实现能够定位到对应的.cpp文件：  
```
  #include "mystyleplugin.h"

  QStyle *MyStylePlugin::create(const QString &key)
  {
    if(key.toLower() == "mystyle")
      return new MyStyle;
    return 0;
  }
```
（注意QStylePlugin是大小写不敏感的，在我们的create()函数实现中，我们使用了小写的版本。其他很多插件是大小写敏感的。）

另外，一个json文件(mystyleplugin.json)中包含了描述该插件时需要的元数据，这对于大多数插件都是必须的。对于风格插件，它就很简单地包含了该插件可以创建风格的列表：  
```
  { "Keys":["mystyleplugin"]}
```

需要在json文件中提供的关于该类型的信息是与插件相关的，参考插件类的文档了解需要添加到该文件中的信息的内容。

对于数据库驱动，图像格式，文本解码和大多数其他插件类型，不需要显式创建对象。Qt会找到并根据要求自动创建它们。风格类插件是一个例外，如果你在代码中显式设置风格。设置风格的代码类似于这样：  
```
  QApplication::setStyle(QStyleFactory::create("MyStyle"));
```

有一些插件需要实现其他函数。在编写插件的时候参考类文档中关于虚函数的描述细节。

[Style Plugin Example](#例子)讲解了如何使用QStylePlugin类创建新的插件。

## 底层API：扩展Qt应用(The Low-Level API: Extending Qt Applications)
不只是Qt本身可以使用插件进行扩展，Qt应用同样可以。这要求应用能够使用QPluginLoader检测和加载插件。在具体的使用中，插件就可能提供任何功能，而不限于Qt的数据库驱动，图像格式，文本解码，风格等等。




