---
title: "私钥和秘钥keystore在代码中的应用"
date: 2018-05-10T23:19:22+08:00
draft: true
lastmod: 2018-05-10T23:19:22+08:00
tags: ["Ethereum","区块链"]
categories: ["Ethereum","区块链"]
keywords: ["Ethereum","区块链"]
description: "Ethereum"
author: "北斗"
---
我们在进行以太坊网络开发时候,可能会遇到`私钥(private key)`和`keystore文件`,那么他们究竟是什么,起什么作用呢?下面就让我们来了解一下`私钥`和`keystore`文件。

你可能已经创建过钱包账户了,那么在创建的时候,你需要输入一个`密码`。

# 私钥 private key

私钥=账户地址+密码

创建钱包后,输入密码可以导出私钥,这个私钥属于明文私钥,是一个64位字符串,一个钱包只有一个私钥且不能修改。比如我这有一个私钥
**a392604efc2fad9c0b3da43b5f698a2e3f270f170d859912be0d54742275c5f6**

# 秘钥 keystore

keystore 属于加密私钥，存储在应用程序目录下一个名为keystore的文件夹里。点击钱包的菜单-账户-备份-账户,就会自动打开到该目录下。

密钥文件的最新格式是：`UTC--<created_at UTC ISO8601>-<address hex>`

keystore和钱包密码有很大关联，钱包密码修改后，keystore 也就相应变化，在用 keystore 导入钱包时，需要输入密码，这个密码是备份 keystore 时的钱包密码，与后来密码的修改无关。

