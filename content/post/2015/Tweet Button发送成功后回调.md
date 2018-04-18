---
title: "Tweet Button发送成功后回调"
date: 2015-08-05T16:20:00+08:00
draft: false
tags: ["Web前端"]
categories: ["Web前端"]
author: "北斗"
---
意图：网站增加社交分享功能，对于成功分享的用户，赠送优惠活动。

Tweet Button设置: https://about.twitter.com/resources/buttons#tweet

Tweet发推后绑定事件：

```
$.getScript("https://platform.twitter.com/widgets.js", function(){
   function handleTweetEvent(event){
     if (event) {
        console.log('callback event')
     }
   }
   twttr.events.bind('tweet', handleTweetEvent);
});
```