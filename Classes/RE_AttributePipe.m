//
//  RE_AttributePipe.m
//  RPG_Engine
//
//  Created by  on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_AttributePipe.h"

@implementation RE_AttributePipe

- (RE_AttributeController*) initWithInt:(int)value 
withCycle:(int)cycle withParams:(id)params
{
    NSDictionary* d = params;
    sourceAttribute = [d valueForKey:@"attribute_name"];
    host = [d valueForKey:@"host"];
    if (!sourceAttribute  || !host) {
        return  nil;
    }
    _value=value;
    _life = cycle;
    return self;
}

//- (NSNumber*) update:(RE_Object *)object
//{
//    NSNumber* a = [object readAttribute:source];
////    computee确实可以这么用的亲
//    if (computee) {
//        a=[self performSelector:computee 
//                   withObject:a ];
//    }
//    if (life--) {
//        NSNumber* d = 
//        [object updateAttribute:target withValue:a];
//        return d;
//    }
//    return nil;
//}
@end
