---
title: "android工程下不能运行java main程序的解决办法"
date: 2013-01-17 22:31:00+08:00
draft: false
tags: ["Android"]
categories: ["Android"]
author: "北斗"
---
直接运行会报这个错误

A fatal error has been detected by the Java Runtime Environment:

Internal Error (classFileParser.cpp:3161), pid=4884, tid=1732

Error: ShouldNotReachHere()

JRE version: 6.0_22-b04

Java VM: Java HotSpot(TM) Client VM (17.1-b03 mixed mode windows-x86 )

解决办法如下：



右击有main方法的类

===> Run as

===> Run Configurations

===>双击java application

===> 单击有main方法的类

===>选中classpath选项卡

===> remove掉Bootstrap Entries下的android.jar

===> 然后点击advanced

===> Add Library

===>JRE System Library

===>next

===>最后finish

===>Run