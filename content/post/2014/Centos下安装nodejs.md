---
title: "Centos下安装nodejs"
date: 2014-11-12T16:24:27+08:00
draft: false
tags: ["Nodejs"]
categories: ["Nodejs"]
author: "北斗"
---

```
# wget http://nodejs.org/dist/v0.10.33/node-v0.10.33.tar.gz
# tar xvfnode-v0.10.33.tar.gz
# cd node-v0.10.33
# ./configure
# make
# make install
# cp /usr/local/bin/node /usr/sbin/
```
检查是否安装成功
```
node -v
```


