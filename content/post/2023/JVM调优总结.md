---
title: "JVM调优总结"
date: 2023-05-07T23:41:31+08:00
lastmod: 2023-05-07T23:41:31+08:00
draft: false
keywords: ["JVM调优总结"]
description: "JVM调优总结"
tags: ["Java", "JVM"]
categories: ["Java"]
author: "北斗"

# Uncomment to pin article to front page
# weight: 1
# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: true
autoCollapseToc: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: false

# Uncomment to add to the homepage's dropdown menu; weight = order of article
# menu:
#   main:
#     parent: "docs"
#     weight: 1
---

JVM调优都是有一个目标的，在总结调优之前，我们需要先介绍几个相关概念：

# 相关概念
## 串行
单线程：垃圾回收发生的时候，其他线程都暂停

使用于堆内存较小的时候，适合个人电脑。
## 吞吐量优先
多线程

适合于堆内存较大，需要多核CPU

让单位时间内STW（Stop The World）的时间最短。

我们可以按照这个公式来计算 GC 的吞吐量：吞吐量 = 应用程序耗时 / (应用程序耗时 +GC 耗时) * 100%

## 响应时间优先
多线程

适合于堆内存较大，需要多核CPU

注重的是垃圾回收时STW（Stop The World）的时间最短

所谓调优，就是要确定我们目标是什么，更高的吞吐量还是更快的响应时间。还是在满足一定的响应时间的情况下，要求达到多大的吞吐量。

如科学计算、数据挖掘-吞吐量优先

网站、API-响应时间优先。

举个例子：
一个服务10S收集一次，停顿时间100ms，通过参数调整，5秒收集一次，停顿时间70ms。吞吐量下降，响应速度得到提升。

目标/原则：
对于那些涉及用户交互体验的业务，我们目标应该是更快的响应速度，对响应速度不敏感的业务，吞吐量优先。

# 常规设置
  查看当前默认参数：

  java -XX:+PrintCommandLineFlags -version

  查看当前JVM支持的参数：

  java -XX:+PrintFlagsFinal -version

  以上两点仅做了解。下面是重点的设置，假定在启动脚本，我们已经算出物理内存大小`PhysicalMemorySize`
  ```shell
  -Xms$[PhysicalMemorySize * 2/4]g -Xmx$[PhysicalMemorySize * 2/4]g -XX:MaxDirectMemorySize=$[PhysicalMemorySize * 1/4]g
  ```
  在很多情况下，-Xms和-Xmx设置成一样的，这么设置，是因为当Heap不够用时，会发生内存抖动，影响程序运行稳定性，在这里我们设置成一半的内存大小。另外对于Netty项目，我们需要使用堆外存，所以需要设置一下`MaxDirectMemorySize`参数。
# 高端设置
  启动优化参数：
  ```shell
  export current_time=`date "+%Y-%m-%d_%H-%M-%S"`

  -XX:ErrorFile=jvm_error_%p_${current_time}.log` # 设置JVM 错误日志，记录崩溃时的数据
  -XX:+UnlockDiagnosticVMOptions # 解锁诊断参数
  -XX:+PrintFlagsFinal #打印JVM中所有参数
  -XX:+UnlockExperimentalVMOptions #解锁实验性参数
  -XX:+UseG1GC #设置使用G1垃圾收集器
  -XX:MaxGCPauseMillis=500 #设置GC时最大停顿参数，对于严格要求响应时间的，我们要设置
  -XX:+PrintGC -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -Xloggc:gc_${current_time}.log #有关GC时记录的相关设置
  -XX:StringTableSize=512000 #配置字符串常量池中的StringTable大小，越大数据存储散列越好，性能越高
  -Dio.netty.leakDetectionLevel=advanced #设置netty内存泄漏检测级别
  -XX:NativeMemoryTracking=[off | summary | detail] # 默认关闭，追踪JVM的内部内存使用，一般在压测调参的时候使用，生产环境不要引入
  ```

