---
title: "MySQL生成随机时间"
date: 2014-06-06T17:09:27+08:00
draft: false
tags: ["数据库","MySQL"]
categories: ["数据库"]
author: "北斗"
---

随机生成2014/05/01到现在的时间

```
SELECT FROM_UNIXTIME(UNIX_TIMESTAMP('20140501000000') + ROUND(RAND()*(UNIX_TIMESTAMP() - UNIX_TIMESTAMP('20140501000000'))));
```