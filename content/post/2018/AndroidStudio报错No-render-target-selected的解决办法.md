---
title: "AndroidStudio报错No Render Target Selected的解决办法"
date: 2018-07-06T11:45:20+08:00
draft: false
tags: ["Android"]
categories: ["Android"]
keywords: ["Android"]
description: "Android"
author: "北斗"
---

之前使用Windows+Android Studio开发的Android项目,后来迁移到Mac+Android Studio开发下,同样的工程项目导入后,报错`No render target selected `。

这个问题的根本原因是Android Studio找不到对应API级别开渲染布局文件。

![android01](/media/images/2018/android01.png)

可尝试如下解决办法:

- 1.有使用Gradle的,先进行Gradle同步。

- 2.检查编译使用的SDK版本在新环境中是否有对应下载安装。

- 3.有人说可以Tools->android->AVD Manager新建一个AVD(注意版本),不过我并不觉得这样做可以,但是大家可以尝试。

- 4.检查确认要求的SDK版本和Android Studio安装的版本确实都存在后,选择 File -> Invalidate Caches/Restart。重启后可在上面截图那个被圈起来的位置选择版本进行渲染。


