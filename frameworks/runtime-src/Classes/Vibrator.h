//
//  Vibrator.h
//  FlipBlocks
//
//  Created by Eleven Chen on 14-8-29.
//
//

#ifndef __FlipBlocks__Vibrator__
#define __FlipBlocks__Vibrator__

class Vibrator
{
public:
    
    static Vibrator* getInstance();
    
    static void destroyInstance();
    
    void vibrate();
};

#endif /* defined(__FlipBlocks__Vibrator__) */
