---
title: "nginx 安装SSL证书"
date: 2016-10-13T18:32:00+08:00
draft: false
tags: ["服务器","Nginx"]
categories: ["服务器"]
author: "北斗"
---
1.证书准备

下载CA证书，在此我下载下来的文件是IntermediateCA.cer和ssl_certificate.cer

2.Key证书转换

openssl pkcs12 -in domain_name_privatekey.p12 -out domain_name.key -nocerts -nodes

3.生成CRT证书

 cat ssl_certificate.cer IntermediateCA.cer >>  domain_name.crt

4.nginx配置
```
server {
    listen       80;
    server_name  www.domain.com;
    rewrite ^(.*)$  https://$host$1 permanent;
}
server {
    listen 443;
    server_name www.domain.com;
    ssl on;
    ssl_certificate /path/domain_name.crt;
    ssl_certificate_key /path/domain_name.key;
    access_log /var/log/nginx/nginx.vhost.access.log;
    error_log /var/log/nginx/nginx.vhost.error.log;
    location / {
        root /data/web/www;
        index index.html;
    }
}
```
5.如果有后台API，需要视情况升级修改。