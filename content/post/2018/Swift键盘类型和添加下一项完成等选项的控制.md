---
title: "Swift键盘类型和添加下一项完成等选项的控制"
date: 2018-07-24T18:56:43+08:00
draft: false
lastmod: 2018-07-24T18:56:43+08:00
tags: ["Swift","iOS"]
categories: ["Swift","iOS"]
keywords: ["Swift","iOS"]
description: "Swift iOS"
author: "北斗"
---


为了便于易用性,Swift在`UIKeyboardType`为我们定义了众多的键盘类型。

# Swift键盘类型 UIKeyboardType
类型	                  |应用
----------------------|------------------
default	              |为当前输入方法提供的默认类型。
asciiCapable	        |一个可以输入ASCII字符的键盘类型
numbersAndPunctuation	|数字和标点符号
URL	                  |为方便输入网址URL网址 (例如 . / .com ).
numberPad	            |数字键盘 (0-9, ۰-۹, ०-९, etc.). 方便PIN码的输入.
phonePad	            |一般用于打电话键盘 (1-9, *, 0, #, 数字下含字母).
namePhonePad	        |方便输入姓名和手机号.
emailAddress	        |方面输入邮箱地址的 (含有 space @ .).
decimalPad	          |iOS4.1+ 支持输入数字和小数点
twitter	              |iOS5.0+ 方便twitter输入的,支持 @ #
webSearch	            |iOS7.0+ 面向URL输入,支持空格 点号.
asciiCapableNumberPad	|iOS10.0+ 数字键盘（0-9），始终为ASCII数字。

# Swift 键盘返回类型 UIReturnKeyType
连续多个输入框的时候,有时我们填写完一项,我们想使用键盘自动跳到下一项输入框,这时候我们可以设置键盘Return按键功能,该类型定义在UIReturnKeyType

|       |               |                    |
|-------|---------------|--------------------|
|default|go             |	google             |
|join	  |next	          |route               |
|search	|send	          |yahoo               |
|done	  |emergencyCall	|continue //iOS 9.0+ |


常用的有next下一项和done完成,使用方法如下:

- 1、ViewController类需要继承UITextFieldDelegate

- 2、设置TextField的returnKeyType和delegate值。

- 3、实现textFieldShouldReturn方法。

效果如图:
![keyboard_next](/media/images/2018/keyboard_next.png)

![keyboard_done](/media/images/2018/keyboard_done.png)

实现代码如下:

```swift
class ViewController: UIViewController, UITextFieldDelegate{

  var nameTextfield :UITextField!//账号
  var passworkTextfield :UITextField!//密码

  override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      ...
      nameTextfield.returnKeyType = UIReturnKeyType.next
      nameTextfield.delegate = self
      passworkTextfield.returnKeyType = UIReturnKeyType.done
      passworkTextfield.delegate = self
      ...
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextfield {
            // 焦点转到密码输入框
            passworkTextfield.becomeFirstResponder()
        }else {
           // 收起键盘
           textField.resignFirstResponder()
        }
        return true;
    }

}
```

在上面的代码中我们设置了,当焦点位于账号输入框时,键盘右下角显示下一项,点击下一项,焦点移到密码输入框,此时键盘右下角显示完成,点击完成,可隐藏键盘。

# 为数字键盘添加完成功能

当我们设置键盘类型为UIKeyboardType.numberPad,我们是无法为键盘添加完成收起键盘的功能。 但是我们可以利用UIToolbar在数字键盘上方附着一个完成按钮。

假设我们的TextField名为 codeTextfield,我们可以利用如下代码实现添加完成按钮,点击完成按钮,隐藏键盘。

效果如下:

![keyboard_number_next](/media/images/2018/keyboard_number_next.png)

![keyboard_number_done](/media/images/2018/keyboard_number_done.png)

实现代码如下:
```swift
// 添加完成按钮
let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
doneToolbar.barStyle       = UIBarStyle.default
let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.doneButtonAction))
var items = [UIBarButtonItem]()
items.append(flexSpace)
items.append(done)
doneToolbar.items = items
doneToolbar.sizeToFit()
codeTextfield.inputAccessoryView = doneToolbar

// 点击完成按钮，隐藏键盘
@objc func doneButtonAction() {
    self.verificationCodeTextfield.resignFirstResponder()
}
```
