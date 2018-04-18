---
title: "Network Error Unable to load the page的解决办法"
date: 2017-12-15T13:42:00+08:00
draft: false
tags: ["Web前端"]
categories: ["Web前端"]
author: "北斗"
---

Cocos2d-x加载一个http页面A，A中其中含有一个链接到https页面B。现在B页面返回到A页面报错Unable to load the page.Please keep network connection.

尝试B页面加载Https页面C没问题，返回A有问题。

修改办法是，B页面的href链接 采用如下形式：
```
<a class="class_name" href="//www.example.com">A Page</a>
```