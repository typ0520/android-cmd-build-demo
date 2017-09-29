#!/bin/bash

COMPILE_VERSION=android-23
if [ -d gen ];then
	rm -rf gen
fi
if [ -d bin ];then
	rm -rf bin
fi
mkdir gen
mkdir bin

#生成R文件
aapt package -f -m -J ./gen -S res -M AndroidManifest.xml -I $ANDROID_HOME/platforms/$COMPILE_VERSION/android.jar
#生成资源索引文件
aapt package -f -M AndroidManifest.xml -S res -I $ANDROID_HOME/platforms/$COMPILE_VERSION/android.jar -F bin/resources.ap_  
#编译java文件
javac -encoding UTF-8 -g -target 1.7 -source 1.7 -cp ${ANDROID_HOME}/platforms/$COMPILE_VERSION/android.jar -d bin src/com/example/hellodemo/*.java gen/com/example/hellodemo/R.java
#生成dex文件
dx --dex --output=bin/classes.dex bin/
#打包apk
sdklib_jar=$(ls $ANDROID_HOME/tools/lib | grep ^sdklib | grep .jar$)
java -cp $ANDROID_HOME/tools/lib/$sdklib_jar com.android.sdklib.build.ApkBuilderMain bin/app-debug-unsigned.apk -v -u -z bin/resources.ap_ -f bin/classes.dex -rf src
#把assets的内容加进去
aapt add -f bin/app-debug-unsigned.apk assets/xieyi.txt
#签名
java -jar auto-sign/signapk.jar auto-sign/testkey.x509.pem auto-sign/testkey.pk8 ./bin/app-debug-unsigned.apk ./bin/app-debug.apk