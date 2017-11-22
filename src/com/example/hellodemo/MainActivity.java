package com.example.hellodemo;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.widget.TextView;

/**
 * Created by tong on 17/9/29.
 */
public class MainActivity extends Activity {
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        TextView tv = (TextView)findViewById(R.id.tv);
        int index = 1;
        for (int i = 2; i <= 50000; i++) {
            try {
                Class.forName("test.Test" + i);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                break;
            }

            index ++;
        }


        tv.setText("Api" + Build.VERSION.SDK_INT  + " ,总共有" + (BuildConfig.MAX_CLASSES_N_DEX + 1) + "个classesN.dex ,加载了" + (index + 1) + "个classesN.dex");
    }
}
