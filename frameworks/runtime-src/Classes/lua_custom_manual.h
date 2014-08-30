//
//  lua_vibrator_manual.h
//  FlipBlocks
//
//  Created by Eleven Chen on 14-8-29.
//
//

#ifndef __FlipBlocks__lua_vibrator_manual__
#define __FlipBlocks__lua_vibrator_manual__

#ifdef __cplusplus
extern "C" {
#endif
#include "tolua++.h"
#ifdef __cplusplus
}
#endif


TOLUA_API int register_all_custom_manual(lua_State* tolua_S);

#endif /* defined(__FlipBlocks__lua_vibrator_manual__) */
