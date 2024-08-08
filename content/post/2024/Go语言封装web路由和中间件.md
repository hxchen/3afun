---
title: "Go语言封装web路由和中间件"
date: 2024-08-08T12:12:59+08:00
lastmod: 2024-08-08T12:12:59+08:00
draft: false
keywords: ["Go","web","路由","中间件"]
description: "Go语言封装web路由和中间件"
tags: ["Go"]
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

Go语言里如何进行路由和封装中间件，进行业务和非业务逻辑的剥离呢？

### 包和导入

```go
package main

import (
	"log"
	"net/http"
	"time"
)
```
导入了三个包：
- `log`：用于日志记录。
- `net/http`：用于处理 HTTP 请求和响应。
- `time`：用于处理时间相关的操作。

### 处理函数

```go
func welcome(wr http.ResponseWriter, r *http.Request) {
	wr.Write([]byte("welcome"))
}
```
- `welcome` 函数是一个简单的 HTTP 处理器函数，当访问 `/welcome` 路由时，它会返回 `"welcome"` 字符串作为响应。

### 中间件

```go
func timeMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(wr http.ResponseWriter, r *http.Request) {
		timeStart := time.Now()
		next.ServeHTTP(wr, r)
		timeElapsed := time.Since(timeStart)
		log.Println("time elapsed:", timeElapsed)
	})
}
```
- `timeMiddleware` 是一个记录请求处理时间的中间件。
- 它接收一个 `http.Handler` 类型的参数 `next`，返回一个新的 `http.Handler`。
- 在处理请求前，记录开始时间 `timeStart`。
- 调用 `next.ServeHTTP` 处理实际的请求。
- 记录处理结束时间，并计算耗时 `timeElapsed`，然后记录日志。

### 自定义路由器

```go
type Router struct {
	middlewareChain []middleware
	mux             map[string]http.Handler
}
```
- `Router` 结构体包含两个字段：
  - `middlewareChain`：存储中间件的切片。
  - `mux`：存储路由和相应处理器的映射。

```go
type middleware func(http.Handler) http.Handler
```
- 定义了一个 `middleware` 类型，是一个函数类型，接收一个 `http.Handler`，返回一个 `http.Handler`。

```go
func NewRouter() *Router {
	return &Router{
		mux: make(map[string]http.Handler),
	}
}
```
- `NewRouter` 函数创建并返回一个新的 `Router` 实例。

```go
func (r *Router) Use(m middleware) {
	r.middlewareChain = append(r.middlewareChain, m)
}
```
- `Use` 方法用于向路由器添加中间件。

```go
func (r *Router) Add(route string, h http.Handler) {
	var mergedHandler = h
	for i := len(r.middlewareChain) - 1; i >= 0; i-- {
		mergedHandler = r.middlewareChain[i](mergedHandler)
	}
	r.mux[route] = mergedHandler
}
```
- `Add` 方法用于向路由器添加路由和相应的处理器。
- 遍历中间件链，将每个中间件应用到处理器上。

```go
func (r *Router) ServeHTTP(wr http.ResponseWriter, req *http.Request) {
	if handler, ok := r.mux[req.URL.Path]; ok {
		handler.ServeHTTP(wr, req)
		return
	}
	http.NotFound(wr, req)
}
```
- `ServeHTTP` 方法使 `Router` 结构体符合 `http.Handler` 接口，用于处理传入的 HTTP 请求。
- 根据请求路径查找相应的处理器，如果找到，则调用处理器的 `ServeHTTP` 方法。
- 如果没有找到相应的处理器，返回 404 错误。

### 主函数

```go
func main() {
	r := NewRouter()
	r.Use(timeMiddleware)
	r.Add("/welcome", http.HandlerFunc(welcome))

	http.Handle("/", r)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
```
- 在 `main` 函数中：
  - 创建一个新的 `Router` 实例 `r`。
  - 添加 `timeMiddleware` 中间件。
  - 添加 `/welcome` 路由，并将其处理器设置为 `welcome` 函数。
  - 将自定义路由器 `r` 注册到 HTTP 服务器根路径 `/`。
  - 启动 HTTP 服务器，监听端口 `8080`。

通过这种方式，你可以使用自定义的路由器处理 HTTP 请求，并在处理请求的过程中应用中间件。例如，当访问 `/welcome` 路由时，请求会先经过 `timeMiddleware` 记录处理时间，然后再由 `welcome` 处理器处理请求。

### 完整代码

```go
package main

import (
	"log"
	"net/http"
	"time"
)

func welcome(wr http.ResponseWriter, r *http.Request) {
	wr.Write([]byte("welcome"))
}

// timeMiddleware 记录请求处理时间的中间件
func timeMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(wr http.ResponseWriter, r *http.Request) {
		timeStart := time.Now()
		next.ServeHTTP(wr, r)
		timeElapsed := time.Since(timeStart)
		log.Println("time elapsed:", timeElapsed)
	})
}

type Router struct {
	middlewareChain []middleware
	mux             map[string]http.Handler
}

type middleware func(http.Handler) http.Handler

func NewRouter() *Router {
	return &Router{
		mux: make(map[string]http.Handler),
	}
}

func (r *Router) Use(m middleware) {
	r.middlewareChain = append(r.middlewareChain, m)
}

func (r *Router) Add(route string, h http.Handler) {
	var mergedHandler = h
	for i := len(r.middlewareChain) - 1; i >= 0; i-- {
		mergedHandler = r.middlewareChain[i](mergedHandler)
	}
	r.mux[route] = mergedHandler
}

// ServeHTTP 方法使 Router 结构体符合 http.Handler 接口，用于处理传入的 HTTP 请求。
func (r *Router) ServeHTTP(wr http.ResponseWriter, req *http.Request) {
	if handler, ok := r.mux[req.URL.Path]; ok {
		handler.ServeHTTP(wr, req)
		return
	}
	http.NotFound(wr, req)
}

func main() {
	r := NewRouter()
	r.Use(timeMiddleware)
	r.Add("/welcome", http.HandlerFunc(welcome))

	http.Handle("/", r)
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
```
