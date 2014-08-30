//
//  Vibrator.cpp
//  FlipBlocks
//
//  Created by Eleven Chen on 14-8-29.
//
//

#include "Vibrator.h"
#include "cocos2d.h"
#include "AppMacro.h"
using namespace cocos2d;
using namespace std;

Vibrator *g_vibrator = nullptr;

Vibrator* Vibrator::getInstance()
{
    if (g_vibrator == nullptr)
    {
        g_vibrator = new Vibrator();
    }
    return g_vibrator;
}

void Vibrator::destroyInstance()
{
    CC_SAFE_DELETE(g_vibrator);
}

// Android平台
#if (CC_TARGET_PLATFORM == CC_PLATFORM_ANDROID)
#include <jni.h>
#include "android/log.h"
#include "platform/android/jni/JniHelper.h"
#include <string>
void Vibrator::vibrate()
{
    CCLOG("Vibrator::vibrate()");
	JniMethodInfo minfo;	// 定义Jni函数信息结构体
	// 无参数
	bool isHave = JniHelper::getStaticMethodInfo(minfo, CLASS_NAME, "vibrate", "()V");
	if (!isHave) {
		CCLog("jni: vibrate 不存在");
	} else {
		minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID);
	}
	CCLog("jni-java 执行完毕");
    
}
#endif

// iOS平台
#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
void Vibrator::vibrate()
{
    
}

#endif
