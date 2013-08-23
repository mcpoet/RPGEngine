//
//  RE_SpriteFactory.m
//  RPG_Engine
//
//  Created by  on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_SpriteFactory.h"

@implementation RE_SpriteFactory
static NSMutableDictionary* _pool;
static NSMutableDictionary* _cache;

+ (void) buildFactory:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:filename];
    _pool = 
    [[NSMutableDictionary alloc] 
     initWithContentsOfFile:finalPath];
}

+ (RE_Spirit*) make:(NSString *)name
{
    RE_Spirit* itm = [_cache valueForKey:name];
    if(itm!=nil)
        return itm;
    NSDictionary* raw = [_pool valueForKey:name];
    itm = [[RE_Spirit alloc]initWithDict:raw];
    [_cache setObject:itm forKey:name];
    return itm;
}
@end
