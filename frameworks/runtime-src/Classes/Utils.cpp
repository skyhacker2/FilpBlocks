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
void Utils::share(std::string text)
{
    JniMethodInfo minfo;	// 定义Jni函数信息结构体
    // 无参数
    bool isHave = JniHelper::getStaticMethodInfo(minfo, CLASS_NAME, "share", "(Ljava/lang/String;)V");
    if (!isHave) {
        CCLOG("jni: share 不存在");
    } else {
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, minfo.env->NewStringUTF(text.c_str()));
    }
    CCLOG("jni-java 执行完毕");
}
void Utils::showDialog(std::string okStr, std::string cancelStr, std::string title, std::string msg)
{
    CCLOG("Utils::showDialog");
    JniMethodInfo minfo;	// 定义Jni函数信息结构体
    // 无参数
    bool isHave = JniHelper::getStaticMethodInfo(minfo, CLASS_NAME, "showDialog", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
    if (!isHave) {
        CCLog("jni: vibrate 不存在");
    } else {
        jstring jokStr = minfo.env->NewStringUTF(okStr.c_str());
        jstring jcancelStr = minfo.env->NewStringUTF(cancelStr.c_str());
        jstring jtitle = minfo.env->NewStringUTF(title.c_str());
        jstring jmsg = minfo.env->NewStringUTF(msg.c_str());
        minfo.env->CallStaticVoidMethod(minfo.classID, minfo.methodID, jokStr, jcancelStr, jtitle, jmsg);
    }
    CCLog("jni-java 执行完毕");
}
// Java call c++
extern "C" {
    JNIEXPORT void JNICALL Java_org_cocos2dx_lua_AppActivity_onExitDialogConfirm
    (JNIEnv *env, jclass thiz)
    {
        EventCustom event("e_exit_game");
        Director::getInstance()->getEventDispatcher()->dispatchEvent(&event);
    }
}
#else
void Utils::rateApp()
{
    
}
void Utils::share(std::string text)
{
    
}
void Utils::showDialog(std::string okStr, std::string cancelStr, std::string title, std::string msg)
{
    
}
#endif
