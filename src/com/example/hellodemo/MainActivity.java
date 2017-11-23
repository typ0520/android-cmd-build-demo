package com.example.hellodemo;

import android.app.Activity;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        findViewById(R.id.btn).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                testLoadClass();
            }
        });

        findViewById(R.id.btn2).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                MultiDex.install(getApplicationContext());
                testLoadClass();

                Button btn = (Button) findViewById(R.id.btn);
                btn.setEnabled(false);
            }
        });
    }

    private void testLoadClass() {
        TextView tv = (TextView) findViewById(R.id.tv);
        int index = 1;
        for (int i = 2; i <= 2000; i++) {
            try {
                Class.forName("test.Test" + i);
            } catch (Throwable e) {
                e.printStackTrace();
                break;
            }

            index ++;
        }

        tv.setText("Api" + Build.VERSION.SDK_INT + " ,加载了: " + index + "个dex");
    }
}