---
title: "利用wget抓取网站模板"
date: 2020-03-11T17:20:56+08:00
draft: false
lastmod: 2020-03-11T17:20:56+08:00
tags: ["linux"]
categories: ["linux"]
keywords: ["利用wget抓取网站模板"]
description: "利用wget抓取网站模板"
author: "北斗"
comment: false
toc: false
autoCollapseToc: false
contentCopyright: false
reward: false
mathjax: false
---
有时遇到精美的网站模板，给了演示Demo下载却花钱，怎么办？找不到好用的软件，又不想写繁多的Python或者Go脚本，别着急，利用```wget```命令可以轻松搞定。
例如你想保存```https://abc.com/```的页面到```web```目录只需要一句命令就可以轻松搞定。
```shell script
wget -r https://abc.com/ -P web
```
