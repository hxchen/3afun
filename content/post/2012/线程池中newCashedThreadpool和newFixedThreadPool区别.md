---
title: "线程池中newCashedThreadpool和newFixedThreadPool区别"
date: 2012-12-22 22:58:00+08:00
draft: false
tags: ["并发编程"]
categories: ["并发编程"]
author: "北斗"
---
如果编写的是小程序，或者是轻载的服务器，使用Excutors.newCashedThreadpool通常是个不错的选择，因为它不需要配置，并且一般情况下都能够正确地完成工作。
但是对于大负载的服务器来说，缓存的线程池就不是很好的选择了！
在缓存的线程池中，被提交的任务没有排成队列。而是直接交给线程执行。
如果没有线程可用，就创建一个新的线程。
如果服务器负载的太重，以致他所有的CPU都完全被占用了，当有更多的任务时，就会创建更多的线程，这样只会使情况变得更糟。
因此在大负载的产品服务器中，最好使用Excutors.newFixedThreadPool，它为你提供了一个包含固定线程数目的线程池，或者为了最大的限度地控制它，就直接使用ThreadPoolExcutor类。