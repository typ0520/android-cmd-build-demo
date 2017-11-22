package com.example.hellodemo;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.widget.TextView;
import com.example.hellodemo.R;


public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView tv = (TextView) findViewById(R.id.tv);
        int index = 1;
        for (int i = 2; i <= 1000; i++) {
            try {
                Class.forName("test.Test" + i);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                break;
            }

            index ++;
        }

        tv.setText("Api" + Build.VERSION.SDK_INT + " ,加载了: " + index + "个dex");
    }
}
