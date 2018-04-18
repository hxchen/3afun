---
title: "MySQL主从复制实现"
date: 2013-01-25 17:38:00+08:00
draft: false
tags: ["MySQL"]
categories: ["MySQL"]
author: "北斗"
---

1、下载免[安装版](http://cdn.mysql.com/Downloads/MySQL-5.5/mysql-5.5.29-win32.zip)。
2、解压缩到  C:\MySQL，命名为mysql-5.5.29-win32-master。

3、目录文件下找到my-large.ini, 在[mysqld]层次下添加如下设置：

```
#Path to installation directory. All paths are usually resolved relative to this.
basedir="C:/MySQL/mysql-5.5.29-win32-master/"

#Path to the database root
datadir="C:/MySQL/mysql-5.5.29-win32-master/Data/"

character-set-server=utf8
```
 [mysql]层次下添加如下设置：

```
default-character-set=utf8
```
 修改所有port  = 3306为

```
port        = 3307
```
 设置server-id

```
server-id   = 1
```

将my-large.ini另存为my.ini文件。

4、命令提示符模式进入

```
C:\MySQL\mysql-5.5.29-win32-master\bin>
```
安装名为Master的服务

```
C:\MySQL\mysql-5.5.29-win32-master\bin>mysqld -install Master
    Service successfully installed.
```
启动Master服务

```
C:\MySQL\mysql-5.5.29-win32-master\bin>net start Master
    Master 服务正在启动 ..
    Master 服务已经启动成功。
```
停止Master服务

```
C:\MySQL\mysql-5.5.29-win32-master\bin>net stop Master
    Master 服务正在停止.
    Master 服务已成功停止。
```
删除Master服务

```
C:\MySQL\mysql-5.5.29-win32-master\bin>mysqld -remove Master
    Service successfully removed.
```
5、重复步骤2-4。

位置：C:\MySQL\mysql-5.5.29-win32-slave

端口：3308

server-id    =2

安装名为Slave的服务。

6、登陆Master

```
C:\MySQL\mysql-5.5.29-win32-slave\bin>mysql -uroot -p
```
 在主服务器上,设置一个从数据库的账户user,使用REPLICATION SLAVE赋予权限,如:

```
mysql> GRANT REPLICATION SLAVE ON *.* TO 'user'@'127.0.0.1' IDENTIFIED BY 'user';
   Query OK, 0 rows affected (0.00 sec)
```
查看主服务器当前二进制日志名和偏移量，这个操作的目的是为了在从数据库启动后，从这个点开始进行数据的恢复。

```
mysql> show master status;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000001 |      255 |              |                  |
+------------------+----------+--------------+------------------+
1 row in set (0.00 sec)
```
主数据库Master操作到此为止。

7、登陆Slave设置Master

```
mysql> CHANGE MASTER TO

            -> MASTER_HOST='127.0.0.1',

            -> MASTER_PORT = 3307,

            -> MASTER_USER='user',

            -> MASTER_PASSWORD='user',

            -> MASTER_LOG_FILE='mysql-bin.000001',

            -> MASTER_LOG_POS=255;
```
8、启动从数据库


```
mysql>start slave
```
 9、查看状态

```
mysql> show slave status;
   Slave_IO_Running :YES

   Slabe_SQL_Running :YES
```
如果以上2项都为YES，说明MySQL主从复制配置成功！！！

10、在Master上创建数据库，查看Slave是否进行同步。

