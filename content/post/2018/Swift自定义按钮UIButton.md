---
title: "Swift自定义按钮UIButton"
date: 2018-07-23T20:58:17+08:00
draft: false
lastmod: 2018-07-23T20:58:17+08:00
tags: ["Swift","iOS"]
categories: ["Swift","iOS"]
keywords: ["Swift","iOS"]
description: "Swift iOS"
author: "北斗"
---

在开发的时候,默认的UI有时候并不能满足我们的要求,我们可能需要一套具有主题的按钮,为了避免使用按钮的时候,每次都需要重写大量UI代码,我们就需要定义一套公共的按钮进行复用。

Swift自定义按钮其实很简单,只要继承`UIButton`,并重写其中的`init`方法就可以。示例中我定义了2种不同颜色的带圆角按钮,并且添加了点击按下变色的效果。

使用的时候直接创建对象,设置按钮文字即可。

按钮效果:

![custom_button01](/media/images/2018/custom_button01.png)

示例代码:
```swift
class KhakiButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.init(rgb: 0x555555), for: .highlighted)
        backgroundColor = UIColor(red: 176/255, green: 160/255, blue: 141/255, alpha:0xFF)
        setBackgroundColor(color: UIColor.init(rgb: 0x9a8b79), forState: .highlighted)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 红色按钮
class RedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 4
        clipsToBounds = true
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.init(rgb: 0x555555), for: .highlighted)
        backgroundColor = UIColor(red: 210/255, green: 93/255, blue: 84/255, alpha:0xFF)
        setBackgroundColor(color: UIColor.init(rgb: 0xbe4e46), forState: .highlighted)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

使用方法:
```swift
let loginButton = RedButton()
loginButton.setTitle("登录", for: .normal)
let registerButton = KhakiButton()
registerButton.setTitle("注册", for: .normal)
```


其中用到的`UIColor.init`是我自定义的一个方法,进行16进制颜色值和rgb转换

```swift
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
```