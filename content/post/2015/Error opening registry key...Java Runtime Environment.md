---
title: "Error opening registry key...Java Runtime Environment"
date: 2015-01-22T17:31:00+08:00
draft: false
tags: ["Java"]
categories: ["Java"]
author: "北斗"
---
电脑（win7,64位）原先安装了jdk1.7 jdk1.8 64位的，但是由于做cocos2dx，同事自己写的插件，只支持32位jdk，没办法只能重新安装32位jdk，安装完，执行java -versioin时报

Error opening registry key 'Software\JavaSoft\Java Runtime Environment'
最后解决方案是：将C:\Windows\System32下的java.exe、javaw.exe和javaws.exe删掉即可。