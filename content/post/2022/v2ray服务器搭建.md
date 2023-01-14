---
title: "V2ray服务器搭建"
date: 2022-08-21T15:50:28+08:00
draft: false
lastmod: 2022-08-21T15:50:28+08:00
tags: []
categories: []
keywords: []
description: ""
author: "北斗"
---

### 闲言碎语
最近的某天，众所周知的原因，vpn上不去了，于是只能换ip重新部署一套。经过实践过，目前还是v2ray最好用安心一些（耐久），所以继续部署v2ray,以下内容为记录一下本次部署记录，供下次使用。

### V2ray服务器安装

1. 更新和安装crul
```shell
sudo apt update
sudo apt install crul
```
2. 下载安装脚本
```shell
curl -O https://raw.githubusercontent.com/v2fly/fhs-install-v2ray/master/install-release.sh
```
3. 执行安装脚本
```shell
sudo bash install-release.sh
```
一些比较有用的输出

```shell
~~~~~~~~~~~~~~~~
[Unit]
Description=V2Ray Service
Documentation=https://www.v2fly.org/
After=network.target nss-lookup.target

[Service]
User=nobody
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
# In case you have a good reason to do so, duplicate this file in the same directory and make your customizes there.
# Or all changes you made will be lost!  # Refer: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
[Service]
ExecStart=
ExecStart=/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
~~~~~~~~~~~~~~~~
warning: The systemd version on the current operating system is too low.
warning: Please consider to upgrade the systemd or the operating system.

installed: /usr/local/bin/v2ray
installed: /usr/local/bin/v2ctl
installed: /usr/local/share/v2ray/geoip.dat
installed: /usr/local/share/v2ray/geosite.dat
installed: /usr/local/etc/v2ray/config.json
installed: /var/log/v2ray/
installed: /var/log/v2ray/access.log
installed: /var/log/v2ray/error.log
installed: /etc/systemd/system/v2ray.service
installed: /etc/systemd/system/v2ray@.service
removed: /tmp/tmp.uUrf9loVR4
info: V2Ray v4.45.2 is installed.
You may need to execute a command to remove dependent software: apt purge curl unzip
Please execute the command: systemctl enable v2ray; systemctl start v2ray
```

从上面可以看到，配置文件位置。

4. 生成uuid
```shell
v2ctl uuid
```
5. 编辑配置文件
```shell
sudo vim /usr/local/etc/v2ray/config.json
```

输入内容并保存
```shell
{
  "inbounds": [{
    "port": 设置端口,
    "protocol": "vmess",
    "settings": {
      "clients": [
        {
          "id": "替换步骤4的uuid",
          "level": 1,
          "alterId": 64
        }
      ]
    }
  }],
  "outbounds": [{
    "protocol": "freedom",
    "settings": {}
  },{
    "protocol": "blackhole",
    "settings": {},
    "tag": "blocked"
  }],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": ["geoip:private"],
        "outboundTag": "blocked"
      }
    ]
  }
}
```
5. 如果需要设置开机自启动
```shell
sudo systemctl enable v2ray
```
6. 启动
```
sudo systemctl start|stop|restart v2ray
```
7. 通过端口查看是否成功开启
```shell
netstat -anp |grep 端口号
```
### Nginx安装（可选）

1. 安装
```shell
sudo apt install nginx
```
2. 增加nginx 域名监听转发
```
sudo vim /etc/nginx/nginx.conf/fw.conf
```
内容如下：
```shell
server {
    listen       80;
    server_name  hostname;
    location / {
        proxy_pass http://ip:port/;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```
3. 重启nginx服务
```shell
sudo nginx -s reload
```
