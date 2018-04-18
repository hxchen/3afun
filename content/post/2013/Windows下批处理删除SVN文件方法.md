---
title: "Windows下批处理删除SVN文件方法"
date: 2013-01-07 15:11:00+08:00
draft: false
tags: ["杂"]
categories: ["杂"]
author: "北斗"
---

在项目根目录执行以下dos命令
```
for /r . %%a in (.) do @if exist "%%a\.svn" rd /s /q "%%a\.svn"
```
