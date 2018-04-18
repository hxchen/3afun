---
title: "Ubuntu16.04 搭建以太坊Ethereum私链(2)"
date: 2018-04-13T16:18:49+08:00
draft: false
tags: ["Ethereum"]
categories: ["Ethereum"]
author: "北斗"
---

前面几篇文章我们介绍了私有链的服务器搭建和客户端连接私有服务器,接下来我们就要学习如何保证服务器端退出后还能继续提供稳定服务,解决客户端可以永久链接服务器,交易实时被处理。

# 服务器端启动

为了让客户端可以链接,我们可以使用nohup命令来让服务器进行后台启动,但仅仅这样还是不够的,我们还应该允许服务器端支持客户端转账等API,我们就要使用`--rpcapi` 参数来指定。

```
nohup geth --identity TestNode --rpc --rpcaddr 0.0.0.0 --rpcport 8545 --rpcapi "db,eth,net,web3,personal,admin,miner" --datadir /home/ubuntu/ethereum/data0 --port 30303 --nodiscover --mine --minerthreads=1 >/dev/null 2>&1 &
```

以上命令可以来后台启动服务器,并且允许客户端进行远程API调用.
在此命令中我们使用了mine参数开启一个线程进行挖矿,我们是有理由这么操作的,因为如果不是这样,即使客户端发起了一笔远程交易,因为不能生产块数据,也还是不会处理转账。

如果你还是想进入console控制台来向原来那样执行命令,可以使用如下命令来进入

```
geth attach http://127.0.0.1:8545
```

这篇文章结束后,我们在使用客户端操作时候,就可以实现实时处理我们的交易。