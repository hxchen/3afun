---
title: "Tomcat8 多实例 Unix daemon 模式 "
date: 2017-09-11T18:47:00+08:00
draft: false
tags: ["服务器", "Tomcat"]
categories: ["服务器"]
author: "北斗"
---
# 一、事前准备



Tomcat8（版本8.5.20） [下载地址](http://apache.spinellicreations.com/tomcat/tomcat-8/v8.5.20/bin/apache-tomcat-8.5.20.tar.gz)

JDK8（版本号1.8.0_144） [下载地址](http://download.oracle.com/otn-pub/java/jdk/8u144-b01/090f390dda5b47b9b721c7dfaa008135/jdk-8u144-linux-x64.tar.gz)



# 二、配置部署



### 目录说明



- jdk 安装目录

 */usr/java/jdk1.8.0_144*

- tomcat 安装目录

 */usr/tomcat/apache-tomcat-8.5.20*

- 项目代码目录

 *data/web/forum*

- tomcat实例目录

 */data/web/tomcat8_forum8082*

### tomcat安装

1.生成jsvc
```
cd /usr/tomcat/apache-tomcat-8.5.20/bin
tar xvfz commons-daemon-native.tar.gz
cd commons-daemon-1.0.x-native-src/unix
./configure --with-java=/usr/java/jdk1.8.0_144
make
cp jsvc ../..
cd ../..
```

2.复制tomcat 安装目录的conf 配置文件到实例目录conf
```
cp /usr/tomcat/apache-tomcat-8.5.20/conf /data/web/tomcat8_forum8082
```

3.修改相应端口号，此处使用8082.

4.在/data/web/tomcat8_forum8082目录下新建启动脚本

*startup.sh*

```
#!/bin/bash

JRE_HOME="/usr/java/jdk1.8.0_144"
JAVA_HOME="/usr/java/jdk1.8.0_144"
SERVER_PATH="/data/web"
LOGS_PATH="/data/web/logs/forum"
CATALINA_HOME="/usr/tomcat/apache-tomcat-8.5.20"
CATALINA_BASE="/data/web/tomcat8_forum8082"
CATALINA_PID="$SERVER_PATH/tomcat8_forum8082/pid"
JAVA_OPTS="-Xms512m -Xmx512m "
#TOMCAT_USER="app100681811"

#export JAVA_HOME JRE_HOME LOGS_PATH CATALINA_HOME CATALINA_BASE
export JAVA_HOME JRE_HOME LOGS_PATH #CATALINA_HOME CATALINA_BASE CATALINA_PID
echo $"tomcat8_forum8082 start"
#/usr/tomcat/apache-tomcat-8.5.20/bin/catalina.sh start
export LANG=en_US.UTF-8

cd $CATALINA_HOME
./bin/jsvc \
    -classpath $CATALINA_HOME/bin/bootstrap.jar:$CATALINA_HOME/bin/tomcat-juli.jar \
    -outfile $CATALINA_BASE/logs/catalina.out \
    -errfile $CATALINA_BASE/logs/catalina.err \
    -pidfile "$CATALINA_PID" \
    -Dcatalina.home=$CATALINA_HOME \
    -Dcatalina.base=$CATALINA_BASE \
    -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager \
    -Djava.util.logging.config.file=$CATALINA_BASE/conf/logging.properties \
    org.apache.catalina.startup.Bootstrap
```

关闭脚本

*shutdown.sh*

```
echo $"tomcat8_forum8082 stop"
ps aux | grep jsvc |grep '/web/tomcat8_forum8082'| grep -v 'grep' | awk -F ' ' '{print $2}' | xargs kill -s 2
```

5.执行相应脚本，即可完成启动关闭。

# 三 、多实例模式

多实例模式，只需要复制tomcat实例目录，修改相应配置文件为B项目地址，端口号等信息即可。