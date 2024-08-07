---
title: "OOM问题小结"
date: 2024-07-04T14:11:08+08:00
lastmod: 2024-07-04T14:11:08+08:00
draft: false
keywords: ["Java","OOM"]
description: ""
tags: ["Java"]
categories: ["Java"]
author: ""

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

# OOM原因
1. 一次性申请的太多内存，导致内存不足 <br>
    更改申请对象的数量
2. 内存资源耗尽未释放 <br>
    找到未释放的对象进行释放
3. 本身资源不够 <br>
    `jmap -heap pid` 查看堆内存使用情况

# 如何通过dump定位
1. 系统已经OOM挂了，提前设置`-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/path/to/dump`，可以在OOM时生成dump文件
2. 系统运行中还未OOM，可以通过`jmap -dump:live,format=b,file=heap.hprof pid`生成dump文件，然后通过`jhat heap.hprof`查看
3. 结合`jvisualvm`进行调试，查看最多跟业务有关的对象，找到GCRoot，查看线程栈，找到问题代码
