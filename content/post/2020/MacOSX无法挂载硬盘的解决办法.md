---
title: "MacOSX无法挂载硬盘的解决办法"
date: 2020-03-08T11:59:21+08:00
draft: false
lastmod: 2020-03-08T11:59:21+08:00
tags: ["OSX"]
categories: ["OSX"]
keywords: ["Mac OSX diskutil"]
description: "MacOSX无法挂载硬盘的解决办法"
author: "北斗"
comment: false
toc: true
autoCollapseToc: false
contentCopyright: false
reward: false
mathjax: false
---

有时移动硬盘无法从电脑退出，下次再次使用时候，插入进去没有反应，通过查看Mac 自带的磁盘工具发现已经识别，但是却无法挂载，遇到这样的问题尝试了以下两种方式，都可以实现正常挂载。

#### 方法1:
插入到Windows进行修复。

#### 方法2：
通过Mac自带的```diskutil```命令。
- 命令1：通过```diskutil list```查看当前硬盘的信息，找到没有挂载的硬盘，我这里是```/dev/disk4```没有挂载上。
- 命令2：通过```sudo fsck_hfs -fy /dev/disk4```命令进行修复。
- 命令3：通过```sudo diskutil mount /dev/disk4```命令进行挂载，这会系统就可以显示可以挂载硬盘了。

