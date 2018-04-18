---
title: "IOS WebView加载本地html文件"
date: 2015-04-28T18:19:00+08:00
draft: false
tags: ["IOS"]
categories: ["IOS"]
author: "北斗"
---
一、选中工程，右键选择Add files，按照下图进行添加后，文件夹被成功添加到项目中去，文件夹显示蓝色图标。

![ios](/media/images/2015/ios01.jpg)

 二、Object-C里文件加载采用loadRequest方式

```
NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:param ofType:@"html" inDirectory:@"assets"]];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
```
以上方式可正确显示html文件，并且文件夹内可采用相对路径访问css、javascript、图片等文件。