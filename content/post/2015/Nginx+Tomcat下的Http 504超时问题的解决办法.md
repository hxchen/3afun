
---
title: "Nginx+Tomcat下的Http 504超时问题的解决办法 "
date: 2015-12-18T13:50:00+08:00
draft: false
tags: ["Http","Nginx"]
categories: ["Nginx"]
author: "北斗"
---
1.前端选用JQuery框架下

延迟超时时间和错误处理

```
timeout: 6000,
error: function (xmlHttpRequest, error) {
    console.info(xmlHttpRequest, error);
}
```
2.后端Nginx增大缓存区

```
http {
...
# set size to:8*128k
fastcgi_buffers 8 128k;
send_timeout 60;
...
}
```
3.以上可以解决，但是无法从根本上解决问题。真正要解决的是日志跟踪Http请求时浪费时间所在，究竟是读写数据库，还是访问第三方接口等等，找到短板，然后优化它！