---
title: "Swift动态库FrameworkSDK开发"
date: 2018-05-18T18:34:58+08:00
draft: false
lastmod: 2018-05-18T18:34:58+08:00
tags: ["Swift"]
categories: ["Swift"]
keywords: ["Swift"]
description: "Swift"
author: "北斗"
---

今天这篇文章主要是来讲解如何进行 `Cocoa Touch Framework` 开发SDK,以及如何使用打包出来的SDK。

## 学习目标
看完这篇文章,你将会学会:

* 使用Xcode创建一个`Cocoa Touch Framework`项目,进行SDK开发
* 打包SDK
* 使用storyboard进行简单布局
* UI和代码的链接,进行事件操作
* 调用打包的SDK中的函数

## 一、创建一个Cocoa Touch Framework项目
### 1.打开Xcode,新建一个工程

因为是进行Cocoa Touch Framework开发,所以我们要选择这个,然后点击next。
![new project](/media/images/2018/swift01.png)

在这里我们给我们的工程起个名字:AccountSDK
![new project](/media/images/2018/swift02.png)

### 2.编写函数供SDK掉用者使用

菜单栏->File->New->File... 新建一个名为`LoginProcessor.swift`的文件。

![new file](/media/images/2018/swift03.png)


`LoginProcessor.swift`代码如下:

```swift
import Foundation

public class LoginProcessor{

    public init(){

    }

    public func login(){
        NSLog("LoginProcessor:login");
    }
}
```
在类LoginProcessor里面我们先定义了构造函数init,然后定义了一个login函数供SDK调用者使用,功能非常简单,只是一句简单输出。

### 3.打包SDK
快捷键command+B打包SDK成framework文件,默认生产的文件会在Products目录下。我们可以选择文件,右键打开文件所在位置找到文件供接下来的步骤使用。
![findindir](/media/images/2018/swift04.png)

## ️二、创建Single View App项目来测试SDK
### 1.使用Xcode新建一个名为AccountSDKDemo的工程
Xcode菜单栏->File->New->Project
![new Project](/media/images/2018/swift05.png)

![new Project](/media/images/2018/swift06.png)

### 2.为storyboard添加Button
左侧导航栏选中`Main.storyboard`,中间我们会看到一个UI,右侧有工具区。我们从工具区拖拽一个Button到中间编辑区的UI上。

![new Project](/media/images/2018/swift07.png)

### 3.切换到Assistant 工作区
点击工具栏左上角的 Show Assistant Editor

![new Project](/media/images/2018/swift08.png)

### 4.UI和代码的绑定
1.编辑 ViewController.swift,在`UIViewController{ `下面添加注释 `//MARK: Properties`,下面代码来绑定UI中的变量,
在类的最后一个括号上面添加一行注释`//MARK: Actions`下面代码好绑定事件。

2.在UI上选中Button按钮,右键拖拽一个Referencing Outlets到`//MARK: Properties`下面,并起名`loginButton`
拖拽一个Touch Up Inside事件到 `//MARK: Actions`下面,起名`login`


![new Project](/media/images/2018/swift09.png)

### 5.添加SDK

1.复制步骤一中打包出来的SDK到AccountSDKDemo目录下,并添加。
![new Project](/media/images/2018/swift10.png)

2.General->Embedded Binaries中添加SDK。
![new Project](/media/images/2018/swift11.png)

### 6.调用SDK代码

编辑ViewController.swift,添加`import AccountSDK`,并且在login事件中调用SDK中定义的login函数。
最终该文件应该是这样的:
```swift
//
//  ViewController.swift
//  AccountSDKDemo
//
//  Created by 海祥陈 on 2018/5/18.
//  Copyright © 2018年 海祥陈. All rights reserved.
//

import UIKit
import AccountSDK

class ViewController: UIViewController {
    //MARK: Properties

    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Actions

    // event for click login button
    @IBAction func login(_ sender: Any) {
        NSLog("Login");
        LoginProcessor().login();
    }

}
```
## 三、测试

 Command+R 在模拟器上运行AccountSDKDemo App,运行后,点击Login按钮,观察后台日志,是否成功输出LoginProcessor中login函数的内容。

 ![new Project](/media/images/2018/swift12.png)


## 四、代码
 <a href="https://github.com/hxchen/account" target="_blank">代码参考</a>



















