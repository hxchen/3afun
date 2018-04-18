---
title: "PowerDesigner导出脚本里包含视图"
date: 2013-01-17 22:32:00+08:00
draft: false
tags: ["MySQL"]
categories: ["MySQL"]
author: "北斗"
---

打开使用MySQL5.0的PDM之后，在菜单里选择Database-> Edit   Current   DBMS..

确认DBMS使用的是MySQL5.0

打开左端树状结构Script-> Objects-> View

选中Create，在右端的Value中写入
```
create   VIEW   [%R%?[   if   not   exists]]   %VIEW%
  as
%SQL%
```
选中Drop，在右端的Value中写入
```
drop   table   if   exists   %VIEW%
```
选中Enable，在右端的Value中选择Yes

确定保存。

