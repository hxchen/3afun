---
title: "Android Studio中提示Cannot resolve symble R"
date: 2015-10-27T10:44:00+08:00
draft: false
tags: ["Android"]
categories: ["Android"]
author: "北斗"
---
1、build.gradle中确认已添加

```
compile 'com.android.support:appcompat-v7:21.0.3'
```
2、菜单里Build->Clean Project

3、菜单里Tools->Android->Sync Project with gradle files


