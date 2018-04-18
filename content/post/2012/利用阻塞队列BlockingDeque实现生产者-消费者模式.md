---
title: "利用阻塞队列BlockingDeque实现生产者-消费者模式"
date: 2012-11-22 16:53:00+08:00
draft: false
tags: ["并发编程"]
categories: ["并发编程"]
author: "北斗"
---
消费者

```java
import java.util.concurrent.BlockingDeque;
import java.util.concurrent.LinkedBlockingDeque;

/**
 * 消费者类
 * */
public class Consumer implements Runnable {
	private BlockingDeque<String> queue = new LinkedBlockingDeque<String>();

	public Consumer(BlockingDeque<String> queue){
		this.queue = queue;
	}
	@Override
	public void run() {
		// TODO Auto-generated method stub
		int i = 0;
			do{
				try {
					String product = queue.take();
					if(!"".equals(product) && null != product){
						System.out.println("消费者-:"+product);
						i++;
					}
				} catch (InterruptedException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

			}while(i < 50);
		}
}
```
生产者
```java
import java.util.concurrent.BlockingDeque;
import java.util.concurrent.LinkedBlockingDeque;
/**
 * 生产者类
 * */

public class Producer implements Runnable {
	private BlockingDeque<String> queue = new LinkedBlockingDeque<String>();

	public Producer(BlockingDeque<String> queue){
		this.queue = queue;
	}
	@Override
	public void run() {
		// TODO Auto-generated method stub
		for(int i=0; i < 50; i++){
			try {
				System.out.println("生产者-Product"+i);
				queue.put("Prodect:"+i);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}
```
测试类
```
javaimport java.util.concurrent.BlockingDeque;
       import java.util.concurrent.LinkedBlockingDeque;

       /**
        * 测试类
        * */
       public class BlockingQueueTest {

       	private static BlockingDeque<String> queue = new LinkedBlockingDeque<String>();

       	public static void main(String[] args) {
       		// TODO Auto-generated method stub
       		Producer producer = new Producer(queue);
       		Consumer cusumer = new Consumer(queue);
       		new Thread(cusumer).start();
       		new Thread(producer).start();
       	}
       }
```