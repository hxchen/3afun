---
title: "Node.js学习笔记（二）开发调试利器之supervisor"
date: 2014-01-20 16:40:27+08:00
draft: false
tags: ["服务器","NodeJS"]
categories: ["服务器","NodeJS"]
author: "北斗"
---
node.js开发调试时候每次更新代码都需要重启node.js，开发调试效率之低令人愤懑，然后却有这样一款小工具supervisor。它会监视你对代码的改动并自动重启。

使用npm安装supervisor方法：

Node.js安装目录下执行:

```
npm install -g supervisor
```

安装完成后，使用supervisor重新运行代码：

```
supervisor index.js
```
 ![nodejs](/media/images/2014/nodejs7.jpg)