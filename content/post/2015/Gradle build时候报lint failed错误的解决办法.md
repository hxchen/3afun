---
title: "Gradle build时候报lint failed错误的解决办法"
date: 2015-04-27T17:27:00+08:00
draft: false
tags: ["Gradle"]
categories: ["Gradle"]
author: "北斗"
---
这是因为程序在buid的时候，会执行lint检查，有任何的错误或者警告提示，都会终止构建，我们可以将其关掉。

修改build.gradle配置文件，在android里面添加

```
android{
    lintOptions {
            abortOnError false
    }
    ...
}
```
