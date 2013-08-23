//
//  RE_ActionV2.h
//  SimpleBox2dScroller
//
//  Created by  on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "RE_AttributeController.h"
#import "RE_ControllerFactory.h"
#import "RE_Entity.h"
/*
 RE_Action 实现了一个角色的动作，
 这个动作包含Model和View两个方面，
 View上就是可能播放的动画，
 Model上就是会影响攻受双方的数值。
 因此就是skill和spriteAction的打包。
 
 在此，RE_Action充当了Attribute Controller的角色
 可以绑定到一个或者一组Attribute，可以对其进行粒子
 
 */

/*
 action实现了两个作用，角色本身的数值操作封装
 和，对目标角色的数值操作封装。
 对于后者，我们发现，可以使用相同的实现方法，
 即，安装，再运行，只不过这种controller的life只有一个cycle一般情况下。
 这种pattern我们可以把0 cycle的controller或者是
 只运行一次的action放到一个cache里面，稍后再用。
 */

@class RE_ActionFactory;

@protocol RE_Computus <NSObject>
@required
-(NSNumber*) computeOn:(RE_Entity*)host;
@optional
-(id<RE_Computus>) copy:(id<RE_Computus>)copee;
-(id) getLastResult;
@end

@interface RE_ActionFormular : NSObject<RE_Computus> {
    NSString* expression;
    NSArray* operStack;
    NSArray* valueStack;
    int timer;
    
}
- (float) binaryPlus:(float)pluser Plusee:(float)plusee;
- (float) binaryMinus:(float)minus Minusee:(float)minusee;
- (float) binaryTime:(float)time Timee:(float)timee;
- (float) binaryDivide:(float)divide Dividee:(float)dividee;
// 对以下两种操作暂时标识战抖。。。
- (float) condition;
- (float) looper;
- (void) compile;

// @protocol RE_Computus
- (int) computeOn:(RE_Entity*)host;
- (id<RE_Computus>) copy:(id<RE_Computus>)copee;
- (id) getLastResult;
@end

@interface RE_OnePassCompulector : NSObject<RE_Computus> 
{
    // Indexed values or named values may be both 
    // provided to the Selector
    NSArray* arguements;
    NSDictionary* attributes;
    
    SEL computor;
    NSNumber* fltProduct;
}

-(id) initWithSelector:(SEL)selector dictNames:(NSArray*)keys;
-(id) initWithSelector:(SEL)selector;
// @protocal RE_Computus
- (NSNumber*) computeOn:(RE_Entity *)host;
- (id) getLastResult;

@end

@interface RE_TwoPassCompulector : NSObject<RE_Computus> 
{
    // Indexed values or named values may be both 
    // provided to the Selector
    NSDictionary* parameters;
    NSArray* attributes;
    int pass;
    SEL computor;
    NSNumber* fltProduct;
}

-(id) initWithSelector:(SEL)selector parameters:(NSDictionary*)params;
// @protocal RE_Computus
- (NSNumber*) computeOn:(RE_Entity *)host;
-(id<RE_Computus>) copy:(id<RE_Computus>)copee;
- (id) getLastResult;

@end

@interface RE_Action : NSObject
{
    NSString* _name;
    //Actually the [formulas allvalues]
    // forms an array of formulas, and so forth
    // formulate a MATRIX for everyrow is the formular operations and params
    // and the RE_Entity attributes forms the input column, which result in
    // a result columns whose attribute names correspond to the [formulas allkeys]
    
    // Annoying fact is that cross-computu dependency may exist, for part of the
    // computus may failed due to previous attribute updates as we update the 
    // attribute after each computu computed.
    NSMutableDictionary* _computus;  
    
}
@property (retain,readwrite) NSDictionary* computus;

- (id) initWithComputus:(NSDictionary*)computus andName:(NSString*)actname;
// 非及物动作
- (RE_Action*) run;

// Some Modifitions on the computus are currently allow.
- (BOOL) setComputu:(id<RE_Computus>)computu withName:(NSString*)name;

// factory
+ (RE_Action*) make:(NSString*)name;

@end
