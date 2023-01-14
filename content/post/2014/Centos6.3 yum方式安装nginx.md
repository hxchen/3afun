---
title: "Centos6.3 yum方式安装nginx"
date: 2014-04-22T17:44:27+08:00
draft: false
tags: ["服务器","Nginx"]
categories: ["服务器","Nginx"]
author: "北斗"
---
1、软件包管理



```
rpm -ivh http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
```
CentOS 5，就用下面的源：

```
rpm -ivh http://nginx.org/packages/centos/5/noarch/RPMS/nginx-release-centos-5-0.el5.ngx.noarch.rpm
```
Red Hat Enterprise Linux 6：

```
rpm -ivh http://nginx.org/packages/rhel/6/noarch/RPMS/nginx-release-rhel-6-0.el6.ngx.noarch.rpm
 ```
Red Hat Enterprise Linux 5：

```
rpm -ivh http://nginx.org/packages/rhel/5/noarch/RPMS/nginx-release-rhel-5-0.el5.ngx.noarch.rpm
```
2、安装

```
yum install nginx
```
3、启动

```
com.a3fun.rocket.service nginx start
```
4、测试

   访问：http://127.0.0.1/
