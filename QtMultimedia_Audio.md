# Qt Multimedia - Camera Overview
Qt Multimedia模块中提供了大量和摄像机操作相关的类，开发者可以通过这些类实现从手机摄像机或者网络摄像机中或者图像或者视频。模块中提供的QML和C++接口都可以很容易实现一些常用功能。
## Camera Features
使用摄像机类之前应该对摄像机工作方式有一个大致的了解。如果你已经熟悉这些内容了，可以直接跳过这部分内容查看[Camera implementation details](#index-1)

### 透镜组件(The Lens Assembly)



### The Sensor
###  Image Processing
### Recording for Posterity

<div id="index-1"/>

## Camera Implemtation Details
### Detecting and Selecting Camera
在使用摄像机API之前，你应该检测在程序运行时摄像机是否可用。如果没有可用的，你可能需要禁用程序中与摄像机相关的功能。在C++中执行这一相关操作时，使用QCameraInfo::avaliableCameras()函数，使用方法如下所示：  
```
    bool checkCameraAvailability()
    {
        if(QCameraInfo::availableCameras().count() > 0)
            return true;
        else
            return false;
    }
```
在QML中，使用QtMultimedia.availableCameras属性：  
```
    Item {
        property bool isCameraAvailable : QtMultimedia.availableCameras > 0
    }
```
在确定由可用的摄像机之后，就可以在C++中使用QCamera类或者在QML中使用Camera类型访问可用摄像机。

当有多个可用的摄像机时，你可以指定要使用的是哪一个摄像机。

在C++中：  
```
    QList<QCameraInfo> cameras = QCameraInfo::availableCameras();
    foreach(const QCameraInfo &cameraInfo, cameras) {
        if(cameraInfo.deviceName() == "myCamera") {
            camera = new QCamera(cameraInfo);
        }
    }
```
在QML中，你可以使用Camera类型的cameraId属性来指定摄像机。通过QtMultimedia.availableCameras可以检索到所有可用的ID：  
```
    Camera {
        deviceId: QtMultimedia.availableCameras[0].deviceId
    }
```
除此之外，还可以通过摄像机在设备系统中的位置来指定使用的摄像机。例如在手机上一般有前后两个摄像头，就可以通过指定使用的摄像头的位置。

在C++中：  
```
    camera = QCamera(QCamera::FrontFace);
```
在QML中：  
```
    Camera {
        position: Camera.FrontFace
    }
```
如果摄像机ID和位置都没有指定，将使用摄像机的默认摄像机。在桌面平台上，默认摄像机是用户在设置中设定的。在移动设备上，一般是屏幕背后的主摄像头。你可以使用QCameraInfo::defaultCamera()和QtMultimedia.defaultCamera来获取默认摄像机的信息。  
### Viewfinder
取景器用于显示摄像机内容。取景器(Viewfinder)在摄像机编程中不是必须的，但是用来显示摄像机内容是非常用的。大多数的数字摄像机都允许从摄像机传感器获取低清晰度的图像组成照片或者视频，也可以转化为更慢但是更高清晰度的模式进行图像捕获。

实现摄像机取景器的方式有多种，取决于你是使用C++还是QML实现的摄像机功能。在QML中，你可以使用Camera和VidwoOutput类型来构成一个简单的取景器：  
```
    VideoOutput {
        source: camera
        Camera {
            id: camera
            // 你可在这里调整摄像机相关设置
        }
    }
```
在C++中，取景器的实现取决于你选择的是控件(widgets)还是QGraphicsView。QCameraViewfinder类用于控件的情况，二QGrfaphicsVideoItem则用于QGraphicsView。  
```
    camera = new QCamera;
    viwfinder = new QCameraViewfinder;
    camera->setViewfinder(viewfinder);
    viewfinder->show();

    camera->start();
```
