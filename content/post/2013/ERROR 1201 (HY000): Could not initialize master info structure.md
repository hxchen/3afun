---
title: "ERROR 1201 (HY000): Could not initialize master info structure"
date: 2013-01-25 11:00:00+08:00
draft: false
tags: ["MySQL"]
categories: ["MySQL"]
author: "北斗"
---

今天在做MySQL主从复制时遇到个ERROR 1201 (HY000): Could not initialize master info structure .

出现这个问题的原因是之前曾做过主从复制！！！

解决方案是：运行命令 stop slave;

成功执行后继续运行 reset slave;

然后进行运行GRANT命令重新设置主从复制。

具体过程如下：

```
mysql> change master to master_host='127.0.0.1', master_user='user', master_pass
word='user', master_log_file='mysql-bin-000202', master_log_pos=553;
ERROR 1201 (HY000): Could not initialize master info structure; more error messa
ges can be found in the MySQL error log
mysql> stop slave;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> reset slave;
Query OK, 0 rows affected (0.00 sec)

mysql> change master to master_host='127.0.0.1', master_user='user', master_pass
word='user', master_log_file='mysql-bin-000202', master_log_pos=553;
Query OK, 0 rows affected (0.11 sec)
```