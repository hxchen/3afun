---
title: "Unity3D与Android SDK交互"
date: 2015-11-20T11:17:00+08:00
draft: false
tags: ["Unity3D","Android"]
categories: ["Unity3D","Android"]
author: "北斗"
---


# 一、Android SDK准备

1、新建Android Library工程unitysdk
![unity01](/media/images/2015/unity01.jpg)


2、新建libs目录，将Unity for Android的 class.jar（Unity安装目录里有）复制到此。在此我这里，重命名为unity3dplayer.jar并且添加到安卓工程里去。

3、新建主Activity：UnityTestActivity 继承 UnityPlayerActivity。

本文件主要是回调Unity游戏对象Canvas。方法AndroidReceive，传递参数message。
```
package com.qikuyx.unitysdk;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.unity3d.player.UnityPlayer;
import com.unity3d.player.UnityPlayerActivity;

/**
 * Created by Administrator on 2015/11/17.
 */
public class UnityTestActivity extends UnityPlayerActivity{
    static final String TAG = "UnityTestActivity";
    Context mContext = null;
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
         mContext = this;
    }

    public void StartActivity0(String name) {
        Intent intent = new Intent(mContext,TestActivity0.class);
        intent.putExtra("name", name);
        Log.i(TAG, "收到Unity传递过来的参数:" + name);
        this.startActivity(intent);
    }
    public static void sendMessageToUnity(String message){
        Log.i(TAG, "向Unity传递参数:"+message);
        UnityPlayer.UnitySendMessage("Canvas", "AndroidReceive", message);
    }
}
```
4、新建TestActivity0，添加如下代码：
```
package com.qikuyx.unitysdk;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;


/**
 * Created by Administrator on 2015/11/17.
 */
public class TestActivity0 extends Activity{
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        TextView text = (TextView)this.findViewById(R.id.textView1);
        text.setText(this.getIntent().getStringExtra("name"));
        final EditText editText = (EditText) this.findViewById(R.id.editText);
        Button close = (Button)this.findViewById(R.id.button0);
        close.setOnClickListener(new View.OnClickListener() {

            @Override
            public void onClick(View v) {
                TestActivity0.this.finish();
                UnityTestActivity.sendMessageToUnity(editText.getText().toString());
            }
        });
    }
}
```
 5、新建布局文件main.xml
```
<?xml version="1.0" encoding="utf-8"?>
<ScrollView xmlns:android="http://schemas.android.com/apk/res/android" android:id="@+id/screen"
    android:layout_width="fill_parent" android:layout_height="fill_parent"
    android:orientation="vertical">
    <LinearLayout
        android:layout_width="fill_parent" android:layout_height="fill_parent"
        android:orientation="vertical">
        <ImageView
            android:src="@drawable/ic_launcher"
            android:layout_width="fill_parent"
            android:layout_height="fill_parent"
            />
        <TextView android:id="@+id/textView0"
            android:layout_width="fill_parent"
            android:layout_height="41dp"
            android:textColor="#000000"
            android:textSize="18dip"
            android:text="@string/android_sdk_for_unity3d"
            android:background="#af1727d3" />

        <TextView
            android:layout_width="match_parent"
            android:layout_height="43dp"
            android:text="@string/received_values"
            android:id="@+id/textView"
            android:layout_gravity="center_horizontal"
            android:layout_marginTop="40dp" />

        <TextView
            android:id="@+id/textView1"
            android:layout_width="fill_parent"
            android:layout_height="42dp"
            android:textColor="#000000"
            android:textSize="18dip"
            android:background="#af17d3c6" />

        <EditText
            android:layout_width="match_parent"
            android:layout_height="wrap_content"
            android:id="@+id/editText"
            android:layout_gravity="center_horizontal"
            android:hint="@string/input_parameters"
            android:layout_marginTop="40dp" />

        <Button android:id="@+id/button0"
            android:layout_width="fill_parent" android:layout_height="wrap_content"
            android:text="@string/send_and_close"/>
    </LinearLayout>
</ScrollView>
```
 6、values/string.xml添加如下：
```
<resources>
    <string name="app_name">UnitySDK</string>
    <string name="android_sdk_for_unity3d">Android SDK for Unity3D</string>
    <string name="received_values">收到Unity传递过来的参数:</string>
    <string name="input_parameters">请在此输入向Unity传送的参数</string>
    <string name="send_and_close">传送并关闭当前Android Activity</string>
</resources>
```
 7、AndroidManifest配置如下：
