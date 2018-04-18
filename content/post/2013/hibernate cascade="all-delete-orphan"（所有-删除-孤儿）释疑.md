---
title: "hibernate cascade='all-delete-orphan'（所有-删除-孤儿）释疑"
date: 2013-01-17 22:39:00+08:00
draft: false
tags: ["MySQL"]
categories: ["MySQL"]
author: "北斗"
---

这是一个级联插入，删除，更新的操作。

cascade="all-delete-orphan"（所有-删除-孤儿）。级联操作的精确语义在下面列出:

如果父对象被保存，所有的子对象会被传递到saveOrUpdate()方法去执行

如果父对象被传递到update()或者saveOrUpdate()，所有的子对象会被传递到saveOrUpdate()方法去执行

如果一个临时的子对象被一个持久化的父对象引用了，它会被传递到saveOrUpdate()去执行

如果父对象被删除了，所有的子对象对被传递到delete()方法执行

如果临时的子对象不再被持久化的父对象引用，什么都不会发生（必要时，程序应该明确的删除这个子对象），除非声明了cascade="all-delete-orphan"，在这种情况下，成为“孤儿”的子对象会被删除。

