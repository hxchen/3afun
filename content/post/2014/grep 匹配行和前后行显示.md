---
title: "grep 匹配行和前后行显示"
date: 2014-05-27T10:20:27+08:00
draft: false
tags: ["Linux"]
categories: ["Linux"]
author: "北斗"
---
grep 检索显示匹配行以及前后行

info.txt里检索KEY，显示KEY的后10行。
```
grep -A 10 'KEY' info.txt
```
info.txt里检索KEY，显示KEY的前10行。
```
grep -B 10 'KEY' info.txt
```
info.txt里检索KEY，显示KEY的前后各10行。
```
grep -C 10 'KEY' info.txt
```
