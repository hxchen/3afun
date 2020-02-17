---
title: "Andrew Ng机器学习ex1(Linear Regression)编程作业详解"
date: 2019-12-02T17:24:46+08:00
draft: false
lastmod: 2019-12-02T17:24:46+08:00
tags: ["机器学习"]
categories: ["机器学习"]
keywords: ["机器学习","Machine Learning","Andrew Ng","吴恩达","作业"]
description: "Andrew Ng机器学习编程作业"
author: "北斗"
mathjax: true
---
要想顺利的完成作业，必须参考编程作业指导文件[ex1.pdf](https://github.com/hxchen/MachineLearning/blob/master/exercise_1/ex1.pdf)
第一次作业主要包括两部分：必做题和选做题。其中必做题包括一道热身练习和完成单变量的线性回归问题，选做题是完成多变量的线性回归问题。

运行作业只要在具有Octave环境时候，进入到文件目录，执行`ex1`或者`ex1_multi`即可。

## 1.热身练习
热身练习主要是在`warmUpExercise.m`文件中生成一个5X5的单位矩阵。
代码如下：
```octave
A = eye(5);
```

## 2.单变量线性回归问题
完成该道题，我们主要是利用样本数据`ex1data1.txt`（第一列为城市人口，第二列为对应该城市餐车收益），完成`plotData.m`、`computeCost.m文件`和`gradientDescent.m`文件，然后进行给出人口数量，对餐车收益进行预测。`ex1.m`文件为入口函数文件，不需要修改。

### 2.1 绘制数据 plotData.m
具体`plotData.m`中补充如下代码
```octave
plot(x,y,'rx','MarkerSize', 10);
xlabel('Profit in $10,000s');
ylabel('Population of City in 10,000s');
```
### 2.2 代价函数 computeCost.m 
该文件主要是实现代价函数
$$J(θ)=  {1 \over 2m} \sum_{i=1}^m(h_θ(x^{(i)}) − y^{(i)})^2$$
具体`computeCost.m`中补充如下代码
```octave
J = 1/(2*m)*sum((X*theta - y).^2);
```
### 2.3 梯度下降 gradientDescent.m
该文件主要是实现梯度下降函数
$$θj := θj − α{1 \over m}\sum_{i=1}^m(h_θ(x^{(i)}) − y^{(i)})x_j^{(i)} (对于所有的j同时更新 θ_j )$$ 
具体`gradientDescent.m`中补充如下代码
```octave
theta_t = theta;
theta(1) = theta(1) - alpha * (1/m) * (sum(X*theta_t-y));
theta(2) = theta(2) - alpha * (1/m) * (sum((X*theta_t-y).*X(:,2)));
```

## 3.多变量线性回归问题
完成该道题，主要是利用样本数据`ex1data2.txt`（房屋面积、房间数，售价）,完成`gradientDescentMulti.m`、`computeCostMulti.m`、`featureNormalize.m`、`normalEqn.m`。最终实现给出房屋面积1650，房间数3的时候对房价进行预测。

### 3.1 特征归一化 featureNormalize.m
要求我们完成`featureNormalize.m`，主要对特征进行缩放，依据公式：
$$x_i = {x_i - u_1 \over s_1} （u_1 为均值 s_1为标准差）$$
具体`featureNormalize.m`中补充如下代码
```octave
len = length(X);
mu = mean(X);
sigma = std(X);
X_norm = (X - ones(len, 1) * mu) ./ (ones(len, 1) * sigma);
```

### 3.2 梯度下降 gradientDescentMulti.m
同单变量一样的思想，我们在`gradientDescentMulti.m`中补充如下代码
```octave
theta_t = theta;
for i = 1:length(theta)
    theta(i,1) = theta_t(i,1) - alpha * (1/m) * (sum((X*theta_t-y).*X(:,i)));
end
```
### 3.2.1 可选练习
`ex1_multi.m`中默认定义了
```octave
alpha = 0.01；
num_iters = 400;
```
我们可以更改学习率和迭代次数，通过观察绘图来获得最佳的学习率。
### 3.2.2 价格预测 
在求预测价格时候，不要忘记同样需要对样本数据进行归一化处理：
```octave
price = [1 (1650-mu(1))/sigma(1) (3-mu(2))/sigma(2)] * theta;
```
我们可以优化alpha，观察梯度下降快满。

### 3.3 正规方程Normal Equations
在多变量线性规划问题中，我们求`θ`还可以直接应用正规方程求解。
其中：
$$θ = (X^TX)^{-1} X^Ty$$
所以我们可以在`normalEqn.m`中直接添加如下代码：
```octave
theta = pinv(X' * X) * X' * y;
```







