---
title: "JQuery JSONP跨域访问数据回调通知"
date: 2015-06-10T19:21:00+08:00
draft: false
tags: ["Web前端"]
categories: ["Web前端"]
author: "北斗"
---
javascript跨域回调，和传统JQuery Ajax有些区别。前端后台需要同时进行改写。

前端：

```
$(document).ready(function(){
            var url = "http://hostname/model-art-code";
            $.ajax({
                type : "GET",
                async: false,
                url : url,
                dataType: 'jsonp',
                jsonp: "callback",
                jsonpCallback:"success_jsonpCallback",
                success : function(json){
                    console.log('success='+json.code);
                },
                error:function(err){
                    console.log('fail'+err);
                }
            });
        });
```

Nodejs后台：
```
res.writeHead(200,{'Content-Type':'application/json;charset=utf-8'});
res.write('success_jsonpCallback'+'({ code:\"value值\"})');
res.end();
```
其中服务器端success_jsonpCallback为客户端jsonpCallback传入的参数