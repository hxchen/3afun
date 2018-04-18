---
title: "Nginx+Tomcat获取用户真实IP"
date: 2013-12-26 19:30:27+08:00
draft: false
tags: ["服务器","Nginx"]
categories: ["服务器","Nginx"]
author: "北斗"
---
项目在测试环境获取用户IP没问题，在正式环境下使用

```Java
request.getRemoteHost()
```
获取的始终是127.0.0.1，最后才想到问题所在：正式环境使用了nginx作为代理，获取的始终是nginx的IP。这时想获取用户真实IP，可在Nginx，location/下作如下设置：

```
proxy_set_header X-Real-IP $remote_addr;
```

代码中使用

```Java
request.getHeader("X-Real-IP")
```
获取。

