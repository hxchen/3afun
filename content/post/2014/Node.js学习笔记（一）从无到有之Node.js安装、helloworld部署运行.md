---
title: "Node.js学习笔记（一）从无到有之Node.js安装、helloworld部署运行"
date: 2014-01-20 16:40:27+08:00
draft: false
tags: ["服务器","NodeJS"]
categories: ["服务器","NodeJS"]
author: "北斗"
---

一、下载

进入 [官网](http://nodejs.org/download/)，下载适合版本。

在此我选用的是64位windows：node-v0.10.24-x64.msi。

二、安装

 ① 安装下载下来的安装程序：node-v0.10.24-x64.msi，默认安装在 C:\Program Files\nodejs

   安装完毕后，命令控制台运行 node -v,查看安装结果，显示版本号
 ![nodejs](/media/images/2014/nodejs1.jpg)

 ②安装express。建议全局安装：

```
npm  install -g express
```
![nodejs](/media/images/2014/nodejs2.jpg)
若是仅安装到当前目录则可使用

```
npm  install express
```

三、创建helloworld项目

express创建helloworld项目

```
express helloworld
```
![nodejs](/media/images/2014/nodejs3.jpg)
进入项目目录，安装nodejs依赖模块.
```
cd helloworld && npm install
```
![nodejs](/media/images/2014/nodejs4.jpg)
四、运行

运行helloworld项目
```
node app.js
```
![nodejs](/media/images/2014/nodejs5.jpg)

浏览器访问：http://127.0.0.1:3000/ 即可看到显示结果
![nodejs](/media/images/2014/nodejs6.jpg)
