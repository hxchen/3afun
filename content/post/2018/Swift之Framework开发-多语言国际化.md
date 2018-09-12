---
title: "Swift之SDK开发-多语言国际化"
date: 2018-07-04T21:56:47+08:00
draft: false
tags: ["Swift","iOS"]
categories: ["Swift"]
keywords: ["Swift","iOS","SDK","framework"]
description: "Swift"
author: "北斗"
---

除了做App开发之外,有时候我们会使用Framework进行SDK开发,如果你使用的语言是Swift,你又怎么才能实现你的多语言国际化呢?

### 添加多语言文件

1.项目配置 -> “Info” -> “Localizations”区域下，可以看到工程默认只支持英文，我们可以再添加中文语言。

2.Command + N, 选择iOS -> Resource -> Strings File
![multiLang01](/media/images/2018/multilang000.png)
3.文件名必须命名为`Localizable.strings`

4.文件创建成功，查看Xcode左侧导航列表，发现多了一个名为Localizable.strings的文件

5.选中Localizable.strings文件，在Xcode的File inspection中点击Localize，目的是选择我们需要本地化的语言.

6.依次选择English->Localize,在此我们可以继续添加简体中文,日语等。

7.此时，Xcode左侧的Localizable.strings左侧多了一个箭头，展开后可以看到存储各个语言的文件。

8.然后我们只需要在Localizable.strings下对应的文件中，分别以Key-Value的形式，为代码中每一个需要本地化的字符串赋值。

例如 `LOGIN = "登录";`

### 代码中多语言适配

在SDK中提取多语言翻译,我们用到的方法是:

`public func NSLocalizedString(_ key: String, tableName: String? = default, bundle: Bundle = default, value: String = default, comment: String) -> String`

`NSLocalizedString`可以接受5个参数,各个参数说明如下:

1.`key`对应多语言文件中的Key值。

2.`tableName`用来确定 .strings 的文件名。 默认情况下，系统会从 Main Bundle 中加载名称为 Localizable.strings 的文件,如果多人开发时候,大家可以各自定义每人使用的文件。

3.`bundle`定义了从这个bundle中查找tableName文件中的key值。

4.`value`定义默认值

5.`comment`注释

因为我是在Framework中调用语言,最终的App是谁,我并不去关心,因此重点我只需要关注Bundle就好,在此可以使用
`NSLocalizedString("LOGIN", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: "登录")`
来调用SDK下面的多语言文件内容。
