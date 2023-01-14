---
title: "Ubuntu14 搭建Squid3代理 "
date: 2016-06-14T17:47:00+08:00
draft: false
tags: ["Squid"]
categories: ["杂"]
author: "北斗"
---
需要一行一行复制安装
```
apt-get install squid
curl https://raw.githubusercontent.com/hxchen/proxy/master/squid.conf > /etc/squid3/squid.conf
mkdir -p /var/cache/squid
chmod -R 777 /var/cache/squid
com.a3fun.rocket.service squid3 stop
squid3 -z
com.a3fun.rocket.service squid3 restart
```
