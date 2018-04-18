---
title: "Nodejs使用Chrome伪装微信浏览器UA"
date: 2015-02-06T15:25:00+08:00
draft: false
tags: ["NodeJS","Web前端"]
categories: ["NodeJS","Web前端"]
author: "北斗"
---
一、获取手机在微信内置浏览器的User-Agent

```
var http = require('http');
http.createServer(function(req, res) {
    res.writeHead(200, {'Content-type' : 'text/html'});
    res.write('user-agent='+req.headers["user-agent"]);
    console.log(req.headers["user-agent"]);
    res.end();
}).listen(3000);
```
 在这里我获取我手机的是

```
Mozilla/5.0 (iPhone; CPU iPhone OS 7_1_2 like Mac OS X) AppleWebKit/537.51.2 (KHTML, like Gecko) Mob
ile/11D257 MicroMessenger/6.1 NetType/WIFI
```
 二、Chrome浏览器F12键打开控制台

![nodejs](/media/images/2015/nodejs.png)

 Spoof user agent选择Other

将第一步获取到的UserAgent（大家也可以直接复制我的结果使用）复制到下面的框里。

三、重新刷新浏览器即可模拟微信内置浏览器，但是对于需要做跳转授权的URL（open.weixin.qq.com）会显示白屏。