---
title: "Java从内存模型上看线程安全"
date: 2023-04-16T18:06:33+08:00
draft: false
lastmod: 2023-04-16T18:06:33+08:00
tags: ["并发","内存模型","线程安全"]
categories: ["内存模型"]
keywords: [内存模型]
description: "从内存模型上看线程安全"
author: "北斗"
autoCollapseToc: false
reward: false
mathjax: false
---

## Java 内存模型

### 主内存与工作内存

不同的平台，内存模型是不一样的，但是jvm的内存模型规范是统一的。
其实java的多线程并发问题最终都会反映在java的内存模型上，所谓线程安全无非是要<font color=red>控制多个线程对某个资源</font>的有序访问或修改。

总结java的内存模型，要解决两个主要的问题：可见性和有序性。我们都知道计算机有高速缓存的存在，处理器并不是每次处理数据都是取内存的。
JVM定义了自己的内存模型，屏蔽了底层平台内存管理细节，对于java开发人员，要清楚在jvm内存模型的基础上，如何解决多线程的可见性和有序性。


Java内存模型（JMM）规定了<font color=red>所有的变量都存储在主内存（Main Memory）中</font>。
主内存可以类比成物理硬件的主内存，但此时仅是虚拟机内存的部分（JVM 内存）。
主内存是多个线程共享的。当new一个对象的时候，也是被分配在主内存中。

而每个线程还有自己的工作内存（Working Memory）。工作内存可以类比成CPU的寄存器和高速缓存。
<font color=red>线程的工作内存中保存了被该线程使用到的变量的主内存副本拷贝， 线程对变量的所有操作(读取、赋值等)都必须在工作内存中进行</font>，
而不能直接读写主内存中的变量。

不同的线程之间也无法直接访问对方工作内存中的变量，<font color=red>线程间变量值的传递均需要通过主内存来完成</font>。

### 内存间交互操作

关于主内存与内存之间具体的交互协议，即一个变量如何从主内存拷贝到工作内存、如何从工作内存同步到主内存之类的实现细节，
Java内存模型中定义了以下8种操作来完成主内存与工作内存之间交互的实现细节，虚拟机实现时必须保证下面提及的每一种操作都是原子的、不可再分的：

1. <font color=red>lock（锁定）：作用于主内存的变量</font>，它把一个变量标示为一条线程独占的状态。

2. <font color=red>unlock（解锁）：作用于主内存的变量</font>，它把一个处于锁定状态的变量释放出来，释放后的变量才可以被其他线程锁定。

3. <font color=red>read（读取）：作用于主内存的变量</font>，它把一个变量的值从主内存传输到工作内存中，以便随后的load动作使用。

4. <font color=red>load（载入）：作用于工作内存的变量</font>，它把read操作从主内存中得到的变量值放入工作内存的变量副本中。

5. <font color=red>use（使用）：作用于工作内存的变量</font>，它把工作内存中的一个变量的值传递给执行引擎，每当虚拟机遇到一个需要使用到变量的值得字节码指令时将会执行这个操作。

6. <font color=red>assign（赋值）：作用于工作内存的变量</font>，它把一个从执行引擎接收到的值赋给工作内存的变量，每当虚拟机遇到一个给变量赋值的字节码指令时执行这个操作。

7. <font color=red>store（存储）：作用于工作内存的变量</font>，它把工作内存中的一个变量的值传递到主内存中，以便随后的write操作使用。

8. <font color=red>write（写入）：作用于主内存的变量</font>，它把store操作从工作内存中得到的变量值放入主内存的变量中。


Java内存模型还规定了执行上述8种基本操作时必须满足如下规则：

1. 不允许read和load、store和write操作之一单独出现，以上两个操作必须按顺序执行，但没有保证必须连续执行，也就是说，read与load之间、store与write之间是可插入其他指令的。

2. 不允许一个线程丢弃它的最近的assign操作，即变量在工作内存中改变了之后必须把该变化同步回主内存。

3. 不允许一个线程无原因地（没有发生过任何assign操作）把数据从线程的工作内存同步回主内存中。

4. 一个新的变量只能从主内存中“诞生”，不允许在工作内存中直接使用一个未被初始化（load或assign）的变量，换句话说就是对一个变量实施use和store操作之前，必须先执行过了assign和load操作。

5. 一个变量在同一个时刻只允许一条线程对其执行lock操作，但lock操作可以被同一个条线程重复执行多次，多次执行lock后，只有执行相同次数的unlock操作，变量才会被解锁。

