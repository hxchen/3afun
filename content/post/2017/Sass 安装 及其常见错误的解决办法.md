---
title: "Sass 安装 及其常见错误的解决办法"
date: 2017-09-27T10:51:00+08:00
draft: false
tags: ["Web前端", "Saas"]
categories: ["Web前端"]
author: "北斗"
---
Sass是一种css的开发工具，它的安装依赖Ruby，没有安装Ruby的请先安装Ruby。

假定你已经安装了Ruby，则可以直接执行如下语句进行安装。



```
gem install sass
```
常见错误提示：



1、ERROR:  While executing gem ... (OpenSSL::SSL::SSLError)

hostname "gems.ruby-china.org" does not match the server certificate

解决办法：

执行命令，查看数据源
```
gem source -l
```

结果
```
*** CURRENT SOURCES ***

https://ruby.taobao.org/
https://gems.ruby-china.org
```

则可以删除多余的
```
gem sources --remove https://ruby.taobao.org/
sudo gem update --system
```
然后重新安装。



2、ERROR:  SSL verification error at depth 1: unable to get local issuer certificate (20)

ERROR:  You must add /O=Digital Signature Trust Co./CN=DST Root CA X3 to your local trusted store

Fetching: ffi-1.9.18.gem ( 32%)ERROR:  SSL verification error at depth 2: self signed certificate in certificate chain (19)

ERROR:  Root certificate is not trusted (/C=US/O=GeoTrust Inc./CN=GeoTrust Global CA)

ERROR:  While executing gem ... (OpenSSL::SSL::SSLError)

hostname "gems.ruby-china.org" does not match the server certificate



3、ERROR:  SSL verification error at depth 1: unable to get local issuer certificate (20)

ERROR:  You must add /O=Digital Signature Trust Co./CN=DST Root CA X3 to your local trusted store

Fetching: ffi-1.9.18.gem (100%)

Building native extensions.  This could take a while...

Successfully installed ffi-1.9.18

ERROR:  SSL verification error at depth 2: self signed certificate in certificate chain (19)

ERROR:  Root certificate is not trusted (/C=US/O=GeoTrust Inc./CN=GeoTrust Global CA)

Fetching: rb-inotify-0.9.10.gem (100%)

Successfully installed rb-inotify-0.9.10

Fetching: sass-listen-4.0.0.gem (100%)

Successfully installed sass-listen-4.0.0

Fetching: sass-3.5.1.gem (100%)

ERROR:  While executing gem ... (Errno::EPERM)

Operation not permitted - /usr/bin/sass


遇到以上错误 2和3的解决办法
```
sudo gem install -n /usr/local/bin sass
```

查看
```
sass -v
```
则会正确显示Sass版本号。


***
2017年12月28日更新：

Mac更新系统后，Ruby由2.0升级到2.3，再次使用Sass时候，发现报错。

于是决定升级SaaS，重新安装时遇到错误。最后找到解决方案：

先安装libgmp-dev，再重新安装即可。

```
brew install libgmp-dev
sudo gem install -n /usr/local/bin sass
```