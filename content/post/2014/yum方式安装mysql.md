---
title: "yum方式安装MySQL"
date: 2014-04-22T17:18:27+08:00
draft: false
tags: ["服务器","MySQL"]
categories: ["服务器","MySQL"]
author: "北斗"
---

1、安装

```
yum install mysql mysql-server
```
 2、启动

```
service mysqld start
```
 3、登录

```
mysql -uroot -p
```
 4、改密码

```
set password for root@localhost=password('your_password')
```

 5、查看密码
```
select user,host,password from mysql.user
```

备注：

更改数据库编码参考：

```
SET character_set_client = utf8 ;
```