---
title: "Centos 编译安装Git(git clone git push git pull 401错误)"
date: 2014-04-22T19:10:27+08:00
draft: false
tags: ["服务器","Git"]
categories: ["服务器"]
author: "北斗"
---
低版本时osc git clone git pull git push 会报401错误

1、准备工作

```
yum install curl curl-devel zlib-devel openssl-devel perl perl-devel
 cpio expat-devel gettext-devel
```
 2、下载git

 去下载页面 [下载](https://code.google.com/p/git-core/)

```
wget https://git-core.googlecode.com/files/git-1.9.0.tar.gz

```
3、解压安装
```
Java代码  收藏代码
tar -zvxf git-1.9.0.tar.gz
cd  git-1.9.0
make prefix=/usr/local/git all
make prefix=/usr/local/git install
#增加软连接
ln -s /usr/local/git/bin/* /usr/bin/
git --version
```