//
//  RE_ActionFactory.m
//  RPG_Engine
//
//  Created by  on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_ActionFactory.h"
#import "RE_DataAgent.h"

static NSMutableDictionary* _pool;
static NSMutableDictionary* _cache;

@implementation RE_ActionFactory



+ (void) buildFactory:(NSString *)filename
{
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString* docDir = [paths objectAtIndex:0];
//    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSString *finalPath = [path stringByAppendingPathComponent:filename];
//    _pool = 
//    [[[NSMutableDictionary alloc] 
//      initWithContentsOfFile:finalPath] valueForKey:@"actions"];
    NSMutableDictionary* tmp = [[RE_DataAgent sharedAgent] 
                                getMutableDictFromFile:filename];
    _pool = [tmp valueForKey:@"actions"];
    
}

+ (RE_Action*) make:(NSString *)name
{
    RE_Action* itm = [_cache valueForKey:name];
    if(itm!=nil)
        return itm;
    NSMutableArray* action = [_pool valueForKey:name];
    itm = [[RE_Action alloc]initWithArray:action withName:name];
    [_cache setObject:itm forKey:name];
    return itm;
    
}

@end
