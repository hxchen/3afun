---
title: "javascript 中contains方法的定义"
date: 2013-10-21 16:16:00+08:00
draft: false
tags: ["Web前端","JavaScript"]
categories: ["Web前端","JavaScript"]
author: "北斗"
---
```JS
/**
 * 对大小写敏感的Contains方法
 * @param substring
 * @returns
 */
String.prototype.contains = function(substring)
{
    return this.indexOf(substring) != -1 ? true:false;
};
```
 使用方法：a.contains(b)----a中是否包含b

