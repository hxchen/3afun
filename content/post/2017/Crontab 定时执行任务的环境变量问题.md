---
title: "Crontab 定时执行任务的环境变量问题"
date: 2017-11-20T17:27:00+08:00
draft: false
tags: ["服务器", "Crontab"]
categories: ["服务器"]
author: "北斗"
---
今天写了一个脚本文件，有用到Python3中time库的localtime函数。在单独执行该脚本文件时候，可以支持获取服务器date时间。但是放在Crontab里定时执行的时候，发现获取的是格林尼治时间。明明系统已经更改到北京时间，为什么还会显示格林尼治时间呢？
怀疑是crontab执行时和单独执行py脚本时候，系统环境变量不一致。

最终原先直接在crontab里定时执行py脚本，改为定时执行shell文件，在shell文件里通过记载用户环境变量，再执行py文件，成功获取到北京时间。
```
#!/bin/sh
source /etc/profile
```