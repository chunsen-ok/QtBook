# JSON Support in Qt
Qt支持处理JSON数据。JSON是从Javascript继承而来的一种编码对象数据的格式，现在作为一种数据交换格式广泛应用于互联网。

Qt中通过C++API可以很容易地解析，修改和保存JSON数据。还可以将这些数据直接保存为二进制数据格式，以实现数据直接“mmap”内存映射和快速访问。

更多关于JSON数据格式的细节，参考[json.org](http://json.org/)和[RFC-7159](https://tools.ietf.org/html/rfc7159).

## Overview
JSON是一种存储结构化数据的格式。它支持六种基本数据类型：  
* bool
* double
* string
* array
* object
* null

任何值可以是以上任何类型。布尔类型值在JSON中使用字符串形式的true或者false来表示。JSON中并不显示制定数值的合法范围，但是在Qt中支持的JSON将其限制为双精度浮点型数值。字符串类型可以是任何合法的unicode字符串。数组是一个值的列表，对象则是关键字-值对的集合。对象中所有关键字都是字符串，在一个对象中不能包含重复的关键字。

<font color="#ff3344" size="20">未完成</font>

## The JSON Classes
Qt中所有JSON类都是基于值，隐式分享的类。
Qt中JSON的支持由以下类组成：
| Class      | Description |
| :---       | :---        |
| QJsonArray | JSON数组    |
| QJsonDocument | 一个JSON文档 |
| QJsonParseError | 用于调查在解析JSON过程中的错误 |
| QJsonObject | JSON对象 |
| QJsonObject::const_iterator | STL-style const iterator for QJsonObject |
| QJsonObject::iterator | ... |
| QJsonValue | Json值 |


