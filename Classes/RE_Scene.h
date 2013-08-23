//
//  RE_Scene.h
//  RPG_Engine
//
//  Created by  on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

// 确定好 Scene、Character&Items和World之间的关系，
// 是一个游戏引擎主要的架构观。
// 确定好每个Scene中的对话、剧情脚本，是引擎的内容观。

// 此处我们要设置一个抽象的RE_Scene类，
// 例如北欧女神这种作品，Scene是一个背景图加一堆碰撞用的图形。
// 而不是我们想象的MapTiles
// 因此，Scene的变化可能会比较大，也就是有比较多的分岔SubClass

// 另外把作战场景和对话场景也归到这个类里面了，
// 分别SubClass之
//
/*
 在此，我们选用比较经典的棋盘模式来实现战斗场景，即battle scene
 因此，scene中要包含一个character和位置的映射表
 和相应的查询函数，
 剩下的，可能就是背景图了，就这么简单。
 */
#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RE_AttributeUpdator.h"

@interface RE_Scene : NSObject <RE_AttributeUpdator>

{
//   核心数据结构需要实现一个快速定位的功能，
//   即是根据位置找到对应的对象。
//   用这个数据结构的话，同一个位置上多个对象的这个问题
//   显然要用一个hashmap了
//   我们决定使用一个奢侈的方法，就是一个数组来做一个稀疏矩阵
//   贫抠的方法是使用两个数组来做成字典。
    NSMutableArray * _sceneContainor;
    NSDictionary* _sceneMap;
//   我们可以专门准备一个位图来做快速查询
    
//   另外，我们需要肯定需要属性的信息的。
//   例如我们只有知道direction，才能确定step
//   甚至要知道我们打算更新的step值，才能返回是否能更新成功。
//   要把这些信息封装成数据包或者指定的接口来作。
    
//   每个Updator都要有的数据结构？
    NSString* _bindAttribute;
    int row;
    int column;
    
}

// RE_AttributeUpdator
// the helper
//- (Boolean) tryUpdate:(RE_AttributeValue *)value;
- (NSNumber*) tryUpdate:(NSNumber *)value withDelta:(NSNumber *)delta;
- (NSNumber*) tryUpdate:(NSNumber *)value withValue:(NSNumber *)delta;

// Collide Event 需要这个接口么？
// - (void) collid

// 返回某个位置上的对象集合：角色和道具。
- (RE_Object*) getObjectAtX:(int)x AtY:(int)p;

- (NSArray*) SceneQuery:(int)row:(int)column;

// 返回某个位置的上的角色是否可以向某个方向做特定方式的移动
- (Boolean) SceneMovementQuery:(CGPoint*)pos
                              :(CGPoint*)move
                              :(NSConstantString*)type;

// 我们假定，world加载是游戏的起点，
// 而world加载基本上一不同级别的scene的加载，
// 因此SceneLoad是个很重要的接口。
// 一种情况是从数据库加载（最普遍）
// 一种情况是从文件加载（xml有爱）
// 先考虑一个plist接口咯。
- (void) setupScene:(NSArray*)containor;
- (RE_Scene*) initScene;

@end
