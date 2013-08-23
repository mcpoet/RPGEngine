//
//  RE_AttributeLocker.m
//  RPG_Engine
//
//  Created by  on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_AttributeLocker.h"

@implementation RE_AttributeLocker

- (RE_AttributeController*) initWithInt:(int)value
withCycle:(int)cycle withParams:(id)params
{
    // 把参数名字改了吧。。。
    lock_start = value;
    _life = cycle;
    lock_value = params;
    return self;
}


- (Boolean) run
{
    if (_life==lock_start) 
    {
        return [_target lock];
    }
    else if(_life==0)
    {
        return [_target unlock];
    }
    return false;
}


//- (Boolean) runwithValue:(NSNumber *)newValue
//{
//    
//}

@end
