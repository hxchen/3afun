---
title: "如何优雅的关闭Java服务程序"
date: 2023-04-23T18:25:08+08:00
lastmod: 2023-04-23T18:25:08+08:00
keywords: ["Java"]
description: "如何优雅的关闭Java服务程序"
tags: ["Java"]
categories: ["Java"]
author: "北斗"
comment: false
toc: true
autoCollapseToc: true
contentCopyright: false
reward: false
mathjax: false
---


# 钩子函数
对于Java服务来说，启动很容易，我们可以通过`java -jar`命令进行启动，或者开发时候通过IDEA的Run/Debug来启动。
然后当我们停止一个Java程序的时候，我们可能需要先将在线玩家踢下线、保存一下内存里的数据等一些收尾性的工作。那么如何去处理这些工作呢？其实很简单，我们可以向`JVM注册钩子函数`,在钩子函数里执行收尾操作。

下面演示一下如何使用：
```java
@SpringBootApplication
@ServletComponentScan
public class ServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServerApplication.class, args);

        ApplicationUtil.initRunTime();

        ApplicationUtil.initHandler();

        regShutdownHook();
    }

    public static void regShutdownHook() {
        Runtime.getRuntime().addShutdownHook(new Thread(() -> {
            try {
                System.out.println("优雅的关闭服务, 准备处理收尾工作");
                // do something
                System.out.println("可以安心停服了");
            } catch (Throwable e) {
                e.printStackTrace();
            }
        }, "Shutdown Server"));
    }
}

```
在上面代码里，我们利用`main`启动了一个Spring Boot程序，在启动时我们可能还有一些其他初始化工作，我们暂且不关心。我们关心的主要是`regShutdownHook`方法。

我们在`regShutdownHook`里创建了一个线程，并且注册到JVM中去，就完成了一个钩子函数，在线程中我们可以处理关闭程序前的扫尾工作。

# 触发场景

既然钩子函数使用如此简单，那么都有哪些场景会触发呢？下面列出的情况都是可以正常触发的：
1. OutOfMemory 宕机
2. 使用系统退出 `System.exit()`
3. 终端使用`Ctrl+C`触发的中段
4. 使用`kill pid`杀死进程
5. 系统关闭
6. 程序正常退出。

下面这些情况是不会触发的：
1. 系统掉电当然是不会的。
2. `Runtime.getRuntime().halt()`也是不能优雅退出的
3. 使用`kill -9`是不会的。

