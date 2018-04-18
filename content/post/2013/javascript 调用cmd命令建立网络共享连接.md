---
title: "javascript 调用cmd命令建立网络共享连接"
date: 2013-01-17 22:36:00+08:00
draft: false
tags: ["Web前端"]
categories: ["Web前端"]
author: "北斗"
---
建立目的电脑（Linux OS）的共享连接，目的电脑IP：192.168.17.211 共享文件夹prison 用户名 root 密码 88888888

```html
<html>
  <head>
 <title>共享连接</title>
 <meta http-equiv="pragma" content="no-cache">
 <meta http-equiv="cache-control" content="no-cache">
 <meta http-equiv="expires" content="0">
 <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
 <meta http-equiv="description" content="This is my page">
 <script type="text/javascript">
  function addNet(){
   var o = new ActiveXObject("WScript.Shell");
   o.run("net use \\\\192.168.17.211\\prison 88888888 /USER:root",0);
  }
  function deleteNet(){
   var o = new ActiveXObject("WScript.Shell");
   o.run("net use \\\\192.168.17.211\\prison /del",0);
  }
 </script>
  </head>

  <body>
    <input type="button" value="添加" onclick="addNet()">
    <input type="button" value="删除" onclick="deleteNet()">
  </body>
</html>
```