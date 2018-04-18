
---
title: "aop advisor说明以及The prefix aop for element  aop:config is not bound.错误原因"
date: 2013-01-17 22:34:00+08:00
draft: false
tags: ["Web前端"]
categories: ["Web前端"]
author: "北斗"
---

原因：我们在定义申明AOP的时候。没有加载schema。

解决：首先应该加载JAR包。

还要在<beans>中要加入“xmlns：aop”的命名申明，

并在“xsi：schemaLocation”中指定aop配置的schema的地址


配置文件如下：
```
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans "
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance "
xmlns:aop="http://www.springframework.org/schema/aop "
xmlns:tx="http://www.springframework.org/schema/tx "
xsi:schemaLocation="http://www.springframework.org/schema/beans
                     http://www.springframework.org/schema/beans/spring-beans.xsd
                     http://www.springframework.org/schema/tx
                     http://www.springframework.org/schema/tx/spring-tx.xsd
                     http://www.springframework.org/schema/aop
                     http://www.springframework.org/schema/aop/spring-aop.xsd ">

(* com.test.service.*.*(..))中几个通配符的含义：
```
第一个 * —— 通配 任意返回值类型

第二个 * —— 通配 包com.test.service下的任意class

第三个 * —— 通配 包com.test.service下的任意class的任意方法

第四个 .. —— 通配 方法可以有0个或多个参数

综上：包com.test.service下的任意class的具有任意返回值类型、任意数目参数和任意名称的方法