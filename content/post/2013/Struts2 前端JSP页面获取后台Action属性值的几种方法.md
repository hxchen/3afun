---
title: "Struts2 前端JSP页面获取后台Action属性值的几种方法"
date: 2013-02-28 10:32:00+08:00
draft: false
tags: ["服务器","Struts"]
categories: ["服务器"]
author: "北斗"
---
1、写在<% %>里，通过java代码获取。

2、通过$引用。比如后台返回bean，获取bean的name值，可以使用如下代码
```
<input type="text"  name="name"   id="name"  value="${bean.name}"  maxlength="50"/>
```
3、通过Struts2标签引用。<s:property value="bean.name"/>