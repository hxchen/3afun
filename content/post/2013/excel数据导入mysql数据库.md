---
title: "excel数据导入mysql数据库"
date: 2013-11-28 19:54:00+08:00
draft: false
tags: ["数据库","MySQL"]
categories: ["数据库","MySQL"]
author: "北斗"
---
1.excel另存为txt。

选中将要导出的数据列，然后另存为选择其它格式=>文本文件（制表符分割）。

存为：

E:\项目\fblike\game_code_san.txt

2.txt导入到mysql数据库。



```
load data infile 'E:\\项目\\fblike\\game_code_san.txt' into table  game_code_san(code)
```



3.远程导数据

登陆使用：

```
mysql -uroot -p -h hostname --local-infile=1;
```
导入使用：

```
load data local infile '/data/example.txt' into table  example(code);
```
