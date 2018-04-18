---
title: "AWS EC2上配置Tomcat"
date: 2013-11-07 14:25:00+08:00
draft: false
tags: ["Tomcat","服务器"]
categories: ["服务器","Tomcat"]
author: "北斗"
---
一、官网下载 [Tomcat](http://ftp.kddilabs.jp/infosystems/apache/tomcat/tomcat-7/v7.0.47/bin/apache-tomcat-7.0.47.tar.gz) ，然后上传解压到EC2主机上，我这解压到：

```
/usr/local/apache-tomcat-7.0.47
```

二、添加环境变量。此次EC2主机是自带JRE的，位置是：

```
/usr/lib/jvm
```
我只需在/etc/profile里添加

```
JRE_HOME=$JAVA_HOME;
export JRE_HOME
PATH=$JAVA_HOME/bin:$PATH;
export PATH
```
运行source命令使其生效：


```
source /etc/profile
```

三、增加tomcat用户。



```
<role rolename="manager-gui"/>
<user username="admin" password="admin" roles="manager-gui"/>
```
四、修改tomcat 端口号8080为80。

五、EC2 控制台Security Groups，选择group，inbound里增加80端口。（默认只开启22端口供SSH连接）。

六、启动Tomcat，浏览器访问Public DNS地址即可。