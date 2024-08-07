---
title: "Go语言下使用Protobuf搭建RPC框架"
date: 2024-08-07T10:32:37+08:00
lastmod: 2024-08-07T10:32:37+08:00
draft: false
keywords: ["Go","Protobuf"]
description: "Go语言下使用Protobuf搭建RPC框架"
tags: ["Go","Protobuf"]
categories: ["Go"]
author: ""

# Uncomment to pin article to front page
# weight: 1
# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
comment: false
toc: true
autoCollapseToc: false
# You can also define another contentCopyright. e.g. contentCopyright: "This is another copyright."
contentCopyright: false
reward: false
mathjax: false

# Uncomment to add to the homepage's dropdown menu; weight = order of article
# menu:
#   main:
#     parent: "docs"
#     weight: 1
---
# Protobuf 安装
1. 安装 protobuf
```shell
brew install protobuf
```
2. 确认安装成功
```shell
protoc --version
```
3. 安装代理(可选，先跳过，4超时再执行3)
```shell
go env -w GOPROXY=https://goproxy.cn
```
4. 安装代码生成插件 protoc-gen-go
```shell
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
```
# 通信协议定义
1. 定义通信协议
```protobuf
syntax = "proto3";

package hello;

option go_package = "./;hello";

message HelloRequest {
  string name = 1;
}
message HelloResponse {
  string message = 1;
}
service HelloService {
  rpc Say (HelloRequest) returns (HelloResponse);
}
```
2. 生成代码，执行完毕后生成hello.pb.go 和 hello_grpc.pb.go
```shell
protoc --go_out=. hello.proto
protoc --go-grpc_out=. hello.proto
```
# 服务端
1. 实现服务端
```go
package main

import (
	"context"
	hi "github.com/hxchen/EasyGo/api/protobuf-spec"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	"log"
	"net"
)

const (
	port = ":1234"
)

type server struct {
	hi.HelloServiceServer
}

func (s *server) Say(ctx context.Context, in *hi.HelloRequest) (*hi.HelloResponse, error) {
	log.Printf("Received: %s", in.Name)
	return &hi.HelloResponse{Message: "Hello " + in.Name}, nil
}

func listenAndService() {
	lis, err := net.Listen("tcp", port)
	if err != nil {
		log.Fatalf("failed to listen, %v", err)
	}
	s := grpc.NewServer()
	hi.RegisterHelloServiceServer(s, &server{})
	reflection.Register(s)
	log.Print("the rpc server is started up\n")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve %v", err)
	}
}

func main() {
	listenAndService()
}
```
2. 启动服务端
```shell
go run main.go
```
# 客户端
1. 实现客户端
```go
package main

import (
	"context"
	rpc "github.com/hxchen/EasyGo/api/protobuf-spec"
	"google.golang.org/grpc"
	"log"
)

const PORT = ":1234"

func main() {
	conn, err := grpc.Dial(PORT, grpc.WithInsecure())
	if err != nil {
		log.Fatalf("get an error : %v\n", err)
	}
	defer conn.Close()

	client := rpc.NewHelloServiceClient(conn)

	resp, err := client.Say(context.Background(), &rpc.HelloRequest{
		Name: "this is client",
	})
	if err != nil {
		log.Fatalf("invoke error \n")
	}

	log.Printf("resp : %s\n", resp.GetMessage())
}
```
2. 启动客户端
```shell
go run main.go
```




