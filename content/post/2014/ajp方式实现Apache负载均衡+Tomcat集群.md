---
title: "ajp方式实现Apache负载均衡+Tomcat集群"
date: 2014-09-24T18:11:27+08:00
draft: false
tags: ["服务器"]
categories: ["服务器"]
author: "北斗"
---
目标:

使用 apache 和 tomcat 配置一个可以应用的 web 网站，要达到以下要求：

Apache 做为 HttpServer ，后面连接多个 tomcat 应用实例，并进行负载均衡。

注：本例程以一台机器为例子，即同一台机器上装一个apache和2个Tomcat。
# 一、准备工作,下载以下软件
JDK1.5+

APAHCE 2.2.8

Tomcat-7.0.41

# 二、安装过程
安装Apache

**D:\Program Files (x86)\Apache Software Foundation\Apache2.2**
解压tomcat
**D:\Tomcat-7.0.41-1**
**D:\Tomcat-7.0.41-2**
# 三、配置
## 1、Apache配置
### 1.1、httpd.conf配置
修改APACHE的配置文件 **Apache2.2\conf\httpd.conf**

将以下Module的注释去掉

```
#apache tomcat负载均衡
LoadModule proxy_module modules/mod_proxy.so
#apache tomcat负载均衡
LoadModule proxy_ajp_module modules/mod_proxy_ajp.so
#apache tomcat负载均衡
LoadModule proxy_balancer_module modules/mod_proxy_balancer.so
#apache tomcat负载均衡
LoadModule proxy_connect_module modules/mod_proxy_connect.so
#apache tomcat负载均衡
LoadModule proxy_ftp_module modules/mod_proxy_ftp.so
#apache tomcat负载均衡
LoadModule proxy_http_module modules/mod_proxy_http.so
```
再找到<IfModule dir_module></IfModule>加上index.jsp修改成
```
<IfModule dir_module>
    DirectoryIndex index.html index.php
</IfModule>
```
去掉如下代码的注释
```
Include conf/extra/httpd-vhosts.conf
```
最下面添加
```
#tomcat集群
ProxyRequests Off
ProxyPass / balancer://example/
<proxy balancer://example>
BalancerMember ajp://127.0.0.1:8010 loadfactor=1 route=jvm1
BalancerMember ajp://127.0.0.1:8011 loadfactor=1 route=jvm2
</proxy>
```
### 1.2、httpd-vhosts.conf设置
接下来进行虚拟主机的设置。修改 **Apache2.2\conf\extra\httpd-vhosts.conf**

```
<VirtualHost *:80>
    ServerAdmin 506110230@qq.com
    ServerName localhost
    ServerAlias localhost
    ProxyPass / balancer://example/ stickysession=jsessionid nofailover=On
    ProxyPassReverse / balancer://example/
    ErrorLog "logs/loadbalancer-error.log"
    CustomLog "logs/loadbalancer-access.log" common
</VirtualHost>
```
## 2 配置 tomcat
### 2.1.  配置 server 的关闭
 tomcat1
```
<Server port="8006" shutdown="SHUTDOWN">
```
 tomcat2
```
<Server port="8007" shutdown="SHUTDOWN">
```
## 2.2. 配置 Engine
 tomcat1
```
<Engine name="Catalina" defaultHost="localhost" jvmRoute="jvm1">
```
 tomcat2
```
<Engine name="Catalina" defaultHost="localhost" jvmRoute="jvm2">
```
##2.3. 配置 Connector
 tomcat1
```
<Connector port="8010" protocol="AJP/1.3" redirectPort="8443" />
```
 tomcat2
```
<Connector port="8011" protocol="AJP/1.3" redirectPort="8443" />
```
## 2.5.配置Cluster
 tomcat1(port号是重点)
