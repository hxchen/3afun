---
title: "智能合约和java智能包装的使用"
date: 2018-04-25T17:34:28+08:00
draft: false
lastmod: 2018-04-25T23:42:28+08:00
tags: ["Ethereum","区块链"]
categories: ["Ethereum","区块链"]
keywords: ["Ethereum","区块链"]
description: "Ethereum 区块链"
author: "北斗"
---

本章节我们将学习如何从智能合约代码自动生成与java交换的java代码。

首先我们需要安装Solidity编译器

# 安装Solidity编译器
```bash
sudo npm install -g solc
```
查看是否安装成功
```bash
solcjs --version
```
# 安装web3j
```bash
brew tap web3j/web3j
brew install web3j
```

查看web3j是否安装成功
```
web3j
```
### 智能合约生成bin文件和abi文件

现在我们有如下合约 CoolCoin.sol
```
pragma solidity 0.4.23;
interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
/**
 * owned 是一个管理者
 */
contract owned {
    address public owner;
    /**
     * 初台化构造函数
     */
    constructor() public {
        owner = msg.sender;
    }
    /**
     * 判断当前合约调用者是否是管理员
     */
    modifier onlyOwner {
        require (msg.sender == owner);
        _;
    }
    /**
     * 指派一个新的管理员
     * @param  newOwner address 新的管理员帐户地址
     */
    function transferOwnership(address newOwner) onlyOwner public{
        owner = newOwner;
    }
}
/**
 * @title 基础版的代币合约
 */
contract TokenERC20 {
    /* 公共变量 */
    string public name; //代币名称
    string public symbol; //代币符号比如'$'
    uint8 public decimals = 18;  //代币精度，展示的小数点后面多少个0,和以太币一样后面是是18个0
    uint256 public totalSupply; //代币总量
    /*记录所有余额的映射*/
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    /* 在区块链上创建一个事件，用以通知客户端*/
    event Transfer(address indexed from, address indexed to, uint256 value);  //转帐通知事件
    event Burn(address indexed from, uint256 value);  //减去用户余额事件
    /* 构造函数
     * 初始化合约，并且把初始的所有代币都给这合约的创建者
     * @param initialSupply 代币的总数
     * @param tokenName 代币名称
     * @param tokenSymbol 代币符号
     */
    constructor(uint256 initialSupply, string tokenName, string tokenSymbol) public {
        //初始化总量
        totalSupply = initialSupply * 10 ** uint256(decimals);    //使用精度来更新总量
        //初始化总量赋值给创建者
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }
    /**
     * 私有方法从一个帐户发送给另一个帐户代币，只能合约内部调用
     * @param  _from address 发送代币的地址
     * @param  _to address 接受代币的地址
     * @param  _value uint256 接受代币的数量
     */
    function _transfer(address _from, address _to, uint256 _value) internal {
      //避免转帐的地址是0x0
      require(_to != 0x0);
      //检查发送者是否拥有足够余额
      require(balanceOf[_from] >= _value);
      //检查是否溢出
      require(balanceOf[_to] + _value > balanceOf[_to]);
      //保存数据用于后面的判断
      uint previousBalances = balanceOf[_from] + balanceOf[_to];
      //从发送者减掉发送额
      balanceOf[_from] -= _value;
      //给接收者加上相同的量
      balanceOf[_to] += _value;
      //通知任何监听该交易的客户端
      emit Transfer(_from, _to, _value);
      //判断买、卖双方的数据是否和转换前一致
      assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }
    /**
     * 从主帐户合约调用者发送给别人代币
     * @param  _to address 接受代币的地址
     * @param  _value uint256 接受代币的数量
     */
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }
    /**
     * 从某个指定的帐户中，向另一个帐户发送代币
     *
     * 调用过程，会检查设置的允许最大交易额
     *
     * @param  _from address 发送者地址
     * @param  _to address 接受者地址
     * @param  _value uint256 要转移的代币数量
     * @return success        是否交易成功
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        //检查发送者是否拥有足够余额
        require(_value <= allowance[_from][msg.sender]);   // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }
    /**
     * 设置帐户允许支付的最大金额
     *
     * 一般在智能合约的时候，避免支付过多，造成风险
     *
     * @param _spender 帐户地址
     * @param _value 金额
     */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }
    /**
     * 设置帐户允许支付的最大金额
     *
     * 一般在智能合约的时候，避免支付过多，造成风险，加入时间参数，可以在 tokenRecipient 中做其他操作
     *
     * @param _spender 帐户地址
     * @param _value 金额
     * @param _extraData 操作的时间
     */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }
    /**
     * 减少代币调用者的余额
     *
     * 操作以后是不可逆的
     *
     * @param _value 要删除的数量
     */
    function burn(uint256 _value) public returns (bool success) {
        //检查帐户余额是否大于要减去的值
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        //给指定帐户减去余额
        balanceOf[msg.sender] -= _value;
        //代币问题做相应扣除
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
        return true;
    }
    /**
     * 删除帐户的余额（含其他帐户）
     *
     * 删除以后是不可逆的
     *
     * @param _from 要操作的帐户地址
     * @param _value 要减去的数量
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        //检查帐户余额是否大于要减去的值
        require(balanceOf[_from] >= _value);
        //检查 其他帐户 的余额是否够使用
        require(_value <= allowance[_from][msg.sender]);
        //减掉代币
        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        //更新总量
        totalSupply -= _value;
        emit Burn(_from, _value);
        return true;
    }
}
/**
 * @title 高级版代币
 * 增加冻结用户、挖矿、根据指定汇率购买(售出)代币价格的功能
 */
contract MyAdvancedToken is owned, TokenERC20 {
    //卖出价格 单位是wei
    uint256 public sellPrice;
    //买入价格
    uint256 public buyPrice;
    //是否冻结帐户的列表
    mapping (address => bool) public frozenAccount;
    //定义一个事件，当有资产被冻结的时候，通知正在监听事件的客户端
    event FrozenFunds(address target, bool frozen);
    /*初始化合约，并且把初始的所有的令牌都给这合约的创建者
     * @param initialSupply 所有币的总数
     * @param tokenName 代币名称
     * @param tokenSymbol 代币符号
     */
    constructor (uint256 initialSupply,string tokenName,string tokenSymbol) public TokenERC20 (initialSupply, tokenName, tokenSymbol){
     //初始化操作
     //   TokenERC20(_initialSupply, _tokenName, _tokenSymbol);
    }
    /**
     * 私有方法，从指定帐户转出余额
     * @param  _from address 发送代币的地址
     * @param  _to address 接受代币的地址
     * @param  _value uint256 接受代币的数量
     */
    function _transfer(address _from, address _to, uint _value) internal {
        //避免转帐的地址是0x0
        require (_to != 0x0);
        //检查发送者是否拥有足够余额
        require (balanceOf[_from] >= _value);
        //检查是否溢出
        require (balanceOf[_to] + _value >= balanceOf[_to]);
        //检查 冻结帐户
        require(!frozenAccount[_from]);
        require(!frozenAccount[_to]);
        //从发送者减掉发送额
        balanceOf[_from] -= _value;
        //给接收者加上相同的量
        balanceOf[_to] += _value;
        //通知任何监听该交易的客户端
        emit Transfer(_from, _to, _value);
    }
    /**
     * 合约拥有者，可以为指定帐户创造一些代币
     * @param  target address 帐户地址
     * @param  mintedAmount uint256 增加的金额(单位是wei)
     */
    function mintToken(address target, uint256 mintedAmount) onlyOwner public{
        //给指定地址增加代币，同时总量也相加
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        emit Transfer(0, this, mintedAmount);
        emit Transfer(this, target, mintedAmount);
    }
    /**
     * 增加冻结帐户名称
     *
     * 你可能需要监管功能以便你能控制谁可以/谁不可以使用你创建的代币合约
     *
     * @param  target address 帐户地址
     * @param  freeze bool    是否冻结
     */
    function freezeAccount(address target, bool freeze) onlyOwner public{
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }
    /**
     * 设置买卖价格
     *
     * 如果你想让ether(或其他代币)为你的代币进行背书,以便可以市场价自动化买卖代币,我们可以这么做。如果要使用浮动的价格，也可以在这里设置
     *
     * @param newSellPrice 新的卖出价格
     * @param newBuyPrice 新的买入价格
     */
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public{
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }
    /**
     * 使用以太币购买代币,通过增加关键字 payable 我们就可以从任何账户接受以太币来调用这个函数。
     */
    function buy() payable public {
      uint amount = msg.value / buyPrice;
      _transfer(this, msg.sender, amount);
    }
    /**
     * @dev 卖出代币
     * @return 要卖出的数量(单位是wei)
     */
    function sell(uint256 amount) public {
        //检查合约的余额是否充足
        require(address(this).balance >= amount * sellPrice);
        _transfer(msg.sender, this, amount);
        msg.sender.transfer(amount * sellPrice);
    }
}
```
我们在同位置新建一个build的目录来存储bin 和 abi 文件。然后用solc编译合约代码获得 bin 和 abi
```bash
solcjs CoolCoin.sol --bin --abi --optimize -o build/
```
用web3j编译bin和abi 获得包装代码
```
web3j solidity generate /path/to/<smart-contract>.bin /path/to/<smart-contract>.abi -o /path/to/src/main/java -p com.your.organisation.name
```

上面从智能合约到生成java包装代码比较麻烦,更聪明的办法是你应该写一个脚本文件来处理:

```
#!/usr/bin/env bash

set -e
set -o pipefail

targets="
ens/ENS
ens/PublicResolver
"

for target in ${targets}; do
    dirName=$(dirname $target)
    fileName=$(basename $target)

    cd $dirName
    echo "Compiling Solidity file ${fileName}.sol:"
    solc --bin --abi --optimize --overwrite ${fileName}.sol -o build/
    echo "Complete"

    echo "Generating web3j bindings"
    web3j solidity generate \
        build/${fileName}.bin \
        build/${fileName}.abi \
        -p org.web3j.ens.contracts.generated \
        -o ../../../../main/java/ > /dev/null
    echo "Complete"

    cd -
done
```
讲解说明:

该文件通过 targets 定义了 你要编译的合约ENS.sol和PublicResolver.sol

然后遍历待编译的合约文件,通过solc命令来编译。

最后通过web3j 命令来生成相应的java包装代码。

参考:<a href="https://github.com/web3j/web3j" target="_blank">web3j/web3j</a>




