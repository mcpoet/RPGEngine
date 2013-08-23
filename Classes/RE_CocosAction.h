//
//  RE_CocosAction.h
//  CocosPractice
//
//  Created by  on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RE_Object.h"


// 只封装动作数据，具体的执行交由RE_Sprite执行
@interface RE_CocosAction : NSObject
{
//    BOOL isDirectionLocked;
//    BOOL isDistanceLocked;
//    BOOL isDurationLocked;
    
//  |0000 0(flip)0( duration)0(distance)0(direction)|
    UInt8 flags;
    int direction;
    int distance;
    float duration;
    BOOL flip;
    CCAction * movement;
    // array of CGRects
    NSArray* frameRects;
    // 维护一个志向sprite_sheet的指针
    CCSpriteBatchNode* sheet;
    CCAnimation *animation;
}
 
- (RE_CocosAction*) initWithDict:(NSDictionary*)dict withSheet:(CCSpriteBatchNode*)sheet;
// 执行动画
- (CCAction*) action;
- (CCAction*) actionWithParams:(NSDictionary*)dict;

// Factory
+ (CCAction*) make:(NSDictionary*)params;
@end
