---
title: "Swift跳转AppStore商店应用评论页"
date: 2018-07-19T16:32:12+08:00
draft: false
lastmod: 2018-07-19T16:32:12+08:00
tags: ["Swift"]
categories: ["Swift"]
keywords: ["Swift"]
description: "Swift"
author: "北斗"
---


兼容iOS10以及iOS11的,跳转苹果商店应用评论页的函数,直接调用就行。

自行替换`XXXXXXXX`为商店ID

```swift
//跳转到应用的AppStore页页面
    func gotoAppStore() {
        let urlString = "itms-apps://itunes.apple.com/cn/app/idXXXXXXXX?mt=8&action=write-review"
        if let url = URL(string: urlString) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],completionHandler: {(success) in})
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
```
