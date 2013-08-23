//
//  RE_AttributeValue.m
//  RPG_Engine
//
//  Created by  on 12-5-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_AttributeValue.h"

@implementation RE_AttributeValue

- (RE_AttributeValue*) initWithData:(id)data
{
    //assert (data is classof NSNumber);
    value = (NSNumber*) data;
    return self;
}
- (id) getData
{
    return value;
}

- (void) setData:(id)data
{
    value = data;
}

- (NSString*) getType
{
    return @"simple";
}
@end

@implementation RE_CompoundAttributeValue

//- (void) addInt:(int)field
//{
////    这样放进去很蛋疼，总是要封装那么一下下
//    NSNumber* o = [[NSNumber alloc]initWithInt:field];
//    [values addObject:o];
//}
//
//- (void) addFloat:(float)field
//{
//    NSNumber* o = [[NSNumber alloc]initWithFloat:field];
//    [values addObject:o];
//}

- (RE_CompoundAttributeValue*) initWithData:(id)data
{
     // assert(data is classof(NSArray));
    values = (NSArray*) data;
    return self;
    
}

- (id) getData{
    return values;
}

- (void) setData:(id)data
{
    //assert class of data is NSArray
    values=data;
}

- (NSString*) getType
{
    return @"Compound";
}
@end
