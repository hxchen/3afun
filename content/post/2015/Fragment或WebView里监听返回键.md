---
title: "Fragment或WebView里监听返回键"
date: 2015-04-24T19:11:00+08:00
draft: false
tags: ["Android"]
categories: ["Android"]
author: "北斗"
---
思路主要是在onResume事件里处理按钮事件并进行判断。

如果使用了WebView则在onKey里处理返回按钮事件。

```
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.RadioButton;

/**
 * Created by Administrator on 2015/4/10.
 */
public class PostFragment extends Fragment{
    View rootView = null;
    WebView webViewForPost = null;
    //RadioButton radioButtonToPostList = null;

    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        rootView = inflater.inflate(R.layout.post_layout, container, false);
        webViewForPost = (WebView) rootView.findViewById(R.id.webViewForPost);
        int index = Integer.valueOf(getArguments().get("index").toString());
        String strategy = "strategy"+(index+1)+".html";
        webViewForPost.loadUrl("file:///android_asset/"+strategy);

        webViewForPost.setOnKeyListener(new View.OnKeyListener() {

            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (event.getAction() == KeyEvent.ACTION_DOWN) {
                    if (keyCode == KeyEvent.KEYCODE_BACK ) {
                       //这里处理返回键事件
                    }
                }
                return false;
            }
        });
        return rootView;
    }


    @Override
    public void onResume() {
        super.onResume();
        getView().setFocusableInTouchMode(true);
        getView().requestFocus();
        getView().setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {

                if (event.getAction() == KeyEvent.ACTION_UP && keyCode == KeyEvent.KEYCODE_BACK){
                    //这里处理返回事件
                }
                return false;
            }
        });
    }

}
```