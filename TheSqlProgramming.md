# Qt SQL - SQL Programming Guide

## Database Classes


SQL数据库类分为三类：

| Class | 用途 |
| ：--- |：--- |
| QSqlDriver | |

## Driver Layer
驱动层由QSqlDriver,QSqlDriverCreator,QSqlDriverCreatorBase,QSqlDriverPlugin和QSqlResult类组成。

驱动层提供了底层特定数据库和SQL接口层的连接。参考[SQL Database Drivers](SQLDatabaseDrivers.md)。

## SQL API Layer
该层的类用于访问数据库。QSqlDatabase类用于连接数据库。QSqlQuery类用于同数据库进行交互。其他的接口则通过QSqlError,QSqlField,QSqlIndex和QSqlRecord提供。

## User Interface Layer
该层的类用于连接数据库和数据显示控件。包括QSqlQueryModel,QSqlTableModel以及QSqlRelationalTableModel类。这些类是设计来同Qt的model/view框架一起工作的。

需要注意的是在使用这些类之前一定要先初始化QCoreApplication对象。
