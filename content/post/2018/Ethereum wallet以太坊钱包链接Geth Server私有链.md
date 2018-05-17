---
title: "Ethereum wallet以太坊钱包链接Geth Server私有链"
date: 2018-04-12T18:31:44+08:00
draft: false
tags: ["Ethereum","区块链"]
categories: ["Ethereum","区块链"]
author: "北斗"
---

上一篇文章里,我们讲到 [Ubuntu16.04 搭建以太坊Ethereum私链](https://www.3afun.com/post/ubuntu16.04-%E6%90%AD%E5%BB%BA%E4%BB%A5%E5%A4%AA%E5%9D%8Aethereum%E7%A7%81%E9%93%BE/)
这次,我就要来介绍如何下载我们的钱包来链接我们的私有链。

# 以太坊钱包Wallet下载
钱包下载,大家可以去 [这里](https://github.com/ethereum/mist/releases)下载。现在最新版本是0.10.0

不管大家选择是 Ethereum Wallet 还是 Mist 都是可以的,这里我都下载了Mac版本的2个钱包。

安装的话没有难度,正常安装就行。

# Geth Server 私有链服务器端

因为我是远程链接私有链不是本地链接,所有我采用了RPC 链接方式。

Geth 启动方式

```
geth --identity "TestNode" --rpc --rpcaddr "0.0.0.0" --rpcport "8545" --datadir data0 --port "30303" --nodiscover console
```
此次我们加入了 `--rpcaddr`参数来允许远程连接,默认是拒绝远程链接的,只能本地链接。

# 客户端钱包Wallet启动
## Mac

### Ethereum Wallet 启动
```
"/Applications/Ethereum Wallet.app/Contents/MacOS/Ethereum Wallet" --rpc "http://YOUR_IP:8545"
```

### Mist 启动
```
/Applications/Mist.app/Contents/MacOS/Mist --rpc http://YOUR_IP:8545
```

## Windows
### Mist 启动
```
"D:\Program Files\Mist-win64-0-10-0\Mist.exe" --rpc http://YOUR_IP:8545
```
### Ethereum Wallet 启动
```
"D:\Program Files\Ethereum-Wallet-win64-0-10-0\Ethereum Wallet.exe" --rpc http://YOUR_IP:8545
```
请自行替换 `YOUR_IP`
