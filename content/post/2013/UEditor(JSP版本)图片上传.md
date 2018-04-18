---
title: "UEditor(JSP版本)图片上传"
date: 2013-02-05 16:16:00+08:00
draft: false
tags: ["Web前端"]
categories: ["Web前端"]
author: "北斗"
---
接上篇UEditor（JSP版本）安装与部署，本篇介绍UEditor（JSP版本）图片上传。

一、新建文件夹ueditor，拷贝源码jsp文件夹内的.jsp和.java内容到该文件夹。目录结构如图所示


二、修改editor_config.js
```js
imageUrl:URL+"ueditor/ueditor/imageUp.jsp" //图片上传提交地址
imagePath:"/Ecommerce/resources/ueditor/ueditor/ueditor/" //图片修正地址，引用了fixedImagePath,如有特殊需求，可自行配置
```
三、访问UEditor实例化页面，上传图片查看。



 ps：注意工程的发布环境，要选择webapps下面，否则可能会引起图片上传成功，但是找不到图片（会上传到实际deploy目录中去）。

本试验中图片最终保存在：

D:\Program Files\Apache Software Foundation\Tomcat 6.0\webapps\Ecommerce\resources\ueditor\ueditor\ueditor/upload/20130205/
