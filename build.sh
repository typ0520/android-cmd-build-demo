#!/bin/bash

#5.0 - 21 可以加载100个classesN.dex
#5.1 - 22 可以加载100个classesN.dex
#6.0 - 23 可以加载>3000个classesN.dex
#7.0 - 24 可以加载>3000个classesN.dex
#7.1 - 25 可以加载>3000个classesN.dex

MAX_CLASSES_N_DEX=110
if [ ! -d dex ];then
	mkdir dex
fi

i=2
while [[ i -le $MAX_CLASSES_N_DEX ]]; do
	#statements
	if [ ! -f "dex/classes${i}.dex" ];then
		echo "create dex/classes$i.dex"
		if [ -d temp ];then
			rm -rf temp
		fi

		mkdir -p ./temp/test
		cd ./temp/test
		echo "package test;public class Test${i} {}" >> Test${i}.java
		javac Test${i}.java
		cd ../../
		dx --dex --output=$(pwd)/dex/classes${i}.dex temp/
	fi
	let i=i+1
done


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

echo "package com.example.hellodemo;public final class BuildConfig {public static final int MAX_CLASSES_N_DEX = ${MAX_CLASSES_N_DEX};}" > gen/com/example/hellodemo/BuildConfig.java

#编译java文件
javac -encoding UTF-8 -g -target 1.7 -source 1.7 -cp ${ANDROID_HOME}/platforms/$COMPILE_VERSION/android.jar -d bin src/com/example/hellodemo/*.java gen/com/example/hellodemo/*.java
#生成dex文件
dx --dex --output=bin/classes.dex bin/
#打包apk
sdklib_jar=$(ls $ANDROID_HOME/tools/lib | grep ^sdklib | grep .jar$)
java -cp $ANDROID_HOME/tools/lib/$sdklib_jar com.android.sdklib.build.ApkBuilderMain bin/app-debug-unsigned.apk -v -u -z bin/resources.ap_ -f bin/classes.dex -rf src
#把assets的内容加进去
aapt add -f bin/app-debug-unsigned.apk assets/xieyi.txt
mv bin/app-debug-unsigned.apk ./dex
cd ./dex

i=2
while [[ -f classes${i}.dex ]] && [[ i -le $MAX_CLASSES_N_DEX ]]; do
	aapt add -f app-debug-unsigned.apk classes${i}.dex
	let i=i+1
done

mv app-debug-unsigned.apk ../bin/
cd ..
#签名
java -jar auto-sign/signapk.jar auto-sign/testkey.x509.pem auto-sign/testkey.pk8 ./bin/app-debug-unsigned.apk ./bin/app-debug.apk