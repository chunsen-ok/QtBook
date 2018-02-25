# Qt Multimedia Module
Qt中多媒体的支持由Qt Multimedia模块提供。Qt Mulitmedia模块中提供了丰富的设施，使得你可以轻松地运用平台的多媒体功能，例如媒体的播放、相机和声音设备的使用。
## Features
下面列举了一些Qt Multimedia模块可以实现的功能：  
* 访问原始声音设备(raw audio devices)进行输入输出
* 播放低延迟声音效果(low latency sound effects)
* 播放播放列表中的媒体文件（如压缩的声音或者视频文件）
* 记录并压缩声音
* 调频接收电台(Tune and listen to radio stations)
* 使用摄像头，包括取景器(viewfinder)、图像捕捉(image capture)以及视频录制(video recording)
* 使用Qt Audio Engine播放3D环绕音效(3D positional audio)
* 将声音文件解码到内容中进行处理
* 在播放或者记录过程中访问视频帧或者声音缓冲
## Multimedia Components
Qt的多媒体模块分为四个主要的组件。详情参考各组件页面：  
* [Audio Overview](QtMultimedia_Audio.md)
* [Video Overview](QtMultimedia_Audio.md)
* [Camera Overview](QtMultimedia_Audio.md)
* [Radio Overview](QtMultimedia_Audio.md)
## Multimedia Recipes
<font color="#ff3344">省略</font>
## Limitations
Qt Multimedia API建立在底层平台的基础上。这意味着支持的解码器和容器类型在不同的机器上可能不同，这取决于用户安装的具体设备和驱动。
## Advanced Usage
为了使开发者能够访问一些平台的特有设备，或者扩展Qt Multimedia API到新的平台或技术上，参考[Multimedia Backend Development](QtMultimedia_MultimediaBackend.md)

## Reference Documentation
