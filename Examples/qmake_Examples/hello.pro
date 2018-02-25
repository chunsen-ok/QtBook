
TARGET = helloWorld
CONFIG += debug \
          c++11

HEADERS += hello.h
SOURCES += main.cpp

win32 {
    SOURCES += helloWin.cpp    
}
unix {
    SOURCES += hello.cpp
}
!exists(main.cpp) {
    error("No main.cpp file founded")
}
Win32:debug{
    CONFIG += console
}


