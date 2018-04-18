---
title: "CountDownLatch 闭锁演示"
date: 2012-11-23 18:02:00+08:00
draft: false
tags: ["并发编程"]
categories: ["并发编程"]
author: "北斗"
---
```java
import java.util.concurrent.CountDownLatch;

/**
 * CountDownLatch 闭锁演示
 * 闭锁的作用相当于一扇门：在闭锁到达结束状态（getCount()=0）前，这扇门一直是关闭的，并且没有任何线程能通过。
 * 当到达结束状态时，这扇门会打开并允许所有的线程通过（可以继续执行await()之后的代码）。
 * 当闭锁到达结束状态后，将不会再改变状态，因此这扇门将永远保持打开状态。
 * **/
public class TestHarness {
	public long timeTasks(int nThreads, final Runnable task)
		throws InterruptedException{

		final CountDownLatch startGate = new CountDownLatch(1);
		final CountDownLatch endGate = new CountDownLatch(nThreads);

		for(int i = 0; i < nThreads; i++){
			Thread thread = new Thread(){
				public void run(){
					try {
						System.out.println("Before:S="+startGate.getCount()+"	E="+endGate.getCount());
						startGate.await();//使当前线程在锁存器倒计数至零之前一直等待，除非线程被中断。
						System.out.println("After：S="+startGate.getCount()+"	E="+endGate.getCount());
						try {
							System.out.println("task run!");
							task.run();
						} finally{
							System.out.println("End Gate countDown()");
							endGate.countDown();
						}
					} catch (InterruptedException e) {}
				}
			};
			thread.start();
		}
		long start = System.nanoTime();//返回最准确的可用系统计时器的当前值，以毫微秒为单位。
		System.out.println("开启启动门!");
		startGate.countDown();//递减锁存器的计数，如果计数到达零，则释放所有等待的线程。
		endGate.await();//使当前线程在锁存器倒计数至零之前一直等待，除非线程被中断。
		System.out.println("End Gate await()");
		long end = System.nanoTime();
		return end-start;
	}
	public static void main(String[] args) {
		MyThread thread=new MyThread("线程A");
		TestHarness testHarness = new TestHarness();
		try {
			long time = testHarness.timeTasks(10, thread);
			System.out.println("It's cost time:"+time);
		} catch (Exception e) {
			System.out.println("Exception Accured!");
		}
	}
}
```

