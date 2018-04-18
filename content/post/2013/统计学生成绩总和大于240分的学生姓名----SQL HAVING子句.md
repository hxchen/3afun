---
title: "统计学生成绩总和大于240分的学生姓名----SQL HAVING子句"
date: 2013-01-11 18:33:00+08:00
draft: false
tags: ["MySQL"]
categories: ["MySQL"]
author: "北斗"
---

HAVING 子句

在 SQL 中增加 HAVING 子句原因是，WHERE 关键字无法与合计函数一起使用。

SQL HAVING 语法
```
SELECT column_name, aggregate_function(column_name)
FROM table_name
WHERE column_name operator value
GROUP BY column_name
HAVING aggregate_function(column_name) operator value
```
比如有学生表：
```
CREATE TABLE `student` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `course` varchar(20) DEFAULT NULL,
  `score` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=gb2312;
```
数据：
```
insert into `student`(`id`,`name`,`course`,`score`) values (1,'张三','语文',80);
insert into `student`(`id`,`name`,`course`,`score`) values (2,'张三','数学',90);
insert into `student`(`id`,`name`,`course`,`score`) values (3,'张三','英语',80);
insert into `student`(`id`,`name`,`course`,`score`) values (4,'李四','语文',85);
insert into `student`(`id`,`name`,`course`,`score`) values (5,'李四','数学',86);
insert into `student`(`id`,`name`,`course`,`score`) values (6,'李四','外语',60);
insert into `student`(`id`,`name`,`course`,`score`) values (7,'王五','语文',90);
insert into `student`(`id`,`name`,`course`,`score`) values (8,'王五','数学',88);
insert into `student`(`id`,`name`,`course`,`score`) values (9,'王五','英语',90);
```
题目:统计学生成绩大于240分的学生姓名

SQL：
```
select s.name from student as s  group by s.name having sum(s.score) > 240;
```