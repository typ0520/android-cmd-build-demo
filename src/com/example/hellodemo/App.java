package com.example.hellodemo;

import android.app.Application;
import android.content.Context;

/**
 * Created by tong on 2017/11/22.
 */
public class App extends Application {

    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        //MultiDex.install(base);
    }
}
