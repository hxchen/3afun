---
title: "Android EditText获取焦点显示输入法时布局自动改变的解决方案 "
date: 2015-06-26T17:33:00+08:00
draft: false
tags: ["Android"]
categories: ["Android"]
author: "北斗"
---

最近在调试Android时，发现当屏幕下方的EditText获取焦点，显示输入法时候。页面布局重新调整而不是整体上移。导致部分控件显示不完全。

最终解决方案是修改项目AnroidManifest.xml的文件，在所属Activity中添加属性设置：

```
android:windowSoftInputMode="adjustPan"
```