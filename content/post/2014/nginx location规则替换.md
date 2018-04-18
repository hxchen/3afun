---
title: "nginx location规则替换"
date: 2014-03-05 16:05:27+08:00
draft: false
tags: ["服务器","Nginx"]
categories: ["服务器","Nginx"]
author: "北斗"
---
```
server {
        listen       80;
        server_name  www.6dgame.com 6dgame.com;

    location /2013/ {
        proxy_pass http://127.0.0.1:8081/;
    }
        location / {
            proxy_pass http://127.0.0.1:8080/;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
```
对于此种设置方法，

访问：http://54.200.150.182:8081/2013/ 和 http://54.200.150.182/2013/2013 是等效的。

也就是说访问http://54.200.150.182/2013/

根据nginx配置会自动替换成

http://54.200.150.182:8081
