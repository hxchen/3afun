
---
title: "Android：Layout_weight的深刻理解"
date: 2015-05-02T17:29:00+08:00
draft: false
tags: ["Android"]
categories: ["Android"]
author: "北斗"
---
最近写Demo，突然发现了Layout_weight这个属性，发现网上有很多关于这个属性的有意思的讨论，可是找了好多资料都没有找到一个能够说的清楚的，于是自己结合网上资料研究了一下，终于迎刃而解，写出来和大家分享。

首先看一下Layout_weight属性的作用：它是用来分配属于空间的一个属性，你可以设置他的权重。很多人不知道剩余空间是个什么概念，下面我先来说说剩余空间。

看下面代码：
```
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:orientation="vertical"
    android:layout_width="fill_parent"
    android:layout_height="fill_parent"
    >
<EditText
    android:layout_width="fill_parent"
    android:layout_height="wrap_content"
    android:gravity="left"
    android:text="one"/>
<EditText
    android:layout_width="fill_parent"
    android:layout_height="wrap_content"
    android:gravity="center"
    android:layout_weight="1.0"
    android:text="two"/>
    <EditText
    android:layout_width="fill_parent"
    android:layout_height="wrap_content"
    android:gravity="right"
    android:text="three"/>
</LinearLayout>
```
运行结果是：

![android](/media/images/2015/android01.png)


看上面代码：只有Button2使用了Layout_weight属性，并赋值为了1，而Button1和Button3没有设置Layout_weight这个属性，根据API，可知，他们默认是0

下面我就来讲，Layout_weight这个属性的真正的意思：Android系统先按照你设置的3个Button高度Layout_height值wrap_content,给你分配好他们3个的高度，

然后会把剩下来的屏幕空间全部赋给Button2,因为只有他的权重值是1，这也是为什么Button2占了那么大的一块空间。

有了以上的理解我们就可以对网上关于Layout_weight这个属性更让人费解的效果有一个清晰的认识了。

我们来看这段代码：
```
 <？xml version="1.0" encoding="UTF-8"？>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="fill_parent"
    android:layout_height="wrap_content"
    android:orientation="horizontal" >
    <TextView
        android:background="＃ff0000"
        android:layout_width="**"
        android:layout_height="wrap_content"
        android:text="1"
        android:textColor="＠android:color/white"
        android:layout_weight="1"/>
    <TextView
        android:background="＃cccccc"
        android:layout_width="**"
        android:layout_height="wrap_content"
        android:text="2"
        android:textColor="＠android:color/black"
        android:layout_weight="2" />
     <TextView
        android:background="＃ddaacc"
        android:layout_width="**"
        android:layout_height="wrap_content"
        android:text="3"
        android:textColor="＠android:color/black"
        android:layout_weight="3" />
</LinearLayout>
```
三个文本框的都是 layout_width=“wrap_content ”时，会得到以下效果

![android](/media/images/2015/android02.jpg)


按照上面的理解，系统先给3个TextView分配他们的宽度值wrap_content（宽度足以包含他们的内容1,2,3即可），然后会把剩下来的屏幕空间按照1:2:3的比列分配给3个textview，所以就出现了上面的图像。

而当layout_width=“fill_parent”时，如果分别给三个TextView设置他们的Layout_weight为1、2、2的话，就会出现下面的效果：

![android](/media/images/2015/android03.jpg)


你会发现1的权重小，反而分的多了，这是为什么呢？？？网上很多人说是当layout_width=“fill_parent”时，weighth值越小权重越大，优先级越高，就好像在背口诀

一样，其实他们并没有真正理解这个问题，真正的原因是Layout_width="fill_parent"的原因造成的。依照上面理解我们来分析：

系统先给3个textview分配他们所要的宽度fill_parent，也就是说每一都是填满他的父控件，这里就死屏幕的宽度

那么这时候的剩余空间=1个parent_width-3个parent_width=-2个parent_width (parent_width指的是屏幕宽度 )

那么第一个TextView的实际所占宽度应该=fill_parent的宽度,即parent_width + 他所占剩余空间的权重比列1/5 * 剩余空间大小（-2 parent_width）=3/5parent_width

同理第二个TextView的实际所占宽度=parent_width + 2/5*(-2parent_width)=1/5parent_width;

第三个TextView的实际所占宽度=parent_width + 2/5*(-2parent_width)=1/5parent_width；所以就是3:1:1的比列显示了。

这样你也就会明白为什么当你把三个Layout_weight设置为1、2、3的话,会出现下面的效果了：

![android](/media/images/2015/android04.jpg)


第三个直接不显示了，为什么呢？一起来按上面方法算一下吧：

系统先给3个textview分配他们所要的宽度fill_parent，也就是说每一都是填满他的父控件，这里就死屏幕的宽度

那么这时候的剩余空间=1个parent_width-3个parent_width=-2个parent_width (parent_width指的是屏幕宽度 )

那么第一个TextView的实际所占宽度应该=fill_parent的宽度,即parent_width + 他所占剩余空间的权重比列1/6 * 剩余空间大小（-2 parent_width）=2/3parent_width

同理第二个TextView的实际所占宽度=parent_width + 2/6*(-2parent_width)=1/3parent_width;

第三个TextView的实际所占宽度=parent_width + 3/6*(-2parent_width)=0parent_width；所以就是2:1:0的比列显示了。第三个就直接没有空间了。