```
<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
                 channelSendOptions="8">

          <Manager className="org.apache.catalina.ha.session.DeltaManager"
                   expireSessionsOnShutdown="false"
                   notifyListenersOnReplication="true"/>

          <Channel className="org.apache.catalina.tribes.group.GroupChannel">
            <Membership className="org.apache.catalina.tribes.membership.McastService"
                        address="228.0.0.4"
                        port="45564"
                        frequency="500"
                        dropTime="3000"/>
            <Receiver className="org.apache.catalina.tribes.transport.nio.NioReceiver"
                      address="auto"
                      port="4000"
                      autoBind="100"
                      selectorTimeout="5000"
                      maxThreads="6"/>

            <Sender className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
              <Transport className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"/>
            </Sender>
            <Interceptor className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"/>
            <Interceptor className="org.apache.catalina.tribes.group.interceptors.MessageDispatch15Interceptor"/>
          </Channel>

          <Valve className="org.apache.catalina.ha.tcp.ReplicationValve"
                 filter=""/>
          <Valve className="org.apache.catalina.ha.session.JvmRouteBinderValve"/>

          <Deployer className="org.apache.catalina.ha.deploy.FarmWarDeployer"
                    tempDir="/tmp/war-temp/"
                    deployDir="/tmp/war-deploy/"
                    watchDir="/tmp/war-listen/"
                    watchEnabled="false"/>

          <ClusterListener className="org.apache.catalina.ha.session.JvmRouteSessionIDBinderListener"/>
          <ClusterListener className="org.apache.catalina.ha.session.ClusterSessionListener"/>
        </Cluster>
```
 tomcat2(port号是重点)
```
<Cluster className="org.apache.catalina.ha.tcp.SimpleTcpCluster"
                 channelSendOptions="8">

          <Manager className="org.apache.catalina.ha.session.DeltaManager"
                   expireSessionsOnShutdown="false"
                   notifyListenersOnReplication="true"/>

          <Channel className="org.apache.catalina.tribes.group.GroupChannel">
            <Membership className="org.apache.catalina.tribes.membership.McastService"
                        address="228.0.0.4"
                        port="45564"
                        frequency="500"
                        dropTime="3000"/>
            <Receiver className="org.apache.catalina.tribes.transport.nio.NioReceiver"
                      address="auto"
                      port="4001"
                      autoBind="100"
                      selectorTimeout="5000"
                      maxThreads="6"/>

            <Sender className="org.apache.catalina.tribes.transport.ReplicationTransmitter">
              <Transport className="org.apache.catalina.tribes.transport.nio.PooledParallelSender"/>
            </Sender>
            <Interceptor className="org.apache.catalina.tribes.group.interceptors.TcpFailureDetector"/>
            <Interceptor className="org.apache.catalina.tribes.group.interceptors.MessageDispatch15Interceptor"/>
          </Channel>

          <Valve className="org.apache.catalina.ha.tcp.ReplicationValve"
                 filter=""/>
          <Valve className="org.apache.catalina.ha.session.JvmRouteBinderValve"/>

          <Deployer className="org.apache.catalina.ha.deploy.FarmWarDeployer"
                    tempDir="/tmp/war-temp/"
                    deployDir="/tmp/war-deploy/"
                    watchDir="/tmp/war-listen/"
                    watchEnabled="false"/>

          <ClusterListener className="org.apache.catalina.ha.session.JvmRouteSessionIDBinderListener"/>
          <ClusterListener className="org.apache.catalina.ha.session.ClusterSessionListener"/>
        </Cluster>
```
# 四、启动服务，测试tomcat
1、测试apache和tomcat协作。
先在每个tomcat中的\webapps\ROOT下的index.jsp下面加上以下的测试代码部分：
```
<%@ page language="java"%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>

<%
System.out.println(new Date().getTime());
%>
```
 浏览器分别刷新:

http://127.0.0.1:8081/

http://127.0.0.1:8082/

http://127.0.0.1/

观察后台输出
![console](/media/images/2014/console1.png)
