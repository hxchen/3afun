---
title: "java打印N阶回旋矩阵"
date: 2013-06-18 20:40:00+08:00
draft: false
tags: ["Java"]
categories: ["Java"]
author: "北斗"
---
算法分析：

1.将此矩阵分解为一个一个的圈，如下图，1-20可以看成一个圈，21-32是一个圈，33-36也是一个圈。

![java](/media/images/2013/java1.jpg)

2.再将圈分解为四个均等的数列

![java](/media/images/2013/java2.jpg)

3.打印的过程中用一个二维数组存储矩阵，记录圈数 ，当前圈的数列长度 和圈开始计数的数字 。

![java](/media/images/2013/java3.jpg)


```java
public class Matrix {
    public void printMatrix(int n){
        int array [][]  = new int[n][n];
        int circleCount ;   //圈数

        int currentCircleLength = n-1;  //当前圈的数列长度

        int startNumber = 1;    // 圈开始计数的数字

        circleCount = n/2 + n%2;
        currentCircleLength = n-1;
        startNumber = 1;

        for(int i = 0; i < circleCount; i++){
            currentCircleLength = n - 1 - 2*i;

            for(int j = 0; j < currentCircleLength; j++){//→
                array[i][i+j] = startNumber++;
            }

            for(int j = 0; j < currentCircleLength; j++){//↓
                array[i+j][n-1-i] = startNumber++;
            }

            for(int j = 0; j < currentCircleLength; j++){//←
                array[n-1-i][n-1-i-j] = startNumber++;
            }

            for(int j = 0; j < currentCircleLength; j++){//↑
                array[n-1-i-j][i] = startNumber++;
            }

        }
        if(n%2 == 1){//奇数补齐中间最后一个数
            array[n/2][n/2] = n*n;
        }
        for(int i = 0; i < n; i++){
            for(int j = 0; j < n; j++){
                System.out.print(array[i][j]+"      ");
            }
            System.out.println("");
        }
    }
    /**
     * @param args
     */
    public static void main(String[] args) {
        // TODO Auto-generated method stub
        Matrix matrix = new Matrix();
        matrix.printMatrix(5);
    }

}
```