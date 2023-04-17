---
title: "MacOS安装FlatBuffers"
date: 2020-02-11T16:46:43+08:00
draft: false
lastmod: 2020-02-11T16:46:43+08:00
tags: ["FlatBuffers"]
categories: ["FlatBuffers"]
keywords: ["FlatBuffers"]
description: "MacOX install FlatBuffers"
author: "北斗"
comment: false
toc: true
autoCollapseToc: false
contentCopyright: false
reward: false
mathjax: false
---
在Mac系统上安装FlatBuffers有两种方式，第一种是通过`Homebrew`安装
```shell script
$ brew install flatbuffers
```
但是并不推荐如此安装，因为可能会造成你安装的`flatc`编译版本和后期运行时版本不一致，导致程序编译不过。建议采用源码安装。
源码安装首先安装`cmake`
```shell script
$ brew install cmake
```
然后再安装FlatBuffers
```shell script
$ git clone https://github.com/google/flatbuffers.git
$ cd flatbuffers
$ cmake -G "Unix Makefiles"
$ make
$ ./flattests # this is quick, and should print "ALL TESTS PASSED"
```
添加到系统，方便以后使用
```shell script
$ sudo cp flatc /usr/local/bin/flatc
```
安装完成后，查看安装版本
```shell script
$ flatc --version
```
后期运行时可以使用`java`目录（其他语言自行选择对应目录）下的源码作为运行时环境，编译直接使用`flatc`命令对schema文件进行编译。
