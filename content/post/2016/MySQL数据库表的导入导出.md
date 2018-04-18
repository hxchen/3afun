---
title: "MySQL数据库表的导入导出"
date: 2016-01-06T19:33:00+08:00
draft: false
tags: ["MySQL"]
categories: ["MySQL"]
author: "北斗"
---

备份：
```
mysqldump -hhostname -uroot -ppassword dbName tableName> tableName.bak
```
还原：
```
mysq> use dbName

mysq> source /data/tableName.bak
```