---
title: "亚马逊EC2上搭建Node.js"
date: 2014-02-14 16:04:27+08:00
draft: false
tags: ["服务器","NodeJS"]
categories: ["服务器","NodeJS"]
author: "北斗"
---

1、安装Node,js编译工具

```
sudo yum install gcc-c++ openssl-devel make curl git
 ```
2、下载Node.js源码、编译、安装

```
wget http://nodejs.org/dist/v0.10.25/node-v0.10.25.tar.gz

tar -xvf node-v0.10.25.tar.gz

cd node-v0.10.25

./configure

make
```

在此make会需要很长时间，我用了大约半小时左右。

```
make install
```
EC2主机环境映射
```
sudo ln -s /usr/local/bin/node /usr/bin/node

sudo ln -s /usr/local/lib/node /usr/lib/node

sudo ln -s /usr/local/bin/npm /usr/bin/npm

sudo ln -s /usr/local/bin/node-waf /usr/bin/node-waf

sudo ln -s /usr/local/bin/supervisor  /usr/bin/supervisor

sudo ln -s /usr/local/lib/supervisor  /usr/lib/supervisor
```
3、安装完毕可以使用如下命令测试安装是否成功
```
node -v
```
