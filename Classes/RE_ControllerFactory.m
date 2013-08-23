//
//  RE_ControllerFactory.m
//  RPG_Engine
//
//  Created by  on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_ControllerFactory.h"
#import "RE_AttributeController.h"

#import "RE_AttributeLocker.h"
#import "RE_AttributePipe.h"

// 这里显式的模式是很清晰而典型的
// c++模式，指定基本的参数，剩下的参数都甩到一个params里面z
@implementation RE_ControllerFactory
+ (RE_AttributeController*) makeController:(RE_ControllerType)type 
                                 withCycle:(int)cycle 
                                 withValue:(int)value 
                                withParams:(id)params
{
    switch (type) 
    {
        case ordinary:
            return 
            [[RE_AttributeController alloc] initWithInt:value 
                                              withCycle:cycle 
                                             withParams:params];
        case locker:
            return 
            [[RE_AttributeLocker alloc] initWithInt:value 
                                          withCycle:cycle 
                                         withParams:params]; 

        case piper:
            return 
            [[RE_AttributePipe alloc] initWithInt:value 
                                        withCycle:cycle 
                                       withParams:params];

//  这么写的话，基本就废了。。。
//  functionController的话，需要一个表达式和因子表，参数表的初始值和
//  循环值？统统都放在params里面了，value是没用的,cycle&params有用。
//        case functer:
//            return 
//            [[RE_AttributeFunctioner alloc] initWithInt:value withCycle:cycle withParams:params];
            
        default:
            break;
    }
    return nil;
}

@end
