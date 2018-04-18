---
title: "Android 按钮控制ViewPager左右翻页"
date: 2015-06-09T18:14:00+08:00
draft: false
tags: ["Android"]
categories: ["Android"]
author: "北斗"
---
ViewPager除了滑动翻页，有时我们需要增加按钮翻页。

向前翻页可以在按钮事件里调用

```
viewPager.arrowScroll(View.FOCUS_LEFT);
```
向后翻页可以在按钮事件里调用

```
viewPager.arrowScroll(View.FOCUS_RIGHT);
```