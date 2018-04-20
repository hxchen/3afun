---
title: "如何利用私有链来创建自己的加密代币"
date: 2018-04-16T11:24:49+08:00
lastmod: 2018-04-20T18:00:48+08:00
draft: false
tags: ["Ethereum"]
categories: ["Ethereum"]
author: "北斗"
---

根据前面的几篇文章,我们已经可以创建自己的私有链、使用钱包来链接私有链,今天我们来学习如何使用私有链来创建我们自己的加密货币。
# 工具
1.私有链服务器 Geth Server

[Ubuntu16.04 搭建以太坊Ethereum私链1](https://www.3afun.com/post/2018/ubuntu16.04-%E6%90%AD%E5%BB%BA%E4%BB%A5%E5%A4%AA%E5%9D%8Aethereum%E7%A7%81%E9%93%BE1/)

[Ubuntu16.04 搭建以太坊Ethereum私链2](https://www.3afun.com/post/2018/ubuntu16.04-%E6%90%AD%E5%BB%BA%E4%BB%A5%E5%A4%AA%E5%9D%8Aethereum%E7%A7%81%E9%93%BE2/)

2.客户端钱包 Mist

[Ethereum wallet以太坊钱包链接Geth Server私有链](https://www.3afun.com/post/2018/ethereum-wallet%E4%BB%A5%E5%A4%AA%E5%9D%8A%E9%92%B1%E5%8C%85%E9%93%BE%E6%8E%A5geth-server%E7%A7%81%E6%9C%89%E9%93%BE/)

# 最低限度的代币(Minimum Viable Token)

标准代币合约可以非常的复杂,但是一个基本的代币像如下这样:
```
pragma solidity ^0.4.20;

contract MyToken {
    /* This creates an array with all balances */
    mapping (address => uint256) public balanceOf;

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function MyToken(
        uint256 initialSupply
        ) public {
        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
    }

    /* Send coins */
    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
        require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        balanceOf[msg.sender] -= _value;                    // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
    }
}
```
# 基础版代币 The Code
如果你只想复制粘贴来实现一个完整的代币,可以使用下面这个。这个是ERC20 规范的代币合约 。相应的标准可以参考之前文章
[ERC20 标准规范](https://www.3afun.com/post/2018/erc-20-token-standard/)
```
pragma solidity ^0.4.16;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }

contract TokenERC20 {
    // Public variables of the token
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public totalSupply;

    // This creates an array with all balances
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    // This generates a public event on the blockchain that will notify clients
    event Transfer(address indexed from, address indexed to, uint256 value);

    // This notifies clients about the amount burnt
    event Burn(address indexed from, uint256 value);

    /**
     * Constructor function
     *
     * Initializes contract with initial supply tokens to the creator of the contract
     */
    function TokenERC20(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
        balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
        name = tokenName;                                   // Set the name for display purposes
        symbol = tokenSymbol;                               // Set the symbol for display purposes
    }

    /**
     * Internal transfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        // Prevent transfer to 0x0 address. Use burn() instead
        require(_to != 0x0);
        // Check if the sender has enough
        require(balanceOf[_from] >= _value);
        // Check for overflows
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        // Save this for an assertion in the future
        uint previousBalances = balanceOf[_from] + balanceOf[_to];
        // Subtract from the sender
        balanceOf[_from] -= _value;
        // Add the same to the recipient
        balanceOf[_to] += _value;
        emit Transfer(_from, _to, _value);
        // Asserts are used to use static analysis to find bugs in your code. They should never fail
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    /**
     * Transfer tokens
     *
     * Send `_value` tokens to `_to` from your account
     *
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    /**
     * Transfer tokens from other address
     *
     * Send `_value` tokens to `_to` on behalf of `_from`
     *
     * @param _from The address of the sender
     * @param _to The address of the recipient
     * @param _value the amount to send
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     // Check allowance
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    /**
     * Set allowance for other address
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     */
    function approve(address _spender, uint256 _value) public
        returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    /**
     * Set allowance for other address and notify
     *
     * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
     *
     * @param _spender The address authorized to spend
     * @param _value the max amount they can spend
     * @param _extraData some extra information to send to the approved contract
     */
    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
        public
        returns (bool success) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    /**
     * Destroy tokens
     *
     * Remove `_value` tokens from the system irreversibly
     *
     * @param _value the amount of money to burn
     */
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
        balanceOf[msg.sender] -= _value;            // Subtract from the sender
        totalSupply -= _value;                      // Updates totalSupply
        emit Burn(msg.sender, _value);
        return true;
    }

    /**
     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowance[_from][msg.sender]);    // Check allowance
        balanceOf[_from] -= _value;                         // Subtract from the targeted balance
        allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
        totalSupply -= _value;                              // Update totalSupply
        emit Burn(_from, _value);
        return true;
    }
}
```
# 如何发布 How to deploy
1.点击钱包右上角合约,选择部署新合约
![deploy step](/media/images/2018/deploy01.png)

2.将上面代码复制粘贴到左边Solidity合约原始代码,右边选择合约Token ERC20 填写相应初始量、代币名称、代币符号后点击最下面 部署按钮

在这里我们发行量选择 1,000,000枚 起名字 BBCoin 货币符号 BBC
![deploy step](/media/images/2018/deploy02.png)
输入密码后,回到合约界面等待一会即可看到自己发布的代币
![deploy step](/media/images/2018/deploy03.png)

![deploy step](/media/images/2018/deploy04.png)
3.回到钱包主界面,点击选择我们的主账户,我们可以看到我们的账户里已经有我们发行的货币了
![deploy step](/media/images/2018/deploy05.png)

![deploy step](/media/images/2018/deploy06.png)
# 转账
1.通过钱包转账

点击发送,选择发送资金时候可以选择我们刚刚创建的BBCoin就可以了
![deploy step](/media/images/2018/deploy07.png)

然后我们点击钱包,去查看账户2的内容,就可以看到多了相应数量的BBCoin
![deploy step](/media/images/2018/deploy08.png)

2.通过合约转账

进入合约管理界面,选择相应的函数,填写参数,执行就好。

(注意:上面我们定义的精度是18,这里参数也是需要带精度的)。

![deploy step](/media/images/2018/deploy09.png)

![deploy step](/media/images/2018/deploy10.png)
# 提升你代币
## 其他更多基础函数
在上面基础版代码中,你可能注意到还有一些其他基本的函数,像是`approve`,`sendFrom`等。这些函数是用来和其他合约进行交互用。
假如你需要出售你的代币到一个去中心化交易,只发送代币到一个地址是不够的,因为合约不会订阅 Events, 只会进行 functions call,所以这次的交换不会被识别成新的代币,不知道是谁发送的。
所以对于合约,你需要首先批准一定量的他们可以从你账户进行转移的代币,然后才能告诉他们让他们知道应该做一些事,或者你可以使用`approveAndCall`可以把这2个操作合二为一。

因为很多这些函数需要重新实现代币转账,所以将他们定义成内部函数是有意义的,像是下面的只可以由合约自身来调用:
```
    /* Internal transfer, can only be called by this contract */
    function _transfer(address _from, address _to, uint _value) internal {
        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
        require (balanceOf[_from] >= _value);                // Check if the sender has enough
        require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        require(!frozenAccount[_from]);                     // Check if sender is frozen
        require(!frozenAccount[_to]);                       // Check if recipient is frozen
        balanceOf[_from] -= _value;                         // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        Transfer(_from, _to, _value);
    }
```
现在所有可以转移代币的函数都可以执行自己的检查,然后再使用正确的参数来调用 transfer函数。我们会发现这个函数会从一个账户转移到另一个账户,而不需要一个人的允许。所以我们要将他定义成一个内部函数,只能被合约来调用。如果你想增加可以调用这个函数的函数,你需要检查调用者是否有权来调用。
## 中心化管理员
所有的Dapps默认是完全去中心化的,这并不意味着他们不需要一些中心化的管理者。或许你需要有货币增发的功能,或者你需要禁止某些人使用你的代币。
你可以添加诸如此类的一些功能,唯一需要做的就是在一开始的时候添加这些功能,所以那些代币持有者永远会在他们决定持有前确切的知道游戏规则。

期待这些事可以实现,你需要一个中心货币管理者。这可以是一个简单的账户,但也可以是一个合约,因此创建更多代币的决定取决于合约:如果他是一个可以投票的民主组织或者它只是一个限制代币所有者的权力。

为了做到这些,我们会学习到一个非常有用的合约属性: `inheritance`。继承允许一个合约无需重新定义他们就得到父合约的一些特点。这就可以使代码干净,简单可复用。在你的代码`contract MyToken {`前面,先添加添加如下代码。
```
contract owned {
        address public owner;

        function owned() {
            owner = msg.sender;
        }

        modifier onlyOwner {
            require(msg.sender == owner);
            _;
        }

        function transferOwnership(address newOwner) onlyOwner {
            owner = newOwner;
        }
    }

```
这创建了一个非常简单的合约,你不需要做什么,只需要在名为`owned`里面定义有关合约的一些通用的函数。
下一步就是只需要在你合约里面添加  `is owned `即可。
```
    contract MyToken is owned {
        /* the rest of the contract as usual */
```
这意味着你在`MyToken`里面所有的函数都可要访问`owner`变量和修改者`onlyOwner`。这个合约同事也得到了一个可以转换管理员的函数。
因为在开始的时候设置一个管理者会非常的有趣,所以你可以把这个功能添加到构造函数中去:
```
    function MyToken(
        uint256 initialSupply,
        string tokenName,
        uint8 decimalUnits,
        string tokenSymbol,
        address centralMinter
        ) {
        if(centralMinter != 0 ) owner = centralMinter;
    }
```
## 代币增发
有时我们可能需要货币增发或者删除的情况。

我们首先需要增加一个`totalSupply`变量来存储发行量,并且在构造函数中指定。
```
    contract MyToken {
        uint256 public totalSupply;

        function MyToken(...) {
            totalSupply = initialSupply;
            ...
        }
        ...
    }
```
现在我们来增加一个函数,可以让管理员来发行新币
```
    function mintToken(address target, uint256 mintedAmount) onlyOwner {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        Transfer(0, owner, mintedAmount);
        Transfer(owner, target, mintedAmount);
    }
```
注意到上面的修饰符`onlyOwner`说明 `mintToken` 是继承了 `onlyOwner`方法，会先调用 `modifier onlyOwner` 方法，然后将`mintToken` 方法的内容，插入到下划线 `_` 处调用。
## 冻结资产
根据你的适用情况,你可能会需要一些监管来让谁或者禁止谁来使用你的代币,你需要添加一个参数来让合约管理员冻结或者解冻资产。
```
    mapping (address => bool) public frozenAccount;
    event FrozenFunds(address target, bool frozen);

    function freezeAccount(address target, bool freeze) onlyOwner {
        frozenAccount[target] = freeze;
        FrozenFunds(target, freeze);
    }
```
使用这段代码,所有的账户默认是非冻结状态,管理员可以通过调用`Freeze Account`来冻结账户。但是到目前还没有正式生效,我们还需在转账交易函数里添加如下代码:
```
    function transfer(address _to, uint256 _value) {
        require(!frozenAccount[msg.sender]);
```
现在被冻结账户仍然玩好的拥有资金,但是不能转移他们。所有的账户默认是非冻结状态,除非你去冻结他们,但是你可以轻易的还原这个行为,把他们一个个的手动批准加入到白名单中去。
只需要把`frozenAccount`重命名成`approvedAccount`并且把最后一行代码改成:
```
    require(approvedAccount[msg.sender]);
```
## 自动买卖
到目前为止,你依靠效用和信任来评估你的代币。但是你如果想要的话,你可以通过创建一个基金来以市场价进行买卖兑换以太币或者其他代币。

首先让我们来设置一个买入和卖出价格:
```
    uint256 public sellPrice;
    uint256 public buyPrice;

    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }
```
对于一个不经常变的价格,这是可以接受的。因为每次更改价格将会需要你来执行一个合同并且花费一点的以太币。如果你希望有个持续浮动的价格,我们建议你研究一下 [standard data feeds](https://github.com/ethereum/wiki/wiki/Standardized_Contract_APIs#data-feeds)

下一步来增加购买和销售函数:
```
    function buy() payable returns (uint amount){
        amount = msg.value / buyPrice;                    // calculates the amount
        require(balanceOf[this] >= amount);               // checks if it has enough to sell
        balanceOf[msg.sender] += amount;                  // adds the amount to buyer's balance
        balanceOf[this] -= amount;                        // subtracts amount from seller's balance
        Transfer(this, msg.sender, amount);               // execute an event reflecting the change
        return amount;                                    // ends function and returns
    }

    function sell(uint amount) returns (uint revenue){
        require(balanceOf[msg.sender] >= amount);         // checks if the sender has enough to sell
        balanceOf[this] += amount;                        // adds the amount to owner's balance
        balanceOf[msg.sender] -= amount;                  // subtracts the amount from seller's balance
        revenue = amount * sellPrice;
        msg.sender.transfer(revenue);                     // sends ether to the seller: it's important to do this last to prevent recursion attacks
        Transfer(msg.sender, this, amount);               // executes an event reflecting on the change
        return revenue;                                   // ends function and returns
    }
```
buy函数中我们增加了一个payable关键字,表示调用者可以直接向该函数传入以太币进行调用。

注意:买入和卖出价格并不是以Ether为单位,而是以wei(最小货币精度)为单位。1Ether = 1000000000000000000 wei。所以当在Ether中设置价格时,后面需要加18个0.

不明白的话,可以看后面的Sell Buy 测试数据。

当创建合约时,要发送足够的Ether以确保能买回来市场上所有的代币,否则你的合约会破产并且你的用户不能卖出他们的代币。

前面的例子,当然是在描述一个和单个中央卖方买方的合约,更有趣的合约是允许任何人都可要设置不懂竞价的市场,或者直接从外部来源加载价格。

## 自动补充

每一次你想在以太坊上进行一笔交易,你需要支付一些费用给挖这个区块的矿工以计算你合约的结果。 [未来这可能会改变](https://github.com/ethereum/EIPs/issues/28)
目前费用只能用以太币来支付因此你代币的用户都需要它。
账户余额小于特定费用的时候会被卡住,直到所有人owner可以支付所需费用。但是在有些情况下,你或许不希望你的用户来考虑以太币,区块链或者怎么获取以太币,所以一个可以的办法是让你的币只要检测余额低的有些危险的时候可以自动补充。

为了做到这样,首先你需要创建一个变量来保存阈值和一个函数来改变它。如果你不知道应该设置多少,设置**5finney**(0.005以太币)就好。
```
    uint public minBalanceForAccounts;

    function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
    }
```
然后，将此行添加到**transfer**功能，以便发件人退款：
```
    /* Send coins */
    function transfer(address _to, uint256 _value) {
        ...
        if(msg.sender.balance < minBalanceForAccounts)
            sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
    }
```
还有一种做法是，发送者检测收款方有没有足够的ETH，如果没有，发送者则兑换一部分自己的代币，将得到的ETH发送给收款方（这种做法就是为收款方服务，收款方不用处理ETH、GAS的事情）
```
    /* Send coins */
    function transfer(address _to, uint256 _value) {
        ...
        if(_to.balance<minBalanceForAccounts)
            _to.send(sell((minBalanceForAccounts - _to.balance) / sellPrice));
    }
```
这将确保不会有低于必要以太币的账户可以接受代币。

# 高级版代币
## 全部代码
如果你打算添加所有高级的高能,下面是最终代码:

注意:原示例中存在几处bug已经修正。

```
pragma solidity 0.4.21;

interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }

/**
 * owned 是一个管理者
 */
contract owned {
    address public owner;

    /**
     * 初台化构造函数
     */
    function owned() public{
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
    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public{

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
    function MyAdvancedToken(
      uint256 initialSupply,
      string tokenName,
      string tokenSymbol
    ) public TokenERC20 (initialSupply, tokenName, tokenSymbol) {
     //初始化操作
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
## 部署
复制修正后代码到部署界面,选择My Advanced Token,填写相应的参数,发布即可。
![deplpy](/media/images/2018/deploy11.png)

## 测试
### 准备
账号           |   地址                                         |   CoolCoin   |    Ether   |
---------------|------------------------------------------------|---------------|----------- |
Main account   |    0x914995c9c3c993C9D3Fdd63602c91823F932b308  |   9800        |   x        |
Account 2      |    0x30Ed8Cd207dfdAF5E24847252DF822b1DA1F2FE5  |   100         |   1        |
Account 3      |    0x379f0f61dF4D9009C1AB7BDEA409F5465b5D940c  |   100         |   1        |
Account 4      |    0xc2298C3398584aaB380fafb564037D9Fb910e0a1  |   0           |   1        |

### 1.Set prices 测试
**实验:**

在合约管理界面,通过Set Prices函数,我们可以设置

New sell price =  1

New buy price = 2

**结果**:

等到同步一个区块后,发现管理界面Sell price 和 Buy Price已经更新。

### 2.Approve & Allowance &Transfer From 测试
**实验1:**

通过账户2授权10个CoolCoin给账户3

Approve(Account2, 100)

![cool coin](/media/images/2018/coolcoin01.png)

**结果:**

通过Allowance查看账户2拥有账户3的授权额度

Allowance(Account 2, Account 3) = 10

![cool coin](/media/images/2018/coolcoin02.png)

**实验2:**

通过Transfer From函数,账户3将账户2账户的10个Cool Coin转给账户4

Transfer From(Account2, Account4,10)

![cool coin](/media/images/2018/coolcoin03.png)

**结果:**

Balance of(Account2) = 90

Balance of(Account4) = 10

Allowance(Account 2, Account 3) = 0

账号           |   地址                                         |   CoolCoin   |    Ether       |
---------------|------------------------------------------------|---------------|---------------|
Main account   |    0x914995c9c3c993C9D3Fdd63602c91823F932b308  |   9800        |   x           |
Account 2      |    0x30Ed8Cd207dfdAF5E24847252DF822b1DA1F2FE5  |   90          |   0,999212698 |
Account 3      |    0x379f0f61dF4D9009C1AB7BDEA409F5465b5D940c  |   100         |   1           |
Account 4      |    0xc2298C3398584aaB380fafb564037D9Fb910e0a1  |   10          |   1           |

其他条件测试可自行进行。

### 3.Burn 测试
**实验**

销毁账户4的5个Cool Coin

![cool coin](/media/images/2018/coolcoin04.png)

**结果**

账户4 还剩下5个Cool Coin,Total supply 同步也会减少5个。

![cool coin](/media/images/2018/coolcoin05.png)

### 4.Mint Token 测试

账户4挖5个Cool Coin

![cool coin](/media/images/2018/coolcoin06.png)

**结果**

账户4 此时有10个Cool Coin

![cool coin](/media/images/2018/coolcoin07.png)

### 5.Burn From 测试
**实验**

账户2通过Burn From函数销毁账户3的 10个CoolCoin

![cool coin](/media/images/2018/coolcoin08.png)

**结果**

执行失败,原因是账户2不具有账户3的授权额度。

![cool coin](/media/images/2018/coolcoin09.png)

那么我们可以将账户3的20个币授权给账户2再重新试一下

授权

![cool coin](/media/images/2018/coolcoin10.png)

此时有Allowance(Account3, Account2)=20

现在我们再次使用账户2来销毁账户3的10个币试一下

![cool coin](/media/images/2018/coolcoin11.png)

现在可以成功销毁账户3的10个币了

此时有Allowance(Account3, Account2)=10

当我们尝试再次销毁20个的时候,发现区块链拒绝我们的服务,但是我们销毁10个的话,还是可以允许的。

### 6.Buy测试

通过Set prices 测试,我们已经完成的设置有:

Buy Price = 1

Sell price = 2

**实验**

由于现在Cool Coin的管理界面账户里是没有Ether的,所以我们只能先用账户4来购买一些以太币。

1.主账户发送100Ether给账户4

2.测试账户4有100,890236054 ETHER和20个CoolCoin,现在我们使用账户4的10个Ether来购买CoolCoin。

![cool coin](/media/images/2018/coolcoin12.png)

3.**注意:我们购买代币,并不是从合约管理员Owner来扣除相应的代币,而是从合约地址来购买代币。**

所以我们需要先给合约地址充值代币,才能允许其他用户来购买,否则其他用户向一个代币为0的"央行"购买,是会购买不到。

在此我们使用Mint Token函数来给合约地址 0x63b5047Decd4501d4eb3bb7b30e3da89cE37c2f5 充值 100万个。

![cool coin](/media/images/2018/coolcoin13.png)

4.现在我们的"央行"--CoolCoin(管理界面),拥有0个以太币,100万个Cool Coin

账户4拥有100.890236054个以太币和20个CoolCoin

回到合约管理界面,我们尝试使用账户4调用Buy函数,传入10个以太币,看看会发什么。

![购买](/media/images/2018/coolcoin14.png)

**结果**

没错!!!

结果正是我们看到的,账户4以太币减少了10个。Cool Coin币增加了5个。

![购买](/media/images/2018/coolcoin15.png)

同样可查看CoolCoin管理界面多了10个Ether。

### 7.Sell 测试

现在更激动人心的来了,我们要进行Sell测试,因为我们订的Buy Price = 2, Sell price = 1。账户4一买一卖我们会净赚一半!!!

现在我们使用账户4卖出刚才买入的5个CoolCoin:

![卖出操作](/media/images/2018/coolcoin16.png)

卖出后,我们回到Account 4,发现我们成功卖出5个CoolCoin,得到5个以太币。

![卖出操作](/media/images/2018/coolcoin17.png)

### 8.Freeze Account 测试
**实验**

1.现在我们进行冻结账户测试,我们选择冻结账户4

![卖出操作](/media/images/2018/coolcoin18.png)

2.然后账户4授权20个币给账户2.

![卖出操作](/media/images/2018/coolcoin19.png)

现在我们有

![卖出操作](/media/images/2018/coolcoin20.png)


**结果**

为了验证,我们选择使用2将账户4的10个币转账给账户3。结果提示交易会失败,符合预期。

![卖出操作](/media/images/2018/coolcoin21.png)

![卖出操作](/media/images/2018/coolcoin22.png)

重新解冻后,我们就可以进行上面验证了。





















































