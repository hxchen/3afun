---
title: "Java热更新方案"
date: 2023-04-22T18:25:08+08:00
lastmod: 2023-04-22T18:25:08+08:00
keywords: ["Java"]
description: "Java热更新方案"
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


线上代码出现问题，我们就要修改问题。面对要求严格的停服计划，对于一些小Bug，我们可以采取不停服热更新，今天就总结一个热更新方案：
利用Arthas在线热更。
# Arthas介绍、安装
## 介绍
<a href="https://arthas.aliyun.com/doc/">Arthas</a>是Ali出品的一款线上针对产品，官方介绍是：
Arthas 是一款线上监控诊断产品，通过全局视角实时查看应用 load、内存、gc、线程的状态信息，并能在不修改应用代码的情况下，对业务问题进行诊断，
包括查看方法调用的出入参、异常，监测方法执行耗时，类加载信息等，大大提升线上问题排查效率。
## 安装&启动
下载`arthas-boot.jar`，然后用`java -jar`的方式启动：

```shell
curl -O https://arthas.aliyun.com/arthas-boot.jar
java -jar arthas-boot.jar
```
启动后，我们就可以在窗口里执行各种Arthas命令。包括后面我们将要学习的热更命令。

打印帮助信息：
```shell
java -jar arthas-boot.jar -h
```
如果下载速度比较慢，可以使用 aliyun 的镜像：

```shell
java -jar arthas-boot.jar --repo-mirror aliyun --use-http
```
## 热更预准备
1. 热更新前，我们使用SpringBoot准备一个Controller，并建立待修复Bug的错误代码：
```java
@RestController
public class FibonacciController {

    @RequestMapping(value ="/fib", method = RequestMethod.GET)
    public long fibonacci(int value){
        return fib(value);
    }

    private long fib(int n){
        if (n <= 1) {
            return 1;
        }
        return fib(n-1) * fib(n-2);
    }
}
```
对于熟悉斐波那契数列的小伙伴可能知道，我们要做的操作就是修改`fib(n-1) * fib(n-2)`中的乘号为加好。

2. 启动运行SpringBoot，访问`http://127.0.0.1:8080/fib?value=5`

查看输出：1

## 热更
热更操作，我们主要是利用Arthas的`jad` `sc` `mc` `retransform`命令。下面我们将逐个讲解如何使用命令。
具体更强大的命令请直接查看<a href="https://arthas.aliyun.com/doc/commands.html">官网信息</a>
1. jad 反编译

   jad 命令将 JVM 中实际运行的 class 的 byte code 反编译成 java 代码，便于你理解业务逻辑；
   下面我们将待修改的方法所在类反编译到指定位置：
   ```shell
    $ jad --source-only com.a3fun.learn.learnhotswap.FibonacciController > /Users/用户名/arthas-output/FibonacciController.java
    ```
   我们可以使用编辑器打开java文件，修改错误代码。
   修改前：return this.fib(n - 1) * this.fib(n - 2);
   修改后：return this.fib(n - 1) + this.fib(n - 2);
2. sc 查看类加载器

   “Search-Class” 的简写，这个命令能搜索出所有已经加载到 JVM 中的 Class 信息。
    ```shell
    $ sc -d *FibonacciController | grep classLoaderHash
    # 输出
    classLoaderHash   5b480cf9
    ```
3. mc 内存编译

   Memory Compiler/内存编译器，编译.java文件生成.class。

   小提示：

   使用mc命令来编译jad的反编译的代码有可能失败。可以在本地修改代码，编译好后再上传到服务器上。
    ```shell
    $ mc -c 5b480cf9 /Users/用户名/arthas-output/FibonacciController.java -d /Users/用户名/arthas-output/
   # 输出
    Memory compiler output:
    /Users/用户名/arthas-output/com/a3fun/learn/learnhotswap/FibonacciController.class
    Affect(row-cnt:1) cost in 616 ms.

   ```
4. retransform 加载class

   加载外部的.class文件，retransform jvm 已加载的类。可以支持单个、多个、正则表达式。

    顺便说一下`redefine`和`retransform`的区别：前者redefine 的 class 不能修改、添加、删除类的 field 和 method，包括方法参数、方法名称及返回值。所以推荐使用后者。
    ```shell
    $ retransform /Users/haixiangchen/arthas-output/com/a3fun/learn/learnhotswap/FibonacciController.class
   # 输出
    retransform success, size: 1, classes:
    com.a3fun.learn.learnhotswap.FibonacciController
    ```
5. 重新访问：访问`http://127.0.0.1:8080/fib?value=5`
   查看新的输出已经是正确的结果：8

