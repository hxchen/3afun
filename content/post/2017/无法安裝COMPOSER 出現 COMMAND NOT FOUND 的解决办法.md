---
title: "无法安裝COMPOSER 出現 COMMAND NOT FOUND 的解决办法"
date: 2017-08-10T11:32:00+08:00
draft: false
tags: ["PHP"]
categories: ["PHP"]
author: "北斗"
---

想要全局安装composer，按照网上的方法下载安装：


```
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
```

然后检查结果
```
composer -V
```



会出现，bash: composer: command not found Installation on Unixes (Ubuntu, Debian, CentOS, 等操作系统上)

如果遇到了这个问题，那么可以将composer原先放在 */usr/local/bin/* 的路径，

换成成以下目录 */usr/bin/* 。

解决办法的LINUX指令：
```
# sudo mv /usr/local/bin/composer /usr/bin/composer
```
接着继续测试
```
#composer -V
```
就会正确显示版本了~