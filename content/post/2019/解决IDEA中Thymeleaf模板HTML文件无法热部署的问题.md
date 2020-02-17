---
title: "解决IDEA中Thymeleaf模板HTML文件无法热部署的问题"
date: 2019-08-20T18:02:47+08:00
draft: false
lastmod: 2019-08-20T18:02:47+08:00
tags: ["HTML"]
categories: ["Web前端"]
keywords: ["IDEA","Tomcat热部署"]
description: "IDEA Tomcat热部署 HTML文件"
author: "北斗"
---

项目中使用了thymeleaf模板引擎，改动HTML文件后，前端页面无法热部署。在排除Tomcat设置问题后，最终发现是Thymeleaf视图模板引擎配置的缓存问题。

解决办法:
`SpringResourceTemplateResolver`中的`cacheable`要设置为false，就可以实现热部署了。
如果你是配置文件可参考如下设置：

```xml
<bean id="templateResolver" class="org.thymeleaf.spring5.templateresolver.SpringResourceTemplateResolver">
    <property name="prefix" value="/WEB-INF/templates/" />
    <property name="suffix" value=".html" />
    <property name="cacheable" value="false" />
    <property name="templateMode" value="HTML5" />
    <property name="characterEncoding" value="UTF-8" />
</bean>
```
    

