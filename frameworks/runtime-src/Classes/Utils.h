//
//  Utils.h
//  FlipBlocks
//
//  Created by Eleven Chen on 14-9-4.
//
//

#ifndef __FlipBlocks__Utils__
#define __FlipBlocks__Utils__
#include "cocos2d.h"

class Utils
{
public:
    
    static void rateApp();
    
    static void share(std::string text);
    
    static void showDialog(std::string okStr, std::string cancelStr, std::string title, std::string msg);
    
};

#endif /* defined(__FlipBlocks__Utils__) */
