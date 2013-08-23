//
//  RE_AttributeFunctioner.m
//  CocosPractice
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_AttributeFunctioner.h"
@implementation RE_AttributeFunction
-(void) interpreFunc
{
    // 实现词法和语法分析，最终的结果保存到AST Nester
    // 之后每次执行AST Nester即可。
    // 自然是需要各种helpper的。
}

@end

@implementation RE_AttributeFunctioner

-(id) initWithInt:(int)value 
        withCycle:(int)cycle 
       withParams:(id)params
{
    // 是这么写嘛。。。
    if([super init]==nil)return nil;
    NSDictionary* paras = (NSDictionary*)params;
    NSString* formula= [paras valueForKey:@"formula"];
    NSDictionary* arguements = [paras valueForKey:@"arguements"];
    
    
    return self;
    
}

@end

