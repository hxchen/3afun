---
title: "JVM内存不足错误"
date: 2018-07-22T16:50:43+08:00
draft: true
lastmod: 2018-07-22T16:50:43+08:00
tags: ["Java","JVM"]
categories: ["Java",JVM"]
keywords: ["Java","JVM"]
description: "JVM Java"
author: "北斗"
---


一样的代码,部署在不同的环境。

一台A环境是`AWS m4.large(2vCPU 8G内存)`,另一台B环境是`AWS m3.xlarge(4vCPU 15G内存)`

JVM启动参数都是 `-Xms512m -Xmx512m`

其中在A台机器上运行一段时间后,会报错:

```
# There is insufficient memory for the Java Runtime Environment to continue.
# Native memory allocation (mmap) failed to map 262144 bytes for committing reserved memory.
```

并且生成一个名为 `//hs_err_pidxxxx.log`的文件。

```
# Possible reasons:
#   The system is out of physical RAM or swap space
#   In 32 bit mode, the process size limit was hit
# Possible solutions:
#   Reduce memory load on the system
#   Increase physical memory or swap space
#   Check if swap backing store is full
#   Use 64 bit Java on a 64 bit OS
#   Decrease Java heap size (-Xmx/-Xms)
#   Decrease number of Java threads
#   Decrease Java thread stack sizes (-Xss)
#   Set larger code cache with -XX:ReservedCodeCacheSize=
```
文件里给了几种原因和解决办法
```
可能的原因:
系统超出了物理RAM或者交换分区
32位系统下,达到了进程限制大小
可能的解决办法:
减少系统的内存负载
增加物理内存或者交换分区
检查交换备份存储空间是否已满
在64位系统下,使用64位JDK
减小-Xmx/-Xms
减小Java线程数量
减小-Xss
增大-XX:ReservedCodeCacheSize=
```

尝试设置
```
JAVA_OPTS="-Xms256m -Xmx512m -Xss1m"
```



