---
title: "EC2主机部署Wordpress"
date: 2014-03-10 17:42:27+08:00
draft: false
tags: ["Wordpress"]
categories: ["开源软件"]
author: "北斗"
---

一、Wordpress配置

下载

```
wget http://wordpress.org/latest.zip
```
解压
```
unzip latest.zip
```
进入目录
```
cd wordpress/
```
重命名
```
mv  wp-config-sample.php wp-config.php
```
更改配置
```
vi wp-config.php
```
请自行根据数据库设置进行配置文件设置。

二、PHP服务器配置

安装

```
yum install php php-mysql php-fpm
```
启动

```
com.a3fun.rocket.service php-fpm start
```
 三、MySQL数据库安装

```
yum install mysql
yum install mysql-server
yum install mysql-devel
chgrp -R mysql /var/lib/mysql
chmod -R 770 /var/lib/mysql
com.a3fun.rocket.service mysqld start
mysql
SET PASSWORD FOR 'root'@'localhost' =PASSWORD('root');
```
创建数据库后，即可浏览器打开

  http://example.com/blog/wp-admin/install.php

进行Wordpress安装。
