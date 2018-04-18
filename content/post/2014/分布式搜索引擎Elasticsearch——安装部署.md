---
title: "分布式搜索引擎Elasticsearch——安装部署"
date: 2014-10-16T18:12:27+08:00
draft: false
tags: ["大数据"]
categories: ["大数据"]
author: "北斗"
---
# 一、系统环境
Centos 6.4

Java 1.7.0_71

# 二、下载安装
```
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.3.4.tar.gz
tar -zxvf elasticsearch-1.3.4.tar.gz
```
# 三、运行
```
./elasticsearch-1.3.4/bin/elasticsearch
```
# 四、查看
在浏览器打开：http://localhost:9200/，即可查看运行状态。

