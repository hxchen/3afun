---
title: "Dubbo教程"
date: 2021-01-28T18:00:14+08:00
draft: false
lastmod: 2021-01-28T18:00:14+08:00
tags: ["Dubbo"]
categories: ["Dubbo"]
keywords: ["Dubbo教程 ZooKeeper"]
description: "Dubbo 教程 配置"
author: "北斗"
comment: false
toc: false
autoCollapseToc: false
contentCopyright: false
reward: false
mathjax: false
---
# 一、Dubbo是什么
Dubbo(读音[ˈdʌbəʊ])是阿里巴巴公司开源的（现在已经捐赠给Apache）一个高性能轻量级的Java RPC框架，可以和Spring框架无缝集成。
提供了六大核心能力：面向接口代理的高性能RPC调用，智能容错和负载均衡，服务自动注册和发现，高度可扩展能力，运行期流量调度，可视化的服务治理与运维。：面向接口的远程方法调用，智能容错和负载均衡，以及服务自动注册和发现。
# 二、Dubbo技术架构
![dubbo-architecture.jpg](/media/images/2021/dubbo-architecture.jpg)
#### 节点角色说明

| 节点 | 角色说明 |
|-|-|
| Provider | 暴露服务的服务提供方 |
| Consumer | 调用远程服务的服务消费方 |
| Registry | 服务注册与发现的注册中心 |
| Monitor | 统计服务的调用次数和调用时间的监控中心 |
| Container | 服务运行容器 |

#### 调用关系说明

1. 服务容器负责启动，加载，运行服务提供者。
2. 服务提供者在启动时，向注册中心注册自己提供的服务。
3. 服务消费者在启动时，向注册中心订阅自己所需的服务。
4. 注册中心返回服务提供者地址列表给消费者，如果有变更，注册中心将基于长连接推送变更数据给消费者。
5. 服务消费者，从提供者地址列表中，基于软负载均衡算法，选一台提供者进行调用，如果调用失败，再选另一台调用。
6. 服务消费者和提供者，在内存中累计调用次数和调用时间，定时每分钟发送一次统计数据到监控中心。

Dubbo 架构具有以下几个特点，分别是连通性、健壮性、伸缩性、以及向未来架构的升级性。

# 三、快速开始
## 3.1 ZooKeeper安装
Dubbo需要有注册中心，因此我们需要安装`zookeeper`，在此我使用的版本是`zookeeper-3.4.9`。

下载
```shell script
wget https://archive.apache.org/dist/zookeeper/zookeeper-3.4.9/zookeeper-3.4.9.tar.gz
sudo tar -zxvf zookeeper-3.4.9.tar.gz
cd zookeeper-3.4.9
sudo cp ./conf/zoo_sample.cfg ./conf/zoo.cfg
```
`zoo.cfg`为默认的`zookeeper`配置文件，用户可以根据实际情况修改数据路径和端口。

启动
```shell script
./bin/zkServer.sh start ./conf/zoo.cfg
```
## 3.2 具体实现
本项目代码可通过 [Github下载](https://github.com/hxchen/SpringBoot-Dubbo)

Dubbo 采用全 Spring 配置方式，透明化接入应用，对应用没有任何 API 侵入，只需用 Spring 加载 Dubbo 的配置即可。

下面是三个项目的大概实现说明：

#### 3.2.1 公共接口项目(hellodubbo-api)
项目结构如下：
![WX20210221-184551@2x.png](/media/images/2021/WX20210221-184551@2x.png)
定义实体类
```Java
public interface UserService {
    /**
     * 通过ID获取User
     * @param id
     * @return
     */
    User getUserById(long id);

}
```
定义接口
```Java
public class User implements Serializable {

    private long id;
    private String name;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
```
#### 3.2.2 服务端项目(hellodubbo-provider)
项目结构如下：
![WX20210221-184748@2x.png](/media/images/2021/WX20210221-184748@2x.png)

`application.yml`配置
```smartyconfig
dubbo:
  application:
    name: hellodubbo-provider
  registry:
    address: zookeeper://127.0.0.1:2181  # zookeeper 注册中心地址
  protocol:
    name: dubbo
    port: 20880  # dubbo 协议端口，默认为20880
server:
  port: 81
```
接口实现
```Java
@Service()
public class UserServiceImpl implements UserService {
    @Override
    public User getUserById(long id) {
        User user = new User();
        user.setName("test");
        user.setId(id);
        return user;
    }
}
```
#### 3.2.3 消费端项目(hellodubbo-consumer)
项目结构如下：
![WX20210221-185141@2x.png](/media/images/2021/WX20210221-185141@2x.png)
`application.yml`配置
```smartyconfig
dubbo:
  application:
    name: hellodubbo-consumer
  registry:
    address: zookeeper://127.0.0.1:2181 # zookeeper 注册中心地址

server:
  port: 80
```
远程调用接口
```Java
@RestController
@RequestMapping("/user")
public class UserController {

    @Reference
    private UserService userService;

    @RequestMapping("/findUser")
    public User findUserById(String id){
        return userService.getUserById(Long.parseLong(id));
    }

}
```
# 四、测试
1. SpringBoot启动服务端
2. SpringBoot启动消费端
3. 浏览器访问消费端`http://127.0.0.1/user/findUser?id=123`
4. 确认浏览器返回结果
```json
{"id":123,"name":"test"}
```





