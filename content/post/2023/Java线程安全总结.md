---
title: "Java线程安全总结"
date: 2023-04-16T18:06:33+08:00
draft: false
lastmod: 2023-04-16T18:06:33+08:00
tags: []
categories: []
keywords: []
description: ""
author: "北斗"
comment: false
toc: false
autoCollapseToc: false
contentCopyright: false
reward: false
mathjax: false
---

## 主内存与工作内存
Java内存模型规定了<font color=red>所有的变量都存储在主内存（Main Memory）中</font>。主内存可以类比成物理硬件的主内存，但此时仅是虚拟机内存的部分（JVM 内存）。

而每条线程还有自己的工作内存（Working Memory）。工作内存可以类比成CPU的寄存器和高速缓存。

<font color=red>线程的工作内存中保存了被该线程使用到的变量的主内存副本拷贝， 线程对变量的所有操作(读取、赋值等)都必须在工作内存中进行</font>，而不能直接读写主内存中的变量。

不同的线程之间也无法直接访问对方工作内存中的变量，线程间变量值的传递均需要通过主内存来完成。

