---
title: "nginx pid No such file or directory解决办法"
date: 2017-06-14T11:32:00+08:00
draft: false
tags: ["Nginx"]
categories: ["服务器"]
author: "北斗"
---
服务器重启后，有时会需要重新启动 nginx，采用

```
nginx -s reload
```
 提示

```
nginx: [error] open() "/var/run/nginx.pid" failed (2: No such file or directory)
```
是因为服务器重启时丢了pid文件。

这种情况下可以使用 nginx -c，具体如下（nginx.conf位置自行替换）

```
nginx -c /etc/nginx/nginx.conf
```