---
title: "NoSuchMethodError ServletFileUpload.parseRequest"
date: 2013-04-01 16:29:00+08:00
draft: false
tags: ["Java"]
categories: ["Java"]
author: "北斗"
---
Bug描述：老项目，文件上传在tomcat下没有问题，在部分WebSphere上存在问题。

Error 500: java.lang.NoSuchMethodError: org/apache/commons/fileupload/servlet/ServletFileUpload.parseRequest(Lorg/apache/commons/fileupload/RequestContext;)Ljava/util/List;

问题原因：不是没有加载fileupload jar包，而是jar包冲突。类加载会加载项目中的一份jar包和服务器（WebSphere）环境中的jar包，如果版本不一致，会报错。

解决方案：都知道原因了，应该不难解决了吧？不过还是推荐[一篇文章](http://newday.iteye.com/blog/1840183)详细了解类加载机制比较好。