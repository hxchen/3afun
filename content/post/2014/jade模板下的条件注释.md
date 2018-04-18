---
title: "jade模板下的条件注释"
date: 2014-11-10T15:59:27+08:00
draft: false
tags: ["Nodejs","jade","Web前端"]
categories: ["Nodejs","Web前端"]
author: "北斗"
---

jade版本1.6.0

在调试浏览器兼容问题时，发现原先的条件注释不再试用，特此更新下最新标记

demo.jade
```
doctype html
html(lang='zh-CN')
    head
        title= title
        //if IE 7
        //if IE 8
        //if IE 9
    body
        h3 Welcome
        //if IE 7
        p IE7_1
        //if IE 8
        p IE8_1
        //if IE 9
        p IE9_1

        <!--[if IE 7]>
        p IE7
        <![endif]-->

        <!--[if IE 8]>
        p IE8
        <![endif]-->

        <!--[if IE 9]>
        p IE9
        <![endif]-->
```
ie7下显示效果
```
Welcome
IE7_1

IE8_1

IE9_1

IE7
```
通过浏览器进行输出查看发现原先的方式
```
//if IE 7
 p IE7
```
不能解析成
```
<!--[if IE 7]>
<p>IE7</p>
<![endif]-->
```
现在又恢复成普通的html条件注释，因此需要写作
```
<!--[if IE 7]>
p IE7
<![endif]-->
```
才能生效！


