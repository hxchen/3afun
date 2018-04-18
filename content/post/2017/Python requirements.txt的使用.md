---
title: "Python requirements.txt的使用"
date: 2017-08-16T15:32:00+08:00
draft: false
tags: ["Python"]
categories: ["Python"]
author: "北斗"
---
在构建别人项目环境时，经常可以看到requirements.txt，这个文件记录了所依赖的包和版本。作用就是方便在另一台电脑搭建项目环境。那么如何使用呢？

生成 *requirements.txt* 文件
```
pip freeze > requirements.txt
```


安装 *requirements.txt* 依赖
```
pip install -r requirements.txt
```