---
title: "Ubuntu16.04 搭建以太坊Ethereum私链"
date: 2018-04-11T15:43:48+08:00
lastmod: 2018-04-11T15:43:48+08:00
draft: false
tags: ["Ethereum"]
categories: ["Ethereum"]
author: "北斗"

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
# comment: false
# toc: false
autoCollapseToc: true
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: '<a href="https://github.com/gohugoio/hugoBasicExample" rel="noopener" target="_blank">See origin</a>'
# reward: false
# mathjax: false
---

# 一、说明

想尝试基于以太坊的应用或者Tokens发布，无奈正常网络测试需要用Ether，购买麻烦，各步骤还得需要消耗以太币，不过我们可以搭建私有链来进行开发，话不多说，马上开始搭建我们自己的开发测试私有链。



# 二、所需工具

1、以太坊客户端

以太坊客户端用于接入以太坊网络，进行账户管理、交易、挖矿、智能合约相关的操作。

目前有多种语言实现的客户端，常用的有 Go 语言实现的 go-ethereum 客户端 Geth，支持接入以太坊网络并成为一个完整节点，也可作为一个 HTTP-RPC 服务器对外提供 JSON-RPC 接口。

其他的客户端有：智能合约编译器

Parity：Rust 语言实现；

cpp-ethereum：C++ 语言实现；

ethereumjs-lib：JavaScript 语言实现；

Ethereum(J)：Java 语言实现；

ethereumH：Haskell 语言实现；

pyethapp： Python 语言实现；

ruby-ethereum：Ruby 语言实现；

2、智能合约编译器

