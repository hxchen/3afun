---
title: "如何利用私有链来创建自己的加密代币"
date: 2018-04-16T11:24:49+08:00
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

注意:买入和卖出价格并不是以Ether为单位,而是以wei(最小货币精度)为单位。1Ether = 1000000000000000000 wei。所以当在Ether中设置价格时,后面需要加18个0.

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
pragma solidity ^0.4.16;

contract owned {
    address public owner;

    function owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
}

// 修正bug public 修改为 external
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
     * Constrctor function
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
        require(balanceOf[_to] + _value > balanceOf[_to]);
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
     * Send `_value` tokens to `_to` in behalf of `_from`
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
     * Allows `_spender` to spend no more than `_value` tokens in your behalf
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
     * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
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

/******************************************/
/*       ADVANCED TOKEN STARTS HERE       */
/******************************************/

contract MyAdvancedToken is owned, TokenERC20 {

    uint256 public sellPrice;
    uint256 public buyPrice;

    mapping (address => bool) public frozenAccount;

    /* This generates a public event on the blockchain that will notify clients */
    event FrozenFunds(address target, bool frozen);

    /* Initializes contract with initial supply tokens to the creator of the contract */
    function MyAdvancedToken(
        uint256 initialSupply,
        string tokenName,
        string tokenSymbol
    ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}

    /* Internal transfer, only can be called by this contract */
    function _transfer(address _from, address _to, uint _value) internal {
        require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
        require (balanceOf[_from] >= _value);               // Check if the sender has enough
        require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
        require(!frozenAccount[_from]);                     // Check if sender is frozen
        require(!frozenAccount[_to]);                       // Check if recipient is frozen
        balanceOf[_from] -= _value;                         // Subtract from the sender
        balanceOf[_to] += _value;                           // Add the same to the recipient
        emit Transfer(_from, _to, _value);
    }

    /// @notice Create `mintedAmount` tokens and send it to `target`
    /// @param target Address to receive the tokens
    /// @param mintedAmount the amount of tokens it will receive
    function mintToken(address target, uint256 mintedAmount) onlyOwner public {
        balanceOf[target] += mintedAmount;
        totalSupply += mintedAmount;
        emit Transfer(0, this, mintedAmount);
        emit Transfer(this, target, mintedAmount);
    }

    /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
    /// @param target Address to be frozen
    /// @param freeze either to freeze it or not
    function freezeAccount(address target, bool freeze) onlyOwner public {
        frozenAccount[target] = freeze;
        emit FrozenFunds(target, freeze);
    }

    /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
    /// @param newSellPrice Price the users can sell to the contract
    /// @param newBuyPrice Price users can buy from the contract
    function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
        sellPrice = newSellPrice;
        buyPrice = newBuyPrice;
    }

    /// @notice Buy tokens from contract by sending ether
    function buy() payable public {
        uint amount = msg.value / buyPrice;               // calculates the amount
        _transfer(this, msg.sender, amount);              // makes the transfers
    }

    /// @notice Sell `amount` tokens to contract
    /// @param amount amount of tokens to be sold
    function sell(uint256 amount) public {
        /// 修正bug
        /// require(address(this).balance >= amount * sellPrice);
        require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
        _transfer(msg.sender, this, amount);              // makes the transfers
        msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
    }
}

```
## 部署
复制修正后代码到部署界面,选择My Advanced Token,填写相应的参数,发布即可。
![deplpy](/media/images/2018/deploy11.png)


