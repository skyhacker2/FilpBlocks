//
//  lua_vibrator_manual.cpp
//  FlipBlocks
//
//  Created by Eleven Chen on 14-8-29.
//
//

#include "lua_custom_manual.h"
#include "cocos2d.h"
#ifdef __cplusplus
extern "C" {
#endif
#include  "tolua_fix.h"
#ifdef __cplusplus
}
#endif

#include "Vibrator.h"
#include "AdManager.h"
#include "AppMacro.h"
#include "Utils.h"

/** 显示广告
 */
static int lua_adManager_showAds(lua_State* L)
{
    if (nullptr == L)
        return 0;
    CCLOG("lua_adManager_showAds");
    AdManager::getInstance()->showAds();
    
    return 0;
}
/** 隐藏广告
 */
static int lua_adManager_hideAds(lua_State* L)
{
	if (nullptr == L)
		return 0;
	CCLOG("lua_adManager_hideAds");
	AdManager::getInstance()->hideAds();
    
	return 0;
}


/**
 * 振动手机
 */
static int lua_vibrator_vibrate(lua_State* L)
{
    if (nullptr == L)
        return 0;
    CCLOG("lua_vibrator_vibrate");
    Vibrator::getInstance()->vibrate();
    
    return 0;
}

/** 
 * 给App评分
 */
static int lua_rate_app(lua_State* L)
{
    if (nullptr == L)
        return 0;
    CCLOG("lua_rate_app");
    Utils::rateApp();
    return 0;
}

/**
 * 分享截图
 */
static int lua_share(lua_State* L)
{
    if (nullptr == L)
        return 0;
    CCLOG("lua_share");
    int argc = lua_gettop(L);
    if (1 == argc)
    {
        if (!lua_isstring(L, 1))
		{
            CCLOG("Error: 参数需要字符串");
            return 0;
        }
        const char* text = lua_tostring(L, 1);
        CCLOG("text: %s", text);
        Utils::share(text);
    }
    
    return 0;
}

/**
 * 关闭游戏
 */
static int lua_close_game(lua_State* L)
{
    if (nullptr == L)
    {
        return 0;
    }
    CCLOG("lua_close_game");
    Vibrator::destroyInstance();
    AdManager::destroyInstance();
    cocos2d::Director::getInstance()->end();
    return 0;
}


int register_all_custom_manual(lua_State* L)
{
	tolua_open(L);
	tolua_module(L, NULL, 0);
	tolua_beginmodule(L, NULL);
	tolua_function(L, "vibrate", lua_vibrator_vibrate);
    tolua_function(L, "closeGame", lua_close_game);
    tolua_function(L, "showAds", lua_adManager_showAds);
	tolua_function(L, "hideAds", lua_adManager_hideAds);
    tolua_function(L, "rateApp", lua_rate_app);
    tolua_function(L, "share", lua_share);
	tolua_endmodule(L);
	return 0;
}

