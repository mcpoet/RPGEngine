//
//  RE_Spirit.h
//  RPG_Engine
//
//  Created by  on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// 这个类更好的一个名字叫做 RE_Puppet
// 因其主要的作用是按照指令执行动作
// 没有太多的自主权

// 一个更高级的方法是，有Collision Detection的RE_Sprite
// 一种可以接受反馈的实体。

// 对于现在的架构而言，RE_Sprite+RE_Character是可以接受
// 反馈的。

// move结构只描述一维的移动，
// 关于多维的移动，可以应用多个move来实现
//enum move_dir 
//{
//    up = 1,
//    down = 2,
//    left =3,
//    rigth = 4,
//};

//typedef enum move_dir  RE_MoveDir;
//
//struct move 
//{
//    RE_MoveDir direction ;
//    Boolean turnback;
//    int distance;
//} ;

//typedef struct move RE_Movement;
// 这个类的任务是在RPG ENgine里面作
// Cocos的代理，因此怎么粘合图形层
// 很重要。
@interface RE_Spirit : CCLayer
{
    NSString* batchNode;
    NSDictionary* actionDictionary;
//  关于动作的映射，怎么设置呢？
//  保守的办法是放在plist里面
//  
    CCSprite* sprite1;

}

// 关于参数的问题，主要是移动的距离和速度。
// 也就是一个空间一个时间的问题

- (void) actionWithDict:(NSString*)name
                       :(NSDictionary*)params;
- (NSArray*) getFrameRects:(NSString*)name;

@end