6. 如果对一个变量执行lock操作，将会清空工作内存中此变量的值，在执行引擎使用这个变量前，需要重新执行load或assign操作初始化变量的值。

7. 如果一个变量实现没有被lock操作锁定，则不允许对它执行unlock操作，也不允许去unlock一个被其他线程锁定的变量。

8. 对一个变量<font color=red>执行unlock操作之前，必须先把此变量同步回主内存（执行store和write操作）</font>。

对于java开发人员，要清楚在jvm内存模型的基础 上，如何解决多线程的可见性和有序性。

那么，何谓<font color=red>可见性？ 多个线程之间是不能互相传递数据通信的，它们之间的沟通只能通过共享变量来进行</font>。
Java内存模型（JMM）规定了jvm有主内存，主内存是多个线程共享的。当new一个对象的时候，也是被分配在主内存中，每个线程都有自己的工作内存，
工作内存存储了主存的某些对象的副本，当然线程的工作内存大小是有限制 的。当线程操作某个对象时，执行顺序如下：
1. 从主存复制变量到当前工作内存 (read and load)
2. 执行代码，改变共享变量值 (use and assign)
3. 用工作内存数据刷新主存相关内容 (store and write)

JVM规范定义了线程对主存的操作指令：read，load，use，assign，store，write。
当一个共享变量在多个线程的工作内存中都有副本时，如果一个线程修改了这个共享变量，那么其他线程应该能够看到这个被修改后的值，这就是多线程的可见性问题。

那么，什么是<font color=red>有序性</font>呢 ？线程在引用变量时不能直接从主内存中引用,如果线程工作内存中没有该变量,则会从主内存中拷贝一个副本到工作内存中,这个过程为read-load,完成后线程会引用该副本。
当同一线程再度引用该字段时,有可能重新从主存中获取变量副本(read-load-use),也有可能直接引用原来的副本 (use),也就是说 read,load,use顺序可以由JVM实现系统决定。
线程不能直接为主存中中字段赋值，它会将值指定给工作内存中的变量副本(assign),完成后这个变量副本会同步到主存储区(store- write)，
至于何时同步过去，根据JVM实现系统决定.
有该字段,则会从主内存中将该字段赋值到工作内存中,这个过程为read-load,完成后线 程会引用该变量副本，当同一线程多次重复对字段赋值时,比如：

```java
for(int i=0;i<10;i++){
    a++;
}
```
线程有可能只对工作内存中的副本进行赋值,只到最后一次赋值后才同步到主存储区，所以assign,store,write顺序可以由JVM实现系统决定。
假设有一个共享变量x，线程a执行x=x+1。从上面的描述中可以知道x=x+1并不是一个原子操作，它的执行过程如下：
1. 从主存中读取变量x副本到工作内存
2. 给x加1
3. 将x加1后的值写回存

如果另外一个线程b执行x=x-1，执行过程如下：
1. 从主存中读取变量x副本到工作内存
2. 给x减1
3. 将x减1后的值写回主存
那么显然，最终的x的值是不可靠的。

假设x现在为10，线程a加1，线程b减1，从表面上看，似乎最终x还是为10，但是多线程情况下会有这种情况发生：
1. 线程a从主存读取x副本到工作内存，工作内存中x值为10
2. 线程b从主存读取x副本到工作内存，工作内存中x值为10
3. 线程a将工作内存中x加1，工作内存中x值为11
4. 线程a将x提交主存中，主存中x为11
5. 线程b将工作内存中x值减1，工作内存中x值为9
6. 线程b将x提交到中主存中，主存中x为9

同样，x有可能为11，如果x是一个银行账户，线程a存款，线程b扣款，显然这样是有严重问题的，要解决这个问题，必须保证线程a和线程b是有序执行的，
并且每个线程执行的加1或减1是一个原子操作。

### synchronized 关键字
上面说了，java用synchronized关键字做为多线程并发环境的执行有序性的保证手段之一。
当一段代码会修改共享变量，这一段代码成为互斥区或 临界区，为了保证共享变量的正确性，synchronized标示了临界区。典型的用法如下：
```java
synchronized(锁){
     临界区代码
}
```
为了保证银行账户的安全，可以操作账户的方法如下：
```java
public synchronized void add(int num) {
     balance = balance + num;
}
public synchronized void withdraw(int num) {
     balance = balance - num;
}
```
刚才不是说了synchronized的用法是这样的吗：
```java
synchronized(锁){
　　临界区代码
}
```
那么对于public synchronized void add(int num)这种情况，意味着什么呢？其实这种情况，锁就是这个方法所在的对象。
同理，如果方法是public  static synchronized void add(int num)，那么锁就是这个方法所在的class。
理论上，每个对象都可以做为锁，但一个对象做为锁时，应该被多个线程共享，这样才显得有意义，
在并发环境下，一个没有共享的对象作为锁是没有意义的。假如有这样的代码：

