---
title: "Mac上安装Gradle "
date: 2016-06-16T19:27:00+08:00
draft: false
tags: ["gradle"]
categories: ["gradle"]
author: "北斗"
---
1.下载
[下载地址](http://gradle.org/)

2.解压
下载完解压到任意目录，我解压在/usr/local/下。

3.配置环境变量
在命令行运行以下命令
```
sudo vim /etc/bashrc
```
添加以下内容
```
GRADLE_HOME=/usr/local/gradle-2.14;
export GRADLE_HOME
export PATH=$PATH:$GRADLE_HOME/bin
```
接着使配置文件生效
```
source /etc/bashrc
```
然后用
```
gradle -version
```
命令测试一下.