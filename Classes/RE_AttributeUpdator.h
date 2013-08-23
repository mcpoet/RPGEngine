//
//  RE_AttributeUpdator.h
//  RPG_Engine
//
//  Created by  on 12-5-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RE_Object;
// 此处的updator被限定为只能绑定一个属性的值
@protocol RE_AttributeUpdator <NSObject>

@optional
- (NSNumber*) tryUpdate:(RE_Object*)value 
            withDelta:(NSNumber*)delta;

- (NSNumber*) tryUpdate:(RE_Object *)value 
            withValue:(NSNumber *)value;


// 需要一个初始化接口，具体没想好呢。
//- (void)   init;
- (NSNumber*) initWithInitiator:(id)controller;
@end