```java
public class ThreadTest{
  public void test(){
     Object lock=new Object();
     synchronized (lock){
        //do something
     }
  }
}
```
lock变量作为一个锁存在根本没有意义，因为它根本不是共享对象，每个线程进来都会执行Object lock=new Object();每个线程都有自己的lock，根本不存在锁竞争。

<font color=red>每个锁对象都有两个队列，一个是就绪队列，一个是阻塞队列，就绪队列存储了将要获得锁的线程，阻塞队列存储了被阻塞的线程</font>，当一个被线程被唤醒 (notify)后，才会进入到就绪队列，等待cpu的调度。当一开始线程a第一次执行account.add方法时，jvm会检查锁对象account 的就绪队列是否已经有线程在等待，如果有则表明account的锁已经被占用了，由于是第一次运行，account的就绪队列为空，所以线程a获得了锁， 执行account.add方法。如果恰好在这个时候，线程b要执行account.withdraw方法，因为线程a已经获得了锁还没有释放，所以线程 b要进入account的就绪队列，等到得到锁后才可以执行。
一个线程执行临界区代码过程如下：
1. 获得同步锁
2. 清空工作内存
3. 从主存拷贝变量副本到工作内存
4. 对这些变量计算
5. 将变量从工作内存写回到主存
6. 释放锁
可见，synchronized既保证了多线程的并发有序性，又保证了多线程的内存可见性。

### 生产者/消费者模式
生产者/消费者模式其实是一种很经典的线程同步模型，很多时候，并不是光保证多个线程对某共享资源操作的互斥性就够了，往往多个线程之间都是有协作的。
假设有这样一种情况，有一个桌子，桌子上面有一个盒子，盒子里最多只能放5个苹果，A生产者专门往盒子里放苹果，如果盒子满了，则一直等到盒子苹果数小于5，
消费者B专门 从盒子里拿苹果，如果盒子里没苹果，则等待直到盒子里有苹果。
其实盒子就是一个互斥区，每次往盒子放苹果应该都是互斥的，A的等待其实就是主动放弃锁，B 等待时还要提醒A放苹果。

<font color=red>如何让线程主动释放锁很简单，调用锁的wait()方法就好</font>。wait方法是从Object来的，所以任意对象都有这个方法。

生产者：  往一个公共的盒子里面放苹果
消费者：从公共的盒子里面取苹果
盒子：盒子的容量不能超过5

wait()  和   notify()   通信方法实现

```java
package 生产者消费者;


public class PublicBox {
    private int apple = 0;
    public synchronized void increace() {
        while (apple == 5) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        apple++;
        System.out.println("生产了一个");
        notify();
    }
    public synchronized void decreace() {
        while (apple ==0) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        apple--;
        System.out.println("消费了一个");
        notify();
    }

    public static void main(String []args)
       {
              PublicBox box= new PublicBox();

              Consumer con= new Consumer(box);
              Producer pro= new Producer(box);

              Thread t1= new Thread(con);
              Thread t2= new Thread(pro);

              t1.start();
              t2.start();

       }
}


//生产者代码（定义十次）：
class Producer implements Runnable {
    private PublicBox box;

    public Producer(PublicBox box) {
        this.box = box;
    }

    @Override
    public void run() {
        for( int i=0;i<10;i++)
        {
            box.increace();
        }
    }
}

//消费者代码（同样十次）：
class Consumer implements Runnable {
    private PublicBox box;

    public Consumer(PublicBox box) {
        this.box = box;
    }
    @Override
    public void run() {
         for( int i=0;i<10;i++)
        {
             box.decreace();
         }
    }
}
```

### volatile 关键字
volatile两个语义：<font color=red>保证变量可见性和禁止指令重排序</font>。

