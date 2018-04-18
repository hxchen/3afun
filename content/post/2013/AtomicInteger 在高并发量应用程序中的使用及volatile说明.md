---
title: "AtomicInteger 在高并发量应用程序中的使用及volatile说明"
date: 2013-04-08 19:45:00+08:00
draft: false
tags: ["并发编程"]
categories: ["并发编程"]
author: "北斗"
---
当我们在处理简单程序中，可以使用诸如count++这种简单的计数器，但是这种简单的处理在高并发/多线程中的使用却是不安全的，几乎可以百分百的说，得到的数据是未更新的，不是实时数据，然而在JDK1.5之后，却封装了一个类AtomicInteger 可以用来统计这种计数。

该类中有三个变量，其中最重要的是
```
private volatile int value;
```
value就类似count，还有2个辅助变量用于进行更新value。其中的volatile使用可见最后说明。
```java
// setup to use Unsafe.compareAndSwapInt for updates

private static final Unsafe unsafe = Unsafe.getUnsafe();

private static final long valueOffset;
```
在该类中常用方法主要是实现加1减1操作，方法分别是：
```java
public final int getAndIncrement()；

public final int getAndDecrement()；
```


volatile说明：

volatile修饰的成员变量在每次被线程访问时，都强迫从共享内存重新读取该成员的值，而且，当成员变量值发生变化时，强迫将变化的值重新写入共享内存，这样两个不同的线程在访问同一个共享变量的值时，始终看到的是同一个值。



java语言规范指出：为了获取最佳的运行速度，允许线程保留共享变量的副本，当这个线程进入或者离开同步代码块时，才与共享成员变量进行比对，如果有变化再更新共享成员变量。这样当多个线程同时访问一个共享变量时，可能会存在值不同步的现象。而volatile这个值的作用就是告诉VM：对于这个成员变量不能保存它的副本，要直接与共享成员变量交互。



建议：当多个线程同时访问一个共享变量时，可以使用volatile，而当访问的变量已在synchronized代码块中时，不必使用。

缺点：使用volatile将使得VM优化失去作用，导致效率较低，所以要在必要的时候使用。



除了volatile外，对于线程安全加锁的，我们接触更多的是synchronized。这里就不在做更多的说明。