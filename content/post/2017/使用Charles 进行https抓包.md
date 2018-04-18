---
title: "使用Charles 进行https抓包"
date: 2017-11-18T16:57:00+08:00
draft: false
tags: ["Charles"]
categories: ["杂"]
author: "北斗"
---
# 1. Charles安装
官网下载安装Charles:
https://www.charlesproxy.com/download/

# 2. HTTP抓包
## （1）查看电脑IP地址

## （2）设置手机HTTP代理
手机连上电脑，点击“设置->无线局域网->连接的WiFi”

设置HTTP代理：服务器为电脑IP地址：如192.168.0.100 端口：8888

设置代理后，需要在电脑上打开Charles才能上网

## （3）电脑上打开Charles进行HTTP抓包
手机上打开某个App

点击电脑上“Allow”允许，出现手机的HTTP请求列

# 3. HTTPS抓包
HTTPS的抓包需要在HTTP抓包基础上再进行设置

手机浏览器打开 https://chls.pro/ssl

并安装证书，记得要信任该证书。

注意：IOS 版本10.3+的，还需要额外设置：

设置->通用->关于本机->证书信任设置->Charles Proxy CA 证书那里打开。


至此大家可以试下Https抓包效果了。


参考：https://www.charlesproxy.com/documentation/using-charles/ssl-certificates/