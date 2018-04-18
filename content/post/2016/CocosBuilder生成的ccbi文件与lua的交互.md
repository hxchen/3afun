
---
title: "CocosBuilder生成的ccbi文件与lua的交互"
date: 2016-12-02T15:52:00+08:00
draft: false
tags: ["CocosBuilder", "Lua"]
categories: ["游戏"]
author: "北斗"
---

# 一、添加Control，设置位置。

属性设置如图所示
![cocos builder ui](/media/images/2016/cocos.png)


# 二、lua代码设置

```
-- 绑定
loginui["close_btn"] = handler(self, self.onClose)


--响应事件
function AdLayer:onClose()
    ...
end
```