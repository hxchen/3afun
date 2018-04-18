---
title: "javascript 根据浏览器UserAgent判断是否是微信还是IOS或Android设备"
date: 2015-07-01T15:04:00+08:00
draft: false
tags: ["Web前端"]
categories: ["Web前端"]
author: "北斗"
---
```
function is_weixn() {
    var ua = navigator.userAgent.toLowerCase();
    console.log(ua);
    if (ua.match(/MicroMessenger/i) == "micromessenger") {
        return true;
    } else {
        return false;
    }
}
if (is_weixn()) {
    console.log('来自微信');
}else {
    /*
     * 智能机浏览器版本信息:
     *
     */
    var browser = {
        versions : function() {
            var u = navigator.userAgent, app = navigator.appVersion;
            return {//移动终端浏览器版本信息
                trident : u.indexOf('Trident') > -1, //IE内核
                presto : u.indexOf('Presto') > -1, //opera内核
                webKit : u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
                gecko : u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, //火狐内核
                mobile : !!u.match(/AppleWebKit.*Mobile.*/) || !!u.match(/AppleWebKit/), //是否为移动终端
                ios : !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
                android : u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, //android终端或者uc浏览器
                iPhone : u.indexOf('iPhone') > -1 || u.indexOf('Mac') > -1, //是否为iPhone或者QQHD浏览器
                iPad : u.indexOf('iPad') > -1, //是否iPad
                webApp : u.indexOf('Safari') == -1
            //是否web应该程序，没有头部与底部
            };
        }(),
        language : (navigator.browserLanguage || navigator.language).toLowerCase()
    }

    if (browser.versions.ios || browser.versions.iPhone || browser.versions.iPad) {
        console.log('ios');
    } else if (browser.versions.android) {
        console.log('android');
    } else {
        console.log('既不是安卓也不是ios?');
    }
}
```