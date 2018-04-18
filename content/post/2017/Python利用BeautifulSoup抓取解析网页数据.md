---
title: "Python利用BeautifulSoup抓取解析网页数据"
date: 2017-05-10T14:22:00+08:00
draft: false
tags: ["Python"]
categories: ["Python"]
author: "北斗"
---


网页UI以及HTML组织形式，目的是抓取网页数据并解析。
![UI](/media/images/2017/python_01.png)

```
<div class="clan__table">
      <div class="clan__headers">
        <div class="clan__headerCaption">Rank</div>
        <div class="clan__headerCaption">Name</div>
        <div class="clan__headerCaption">Level</div>
        <div class="clan__headerCaption">League</div>
        <div class="clan__headerCaption">Trophies</div>
        <div class="clan__headerCaption">Donations</div>
        <div class="clan__headerCaption">Role</div>
      </div>


      <div class="clan__rowContainer">
        <div class="clan__row">
                            #1
                    </div>
        <div class="clan__row">
          <a class="ui__blueLink" href="/profile/2P0V2CCY">北斗</a>
        </div>
        <div class="clan__row">
          <span class="clan__playerLevel">11</span>
        </div>
        <div class="clan__row">
          <div class="clan__leagueContainer">
                            <div class="league__2"></div>
          </div>
        </div>
        <div class="clan__row">
          <div class="clan__cup">4438</div>
        </div>
        <div class="clan__row">379</div>
        <div class="clan__row">
             Leader
        </div>
      </div>


      <div class="clan__rowContainer">
        <div class="clan__row">
                            #2
                    </div>
        <div class="clan__row">
          <a class="ui__blueLink" href="/profile/9UURJRQU">wglj</a>
        </div>
        <div class="clan__row">
          <span class="clan__playerLevel">12</span>
        </div>
        <div class="clan__row">
          <div class="clan__leagueContainer">
                            <div class="league__2"></div>
           </div>
        </div>
        <div class="clan__row">
          <div class="clan__cup">4344</div>
        </div>
        <div class="clan__row">498</div>
        <div class="clan__row">
             Co-Leader
        </div>
      </div>


</div>
```
![UI](/media/images/2017/python_02.png)

通过查看页面源代码，我们发现每一个玩家信息都是存储在一个class为clan__rowContainer的div中。

那么我们就可以通过soup的finaAll选择器来获取所有行的玩家信息，然后遍历挨个解析玩家数据。

```
for i, row in enumerate(soup.findAll("div",attrs = {"class":"clan__rowContainer"})):
        user_dict = {}
        for j,col in enumerate(row.findAll("div",attrs = {"class":"clan__row"})):
            if j == 0:
                user_dict["rank"] = col.string.strip().replace("#","")
            elif j == 1:
                user_dict["name"] = col.a.string.strip()
                user_dict["uid"] = col.a.get("href").strip("/profile/")
            elif j == 2:
                user_dict["level"] = col.span.string.strip()
            elif j == 3:
                user_dict["league"] = col.contents[1].div.get("class")[0].replace("league__","")
            elif j == 4:
                user_dict["score"] = col.div.string.strip()
            elif j == 5:
                user_dict["donations"] = col.string.strip()
            elif j == 6:
                user_dict["role"] = col.string.strip()
        print(user_dict)
```
