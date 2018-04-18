---
title: "redis 批量删除数据"
date: 2014-07-25T10:12:27+08:00
draft: false
tags: ["redis"]
categories: ["数据库"]
author: "北斗"
---
redis在cli里不能直接操作。批量删除gameRankData_DGJD开始的keys需要：

```
./redis-cli -n 0 keys "gameRankData_DGJD*"|xargs ./redis-cli -n 0 del
```