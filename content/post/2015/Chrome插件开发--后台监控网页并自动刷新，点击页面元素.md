
---
title: "Chrome插件开发--后台监控网页并自动刷新，点击页面元素"
date: 2015-06-18T16:54:00+08:00
draft: false
tags: ["Web前端","浏览器插件"]
categories: ["Web前端"]
author: "北斗"
---
2015年6.17号，在线旅游网站蚂蜂窝出现了抢粽子活动：页面会出现一些粽子，点击粽子，即抢到。很明显，这是一个重复性的劳动，可以代码自动刷新页面，点击页面上的粽子。

本方案中选择了开发一款Chrome浏览器插件进行前台页面刷新，后台点击粽子。



Chrome插件开发。

一、新建目录ChromeAddin-mafengwo。目录下新建名为manifest.json的入口文件。

manifest.json:

```
{
    "name": "picZongzi",
    "version": "1.0",
    "manifest_version": 2,
    "description": "自动抓取蚂蜂窝粽子",
    "browser_action": {
        "default_icon": "./images/icon.png",
        "default_title": "蚂蜂窝自动捡粽子"
    },
    "permissions": [
        "tabs",
        "https://*/*",
        "http://*/*"
    ],
    "content_scripts": [
        {
            "matches": ["*://*.mafengwo.cn/*"],
            "js": ["jquery-1.11.3.min.js", "mafengwo.js"]
        }
    ]
}
```
 本文件主要声明了插件名称版本，监控的权限，网站，加载的文件。



二、实现后台处理文件。

我们发现蚂蜂窝的粽子主要是在一个class=“pickZongzi”的div中，只要发现页面中有改div，即可进行点击。

示例代码主要是从预定义列表中随机选择一个页面，加载该页面并检测是否有粽子，有即进行点击。2.5秒钟刷新一次页面。

具体业务逻辑如下：

mafengwo.js:

```
console.log("蚂蜂窝自动捡粽子，实时监控ing");
$(document).ready(function(){
    var sites = [
                 'http://www.mafengwo.cn/',
                 'http://www.mafengwo.cn/activity/zongzi2015.php?fromhead',
                 'http://www.mafengwo.cn/gonglve/',
                 'http://www.mafengwo.cn/mdd/',
                 'http://www.mafengwo.cn/wenda/',
                 'http://www.mafengwo.cn/sales/'
                 ]
    function GetRandomNum(Min,Max){
        var Range = Max - Min;
        var Rand = Math.random();
        return(Min + Math.round(Rand * Range));
    }
    function killZongzi(){
        var number = GetRandomNum(1,5);
        location.href = sites[number];
        var body = document.body.innerHTML;
        $(".pickZongzi").each(function(){
            $(this).click();
        });
        console.log('杀死粽子！');
    }
    setTimeout(killZongzi, 2500);
});
```
三、开发中的插件调试

浏览器输入：chrome://extensions/

勾选开发者模式，点击加载正在开发的扩展程序，选择插件目录。注意：代码修改一次，就要在此页面重新加载一次。

四、打包插件。

浏览器输入：chrome://extensions/

选择打包扩展程序，即可对插件打包成crx文件。

五、相关代码，移步：https://github.com/hxchen/ChromeAddin-mafengwo
