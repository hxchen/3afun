---
title: "SpringMVC Controller层中 request接收参数乱码"
date: 2014-02-26 11:09:27+08:00
draft: false
tags: ["服务器","Spring-MVC"]
categories: ["服务器","Spring-MVC"]
author: "北斗"
---
直接使用
```java
String email = request.getParameter("email");
```
接收到email是乱码，需要转换

```java
email = new String(request.getParameter("email").getBytes("ISO-8859-1"),"UTF-8");
```
这样麻烦还需要处理异常。

还可以这么解决：

web.xml
```
<filter>
    <filter-name>CharacterEncodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>utf-8</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>CharacterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```
