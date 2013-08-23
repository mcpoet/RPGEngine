//
//  RE_AttributeController.m
//  RPG_Engine
//
//  Created by  on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_AttributeController.h"

@implementation RE_AttributeController
@synthesize retarget=_target;

- (RE_AttributeController*) initWithInt:(int)value
                              withCycle:(int)cycle 
                              withParams:(id)params
{
    _value = value;
    _life  = cycle;
//    inParams = params;
    return self;
}

// 相当于Template re-manufact
- (RE_AttributeController*) reinit:(id)params
{
//    垃圾怎么收集呢？
    RE_AttributeController* r = 
    [[RE_AttributeController alloc] initWithInt:_value withCycle:_life withParams:params];
    return  r;
}

- (void) reValue:(NSNumber *)newValue
{
    _value = [newValue intValue];
}

//- (NSNumber*) computeWithValue:(id)object
//{
//    NSNumber* d = [[NSNumber alloc]initWithUnsignedInteger:0];
//    for (NSString* s in inParams) {
//        NSNumber* g = [object getAttr:s];
//        
//    }
//    return  d;
//}

// 加锁的操作什么实现呢？
//- (Boolean) runWithValue:(NSNumber *)newValue
//{
//
//    Boolean g=false;
//    if(_life==-1 ||_life--)
//    {
//        g = [_target setValue:newValue];
//    }
//    return g;
//
//}

//- (Boolean) run
//{
//    Boolean g;
//    if(_life==-1 || _life--)
//    {
//        g = [_target updateWithDelta:[[NSNumber alloc]initWithInt:_value]];
//    }
//    if (once) {
//        _value=_restore;
//        once=NO;
//    }
//    return g;
//}

- (void) runOnce:(NSNumber *)temp
{
    once=YES;
    _restore=_value;
    _value=[temp intValue];
}

@end
