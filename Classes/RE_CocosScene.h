//
//  RE_CocosScene.h
//  CocosPractice
//
//  Created by  on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "libs/cocos2d/cocos2d.h"
#import "RE_Character.h"

@interface RE_CocosScene : CCLayer
{
//    存放RE_Characters
    NSMutableDictionary* container;
//    角色被放进来时的位置
    CGPoint entry;
    
//  临时的变量，用来表示当前场景里可以被玩家控制的角色
//  那么，其实其它的角色也是需要驱动源的，稍后解决。
    RE_Character* _curCharacter;
    
}

- (void) messageRelay:(RE_Msg*)msg;
- (void) addCharacter:(RE_Character*)character 
                atPos:(CGPoint*)pos;

- (id) init;
// -(id) initWithCharacterName:(NSString*)name;
+ (CCScene*) scene;

// 临时的接口,factory
- (void) genCharacter:(NSString*)name;
@end
