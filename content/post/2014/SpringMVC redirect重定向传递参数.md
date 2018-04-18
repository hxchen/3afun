---
title: "SpringMVC redirect重定向传递参数"
date: 2014-04-04T14:46:00+08:00
draft: false
tags: ["服务器","Spring-MVC"]
categories: ["服务器","Spring-MVC"]
author: "北斗"
---
URL不接参数的非重定向可以使用

```
Model.addAttribute(Object arg1);
```
 重定向可以使用如下方法传递对象参数

```
RedirectAttributes.addFlashAttribute(String arg0, Object arg1)
```
 其他传递方法则可参考RedirectAttributes类的方法