//
//  AdManager.cpp
//  SnakeGameLua
//
//  Created by Eleven Chen on 14-8-21.
//
//

#include "AdManager.h"
#include "AppMacro.h"

using namespace cocos2d;
using namespace std;


AdManager *g_adManager = nullptr;

AdManager* AdManager::getInstance()
{
    if (g_adManager == nullptr)
    {
        g_adManager = new AdManager();
    }
    return g_adManager;
}

void AdManager::destroyInstance()
{
    CC_SAFE_DELETE(g_adManager);
}
// Android平台
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#include "android/log.h"
#include "platform/android/jni/JniHelper.h"
#include <string>

void AdManager::showAds()
{
    CCLOG("AdManager::showAds()");
	JniMethodInfo minfo;	// 定义Jni函数信息结构体
	// 无参数
	bool isHave = JniHelper::getStaticMethodInfo(minfo, CLASS_NAME, "showAds", "()V");
	if (!isHave) {
		CCLog("jni: showAds 不存在");
	} else {
		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
	}
	CCLog("jni-java 执行完毕");

}

void AdManager::hideAds()
{
    CCLOG("AdManager::hideAds()");
	JniMethodInfo minfo;	// 定义Jni函数信息结构体
	// 无参数
	bool isHave = JniHelper::getStaticMethodInfo(minfo, CLASS_NAME, "hideAds", "()V");
	if (!isHave) {
		CCLog("jni: hideAds 不存在");
	} else {
		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
	}
	CCLog("jni-java 执行完毕");
}

void AdManager::showWall()
{
    CCLOG("AdManager::showWall()");
    JniMethodInfo minfo;
    // 无参数
    bool isHave = JniHelper::getStaticMethodInfo(minfo, CLASS_NAME, "showWall", "()V");
    if (!isHave) {
        CCLog("jni: showWall 不存在");
    } else {
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
    }
    CCLog("jni-java 执行完毕");
}

#endif

// iOS平台
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
void AdManager::showAds()
{
    
}

void AdManager::hideAds()
{
    
}

void AdManager::showWall()
{
    
}

#endif