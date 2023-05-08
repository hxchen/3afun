---
title: "谈谈Synchronized锁锁住的是什么"
date: 2023-04-19T22:06:33+08:00
draft: false
lastmod: 2023-04-19T22:06:33+08:00
tags: ["锁"]
categories: ["锁"]
keywords: ["锁"]
description: "谈谈Synchronized锁锁住的是什么"
author: "北斗"
autoCollapseToc: false
reward: false
mathjax: false
---
先考考你，如果一个线程调用了synchronized修饰的实例方法，在这个方法内，是否可以继续调用其他synchronized修饰的实力方法呢？如果是2个线程调用同一个对象的被synchronized修饰的不同的实例方法呢？

有人会问，synchronized 锁住的是谁呢？其实这有2种情况：
1. 锁住类
2. 锁住对象实例

下面我们就从语法上来分析这2种情况。synchronized 从语法上来说，使用一共有3种情况：
1. 修饰一个静态方法(偷懒行事)----锁住类
2. 修饰一个实例方法(偷懒行事)----锁住对象实例
3. 修饰一个代码块(性能最好)----既可以锁类又可以锁对象，具体看synchronized(参数)内的参数是谁。

## 1.修饰静态方法
静态方法是属于“类”，不属于某个实例，是所有对象实例所共享的方法。
也就是说如果在静态方法上加入synchronized，那么它获取的就是这个类的锁，锁住的就是这个类。

## 2.修饰实例方法
修饰实例方法时，锁住的是对象，一个线程进入synchronized修饰的方法，会阻塞另一个线程进入。但不会阻塞自身继续访问其他synchronized方法。

下面我们用一段代码来说明修饰实例方法的情况：
```java
public class SynLockDemo {

  private int count;

  SynLockDemo(int count){
    this.count = count;
  }

  /**
   * 当 synchronized 修饰实例方法时，锁住的是对象
   * 其他线程不会获取到锁，也就不会执行调用方法
   * @throws InterruptedException
   */
  public synchronized void addOne() throws InterruptedException {
    while (true){
      // 持续占有锁
      count += 1;
      System.out.println(Thread.currentThread().getName() + " 执行 + 1");
      Thread.sleep(1000);
      // 当一个 synchronized 调用另一个 synchronized 方法时候, 是可以获取锁执行的，因为本线程已经获取到了对象锁
      addThree();
    }
  }
  /**
   * 当 synchronized 修饰实例方法时，锁住的是对象
   * 其他线程不会获取到锁，也就不会执行调用方法
   * @throws InterruptedException
   */
  public synchronized void addTwo() throws InterruptedException {
    while (true){
      // 持续占有锁
      count += 2;
      System.out.println(Thread.currentThread().getName() + " 执行 + 2");
      Thread.sleep(1000);
    }

  }

  /**
   * 当 synchronized 修饰实例方法时，锁住的是对象, 在该 synchronized 方法里还可以继续调用其他 synchronized方法。
   */
  public synchronized void addThree(){
    count += 3;
    System.out.println(Thread.currentThread().getName() + " 执行 + 3");
  }

  public static void main(String[] args) {
    SynLockDemo synLockDemo = new SynLockDemo(0);
    ThreadFactory threadFactory = new NameTreadFactory();
    ExecutorService executorService = new ThreadPoolExecutor(2, 3, 0L, TimeUnit.MILLISECONDS, new LinkedBlockingQueue<>(1000), threadFactory);
    // 创建线程任务调用实例方法
    executorService.execute(()->{
      try {
        synLockDemo.addOne();
      } catch (InterruptedException e) {
        throw new RuntimeException(e);
      }
    });
    // 创建线程任务调用实例方法
    executorService.execute(()->{
      try {
        synLockDemo.addTwo();
      } catch (InterruptedException e) {
        throw new RuntimeException(e);
      }
    });

  }

  static class NameTreadFactory implements ThreadFactory {

    private final AtomicInteger mThreadNum = new AtomicInteger(1);

    @Override
    public Thread newThread(Runnable r) {
      Thread t = new Thread(r, "my-thread-" + mThreadNum.getAndIncrement());
      return t;
    }
  }

}
```
查看输出
```text
my-thread-1 执行 + 1
my-thread-1 执行 + 3
my-thread-1 执行 + 1
my-thread-1 执行 + 3
my-thread-1 执行 + 1
my-thread-1 执行 + 3
...
```

通过输出我们看到了2个真相：
1. 实例方法`addOne`得到了调用, 实例方法`addTwo`没有得到调用，另一个线程没有获取到对象锁。
2. 实例方法`addThree`得到了调用，这说明在两个`synchronized`修饰的实例方法里，只要该线程持有对象锁，就可以调用另一个被修饰的实例方法。

## 3.修饰代码块
#### 3.1 synchronized(this){...}
这种情况下，this是实例对象，锁住的是实例对象。
```java
public void addOne() throws InterruptedException {
        synchronized (this){
            // do something
        }
    }
```
#### 3.2 synchronized(xx.class){...}
这种情况下锁住的是类。
```java
public void addTwo() throws InterruptedException {
        synchronized (SynLockDemo2.class){
            // do something
        }
    }
```

知道 synchronized 的你，是不是更懂得如何在方法内加锁来提高性能呢？
还是偷懒直接锁方法呢?
甚至锁类呢?



