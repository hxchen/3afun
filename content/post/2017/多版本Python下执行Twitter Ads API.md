---
title: "多版本Python下执行Twitter Ads API"
date: 2017-03-29T10:53:00+08:00
draft: false
tags: ["Python"]
categories: ["Python"]
author: "北斗"
---
Twitter-API 地址

https://github.com/twitterdev/twitter-python-ads-sdk


Mac电脑自带了Python2.7版本，Twitter在改版本下脚本是可执行的。但是我更想使用Python3，于是在电脑安装了Python3，然后再执行脚本发现缺少库。使用pip 安装后发现报已经安装过。最后就想应该是把待安装的库安装到Python3下。于是执行如下命令:

```
pip3 install python-dateutil
pip3 install requests-oauthlib
```
然后再执行Quick Start 便可以获取到所创建的Campaigns

```
from twitter_ads.client import Client
from twitter_ads.campaign import Campaign

CONSUMER_KEY = ''
CONSUMER_SECRET = '
ACCESS_TOKEN = ''
ACCESS_TOKEN_SECRET = ''
ACCOUNT_ID = ''

# initialize the client
client = Client(CONSUMER_KEY, CONSUMER_SECRET, ACCESS_TOKEN, ACCESS_TOKEN_SECRET)

# load the advertiser account instance
account = client.accounts(id=ACCOUNT_ID)


# iterate through campaigns
for campaign in account.campaigns():
    print(campaign.name)
```