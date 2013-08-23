//
//  RE_AttributeValue.h
//  RPG_Engine
//
//  Created by  on 12-5-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RE_AttributeValue : NSObject 
{
    NSNumber* value;
}

- (RE_AttributeValue*) initWithData:(id)data;
- (id) getData;
//这个setter显然是要友元保护的
- (void) setData:(id)data;
- (NSString*) getType;

@end

@interface RE_CompoundAttributeValue : RE_AttributeValue
{
// 直接包一个能接受int和float的array好了
    NSArray * values;
    
    NSString* name;
}

//- (void)  addInt:(int)field;
//- (void)  addFloat:(float)field;
- (RE_CompoundAttributeValue*) initWithData:(id) data;
- (id) getData;
//友元保护撒
- (void) setData:(id)data;
- (NSString*) getType;
@end
