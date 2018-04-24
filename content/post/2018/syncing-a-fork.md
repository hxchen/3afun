---
title: "如何同步一个fork"
date: 2018-04-24T22:23:11+08:00
draft: false
tags: ["git"]
categories: ["git"]
keywords: ["git","同步","fork"]
description: ["git","同步","fork"]
author: "北斗"
---
有时我们fork一个项目到我们账号下,但是又想同步更新原先的内容,怎么办?别着急 **remote upstream**可以来搞定。

1.先使用`git remote -v`查看远程状态。
```bash
git remote -v
origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
origin  https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
```

2.指定一个远程的 remote upstream 用以同步,也就是你fork而来的那个。
```bash
git remote add upstream https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git
```

3.确认新加的 upstream 库
```bash
git remote -v
origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (fetch)
origin    https://github.com/YOUR_USERNAME/YOUR_FORK.git (push)
upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (fetch)
upstream  https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY.git (push)
```

4.获取 upstream 的`master`内容,该内容会被存在本地的 `upstream/master`分支
```bash
git fetch upstream
remote: Counting objects: 75, done.
remote: Compressing objects: 100% (53/53), done.
remote: Total 62 (delta 27), reused 44 (delta 9)
Unpacking objects: 100% (62/62), done.
From https://github.com/ORIGINAL_OWNER/ORIGINAL_REPOSITORY
 * [new branch]      master     -> upstream/master
```

5.切换到本地`master`分支
```bash
git checkout master
Switched to branch 'master'
```

6.合并从`upstream/master`来的变化到本地`master`分支,这会将`fork`的`master`的内容同步到你本地,你本地也不会丢失内容。
```bash
git merge upstream/master
Updating a422352..5fdff0f
Fast-forward
 README                    |    9 -------
 README.md                 |    7 ++++++
 2 files changed, 7 insertions(+), 9 deletions(-)
 delete mode 100644 README
 create mode 100644 README.md
```
如果你本地没有改变的话,git会为你进行"fast-forward"合并
```bash
git merge upstream/master
Updating 34e91da..16c56ad
Fast-forward
 README.md                 |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)
```

7.如果你想更新到你的git上去,只要提交就好了。
```bash
git push origin master
```



