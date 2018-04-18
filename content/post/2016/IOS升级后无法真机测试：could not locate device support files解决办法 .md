---
title: "IOS升级后无法真机测试：could not locate device support files解决办法 "
date: 2016-10-25T17:59:00+08:00
draft: false
tags: ["IOS"]
categories: ["IOS"]
author: "北斗"
---
手机升级了10.1，可是XCode（8.0）不支持。

解决办法是：下载SDK，放到

*/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/DeviceSupport*

重启XCode。