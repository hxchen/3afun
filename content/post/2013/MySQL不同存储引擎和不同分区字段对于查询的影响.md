---
title: "MySQL不同存储引擎和不同分区字段对于查询的影响"
date: 2013-01-31 15:46:00+08:00
draft: false
tags: ["MySQL"]
categories: ["MySQL"]
author: "北斗"
---

前提：每种表类型准备了200万条相同的数据。

表一 InnoDB & PARTITION BY RANGE (id)

```
CREATE TABLE `customer_innodb_id` (
  `id` int(11) NOT NULL,
  `email` varchar(64) NOT NULL,
  `name` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `phone` varchar(13) DEFAULT NULL,
  `birth` date DEFAULT NULL,
  `sex` int(1) DEFAULT NULL,
  `avatar` blob,
  `address` varchar(64) DEFAULT NULL,
  `regtime` datetime DEFAULT NULL,
  `lastip` varchar(15) DEFAULT NULL,
  `modifytime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
/*!50100 PARTITION BY RANGE (id)
(PARTITION p0 VALUES LESS THAN (100000) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN (500000) ENGINE = InnoDB,
 PARTITION p2 VALUES LESS THAN (1000000) ENGINE = InnoDB,
 PARTITION p3 VALUES LESS THAN (1500000) ENGINE = InnoDB,
 PARTITION p4 VALUES LESS THAN (2000000) ENGINE = InnoDB,
 PARTITION p5 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
```

查询结果：

```
mysql> select count(*) from customer_innodb_id where id > 50000 and id < 500000;

+----------+
| count(*) |
+----------+
|   449999 |
+----------+
1 row in set (1.19 sec)

mysql> select count(*) from customer_innodb_id where id > 50000 and id < 500000;

+----------+
| count(*) |
+----------+
|   449999 |
+----------+
1 row in set (0.28 sec)

mysql> select count(*) from customer_innodb_id where regtime > '1995-01-01 00:00
:00' and regtime < '1996-01-01 00:00:00';
+----------+
| count(*) |
+----------+
|   199349 |
+----------+
1 row in set (4.74 sec)

mysql> select count(*) from customer_innodb_id where regtime > '1995-01-01 00:00
:00' and regtime < '1996-01-01 00:00:00';
+----------+
| count(*) |
+----------+
|   199349 |
+----------+
1 row in set (5.28 sec)

```
表二 InnoDB & PARTITION BY RANGE (year)

```
CREATE TABLE `customer_innodb_year` (
  `id` int(11) NOT NULL,
  `email` varchar(64) NOT NULL,
  `name` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `phone` varchar(13) DEFAULT NULL,
  `birth` date DEFAULT NULL,
  `sex` int(1) DEFAULT NULL,
  `avatar` blob,
  `address` varchar(64) DEFAULT NULL,
  `regtime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastip` varchar(15) DEFAULT NULL,
  `modifytime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`regtime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
/*!50100 PARTITION BY RANGE (YEAR(regtime ))
(PARTITION p0 VALUES LESS THAN (1996) ENGINE = InnoDB,
 PARTITION p1 VALUES LESS THAN (1997) ENGINE = InnoDB,
 PARTITION p2 VALUES LESS THAN (1998) ENGINE = InnoDB,
 PARTITION p3 VALUES LESS THAN (1999) ENGINE = InnoDB,
 PARTITION p4 VALUES LESS THAN (2000) ENGINE = InnoDB,
 PARTITION p5 VALUES LESS THAN (2001) ENGINE = InnoDB,
 PARTITION p6 VALUES LESS THAN (2002) ENGINE = InnoDB,
 PARTITION p7 VALUES LESS THAN (2003) ENGINE = InnoDB,
 PARTITION p8 VALUES LESS THAN (2004) ENGINE = InnoDB,
 PARTITION p9 VALUES LESS THAN (2005) ENGINE = InnoDB,
 PARTITION p10 VALUES LESS THAN (2006) ENGINE = InnoDB,
 PARTITION p11 VALUES LESS THAN (2007) ENGINE = InnoDB,
 PARTITION p12 VALUES LESS THAN (2008) ENGINE = InnoDB,
 PARTITION p13 VALUES LESS THAN (2009) ENGINE = InnoDB,
 PARTITION p14 VALUES LESS THAN (2010) ENGINE = InnoDB,
 PARTITION p15 VALUES LESS THAN (2011) ENGINE = InnoDB,
 PARTITION p16 VALUES LESS THAN (2012) ENGINE = InnoDB,
 PARTITION p17 VALUES LESS THAN (2013) ENGINE = InnoDB,
 PARTITION p18 VALUES LESS THAN (2014) ENGINE = InnoDB,
 PARTITION p19 VALUES LESS THAN MAXVALUE ENGINE = InnoDB) */;
