
//
//  RE_ControllerTemplate.m
//  RPG_Engine
//
//  Created by  on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_ControllerTemplate.h"
#import "RE_AttributeController.h"
#import "RE_ControllerFactory.h"

// 封装创建controller的参数，
// 以及自创建的功能。。。

// 理论上，我们希望controller有两种状态，
// 一种是数据态，一种是代码态，
// 就在此基础上封装一下就好
@implementation RE_ControllerTemplate

- (RE_AttributeController*) maker
{
    if (!invalid && cache!=nil) 
    {
        return cache;
    }
    cache = [RE_ControllerFactory makeController:type 
                                      withCycle:cycle
                                      withValue:value
                                     withParams:data];
    return cache;
}

@end
