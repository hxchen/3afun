---
title: "Swift之SDK开发-从Framework中给UIButton按钮加载图片"
date: 2018-06-25T17:40:07+08:00
draft: falsse
tags: ["Swift","iOS"]
categories: ["Swift"]
keywords: ["Swift","iOS","SDK","framework"]
description: "Swift"
author: "北斗"
---


如果是正常App加载图片资源,我们会如下方法加载
```swift
let button = UIButton()
let logoImage:UIImageView!
logoImage = UIImageView(image: UIImage(named: "image_name"))
button.setImage(logoImage, for: .normal)

```

但是当我们这个资源是要打包成Framework,给第三方使用的使用,第三方就会不能加载我们的图片资源。这时候我们就应该从该SDK内读取资源,正确方式如下:

```swift
let button = UIButton()
let logoImage:UIImageView!
logoImage = UIImageView(named: "image_name",in: Bundle(for: type(of: self)), compatibleWith: nil)
button.setImage(logoImage, for: .normal)

```