```
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.qikuyx.unitysdk"
    android:versionCode="1"
    android:versionName="1.0" >

    <uses-sdk android:minSdkVersion="7" />
    <application
        android:icon="@drawable/ic_launcher"
        android:label="@string/app_name" >
        <activity
            android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
            android:name="com.qikuyx.unitysdk.UnityTestActivity"
            android:label="@string/app_name" >
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>

        <activity
            android:name="com.qikuyx.unitysdk.TestActivity0"
            android:theme="@android:style/Theme.NoTitleBar.Fullscreen"
            >
        </activity>

    </application>

</manifest>
```
 8、build.gradle配置文件：
```
apply plugin: 'com.android.library'
def SDKVersion = '1.0'
android {
    compileSdkVersion 21
    buildToolsVersion "21.1.2"

    defaultConfig {
        minSdkVersion 15
        targetSdkVersion 21
        versionCode 1
        versionName "1.0"
    }
    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
    sourceSets {
        defaultConfig {
        }
        main {
            java.srcDirs = ['src/main/java']
            manifest.srcFile 'src/main/AndroidManifest.xml'
        }
    }
}

dependencies {
    compile fileTree(dir: 'libs', include: ['*.jar'])
    testCompile 'junit:junit:4.12'
    compile 'com.android.support:appcompat-v7:21.0.3'
    compile files('libs/unity3dplayer.jar')
}
task clearJar(type: Delete) {
    delete "build/outputs/UnitySDK_$SDKVersion"+".jar"
}
task makeUnitySDKJar(type: Copy) {
    from("build/intermediates/bundles/release/")
    into("build/outputs/")
    include("classes.jar")
    rename ("classes.jar", "UnitySDK_$SDKVersion"+".jar")
}
makeUnitySDKJar.dependsOn(clearJar, build)
```
 9、通过执行如下命令就可以生成Jar包供Unity使用：
```
gradle makeUnitySDKJar
```
 Android部分到此结束，下面开始Unity部分说明。

# unity02二、Unity准备
1、新建一个名为QikuLogin的Unity3D工程。

2、在Hierarchy上。选中Main Camera新建Button(右键->UI->Button)。

3、上面步骤中将自动创建Canvas，然后在其上依次添加2个InputField，最后结构如下：

![unity02](/media/images/2015/unity02.jpg)

 4、在Project控件上，新建Android目录和bin子目录。将Android中打包行程的jar放于此。

Android的res文件放于Assets\Plugins\Android

Android的AndroidManifest.xml文件放于Assets\Plugins\Android

最终目录如下：

![unity03](/media/images/2015/unity03.jpg)

 5、Assets\Plugins下新建C#脚本文件Test.cs,并且挂载到Canvas上。

本文件主要是进行Java对象初始化和方法调用。
```
using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class Test : MonoBehaviour {
    private AndroidJavaClass jc;
    private AndroidJavaObject jo;
    public InputField receivedText;
    public InputField sendText;
    // Use this for initialization
    void Start () {
        jc = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
        jo = jc.GetStatic<AndroidJavaObject>("currentActivity");
    }

    // Update is called once per frame
    void Update () {

    }
    void OnGUI() {

    }
    void AndroidReceive(string content) {
        receivedText.text = content;
    }
    public void openAndroidActivity() {
        jo.Call("StartActivity0", sendText.text);
    }
}
```

 6、将控件Button事件关联到openAndroidActivity函数，2个InputField关联到脚本文件的receivedText和sendText变量。
最终配置如下：
![unity04](/media/images/2015/unity04.jpg)

![unity05](/media/images/2015/unity05.jpg)

![unity06](/media/images/2015/unity06.jpg)

![unity07](/media/images/2015/unity07.jpg)

7、Unity选择File->build settings->android->player settings,右边设置 Bundle Identifiery为Jar包名。
![unity08](/media/images/2015/unity08.jpg)

8、然后执行Build And Run，真机测试！
![unity09](/media/images/2015/unity09.png)

![unity10](/media/images/2015/unity10.png)

![unity11](/media/images/2015/unity11.png)

![unity12](/media/images/2015/unity12.png)

![unity13](/media/images/2015/unity13.png)
