---
title: "使用crontab，定时执行一个python脚本"
date: 2016-01-06T19:19:00+08:00
draft: false
tags: ["服务器","crontab"]
categories: ["服务器"]
author: "北斗"
---

添加任务，执行命令：
```
crontab -e
```
在新开的文件里添加：
```
00 05 * * *  python /data/Backup_DB_MAT_TABLE_INSTALL.py
```
保存退出。
```
!wq
```
重启crond：
```
service crond restart
```