# Qt SQL Module
Qt SQL模块是Qt核心模块之一，提供了对SQL数据库的支持。Qt SQL接口被分为三个不同的部分：  
* 驱动层
* SQL接口层
* 用户接口层

[The SQL Programming](TheSqlProgramming.md)中提供了使用Qt SQL模块的开发指南。

Qt SQL模块中提供了第三方数据库SQLite的扩展插件：  
使用Qt SQL Lite插件时，为Qt配置-system-sqlite启用或者-no-sqlite关闭。其源代码可以在qtbase/src/3rdparty/sqlite中找到。