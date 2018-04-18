---
title: "Wordpress更改Permalink后出现404的解决办法"
date: 2014-03-19 15:18:27+08:00
draft: false
tags: ["Wordpress"]
categories: ["开源软件"]
author: "北斗"
---
1、Apache作为服务器的话

修改httpd.conf

打开

```
LoadModule rewrite_module modules/mod_rewrite.so
```
 查找并替换
```
AllowOverride none -> AllowOverride All
```
 2、nginx作为服务器的话，添加三条if语句。

```
location ~ \.php$ {
        #    root           html;
            fastcgi_pass   127.0.0.1:9000;
            fastcgi_index  index.php;
            fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            include        fastcgi_params;
        }
        if (-f $request_filename/index.html){
            rewrite (.*) $1/index.html break;
        }
        if (-f $request_filename/index.php){
            rewrite (.*) $1/index.php;
        }
        if (!-f $request_filename){
            rewrite (.*) /index.php;
        }
```