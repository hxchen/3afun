---
title: "Android按钮美化"
date: 2015-06-09T18:22:00+08:00
draft: false
tags: ["Android"]
categories: ["Android"]
author: "北斗"
---
下面介绍的Android按钮的美化主要是通过android:background来实现的。

一、首先需要定义按钮样式

在res/drawable下新建文件button_selector.xml，内容如下

```
<?xml version="1.0" encoding="utf-8"?>
<selector xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- pressed -->
    <item android:state_pressed="true" >
        <shape  android:shape="rectangle">
            <gradient
                android:startColor="#ff2b35f0"
                android:endColor="#ff2b35f0"
                android:angle="270" />
            <corners
                android:radius="4dp" />
        </shape>
    </item>
    <!-- focus -->
    <item android:state_focused="true" >
        <shape>
            <gradient
                android:startColor="#ffc2b7"
                android:endColor="#ffc2b7"
                android:angle="270" />
            <corners
                android:radius="4dp" />
        </shape>
    </item>
    <!-- default -->
    <item>
        <shape>
            <gradient
                android:startColor="#ff00aced"
                android:endColor="#ff00aced"
                android:angle="0" />
            <corners
                android:radius="4dp" />
        </shape>
    </item>
</selector>
 ```
二、使用美化的按钮

在原有Button布局文件上增加android:background="@drawable/button_selector"

```
<Button
    android:layout_width="fill_parent"
    android:layout_height="wrap_content"
    android:text="@string/subscribe"
    android:id="@+id/buttonSubscribe"
    android:layout_gravity="center_horizontal"
    android:background="@drawable/button_selector" />
```
 效果如下：
 ![android button](/media/images/2015/android_btn.png)
