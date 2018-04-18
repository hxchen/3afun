---
title: "斐波那契数列----有一段楼梯有n级台阶,规定每一步只能跨一级或两级,要登上第n级台阶有几种不同的走法?"
date: 2013-03-26 16:42:00+08:00
draft: false
tags: ["Java"]
categories: ["java"]
author: "北斗"
---
问题：有一段楼梯有n级台阶,规定每一步只能跨一级或两级,要登上第n级台阶有几种不同的走法?

求解：
```java
/**
 * 有一段楼梯有n级台阶,规定每一步只能跨一级或两级,要登上第n级台阶有几种不同的走法?
 * n=1 m=1
 * n=2 m=2
 * n=3 m=3
 * n=4 m=5
 * n=5 m=8
 * n=6 m=13
 * n=7 m=21
 * ......
 * */
public class Fibonacci {
	/**
	 * @param n
	 * @return m 返回M种走法
	 * */
	public static int Sigma (int n ){
		if (n == 1) {
			return 1;
		}else if(n == 2){
			return 2;
		}else {
			return Sigma(n-1) + Sigma(n-2);
		}
	}
}
```