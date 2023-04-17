---
title: "ERC223 标准规范"
date: 2018-04-09T15:43:48+08:00
lastmod: 2018-04-09T15:43:48+08:00
draft: false
tags: ["Ethereum","区块链"]
categories: ["Ethereum","区块链"]
author: "北斗"

# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
# comment: false
# toc: true
autoCollapseToc: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: '<a href="https://github.com/gohugoio/hugoBasicExample" rel="noopener" target="_blank">See origin</a>'
# reward: false
# mathjax: false
---

翻译自 https://github.com/ethereum/EIPs/issues/223
# 抽象
以下描述了标准代币合约函数和特定的代币,这样的实现代币可以避免意外发送到合约,可以是代币事物表现的像其他事务一样。
# 动机
以下描述了ER223解决的ERC20代币规范的问题:
ERC20代币规范会导致退出用户的金钱损失.主要的问题是无法处理传入的ERC20事务,该事务是指通过 ERC20规范中 `transfer` 函数执行的。

如果你发送100个 ETH到一个不支持Ether的合约地址,那么他会拒绝交易并没有什么坏事发生。
如果您发送100个 ERC20代币到一个不支持ERC20的代币合约地址,那么他不会被拒绝,因为它能识别传入事务,所以会导致你的代币在你的余额里被卡住。

比起ERC20,ERC23里解决的是:

1.缺少 `transfer` 处理的可能性。

2.代币丢失。

3.代币交易应该符合以太坊思想。当一个用户想交易的时候,他应该一直是通过调用 `transfer`.用户是存一个新合约还是发送给一个外部账户,这都是无关紧要的.

这些讲允许合约处理传入的代币事务并且阻止意外发送的和合约接受的代币(卡在余额中)

例如,去中心化的交易不再需要用户调用 `approve` 然后调用 `deposit`(内部调用 `transferFrom`用来取出批准的代币). 代币事务会在交易合约中自动处理.

这里最重要的是在执行合约时调用 `tokenFallback`

# 规范
# 代币(Tokens)
## 方法
注意:合约开发者如果想他们的合约支持特定代币,那么他们必须实现`tokenFallback`

如果接受者没有实现 `tokenFallback`函数,考虑合约不是设计用来支持代币,那么交易必定失败并且不会有代币被转账.
类比以太币交易,当发送以太币到一个没有实现 `function() payable`的合约地址,也是会失败。

### totalSupply

`function totalSupply() constant returns (uint256 totalSupply)`

返回代币总量

### name

`function name() constant returns (string _name)`

返回代币名字

### symbol

`function symbol() constant returns (bytes32 _symbol)`

返回代币符号

### decimals

`function decimals() constant returns (uint8 _decimals)`
返回精度


### balanceOf
`function balanceOf(address _owner) constant returns (uint256 balance)`
返回 address _owner 的余额

### transfer(address, uint)

`function transfer(address _to, uint _value) returns (bool)`

因为 ERC20 `transfer` 函数没有 `bytes` 参数,所以需要向后兼容.
该函数必须必须传输令牌并调`_to`中的函数`tokenFallback(address,uint256,bytes)`。
如果`_to`（接收方合同）中没有实现`tokenFallback`函数，则事务必须失败，并且不会发生令牌的传输。

注意:将在接收方合约中调用的令牌备用功能必须命名为`tokenFallback`，并使用参数`address,uint256，bytes`。 此函数必须具有0xc0ee0b8a签名。

### transfer(address, uint, bytes)

`function transfer(address _to, uint _value, bytes _data) returns (bool)`

该函数总是在某人想转移代币的时候调用。

## 事件
### Transfer

`event Transfer(address indexed _from, address indexed _to, uint256 indexed _value, bytes _data)`

转移代币时候触发.

## Contract合约和tokens 代币 一起工作

`function tokenFallback(address _from, uint _value, bytes _data)`

一个处理代币转移的函数,当代币持有者发送代币时候由代币合约来调用.
`_from`指代币发送者 `_value`是收入代币的数量,`_data`是附加数据,类似于以太币交易中的`msg.data`.
它类似于Ether事务的fallback功能，并且什么也不返回。

## 推荐的实现
这是一个强烈推荐的ERC223的代币实现 https://github.com/Dexaran/ERC23-tokens/tree/Recommended