```

查询结果：

```
mysql> select count(*) from customer_innodb_year where id > 50000 and id < 50000
0;
+----------+
| count(*) |
+----------+
|   449999 |
+----------+
1 row in set (5.31 sec)

mysql> select count(*) from customer_innodb_year where id > 50000 and id < 50000
0;
+----------+
| count(*) |
+----------+
|   449999 |
+----------+
1 row in set (0.31 sec)

mysql> select count(*) from customer_innodb_year where regtime > '1995-01-01 00:
00:00' and regtime < '1996-01-01 00:00:00';
+----------+
| count(*) |
+----------+
|   199349 |
+----------+
1 row in set (0.47 sec)

mysql> select count(*) from customer_innodb_year where regtime > '1995-01-01 00:
00:00' and regtime < '1996-01-01 00:00:00';
+----------+
| count(*) |
+----------+
|   199349 |
+----------+
1 row in set (0.19 sec)
```

表三 MyISAM & PARTITION BY RANGE (id)

```
CREATE TABLE `customer_myisam_id` (
  `id` int(11) NOT NULL,
  `email` varchar(64) NOT NULL,
  `name` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `phone` varchar(13) DEFAULT NULL,
  `birth` date DEFAULT NULL,
  `sex` int(1) DEFAULT NULL,
  `avatar` blob,
  `address` varchar(64) DEFAULT NULL,
  `regtime` datetime DEFAULT NULL,
  `lastip` varchar(15) DEFAULT NULL,
  `modifytime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8
/*!50100 PARTITION BY RANGE (id)
(PARTITION p0 VALUES LESS THAN (100000) ENGINE = MyISAM,
 PARTITION p1 VALUES LESS THAN (500000) ENGINE = MyISAM,
 PARTITION p2 VALUES LESS THAN (1000000) ENGINE = MyISAM,
 PARTITION p3 VALUES LESS THAN (1500000) ENGINE = MyISAM,
 PARTITION p4 VALUES LESS THAN (2000000) ENGINE = MyISAM,
 PARTITION p5 VALUES LESS THAN MAXVALUE ENGINE = MyISAM) */;

```
查询结果：

```
mysql> select count(*) from customer_myisam_id where id > 50000 and id < 500000;

+----------+
| count(*) |
+----------+
|   449999 |
+----------+
1 row in set (0.59 sec)

mysql> select count(*) from customer_myisam_id where id > 50000 and id < 500000;

+----------+
| count(*) |
+----------+
|   449999 |
+----------+
1 row in set (0.16 sec)

mysql> select count(*) from customer_myisam_id where regtime > '1995-01-01 00:00
:00' and regtime < '1996-01-01 00:00:00';
+----------+
| count(*) |
+----------+
|   199349 |
+----------+
1 row in set (34.17 sec)

mysql> select count(*) from customer_myisam_id where regtime > '1995-01-01 00:00
:00' and regtime < '1996-01-01 00:00:00';
+----------+
| count(*) |
+----------+
|   199349 |
+----------+
1 row in set (34.06 sec)
```

表四 MyISAM & PARTITION BY RANGE (year)

```
CREATE TABLE `customer_myisam_year` (
  `id` int(11) NOT NULL,
  `email` varchar(64) NOT NULL,
  `name` varchar(32) NOT NULL,
  `password` varchar(32) NOT NULL,
  `phone` varchar(13) DEFAULT NULL,
  `birth` date DEFAULT NULL,
  `sex` int(1) DEFAULT NULL,
  `avatar` blob,
  `address` varchar(64) DEFAULT NULL,
  `regtime` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `lastip` varchar(15) DEFAULT NULL,
  `modifytime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`,`regtime`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8
/*!50100 PARTITION BY RANGE (YEAR(regtime ))
(PARTITION p0 VALUES LESS THAN (1996) ENGINE = MyISAM,
 PARTITION p1 VALUES LESS THAN (1997) ENGINE = MyISAM,
 PARTITION p2 VALUES LESS THAN (1998) ENGINE = MyISAM,
 PARTITION p3 VALUES LESS THAN (1999) ENGINE = MyISAM,
 PARTITION p4 VALUES LESS THAN (2000) ENGINE = MyISAM,
 PARTITION p5 VALUES LESS THAN (2001) ENGINE = MyISAM,
 PARTITION p6 VALUES LESS THAN (2002) ENGINE = MyISAM,
 PARTITION p7 VALUES LESS THAN (2003) ENGINE = MyISAM,
 PARTITION p8 VALUES LESS THAN (2004) ENGINE = MyISAM,
 PARTITION p9 VALUES LESS THAN (2005) ENGINE = MyISAM,
 PARTITION p10 VALUES LESS THAN (2006) ENGINE = MyISAM,
 PARTITION p11 VALUES LESS THAN (2007) ENGINE = MyISAM,
 PARTITION p12 VALUES LESS THAN (2008) ENGINE = MyISAM,
 PARTITION p13 VALUES LESS THAN (2009) ENGINE = MyISAM,
 PARTITION p14 VALUES LESS THAN (2010) ENGINE = MyISAM,
 PARTITION p15 VALUES LESS THAN (2011) ENGINE = MyISAM,
 PARTITION p16 VALUES LESS THAN (2012) ENGINE = MyISAM,
 PARTITION p17 VALUES LESS THAN (2013) ENGINE = MyISAM,
 PARTITION p18 VALUES LESS THAN (2014) ENGINE = MyISAM,
 PARTITION p19 VALUES LESS THAN MAXVALUE ENGINE = MyISAM) */;
```

查询结果：

```
mysql> select count(*) from customer_myisam_year where id > 50000 and id < 50000
0;
+----------+
| count(*) |
+----------+
|   449999 |
+----------+
1 row in set (2.08 sec)

mysql> select count(*) from customer_myisam_year where id > 50000 and id < 50000
0;
+----------+
| count(*) |
+----------+
|   449999 |
+----------+
1 row in set (0.17 sec)

mysql> select count(*) from customer_myisam_year where regtime > '1995-01-01 00:
00:00' and regtime < '1996-01-01 00:00:00';
+----------+
| count(*) |
+----------+
|   199349 |
+----------+
1 row in set (0.56 sec)

mysql> select count(*) from customer_myisam_year where regtime > '1995-01-01 00:
00:00' and regtime < '1996-01-01 00:00:00';
+----------+
| count(*) |
+----------+
|   199349 |
+----------+
1 row in set (0.13 sec)
```

结果汇总

序号	|存储引擎	    |分区函数    |查询条件    |一次查询(sec)|  二次查询(sec)|
----|-----------|-----------|-----------|------------|--------------|
1	|InnoDB	    |id	        |id	        |1.19	     |0.28           |
2	|InnoDB	    |id	        |regtime	|4.74	     |5.28           |
3	|InnoDB	    |year	    |id         |5.31   	 |0.31           |
4	|InnoDB	    |year	    |regtime	|0.47	     |0.19           |
5	|MyISAM	    |id	        |id	        |0.59   	 |0.16           |
6	|MyISAM	    |id	        |regtime	|34.17	     |34.06          |
7	|MyISAM	    |year	    |id	        |2.08   	 |0.17           |
8	|MyISAM	    |year	    |regtime	|0.56	     |0.13           |

总结

1、对于按照时间区间来查询的，建议采用按照时间来分区，减少查询范围。

2、MyISAM性能总体占优，但是不支持事务处理、外键约束等。