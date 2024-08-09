---
title: "Go语言defer关键字的使用场景"
date: 2024-08-09T10:41:28+08:00
lastmod: 2024-08-09T10:41:28+08:00
draft: false
keywords: ["Go"]
description: "Go语言defer关键字的使用场景"
tags: ["Go"]
categories: ["G"]
author: "北斗"

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

`defer` 是 Go 语言中的一个关键字，用于延迟执行一个函数或方法，直到包含 `defer` 语句的函数结束后再执行。无论该函数是因为正常的 `return` 语句退出，还是因为触发了 `panic` 导致的退出，`defer` 语句都会执行。

### 使用 `defer` 的场景

`defer` 关键字通常用于确保一些必须要执行的操作能够在函数结束时执行。常见的使用场景包括：

1. **释放资源**：例如关闭文件、释放锁、关闭数据库连接等。
2. **解锁互斥锁**：在使用 `sync.Mutex` 进行并发编程时，可以使用 `defer` 来确保 `Unlock` 函数一定会被调用。
3. **处理错误**：在可能引发 `panic` 的地方，使用 `defer` 来确保恢复（`recover`）操作能够正确执行。
4. **清理操作**：在函数结束时需要执行的清理或恢复状态操作。

### `defer` 的执行顺序

如果在一个函数中有多个 `defer` 语句，它们的执行顺序是**后进先出**（LIFO，Last In First Out）。也就是说，最后一个 `defer` 语句会最先执行，依次类推。

### 示例

```go
package main

import "fmt"

func example() {
    fmt.Println("Start")
    defer fmt.Println("Deferred 1")
    defer fmt.Println("Deferred 2")
    fmt.Println("End")
}

func main() {
    example()
}
```

**输出结果：**

```
Start
End
Deferred 2
Deferred 1
```

在这个例子中，`defer fmt.Println("Deferred 2")` 和 `defer fmt.Println("Deferred 1")` 的执行顺序是相反的，因为它们遵循 LIFO 的顺序。
