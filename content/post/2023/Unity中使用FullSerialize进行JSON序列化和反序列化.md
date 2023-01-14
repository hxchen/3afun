---
title: "Unity中使用Full Serialize进行JSON序列化和反序列化"
date: 2023-01-14T17:12:15+08:00
draft: false
lastmod: 2023-01-14T17:12:15+08:00
tags: ["Unity"]
categories: ["Unity"]
keywords: ["Unity", "Full Serialize"]
description: "Unity中使用Full Serialize进行JSON序列化和反序列化"
author: "北斗"
---


现如今几乎没什么程序猿的开发项目不跟JSON打交道，在使用Unity 3D 进行游戏开发时候，我们也会遇到这样的场景，对数据进行JSON序列化和反序列化。
自带的JsonUnity可以解决一部分问题，但是当我们对象有大量的数值需要进行操作时候，我们不可能挨个对对象属性进行操作，那么这时候我们就有一款开源库能满足我们进行对对象的自动装配。
他就是Full Serialize。

[Full Serialize On Github](https://github.com/jacobdufault/fullserializer)

1. 序列化方法封装，我们可以对任意类型对象存储为Json 文件

    ```C#
            /// <summary>
            /// Saves the specified data to a json file at the specified path.
            /// </summary>
            /// <param name="path">The path to the json file.</param>
            /// <param name="data">The data to save.</param>
            /// <typeparam name="T">The type of the data to serialize to the file.</typeparam>
            protected void SaveJsonFile<T>(string path, T data) where T : class
            {
                fsData serializedData;
                var serializer = new fsSerializer();
                serializer.TrySerialize(data, out serializedData).AssertSuccessWithoutWarnings();
                var file = new StreamWriter(path);
                var json = fsJsonPrinter.PrettyJson(serializedData);
                file.WriteLine(json);
                file.Close();
            }
    ```
2. 反序列化方法，我们可以对任意Json 格式文件进行反序列化为对象

    ```C#
            /// <summary>
            /// Loads the specified json file.
            /// </summary>
            /// <param name="serializer">The FullSerializer serializer to use.</param>
            /// <param name="path">The json file path.</param>
            /// <typeparam name="T">The type of the data to load.</typeparam>
            /// <returns>The loaded json data.</returns>
            public static T LoadJsonFile<T>(fsSerializer serializer, string path) where T : class
            {
                var textAsset = Resources.Load<TextAsset>(path);
                Assert.IsNotNull((textAsset));
                var data = fsJsonParser.Parse(textAsset.text);
                object deserialized = null;
                serializer.TryDeserialize(data, typeof(T), ref deserialized).AssertSuccessWithoutWarnings();
                return deserialized as T;
            }
    ```

