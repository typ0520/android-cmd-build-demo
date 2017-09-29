```
git clone https://github.com/typ0520/android-cmd-build-demo.git
cd android-cmd-build-demo
sh build.sh
adb install -r bin/app-debug.apk
adb shell am start com.example.hellodemo/com.example.hellodemo.MainActivity
```