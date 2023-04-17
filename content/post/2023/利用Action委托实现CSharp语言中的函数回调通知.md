---
title: "利用Action委托实现C#语言中的函数回调通知"
date: 2023-02-18T17:31:19+08:00
draft: false
lastmod: 2023-02-18T17:31:19+08:00
tags: ["C#"]
categories: ["Unity", "C#"]
keywords: ["C#", "Action"]
description: "C#语言中，如何实现事件回调啊"
author: "北斗"
comment: false
toc: true
autoCollapseToc: false
contentCopyright: false
reward: false
mathjax: false
---

## Action<T>委托
### 定义
*(定义看不懂没关系，浏览一眼后看完示例再过来看定义，会更好理解)*

命名空间:
`System`

程序集:
`System.Runtime.dll`

下面我们来封装一个方法，该方法只有一个参数并且不返回值。

```C#
public delegate void Action<in T>(T obj);
```
**方法讲解：**

  类型参数 `T` 此委托封装的方法的参数类型。

  这是逆变类型参数。 即，可以使用指定的类型，也可以使用派生程度较低的任何类型。 有关协变和逆变的详细信息，请参阅泛型中的协变和逆变。

  参数 `obj`T 此委托封装的方法的参数。

**注解**

可以使用 `Action<T>` 委托将方法作为参数传递，而无需显式声明自定义委托。 封装的方法必须与此委托定义的方法签名相对应。
这意味着封装方法必须具有一个按值传递给它的参数，并且不能返回值。 (在 C# 中，该方法必须返回 void。)

利用这个特性我们就可以很好的实现C#语言中的函数回调。
### 示例
假如我们实战中可能会有金币系统，金币改变的时候，我们需要对UI也要进行更新。这个UI就要向金币系统进行一个事件注册，当你有更新的时候，你要通知我。
下面我们就要实现这么一个金币系统。
```C#
public class CoinsSystem : MonoBehaviour
{
  public static CoinsSystem instance;


  // 保存金币更新回调函数
  private Action<int> onCoinsUpdated;

  private void Awake()
  {
      if (instance == null)
      {
          instance = this;
      }
      else if (instance != this)
      {
          Destroy(gameObject);
      }
      DontDestroyOnLoad(gameObject);
  }
  /// <summary>
  /// 购买金币
  /// </summary>
  /// <param name="amount">金币数量</param>
  public void BuyCoins(int amount)
  {
      // some other code
      if (onCoinsUpdated != null)
      {
          onCoinsUpdated(numCoins);
      }
  }

  /// <summary>
  /// 注册监听，当金币变化的时候调用
  /// </summary>
  /// <param name="callback">回调函数</param>
  public void Subscribe(Action<int> callback)
  {
      onCoinsUpdated += callback;
  }

  /// <summary>
  /// 取消注册
  /// </summary>
  /// <param name="callback">回调函数</param>
  public void Unsubscribe(Action<int> callback)
  {
      if (onCoinsUpdated != null)
      {
          onCoinsUpdated -= callback;
      }
  }
}
```
金币系统我们就这么实现了出来，下面我们再演示一个使用的过程。
```C#
public class BuyCoinsBar
{
  [SerializeField]
  private Text numCoinsText;

  /// <summary>
  /// Unity's Start method.
  /// </summary>
  private void Start()
  {
      // 注册监听金币
      CoinsSystem.instance.Subscribe(OnCoinsChanged);
  }

  /// <summary>
  /// Unity's OnDestroy method.
  /// </summary>
  private void OnDestroy()
  {
      // 取消注册
      CoinsSystem.instance.Unsubscribe(OnCoinsChanged);
  }

  /// <summary>
  /// 金币变化时调用，更新UI
  /// </summary>
  /// <param name="numCoins">当前金币数量</param>
  private void OnCoinsChanged(int numCoins)
  {
      numCoinsText.text = numCoins.ToString("n0");
  }
}
```
在使用的过程中，我们可以看到`OnCoinsChanged`这个方法就被当做一个参数传递到注册/取消注册函数中。
当我们`CoinsSystem`中的金币数量发生了变化，任何注册进来的函数都会得到被调用，
