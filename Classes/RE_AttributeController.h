//
//  RE_AttributeController.h
//  RPG_Engine
//
//  Created by  on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_AttributeValue.h"
#import "RE_CharacterAttributes.h"

@class RE_Object;

// 其它的Bumpper之类的实现用Category
// 实现更合适一些。

@interface RE_AttributeController : NSObject
{
//    一个函数，或者函数指针
//    SEL controller;    
//    剩余的执行的周期
    boolean_t once;
////    输入参数列表 of NSString
//    NSMutableArray* inParams;
////    输出参数列表
    NSString* _target_name;
    RE_CharacterAttribute* _target;
    
    int _life;
    int _value;
    int _restore;
}
@property (readwrite,retain) RE_CharacterAttribute* retarget;

//- (NSNumber*) compute;

- (id) initWithInt:(int)value 
                              withCycle:(int)cycle 
                              withParams:(id)params;
- (RE_AttributeController*) reinit:(id)params;

- (void) reValue:(NSNumber*)newValue;
//- (NSNumber*) computeWithValue:(id)object;

- (Boolean) runwithValue:(NSNumber*)newValue;
- (Boolean) run;
- (void) runOnce:(NSNumber*)once;


@end
