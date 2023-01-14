---
title: "Unity构建Android和iOS"
date: 2022-12-26T22:19:06+08:00
draft: false
lastmod: 2022-12-26T22:19:06+08:00
tags: ["Unity"]
categories: ["Unity"]
keywords: ["Unity Build iOS Android"]
description: "How to build an APP in Unity"
author: "北斗"
---
# Android 构建
### A. Unity配置Android环境
1. 打开菜单栏：Unity -> Preferences，设置External Tools -> Android。

- JDK 设置。当电脑装有多版本JDK时候，可以使用命令查看并选择想要使用的版本。
```shell script
/usr/libexec/java_home -V
```
- SDK设置。
![WX20221227-142254@2x.png](/media/images/2022/WX20221227-142254@2x.png)

2. 打开菜单栏：Unity -> Assets -> Mobile Dependency Resolver -> Android Resolver -> Settings。
![WX20221227-142926@2x.png](/media/images/2022/WX20221227-142926@2x.png)

### B. 构建
1. 打开菜单栏：File -> Build Settings，选择构建的Scene（Scenes In Build），切换平台至Android。
- Player Settings 设置，Player选项进行App相关设置（Company Name、Product Name、 Version、Icon等）
  Build设置，勾选 Custom Main Gradle Template和Custom Gradle Properties Template
2. 设置完后，直接点击Build进行构建。

# iOS 构建(待做)
# 常见Unity报错
1. 404 game init not found for game id
    ```Error log
    ---> Unity.Services.Mediation.InitializeFailedException: Request to https://mediation-instantiation.unityads.unity3d.com/v1/initialize failed due to java.io.IOException: Instantiation Service initialization request failed with http status code 404 and server response: game init not found for game id: xxxxx
    ```
    解决办法：确认game id是否真的存在，注意一定要是game id 不是game name，这点在unity看板里具有迷惑性。

2. 相关引用依赖库出现了问题，可以尝试选择Project页签下的： Plugins -> reimport
3. 如果遇到useAndroidX，可以进行gradle Template设置

    问题：
    ```Error log
   This project uses AndroidX dependencies, but the 'android.useAndroidX' property is not enabled. Set this property to true in the gradle.properties file and retry.
    ```
   解决办法：
   Player Settings -> Player -> Build -> Custom Gradle Properties Template 勾选后，在其配置文件中增加如下配置内容:
    ```Properties配置
    # Android Resolver Properties Start
    android.useAndroidX=true
    android.enableJetifier=true
    # Android Resolver Properties End
   ```
4. 重复类问题
    ```
    java.lang.RuntimeException: Duplicate class com.unity3d.ads.BuildConfig found in modules
    ```
   解决办法：
    ```
   Assets > Mobile Dependency Resolver > Android Resolver > Delete Resolved Libraries
   ```