volatile是java提供的一种同步手段，只不过它是轻量级的同步，为什么这么说，因为volatile只能保证多线程的内存可见性，不能保证多线程的执行有序性,也不能保证原子性。
而最彻底的同步要保证有序性和可见性，例如synchronized。
任何被volatile修饰的变量，每次读取和修改看起来都像是直接在主存操作（
volatile变量在各个线程的工作内存中不存在一致性问题，因为在每次使用之前都要先刷新，执行引擎看不到不一样的情况）。
因此对于Valatile修饰的变量的修改，所有线程马上就能看到，但是volatile不能保证对变量的修改是有序的。什么意思 呢？假如有这样的代码：
```java
public class VolatileTest{
  public volatile int a;
  public void add(int count){
       a=a+count;
  }
}
```
当一个VolatileTest对象被多个线程共享，a的值不一定是正确的，因为a=a+count包含了好几步操作，而此时多个线程的执行是无序的，
因为没有任何机制来保证多个线程的执行有序性和原子性。volatile存在的意义是，任何线程对a的修改，都会马上被其他线程读取到，因为直接操作主存，
没有线程对工作内存和主存的同步。所以，volatile的使用场景是有限的，在有限的一些情形下可以使用 volatile 变量替代锁。
要使 volatile 变量提供理想的线程安全,必须同时满足下面两个条件:
1. 对变量的写操作不依赖于当前值。
2. 该变量没有包含在具有其他变量的不变式中
volatile只保证了可见性，所以Volatile适合直接赋值的场景，如
```java
public class VolatileTest{
  public volatile int a;
  public void setA(int a){
      this.a=a;
  }
}
```
在没有volatile声明时，多线程环境下，a的最终值不一定是正确的，因为this.a=a;涉及到给a赋值和将a同步回主存的步骤，这个顺序可能被打乱。
如果用volatile声明了，读取主存副本到工作内存和同步a到主存的步骤，相当于是一个原子操作。
所以简单来说，volatile适合这种场景：一个变量被多个线程共享，线程直接给这个变量赋值。这是一种很简单的同步场景，这时候使用volatile的开销将会非常小。

很多人都问，所谓线程的“工作内存”到底是个什么东西？有的人认为是线程的栈，其实这种理解是不正确的。
看看JLS（java语言规范）对线程工作 内存的描述，线程的working memory只是cpu的寄存器和高速缓存的抽象描述。

可能很多人都觉得莫名其妙，说JVM的内存模型，怎么会扯到cpu上去呢？在此，我认为很有必要阐述下，免得很多人看得不明不白的。
先抛开java虚拟机不谈，我们都知道，现在的计算机，cpu在计算的时候，并不总是从内存读取数据，它的数据读取顺序优先级是：寄存器－高速缓存－内存。
线程耗费的是CPU，线程计算的时候，原始的数据来自内存，在计算过程中，有些数据可能被频繁读取，这些数据被存储在寄存器和高速缓存中，
当线程计算完后，这些缓存的数据在适当的时候应该写回内存。当个多个线程同时读写某个内存数据时，就会产生多线程并发问题，涉及到三个特性：原子性，有序性，可见性。

那么，我们看看JVM，JVM是一个虚拟的计算机，它也会面临多线程并发问题，java程序运行在java虚拟机平台上，
java程序员不可能直接去控制底层线程对寄存器高速缓存内存之间的同 步，那么java从语法层面，应该给开发人员提供一种解决方案，
这个方案就是诸如synchronized, volatile,锁机制（如同步块，就绪队 列，阻塞队列）等等。这些方案只是语法层面的，
但我们要从本质上去理解它，不能仅仅知道一个 synchronized 可以保证同步就完了。
在这里我说的是jvm的内存模型，是动态的，面向多线程并发的，沿袭JSL的“working memory”的说法。

## JVM内存结构
（所以顺便简要说一下JVM内存结构，不要混淆）
<a font color='red'>
1. 堆（Heap）：线程共享。所有的对象实例以及数组都要在堆上分配。回收器主要管理的对象。
2. 方法区（Method Area）：线程共享。存储类信息、常量、静态变量、即时编译器编译后的代码。
3. 方法栈（JVM Stack）：线程私有。存储局部变量表、操作栈、动态链接、方法出口，对象指针。
4. 本地方法栈（Native Method Stack）：线程私有。为虚拟机使用到的Native 方法服务。如Java使用c或者c++编写的接口服务时，代码在此区运行。
5. 程序计数器（Program Counter Register）：线程私有。有些文章也翻译成PC寄存器（PC Register），同一个东西。它可以看作是当前线程所执行的字节码的行号指示器。指向下一条要执行的指令。
 </font>