以太坊支持两种智能合约的编程语言：Solidity 和 Serpent。现在的主流是Solidity，学习教程可参考 [站点](http://www.tryblockchain.org/Solidity-%E8%AF%AD%E8%A8%80%E4%BB%8B%E7%BB%8D.html) 。

现在以太坊提供更方便的在线 IDE —— Remix https://remix.ethereum.org 使用 Remix，免去了安装solc和编译过程，它可以直接提供部署合约所需的二进制码和 ABI。

3、以太坊钱包

以太坊提供了图形界面的钱包 Ethereum Wallet 和 Mist Dapp 浏览器。

钱包的功能是 Mist 的一个子集，可用于管理账户和交易；Mist 在钱包基础上，还能操作智能合约。为了演示合约部署过程，本文使用了 Geth console 操作，没有用到 Mist，当然，使用 Mist 会更简单。

# 三、安装

服务器我们采用Ubuntu16.04。

首先安装必要的工具

```
apt install software-properties-common
```

再次添加以太坊源

```
add-apt-repository -y ppa:ethereum/ethereum
apt update
```

最后安装go-ethereum

```
apt install ethereum
```

安装完成后，可以运行命令查看是否成功

```
geth version
```

显示

```
Geth
Version: 1.8.2-stable
Git Commit: b8b9f7f4476a30a0aaf6077daade6ae77f969960
Architecture: amd64
Protocol Versions: [63 62]
Network Id: 1
Go Version: go1.9.4
Operating System: linux
GOPATH=
GOROOT=/usr/lib/go-1.9
```



# 四、私有链搭建

1、创建初始化配置文件和存放数据目录

要运行以太坊私有链，需要定义自己创世区块，创世区块是一个json格式配置文件。我们可以新建一个文件 genesis.json

```
{
"config": {
    "chainId": 411,
    "homesteadBlock": 0,
    "eip155Block": 0,
    "eip158Block": 0
  },
  "nonce": "0x0000000000000033",
  "timestamp": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "gasLimit": "0x8000000",
  "difficulty": "0x100",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "coinbase": "0x0000000000000000000000000000000000000000",
  "alloc": {
        "0x1C83C95473e1e93A2C8560c73976dAFA9C3f0a79":{"balance":"1000000"}
  }
}
```

其中chainID 指定了区块链网络ID。

并且我对自己地址进行了配额。其他参数可参考 [站点](http://www.tryblockchain.org/Solidity-%E8%AF%AD%E8%A8%80%E4%BB%8B%E7%BB%8D.html)

存放数据目录在此我使用 `/home/ubuntu/ethereum/data0`

genesis.json存放在`/home/ubuntu/ethereum/`



然后可以执行命令来进行初始化操作。

```
cd ethereum
geth --datadir data0 init genesis.json
```

结果

```
INFO [04-11|07:51:14] Maximum peer count                       ETH=25 LES=0 total=25
INFO [04-11|07:51:14] Allocated cache and file handles         database=/home/ubuntu/ethereum/data0/geth/chaindata cache=16 handles=16
INFO [04-11|07:51:14] Writing custom genesis block
INFO [04-11|07:51:14] Persisted trie from memory database      nodes=1 size=195.00B time=35.174碌s gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [04-11|07:51:14] Successfully wrote genesis state         database=chaindata                                  hash=b924d6Ωfdceb
INFO [04-11|07:51:14] Allocated cache and file handles         database=/home/ubuntu/ethereum/data0/geth/lightchaindata cache=16 handles=16
INFO [04-11|07:51:14] Writing custom genesis block
INFO [04-11|07:51:14] Persisted trie from memory database      nodes=1 size=195.00B time=460.134碌s gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [04-11|07:51:14] Successfully wrote genesis state         database=lightchaindata                                  hash=b924d6Ωfdceb
```

初始化成功后，会在data0目录下生产所需文件。

其中 `geth/chaindata` 中存放的是区块数据，`keystore` 中存放的是账户数据。



# 五、启动私有节点

初始化完成后，就有了一条自己的私有链。我们可以执行命令来启动它

```
geth --identity "TestNode" --rpc --rpcport "8545" --datadir data0 --port "30303" --nodiscover console
```

上面命令的主体是 geth console，表示启动节点并进入交互式控制台。


各选项含义如下：

–identity：指定节点 ID；

–rpc：表示开启 HTTP-RPC 服务；

–rpcport：指定 HTTP-RPC 服务监听端口号（默认为 8545）；

–datadir：指定区块链数据的存储位置；

–port：指定和其他节点连接所用的端口号（默认为 30303）；

–nodiscover：关闭节点发现机制，防止加入有同样初始配置的陌生节点。

运行上面的命令后，就启动了区块链节点并进入了该节点的控制台：

```
INFO [04-11|08:05:23] Maximum peer count                       ETH=25 LES=0 total=25
INFO [04-11|08:05:23] Starting peer-to-peer node               instance=Geth/TestNode/v1.8.2-stable-b8b9f7f4/linux-amd64/go1.9.4
INFO [04-11|08:05:23] Allocated cache and file handles         database=/home/ubuntu/ethereum/data0/data0/geth/chaindata cache=768 handles=512
INFO [04-11|08:05:23] Writing default main-net genesis block
INFO [04-11|08:05:23] Persisted trie from memory database      nodes=12356 size=2.34mB time=47.705254ms gcnodes=0 gcsize=0.00B gctime=0s livenodes=1 livesize=0.00B
INFO [04-11|08:05:23] Initialised chain configuration          config="{ChainID: 1 Homestead: 1150000 DAO: 1920000 DAOSupport: true EIP150: 2463000 EIP155: 2675000 EIP158: 2675000 Byzantium: 4370000 Constantinople: <nil> Engine: ethash}"
INFO [04-11|08:05:23] Disk storage enabled for ethash caches   dir=/home/ubuntu/ethereum/data0/data0/geth/ethash count=3
INFO [04-11|08:05:23] Disk storage enabled for ethash DAGs     dir=/root/.ethash                                 count=2
INFO [04-11|08:05:23] Initialising Ethereum protocol           versions="[63 62]" network=1
INFO [04-11|08:05:23] Loaded most recent local header          number=0 hash=d4e567b8fa3 td=17179869184
INFO [04-11|08:05:23] Loaded most recent local full block      number=0 hash=d4e567b8fa3 td=17179869184
INFO [04-11|08:05:23] Loaded most recent local fast block      number=0 hash=d4e567b8fa3 td=17179869184
INFO [04-11|08:05:23] Regenerated local transaction journal    transactions=0 accounts=0
INFO [04-11|08:05:23] Starting P2P networking
INFO [04-11|08:05:23] RLPx listener up                         self="enode://b5e91ca148308d721599ac14b9f2a9aff28c88b258a439fbc19f094d65ecaa9954a6a7d0de29f5737726bcdb20a443db9edeedce0471c1ba5cda043e8601e0d0@[::]:30303?discport=0"
INFO [04-11|08:05:23] IPC endpoint opened                      url=/home/ubuntu/ethereum/data0/data0/geth.ipc
INFO [04-11|08:05:23] HTTP endpoint opened                     url=http://127.0.0.1:8545                      cors= vhosts=localhost
Welcome to the Geth JavaScript console!

instance: Geth/TestNode/v1.8.2-stable-b8b9f7f4/linux-amd64/go1.9.4
 modules: admin:1.0 debug:1.0 eth:1.0 miner:1.0 net:1.0 personal:1.0 rpc:1.0 txpool:1.0 web3:1.0
```

这是一个交互式的 JavaScript 执行环境，在这里面可以执行 JavaScript 代码，其中 `>`是命令提示符。在这个环境里也内置了一些用来操作以太坊的 JavaScript 对象，可以直接使用这些对象。这些对象主要包括：


eth：包含一些跟操作区块链相关的方法；

net：包含一些查看p2p网络状态的方法；

admin：包含一些与管理节点相关的方法；

miner：包含启动&停止挖矿的一些方法；

personal：主要包含一些管理账户的方法；

txpool：包含一些查看交易内存池的方法；

web3：包含了以上对象，还包含一些单位换算的方法。

# 六、控制台操作

进入以太坊 Javascript Console 后，就可以使用里面的内置对象做一些操作，这些内置对象提供的功能很丰富，比如查看区块和交易、创建账户、挖矿、发送交易、部署智能合约等。

常用命令有：

`personal.newAccount()`：创建账户；

`personal.unlockAccount()`：解锁账户；

`eth.accounts`：枚举系统中的账户；

`eth.getBalance()`：查看账户余额，返回值的单位是 Wei（Wei 是以太坊中最小货币面额单位，类似比特币中的聪，1 ether = 10^18 Wei）；

`eth.blockNumber`：列出区块总数；

`eth.getTransaction()`：获取交易；

`eth.getBlock()`：获取区块；

`miner.start()`：开始挖矿；

`miner.stop()`：停止挖矿；

`web3.fromWei()`：Wei 换算成以太币；

`web3.toWei()`：以太币换算成 Wei；

`txpool.status`：交易池中的状态；

`admin.addPeer()`：连接到其他节点；

这些命令支持 Tab 键自动补全，具体用法如下。


## 1、创建账户

```
>personal.newAccount()
Passphrase:
Repeat passphrase:
"0x914995c9c3c993c9d3fdd63602c91823f932b308"
```

输入密码、确认密码将会创建一个账户.

同样方法再创建一个

```
> personal.newAccount()
Passphrase:
Repeat passphrase:
"0x30ed8cd207dfdaf5e24847252df822b1da1f2fe5"
```

查看账户(上面初始化配置文件出差错了？没分配呀)
```
> eth.accounts
["0x914995c9c3c993c9d3fdd63602c91823f932b308", "0x30ed8cd207dfdaf5e24847252df822b1da1f2fe5"]
```
## 2、查看账户余额

```
eth.getBalance(eth.accounts[0])
```

## 3、启动 停止挖矿

### 启动挖矿

```
>miner.start(1)
```

其中 start 的参数表示挖矿使用的线程数。第一次启动挖矿会先生成挖矿所需的 DAG 文件，这个过程有点慢，等进度达到 100% 后，就会开始挖矿，此时屏幕会被挖矿信息刷屏。


### 停止挖矿

```
>miner.stop()
```
挖到一个区块会奖励5个以太币，挖矿所得的奖励会进入矿工的账户，这个账户叫做 coinbase，默认情况下 coinbase 是本地账户中的第一个账户，可以通过 miner.setEtherbase() 将其他账户设置成 coinbase。

再次查看账户余额
```
> eth.getBalance(eth.accounts[0])
510000000000000000000
```


## 4、发送交易

目前，账户0已经挖到了97个块的奖励，账户1余额还是0：


```
> eth.getBalance(eth.accounts[0])
510000000000000000000
> eth.getBalance(eth.accounts[1])
0
```

我们要从账户0到账户1转账，需要先解锁账户0才能转账


```
> personal.unlockAccount(eth.accounts[0])
Unlock account 0x914995c9c3c993c9d3fdd63602c91823f932b308
Passphrase:
true
```
 转账0->1

```
> amount = web3.toWei(5,'ether')
"5000000000000000000"
> eth.sendTransaction({from:eth.accounts[0],to:eth.accounts[1],value:amount})
INFO [04-11|09:37:09] Submitted transaction                    fullhash=0x2d8342ce23ca00a61a66a9926d45e8516bd0edda18703770c72897d2b9c31973 recipient=0x30Ed8Cd207dfdAF5E24847252DF822b1DA1F2FE5
"0x2d8342ce23ca00a61a66a9926d45e8516bd0edda18703770c72897d2b9c31973"
```

此时如果没有挖矿，用 txpool.status 命令可以看到本地交易池中有一个待确认的交易，可以使用 `eth.getBlock("pending", true).transactions` 查看当前待确认交易。

```
> txpool.status
{
  pending: 1,
  queued: 0
}
> eth.getBlock("pending", true).transactions
[{
    blockHash: "0x2a13705bbe3a60c1d8fa686d6c8a326c6f1b70e7943bb7be8d8e9aa9fef7701e",
    blockNumber: 103,
    from: "0x914995c9c3c993c9d3fdd63602c91823f932b308",
    gas: 90000,
    gasPrice: 18000000000,
    hash: "0x2d8342ce23ca00a61a66a9926d45e8516bd0edda18703770c72897d2b9c31973",
    input: "0x",
    nonce: 0,
    r: "0x546055f53f1f7535549c4e31ddf03c6678384afc9571240d237823c205239a11",
    s: "0x65f39c6a35f338c6fe67faf7a3bb14c91abc0472113bb9916c82cc51a407f6c9",
    to: "0x30ed8cd207dfdaf5e24847252df822b1da1f2fe5",
    transactionIndex: 0,
    v: "0x359",
    value: 5000000000000000000
}]
```


使用 `miner.start()` 命令开始挖矿：


```
> miner.start(1);admin.sleepBlocks(1);miner.stop();
INFO [04-11|09:39:49] Updated mining threads                   threads=1
INFO [04-11|09:39:49] Transaction pool price threshold updated price=18000000000
INFO [04-11|09:39:49] Starting mining operation
INFO [04-11|09:39:49] Commit new mining work                   number=103 txs=1 uncles=0 elapsed=378.402碌s
INFO [04-11|09:39:52] Successfully sealed new block            number=103 hash=8327606bec9
INFO [04-11|09:39:52]  block reached canonical chain          number=98  hash=9d43b286588
INFO [04-11|09:39:52]  mined potential block                  number=103 hash=8327606bec9
INFO [04-11|09:39:52] Commit new mining work                   number=104 txs=0 uncles=0 elapsed=231.591碌s
true
```


新区块挖出后，挖矿结束，查看账户 1 的余额，已经收到了账户 0 的以太币：


```
> web3.fromWei(eth.getBalance(eth.accounts[1]),'ether')
5
```



## 5、查看交易和区块

 查看当前区块总数：

```
> eth.blockNumber
103
```

通过交易 Hash 查看交易（Hash 值包含在上面交易返回值中）：

```
> eth.getTransaction("0x2d8342ce23ca00a61a66a9926d45e8516bd0edda18703770c72897d2b9c31973")
{
  blockHash: "0x83276067a8ad0168cf1d9fabb089b7778024bc6700434f470d830decb4a6bec9",
  blockNumber: 103,
  from: "0x914995c9c3c993c9d3fdd63602c91823f932b308",
  gas: 90000,
  gasPrice: 18000000000,
  hash: "0x2d8342ce23ca00a61a66a9926d45e8516bd0edda18703770c72897d2b9c31973",
  input: "0x",
  nonce: 0,
  r: "0x546055f53f1f7535549c4e31ddf03c6678384afc9571240d237823c205239a11",
  s: "0x65f39c6a35f338c6fe67faf7a3bb14c91abc0472113bb9916c82cc51a407f6c9",
  to: "0x30ed8cd207dfdaf5e24847252df822b1da1f2fe5",
  transactionIndex: 0,
  v: "0x359",
  value: 5000000000000000000
}
```


通过区块号查看区块

```
> eth.getBlock(102)
{
  difficulty: 137514,
  extraData: "0xd783010802846765746887676f312e392e34856c696e7578",
  gasLimit: 121486905,
  gasUsed: 0,
  hash: "0x09c0a05f1a76fa39222f965d0b3665550bb5a0ab518963c8d1c5280a7b13cf43",
  logsBloom: "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
  miner: "0x914995c9c3c993c9d3fdd63602c91823f932b308",
  mixHash: "0x7afd2e352e797ad57554bd81d1f156baed041242fcb641c336683fc9f5937b6c",
  nonce: "0x4fe257812731bb15",
  number: 102,
  parentHash: "0xaf1c22536346d8183b63632e4eb6fae81bfd5f9ca305f5fe20b9b7ef0da2a9de",
  receiptsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  sha3Uncles: "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
  size: 536,
  stateRoot: "0x73bb0a88af2d04b4fcec031a48ffdc16cda90b88c215e3587f1e9acc1c050eca",
  timestamp: 1523438740,
  totalDifficulty: 13695386,
  transactions: [],
  transactionsRoot: "0x56e81f171bcc55a6ff8345e692c0f86e5b48e01b996cadc001622fb5e363b421",
  uncles: []
}
```
