---
title: "Java8函数式接口实战之实现全服玩家操作"
date: 2023-04-20T21:45:26+08:00
lastmod: 2023-04-20T21:45:26+08:00
draft: false
keywords: ["Java8","函数式编程"]
description: "Java8函数式接口实战之实现全服玩家操作"
tags: ["Java", "函数式接口", "Lambda"]
categories: ["Java"]
author: "北斗"
comment: true
toc: false
autoCollapseToc: false
contentCopyright: false
reward: false
mathjax: false
---

# 函数式接口
函数式接口(Functional Interface)就是一个有且仅有一个抽象方法，但是可以有多个非抽象方法的接口。

函数式接口可以被隐式转换为 Lambda 表达式。

如定义了一个函数接口如下:
```java
public interface PlayerAction {
    void action(Player player);
}
```
在我们的PlayerServiceImpl上我们定义变量`playerMap`用来保存所有玩家的<ID,Player>信息。
同时我们再定义一个方法`actionForEachPlayer`用来遍历所有玩家，进行PlayerAction的action操作。
```java
@Service
public class PlayerServiceImpl{
    // 其他属性...
    private Map<Long, Player> playerMap = new ConcurrentHashMap<>();
    // 其他方法...
    public void actionForEachPlayer(PlayerAction playerAction) {
      Iterator<Player> iterator = this.playerMap.values().iterator();
      while (iterator.hasNext()) {
        Player player = iterator.next();
        try {
          playerAction.action(player);
        } catch (Exception ex) {
          ex.printStackTrace();
        }
      }
    }
}
```
正常情况下我们在调用`actionForEachPlayer`时，可能需要先`PlayerAction action = new PlayerAction()`,然后将action传给函数。
但是利用函数接口，我们可以简化在对玩家进行全服发奖，全服推送活动，全服等等行为操作，而不需要去挨个创建`PlayerAction`实例。
例如另一个类里有如下方法：
```java
private void pushNewActivity(Activity activity) {
        try {
            playerService.actionForEachPlayer(player -> {
                try {
                    if (player == null) {
                        return;
                    }
                    player.Send(activity);
                } catch (Exception e) {
                    // do something
                }
            });
        } catch (Exception e) {
            // do somethong
        }
    }
```
进行其他全服操作时，我们只需要单独几行类似`pushNewActivity`里的代码，就可以实现各种操作。
