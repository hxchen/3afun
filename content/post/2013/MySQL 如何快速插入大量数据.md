---
title: "MySQL 如何快速插入大量数据"
date: 2013-01-31 13:45:00+08:00
draft: false
tags: ["MySQL"]
categories: ["MySQL"]
author: "北斗"
---

这几天尝试了使用不同的存储引擎大量插入MySQL表数据，主要试验了MyISAM存储引擎和InnoDB。下面是实验过程：

一、InnoDB存储引擎。

创建数据库和表

```
CREATE DATABASE ecommerce;
CREATE TABLE employees (
    id INT NOT NULL,
    fname VARCHAR(30),
    lname VARCHAR(30),
    birth TIMESTAMP,
    hired DATE NOT NULL DEFAULT '1970-01-01',
    separated DATE NOT NULL DEFAULT '9999-12-31',
    job_code INT NOT NULL,
    store_id INT NOT NULL
)

partition BY RANGE (store_id) (
    partition p0 VALUES LESS THAN (10000),
    partition p1 VALUES LESS THAN (50000),
    partition p2 VALUES LESS THAN (100000),
    partition p3 VALUES LESS THAN (150000),
    Partition p4 VALUES LESS THAN MAXVALUE
);
```

创建存储过程

```
use ecommerce;
CREATE PROCEDURE BatchInsert(IN init INT, IN loop_time INT)
BEGIN
    DECLARE Var INT;
    DECLARE ID INT;
    SET Var = 0;
    SET ID = init;
        WHILE Var < loop_time DO
        insert into employees(id,fname,lname,birth,hired,separated,job_code,store_id) values(ID,CONCAT('chen',ID),CONCAT('haixiang',ID),Now(),Now(),Now(),1,ID);
        SET ID = ID + 1;
        SET Var = Var + 1;
        END WHILE;
END;
```

调用存储过程插入数据

```
CALL BatchInsert（30036,200000）
```
用时：3h 37min 8sec

二、MyISAM存储引擎

创建表

```
use ecommerce;
CREATE TABLE ecommerce.customer (
   id INT NOT NULL,
   email VARCHAR(64) NOT NULL,
   name VARCHAR(32) NOT NULL,
   password VARCHAR(32) NOT NULL,
   phone VARCHAR(13),
   birth DATE,
   sex INT(1),
   avatar BLOB,
   address VARCHAR(64),
   regtime DATETIME,
   lastip VARCHAR(15),
   modifytime TIMESTAMP NOT NULL,
  PRIMARY KEY (id)
)ENGINE = MyISAM ROW_FORMAT = DEFAULT
partition BY RANGE (id) (
    partition p0 VALUES LESS THAN (100000),
    partition p1 VALUES LESS THAN (500000),
    partition p2 VALUES LESS THAN (1000000),
    partition p3 VALUES LESS THAN (1500000),
    partition p4 VALUES LESS THAN (2000000),
    Partition p5 VALUES LESS THAN MAXVALUE
);
```

创建存储过程

```
use ecommerce;
DROP PROCEDURE IF EXISTS ecommerce.BatchInsertCustomer;
CREATE PROCEDURE BatchInsertCustomer(IN start INT,IN loop_time INT)
BEGIN
    DECLARE Var INT;
    DECLARE ID INT;
    SET Var = 0;
    SET ID= start;
        WHILE Var < loop_time
        DO
        insert into customer(ID,email,name,password,phone,birth,sex,avatar,address,regtime,lastip,modifytime)
        values(ID,CONCAT(ID,'@sina.com'),CONCAT('name_',rand(ID)*10000 mod 200),123456,13800000000,adddate('1995-01-01',(rand(ID)*36520) mod 3652),Var%2,'http://t3.baidu.com/it/u=2267714161,58787848&fm=52&gp=0.jpg','北京市海淀区',adddate('1995-01-01',(rand(ID)*36520) mod 3652),'8.8.8.8',adddate('1995-01-01',(rand(ID)*36520) mod 3652));
        SET Var = Var + 1;
        SET ID= ID + 1;
        END WHILE;
END;
```

调用存储过程插入数据

```
ALTER  TABLE  customer  DISABLE  KEYS;
CALL BatchInsertCustomer(1,2000000);
ALTER  TABLE  customer  ENABLE  KEYS;
```

用时：8min 50sec

通过以上对比发现对于插入大量数据时可以使用MyISAM存储引擎，如果再需要修改MySQL存储引擎可以使用命令：

```
ALTER TABLE t ENGINE = MYISAM;
```
