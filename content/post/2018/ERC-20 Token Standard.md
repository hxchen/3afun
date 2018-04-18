---
title: "ERC20 标准规范"
date: 2018-04-04T15:43:48+08:00
lastmod: 2018-04-04T15:43:48+08:00
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

# 简要说明
该文主要是一个以太币智能合约的标准接口说明。
# 抽象
以下将要说明的标准允许你去实现基于智能合约的标准代币（Tokens）API提供的接口。这个标准提供了一些基本功能以用于代币（Tokens）转账，以及批准用于其他链上的第三方来使用。
# 动机
标准接口允许以太坊上的任何代币（Tokens）可以被其他程序来重新使用：包括钱包和去中心化的交换。
# 规范
# 代币(Tokens)
## 方法
注意：调用者必须处理返回方法 `returns (bool success)`返回的 `false`.调用者绝对不能认为 `false`从未返回。

### name
返回代币的名字 ，例如 “MyToken”
可选 - 该方法用来提高可用性，但是接口和其他合约不能期望这些值的呈现。

`function name() view returns (string name)`

### symbol
返回代币的符号，例如“ETH”
可选 - 该方法用来提高可用性，但是接口和其他合约不能期望这些值的呈现。

`function symbol() view returns (string symbol)`

### decimals
返回代币的精确度，例如“8”，代币最小可以是0.00000001
可选 - 该方法用来提高可用性，但是接口和其他合约不能期望这些值的呈现。

`该方法用来提高可用性，但是接口和其他合约不能期望这些值的呈现。`

### totalSupply
返回代币的总量

`function totalSupply() view returns (uint256 totalSupply)`

### balanceOf
返回地址为 _owner 账户的 账户余额

`function balanceOf(address _owner) view returns (uint256 balance)`

### transfer
将 `_value` 数量的代币（从外面账户）转到账户 `_to`,并且必须调用 `Transfer` 事件。如果 `_from` 账户余额不够使用的话，该函数 应该抛出 `throw` 。

`function transfer(address _to, uint256 _value) returns (bool success)`

### transferFrom
实现代币用户之间的交易，将 `_value` 数量的代币从 `_from` 账户转账到 `_to`账户，并且必须调用 `Transfer` 事件。
transferFrom 方法用于退出工作流程，允许合约代表你来转账。例如，这可以允许合约代替你来交易或者收取子货币的费用。该函数应该抛出 `throw`，除非 `_from` 账户通过某些机制授权消息的发送者。
注意：交易数量为 0 的转账须当做正常交易，并且应该调用 `Transfer`事件

`function transferFrom(address _from, address _to, uint256 _value) returns (bool success)`

### approve
该方法允许发送者`_spender`从你的账户多次取走最多为`_value`限额数量的代币。如果这个方法再次被调用，那么他会用`_value`的值覆盖当前可用限额。
注意:为了避免攻击，客户端应该以这样的方式来设置限额，在设置其他值给同一个发送者之前，先设置成0（尽管为了向后兼容之前的合约，合约不会执行它）.

`function approve(address _spender, uint256 _value) returns (bool success)`

### allowance
返回发送者`_spender`还剩下可从`_owner`取走的额度。

`function allowance(address _owner, address _spender) view returns (uint256 remaining)`

## 事件
### Transfer
该事件必须在交易代币（Tokens）的时候出发，包括数量为0的交易。
当创建新代币时应该触发一个 `Transfer`事件，并将_from账户设置为`0x0`

`event Transfer(address indexed _from, address indexed _to, uint256 _value)`

### Approval
该事件必须在 成功调用 `approve(address _spender, uint256 _value)`的时候触发。

`event Approval(address indexed _owner, address indexed _spender, uint256 _value)`

# 实现
现在已经有很多的兼容ERC20标准并且基于以太坊网络的代币。有众多的团队根据接口来实现了不一样的代币，这些不同的实现包括节约费用Gas，提高安全性。
以下是一些可用的实现：

https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol

https://github.com/ConsenSys/Tokens/blob/master/contracts/eip20/EIP20.sol

一个再次调用 `approve`前，设置0操作的实现：

https://github.com/Giveth/minime/blob/master/contracts/MiniMeToken.sol













