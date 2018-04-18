---
title: "WAS7.0 在Linux（Suse）下的静默安装"
date: 2013-03-29 18:32:00+08:00
draft: false
tags: ["服务器"]
categories: ["服务器"]
author: "北斗"
---
一、WAS程序安装

1、上传文件：

上传文件C1G35ML.tar.gz、C1G36ML.tar.gz到待安装系统/home下。



2、登陆root用户到home下，解压缩文件。

tar zxvf C1G35ML.tar.gz

tar zxvf C1G36ML.tar.gz



3、编辑/WAS下的配置文件responsefile.nd.txt

命令行安装（静默安装）需要修改该文件的相关选择，下面讲要修改的参数陈列如下：

-OPT silentInstallLicenseAcceptance="true"    –接受License

-OPT allowNonRootSilentInstall="true" --是否允许非root用户安装

-OPT disableOSPrereqChecking="true" --取消对系统的检测

-OPT installType="installNew"   --是否全新安装

-OPT feature="noFeature"   --不安装示例

-OPT installLocation="/opt/IBM/WebSphere/AppServer" --HP-UX, Solaris or Linux默认安装路径

-OPT profileType=”standAlone”   --生成标准概要表

-OPT PROF_enableAdminSecurity="true" --设置管理员安全，在下面两项上输入用户名和密码。如：用户名为admin，密码为admin。如果值为”false”，表示不设置，则下面两项不需要填写。

-OPT PROF_adminUserName=”admin”

-OPT PROF_adminPassword=”admin”

另存为该文件为install.txt



4、执行命令行安装（静默安装）：

以root账号身份执行，切换目录到/WAS在命令行输入
```
./install -options install.txt  –silent
```
等待一段时间，直到命令执行完成。查看是否安装成功。

切换目录到/opt如果opt路径下执行下面的命令，有.ibm 和IBM文件夹则说明安装完成。
```
ls -la
```
该版本在安装时报错，位置发生在install下。

401行原来代码是  if [ $version -ge 5 ]

修改为if [[ $version -ge 5 ]]

5、查看安装日志

日志文件位于/opt/IBM/WebSphere/AppServer/logs/install/log.txt。



6、验证是否安装成功

切换目录到/opt/IBM/WebSphere/AppServer/bin启动WAS
```
./startServer.sh server1
```
启动完成后，在其他机器输入http://iphost:9060/ibm/console，如果能打开界面，说明安装成功，至此WAS光盘镜像的静默安装完成