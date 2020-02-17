---
title: "Lets Encrypt免费通配符SSL 证书申请配置教程"
date: 2018-09-10T18:12:26+08:00
draft: false
lastmod: 2018-09-10T18:12:26+08:00
tags: ["SSL"]
categories: ["SSL"]
keywords: ["SSL","HTTPS"]
description: "Lets Encrypt SSL HTTPS"
author: "北斗"
---
## 一、Lets Encrypt介绍

Lets Encrypt 是一个免费、自动化、开放的证书颁发机构(CA),为了公众利益而服务。它由Internet Security Research Group (ISRG) 来提供服务。

## 二、通配符证书介绍

通配符证书,是我们申请一个域名证书,可以支持子域名的证书。比如申请一个```abc.com```,那么子域名```bbs.abc.com```和```blog.abc.com```都可以使用。

## 三、申请通配符证书
Let’s Encrypt 上的证书申请是通过 ACME 协议来完成的。ACME 协议规范化了证书申请、更新、撤销等流程，实现了 Let’s Encrypt CA 自动化操作。解决了传统的 CA 机构是人工手动处理证书申请、证书更新、证书撤销的效率和成本问题。

ACME v2 是 ACME 协议的更新版本，通配符证书只能通过 ACME v2 获得。要使用 ACME v2 协议申请通配符证书，只需一个支持该协议的客户端就可以了，官方推荐的客户端是 Certbot。

## 四、安装Certbot 客户端

```bash
# 下载
wget https://dl.eff.org/certbot-auto
# 添加可执行权限
chmod a+x certbot-auto
```

## 五、申请通配符证书

使用 Certbot 客户端申请证书方法非常的简单，只需如下一行命令就搞定了。

```bash
./certbot-auto certonly  -d "*.3afun.com" --manual --preferred-challenges dns-01  --server https://acme-v02.api.letsencrypt.org/directory
```

3afun.com为申请证书的域名

```
Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator manual, Installer None
Obtaining a new certificate
Performing the following challenges:
dns-01 challenge for 3afun.com

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
NOTE: The IP of this machine will be publicly logged as having requested this
certificate. If you're running certbot in manual mode on a machine that is not
your server, please ensure you're okay with that.

Are you OK with your IP being logged?
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
(Y)es/(N)o:
```

输入Y

```
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name
_acme-challenge.3afun.com with the following value:

nEPEFRYbYHUCS_BFqpB6kZslvuhGor5EfUvSWHIvEE4

Before continuing, verify the record is deployed.
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue


```

在域名的供应商那里添加一条TXT记录。

键:_acme-challenge.3afun.com

值: nEPEFRYbYHUCS_BFqpB6kZslvuhGor5EfUvSWHIvEE4

**再回车之前我们需要新开一个窗口通过命令来检查TXT记录设置已生效。**
```
# dig -t txt _acme-challenge.3afun.com @8.8.8.8
; <<>> DiG 9.8.2rc1-RedHat-9.8.2-0.37.rc1.49.amzn1 <<>> -t txt _acme-challenge.3afun.com @8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 64795
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;_acme-challenge.3afun.com.        IN      TXT

;; ANSWER SECTION:
_acme-challenge.3afun.com. 299 IN  TXT     "nEPEFRYbYHUCS_BFqpB6kZslvuhGor5EfUvSWHIvEE4"

;; Query time: 118 msec
;; SERVER: 8.8.8.8#53(8.8.8.8)
;; WHEN: Wed Sep 12 08:51:13 2018
;; MSG SIZE  rcvd: 104
```


然后现在可以回到原来窗口按下回车键


```
Waiting for verification...
Cleaning up challenges

IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/3afun.com/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/3afun.com/privkey.pem
   Your cert will expire on 2018-12-11. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot-auto
   again. To non-interactively renew *all* of your certificates, run
   "certbot-auto renew"
 - If you like Certbot, please consider supporting our work by:

   Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
   Donating to EFF:                    https://eff.org/donate-le

```

通配符证书会在```/etc/letsencrypt/live/3afun.com``` 目录下给我们生成。

## 六、Nginx 配置使用证书

Nginx里设置证书和Key文件即可,简约代码如下:

```
ssl_certificate /etc/letsencrypt/live/3afun.com/fullchain.pem; # managed by Certbot
ssl_certificate_key /etc/letsencrypt/live/3afun.com/privkey.pem; # managed by Certbot
```


## 七、证书续期

Let’s encrypt 的免费证书默认有效期为 90 天，到期后如果要续期可以执行：

```
# certbot-auto renew
```

我们可以使用 crontab 来定时续期。

1.编辑crontab文件
```
crontab -e
```
2.添加
```
# 每隔90天执行一次 certbot-auto renew
0 0 */90 * * certbot-auto renew
```

3.保存退出。

```
!wq
```

4.重启crond：

```
service crond restart
```
