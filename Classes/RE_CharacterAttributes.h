//
//  RE_CharacterAttributes.h
//  RPG_Engine
//
//  Created by  on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_AttributeUpdator.h"

//!!!!!!
//THis CLass would change name to RE_Attribute LAter

// 属性的类型，比如简单的int、float、string等等都叫做简单数据类型吧
// 另外一类就是复合类型
// 一个关键的问题是这两类属性的初始化方法和途径。
@class RE_AttributeController;
@interface RE_CharacterAttribute : NSObject
{
    // 稍后把下面两个字段合到一个32位的Flags里面
    Boolean _lockable;
    Boolean _locked;
    // controller 可能是一个集合 controllers
//    针对一个属性可能有很多的controller的话，
//    那模型是足够灵活了。
//    然后我们可以执行一个queue了。
    id _controller;
    
//    单独封装一个类是为了封装复合值，例如数组和集合。
//    RE_AttributeValue* value;
//    为了坚持使用NSNumber，我们尝试使用
    
//    带依赖的属性更新方式，就是两个或更多属性
//    依次更新，如果其中一个失败，整个属性组都失败了。
//    还有无序式更新，即其中一个失败所有都失败
//    最后就是无依赖更新了，各属性更新自己的。
    
//    依然谈这个walk的动作，实际上walk动作要操作的属性
//    是direction和step，但是这两个属性显然是和position
//    属性耦合的；那么问题就可以描述如下：
//    我们需要一个属性组的概念来讲此二属性打包到一起来更新
//    最核心的问题在于，此二属性的更新是有顺序的，或者叫依赖
//    就是direction要先更新，之后才是step
//    因此，两者的更新有这样的约定，
//    （1）同时更新，即打包更新。
//    （2）顺序更新，先更新direction
//    （3）position属性会同时被同步更新。
//    同时，可以举一反三的做出更多类似的模型，比如无序打包，等等。
    
//  还是觉得，用这个封装不如用一种更平摊的方式来处理。。
//  例如上文提到的。。
//  子类不会继承吧
    @private
//    RE_AttributeValue* _value;
    float _value;
    id var;
//  可能存在的依赖属性，可以有多个
//  考虑一下防止循环依赖
//  Array<NSString*>
//  之后用NSString来查询属性的更新情况
    NSMutableArray* _depends;
    
    
    @public
    Boolean hasUpdator;
//  用来更新依赖
    Boolean updated;
//  可能会有很多个updator么？完全可能，但是接口只能有一个
//  可以把这些updator打个包神马的
    id<RE_AttributeUpdator> updator;
//    那么controller和updator的关系如何呢？
//    controller是character自己的，可能不会涉及到别的object
//    而updator是用于互动的设置器，可能要有一个来回计算的周期
//    其中层次也不通，controller在外面，updator在里面，
//    如果对于updatable的属性，每一个set操作都需要通过updator
//    来执行setter
    
//    另外考虑在Character级别设置跨Attribute级别的Controller
//    称之为AttributesController。
    
//    两个重要的结构，每次set的时候都要刷新这两个结构
//    Controllers
//    那么Controllers需要分级别么？
//    如果要分的话，只能先放到Controller内部了。
    NSMutableArray* controllers;
//    Listeners
    
}

@property (readwrite) Boolean lockable;
@property (readwrite) Boolean locked;

//@property (assign,atomic) id controller ;

// Lockers
- (Boolean) lock;
- (Boolean) unlock;
// Controllers
- (Boolean) hasController;
- (void) runControllers;
- (void) addController:(RE_AttributeController*)controller;
//- (void) addController:(RE_AttributeController*)controller
//              withName:(NSString*)name;
- (void) unsetController;

// Listeners
- (BOOL) hasListener;
- (void) runListeners;
- (void) addListener:(id)listener withName:(NSString*)name;
- (void) removeListener:(NSString*)name;
- (void) clearListeners;
- (id) popListener;
- (void) pushListener:(id)listener;

// 有updator的话这个setter就没什么用了
- (Boolean) setValue:(float)value;
- (Boolean) updateWithDelta:(float)delta;

// 这个构造器比较诡异。。。
- (id) initWithUpdator:(id<RE_AttributeUpdator>*)Updater;

//- (id) initWithValue:(RE_AttributeValue*)Value;

//- (id) initWithInt:(int)Int;
- (id) initWithFloat:(float)Float;
//- (id) initWithNSArray:(NSArray*)array;
- (id) initWithFloat:(float)value
         withDepends:(NSArray*)depends;
- (id) initwithLockable:(BOOL)lockable andValue:(float)value;

// 暂时不准备String类型。
//- (id) initWithString:(NSString*)string;

// 暂时先用NSNumber？
- (NSNumber*) getValue;
-(float) getFloatValue;

+ (RE_CharacterAttribute*) make:(NSDictionary*)data;

@end
