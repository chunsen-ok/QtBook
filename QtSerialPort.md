# Qt Serial Port
Qt Serial Port模块提供了RS-232端口的基本配置，I/O操作，获取和设置控制信号的功能。

在本模块中不支持一下功能：  
1. 终端功能，如echo, CR/LF控制符,等等。
2. 文本模式。
3. 读写时配置超时或者延时功能。
4. 端口信号改变提示。

本模块支持的类：  
* QSerialPort        提供访问串口的功能
* QSerialPortInfo    提供关于已存在的端口的信息

# QSerialPort class
QSerialPort类提供了访问串口的功能。

你可以使用QSerialPortInfo帮助类来获取可用的串口的信息。它能列举出系统所有可用的串口。这是一种获取可用的串口的正确名称的有效方式。你可以将一个帮助类对象作为setPort()或者setPortName()函数的参数来配置想要使用的设备串口。

设置好端口后，你可以以只读，只写，或者读写模式，使用open()函数打开串口。

注意：串口总是以独占方式打开（这意味着，从其他进程或者线程不能访问已经打开的串口）。

使用close()函数可关闭端口和取消I/O操作。

端口打开后，QSerialPort类会尝试决定当前使用的配置并且初始化该端口(QSerialPort tries to determine the current configuration of the port and initializes itself. )。你可以使用setBaudRate(),setDataBits(),setParity(),setStopBits()和setFlowControl()函数来重新配置端口。

QSerialPort中有一对属性用于命名端口信号：QSerialPort::dataTerminalReady,QSerialPort::requestToSend.也可以使用pinoutSignals()函数来查询当前端口信号的设置情况。

一旦知晓端口已经准备好进行读或者写操作后，你就可以使用read()或者write()函数进行相应操作了。此外，可以直接使用readLine()或者readAll()函数直接读取所有数据。如果端口数据不是一下子全部读取的，后面到达的数据可以追加到QSerialPort的内部写缓冲当中。你可以使用setReadBufferSize()函数来限制读取缓冲的大小。

QSerialPort中提供了一系列可以中止(suspend)线程调用的函数，知道特定信号发出。这些函数可以用于实现串口锁定(implement blocking serial port)：  
* waitForReadyRead()锁定直到新的可用可读数据到来。
* waitForBytesWritten()锁定直到一个有效数据负载被写到串口中。

参考下面的例子：

```
    int numRead = 0, numReadTotal = 0;
    char buffer[50];

    for(;;) {
        numRead = serial.read(buffer,50);

        // Do whatever with the array

        numReadTotal += numRead;
        if(numRead == 0 && !serial.waitForReadyRead())
            break;
    }
```

如果waitForReadyRead()函数返回false，说明连接已经被关闭或者发生了其他错误。

端口在任何时候发生了错误，QSerialPort都会发送errorOccurred()信号。你可以调用error()函数来找到最近一次发生的错误的类型。

串口锁定编程和非锁定串口的编程完全不同。串口锁定的编程不需要事件循环且常常只须要很简单的代码。然而，在一个GUI应用当中，锁定串口只应该用于非GUI线程，以避免冻结用户操作接口。

QSerialPort类还可以和QTestStream类和QDataStream的流操作符结合使用。但是需要确保一件事情：确保在尝试使用输入操作符时，有足够可用的数据。

# QSerialPorInfo class
提供已存在串口的信息。

使用静态函数生成一个QSerialPortInfo对象列表。列表中的每一个QSerialPortInfo对象就表示了一个单独的串口，可以查询其串口名称，系统位置，描述以及生产商。QSerialPortInfo对象还可以作为QSerialPort类的setPort()函数的输入参数。

# Exmaples
QSerialPort支持两种编程模式：
* 异步模式
* 同步模式

