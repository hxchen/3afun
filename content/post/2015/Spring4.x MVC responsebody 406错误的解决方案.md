---
title: "Spring4.x MVC responsebody 406错误的解决方案"
date: 2015-09-10T17:32:00+08:00
draft: false
tags: ["Spring MVC"]
categories: ["服务器"]
author: "北斗"
---


Spring MVC REST 风格API升级到Spring4.x（4.1.1.RELEASE）+的时候报了406错误。结合网上方案，最终定位为：

1、pom文件
```
<dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-core</artifactId>
      <version>2.5.1</version>
    </dependency>
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-databind</artifactId>
      <version>2.5.1</version>
    </dependency>
    <dependency>
      <groupId>com.fasterxml.jackson.core</groupId>
      <artifactId>jackson-annotations</artifactId>
      <version>2.5.1</version>
    </dependency>
```
2、配置文件
```
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:context="http://www.springframework.org/schema/context"
xmlns:mvc="http://www.springframework.org/schema/mvc"
xsi:schemaLocation="http://www.springframework.org/schema/mvc http://www.springframework.org/schema/mvc/spring-mvc-4.2.xsd
      http://www.springframework.org/schema/beans http://www.springframework.org/schema/beans/spring-beans-4.2.xsd
      http://www.springframework.org/schema/context http://www.springframework.org/schema/context/spring-context-4.2.xsd">

<!-- Scans the classpath of this application for @Components to deploy as beans -->
<context:component-scan base-package="com.qikuyx.qikuloginserver.com.a3fun.rocket.controller" />
   <mvc:annotation-driven content-negotiation-manager="contentNegotiationManager" />
   <bean id="contentNegotiationManager" class="org.springframework.web.accept.ContentNegotiationManagerFactoryBean">
      <property name="favorPathExtension" value="false" />
      <property name="favorParameter" value="false" />
      <property name="ignoreAcceptHeader" value="false" />
      <property name="mediaTypes" >
         <value>
atom=application/atom+xml
            html=text/html
            json=application/json
            *=*/*
         </value>
      </property>
   </bean>


<!-- Handles HTTP GET requests for /resources/** by efficiently serving up static resources in the ${webappRoot}/resources/ directory -->
<mvc:resources mapping="/resources/**" location="/resources/" />

<!-- Resolves view names to protected .jsp resources within the /WEB-INF/views directory -->
<bean class="org.springframework.web.servlet.view.InternalResourceViewResolver">
      <property name="prefix" value="/views/"/>
      <property name="suffix" value=".jsp"/>
   </bean>

</beans>
```


3、Controller

```
@RequestMapping(value="/account/isExistEmail/{email:.+}", method=RequestMethod.GET)
    @ResponseBody
    public  Message isExistEmail(@PathVariable("email") String email){
        ...
        Message message = new Message(QikuLoginConst.EMAIL_EXIST,"此邮箱已被注册");
        return  message;

}
```
