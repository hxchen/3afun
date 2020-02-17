---
title: "解决Minimum supported Gradle version is 3.3. Current version is 2.10."
date: 2018-08-01T11:30:40+08:00
draft: false
lastmod: 2018-04-25T23:42:28+08:00
tags: ["Android","Gradle"]
categories: ["Android","Gradle"]
keywords: ["Android","Gradle"]
description: "Android Gradle"
author: "北斗"
---

原先Windows电脑开发的Android项目,转移到Mac下进行开发维护后,本机安装了Gradle4.9后,发现Android Studio还是使用的旧版本Gradle。

报错:`Gradle sync failed: Minimum supported Gradle version is 3.3. Current version is 2.10.`

解决办法是更新Android Studio使用的Gradle:

Mac版本Android Studio

选择:菜单栏 -> Android Studio -> Preferences -> Build,Execution,Deployment -> Build Tools -> Gradle

![android-gradle](/media/images/2018/android-gradle.png)

然后来 https://services.gradle.org/distributions/ 下载更新版本,解压缩更换 Android Studio目录下的gradle。


