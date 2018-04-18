---
title: "Can not find the tag library descriptor for jstl core 的解决办法"
date: 2014-07-23T16:40:27+08:00
draft: false
tags: ["Web前端"]
categories: ["Web前端"]
author: "北斗"
---
Maven工程，确定已经导入了standard.jar，jstl.jar 还提示

**Can not find the tag library descriptor for "http://java.sun.com/jsp/jstl/core"**

错误解决方案：

Maven pom配置文件里删除导入，重新添加。工程会自动进行validation操作，就不会再提示了。
