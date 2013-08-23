//
//  RE_CocosSpirit.h
//  RPG_Engine
//
//  Created by  on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RE_Object.h"

// move结构只描述一维的移动，
// 关于多维的移动，可以应用多个move来实现
enum move_dir 
{
    up = 1,
    down = 2,
    left =3,
    rigth = 4,
};

typedef enum move_dir  RE_MoveDir;

struct move 
{
    RE_MoveDir direction ;
    Boolean turnback;
    int distance;
} ;

typedef struct move RE_Movement;
// 这个类的任务是在RPG ENgine里面作
// Cocos的代理，因此怎么粘合图形层
// 很重要。

// 对于其参数的处理考虑先把默认值放到plist之后加载到dictionary里面
// 使用的时候先从参数diction里面找，找不到再使用默认值。

// 具体使用哪些参数视需求慢慢扩展了。

@interface RE_CocosSpirit : NSObject 
{
    NSString* sheetPath;
    
    NSMutableDictionary* actionDictionary;
//  关于动作的映射，怎么设置呢？
//  保守的办法是放在plist里面

    CCSpriteBatchNode* _batch;
    CCSprite* sprite1;
    
    CGPoint position;
    
    NSDictionary* propertyList;
    
//  Diction of RE_CocosAction
    NSMutableDictionary* actionCache;
//    每个动作需要几个要素呢？
//    动作：即是动画帧，
//    移动：方向，速度，距离
//    其中，有些性质可能是被锁定的。
//    例如某些动画只能在某个／某几个朝向的时候使用
//    大概解决一下属性绑定的情况就可以
//    有的属性是可以计算的，自然就由我们来算了
    
//    对于三维的情况，倒是要简单一些了呢。。。

//    不论三维还是二维，actionCache，SpriteCache都是必要的。
//    特别是背包技能神马的，Cache就很好用了。
    
//    基本上我们是不会给Sprite绑RE_Object或RE_Character对象的
//    因为Sprite是被很多对象共用滴，可能呃
//    所以在此仅临时绑一个，稍后移到参数里
    RE_Object* _host;

}
@property (readonly) CCSprite* sprite;
@property (readwrite,retain) RE_Object* host;
@property (readonly) CCSpriteBatchNode* batch;

// debug use
//- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

// 关于参数的问题，主要是移动的距离和速度。
// 也就是一个空间一个时间的问题

- (void) actionWithName:(NSString*)name;
- (void) actionWithName:(NSString*)name
                       withParams:(NSDictionary*)params;
- (void) actionWithName:(NSString*)name
             withObject:(RE_Object*)reobj;

- (CCAction *)frameWithName:(NSString*)name;

- (RE_CocosSpirit*) initWithSheet:(NSString*)sheetName
                        withPlist:(NSString*)plistpath;
//+ (CCScene *) scene;
+ (RE_CocosSpirit*) make:(NSString*)filename;
- (NSDictionary*) offset:(CGPoint)p1:(CGPoint)p2;
@end
