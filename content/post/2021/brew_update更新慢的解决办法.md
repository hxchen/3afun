---
title: "brew update更新慢的解决办法"
date: 2021-03-04T22:49:48+08:00
draft: false
lastmod: 2021-03-04T22:49:48+08:00
tags: []
categories: []
keywords: []
description: ""
author: "北斗"
comment: false
toc: true
autoCollapseToc: false
contentCopyright: false
reward: false
mathjax: false
---
默认镜像源在github上，国内可更新为中科大源，速度非常快
```shell script
# 替换 brew
cd "$(brew --repo)"
git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
# 替换 homebrew-cor
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
# 替换 homebrew-cask
cd "$(brew --repo)/Library/Taps/homebrew/homebrew-cask"
git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-cask.git
# 重新执行
brew update
```
