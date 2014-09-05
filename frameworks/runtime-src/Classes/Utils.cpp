//
//  Utils.cpp
//  FlipBlocks
//
//  Created by Eleven Chen on 14-9-4.
//
//

#include "Utils.h"
#include "AppMacro.h"
using namespace cocos2d;

#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#include "android/log.h"
#include "platform/android/jni/JniHelper.h"
#include <string>

void Utils::rateApp()
{
    JniMethodInfo minfo;	// 定义Jni函数信息结构体
    // 无参数
    bool isHave = JniHelper::getStaticMethodInfo(minfo, CLASS_NAME, "rateApp", "()V");
    if (!isHave) {
        CCLOG("jni: rateApp 不存在");
    } else {
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
    CCLOG("jni-java 执行完毕");
}
void Utils::takeScreenshot()
{
	/*
    Size size = Director::getInstance()->getWinSize();
    RenderTexture* texture = RenderTexture::create((int)size.width, (int)size.height);
    texture->setPosition(Point(size.width, size.height));
    texture->begin();
    Director::getInstance()->getRunningScene()->visit();
    texture->end();
    if (texture->saveToFile("screenshot.png", kCCImageFormatPNG)){
        CCLOG("screen captured");
    }
    CC_SAFE_DELETE(texture);
    */
    JniMethodInfo minfo;	// 定义Jni函数信息结构体
    // 无参数
    bool isHave = JniHelper::getStaticMethodInfo(minfo, CLASS_NAME, "share", "()V");
    if (!isHave) {
        CCLOG("jni: share 不存在");
    } else {
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
    CCLOG("jni-java 执行完毕");
}
#else
void Utils::rateApp()
{
    
}
void Utils::takeScreenshot()
{
    
}
#endif