
---
title: "UEditor(JSP版本)安装与部署"
date: 2013-02-04 17:35:00+08:00
draft: false
tags: ["Web前端"]
categories: ["Web前端"]
author: "北斗"
---
一、访问UEditor[官方网站](http://ueditor.baidu.com/website/download.html#)，此处我选择的是开发版->1.2.5.0Jsp版本->UTF-8版本。



二、解压缩下载文件。如图所示



 三、在原有Java Web工程（此处我的是Ecommerce）里新建resources/ueditor目录。

拷贝源码包dialogs、lang、themes、third-party、editor_all.js、editor_config.js文件或目录到工程ueditor下面。新建editor.jsp文件用于展示ueditor。

ueditor.jsp内容：

```jsp
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<SCRIPT type=text/javascript src="../resources/ueditor/editor_config.js"></SCRIPT>
<SCRIPT type=text/javascript src="../resources/ueditor/editor_all.js"></SCRIPT>
<LINK rel=stylesheet href="../resources/ueditor/themes/default/css/ueditor.css">
<title>文本编辑器</title>
</head>
<body>
<DIV id=myEditor></DIV>
<SCRIPT type=text/javascript>
    var editor = new baidu.editor.ui.Editor();
    editor.render("myEditor");
</SCRIPT>
</body>
</html>
```

四、修改editor_config.js中URL值指向资源文件

```js
URL = window.UEDITOR_HOME_URL||"/Ecommerce/resources/ueditor/";//这里你可以配置成ueditor目录在您网站的相对路径或者绝对路径（指以http开头的绝对路径）
```
五、至此ueditor部署完毕。访问预览如图所示