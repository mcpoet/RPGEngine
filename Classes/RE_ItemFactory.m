//
//  RE_ItemFactory.m
//  RPG_Engine
//
//  Created by  on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_ItemFactory.h"

@implementation RE_ItemFactory

static RE_ItemFactory* unique;

+ (RE_ItemFactory*) getInstance
{
    if (unique) {
        return unique;
    }
    unique = [[RE_ItemFactory alloc] buildFactory:@"items"];
    return unique;
}

- (RE_ItemFactory*) buildFactory:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:filename];
    _itempool = 
    [[NSMutableDictionary alloc] 
     initWithContentsOfFile:finalPath];
}



-(RE_Item*)make:(NSString *)name
{
    RE_Item* itm = [_itemcache valueForKey:name];
    if(itm!=nil)
        return itm;
    NSDictionary* raw = [_itempool valueForKey:name];
    itm = [[RE_Item alloc]initWithDict:raw];
    [_itemcache setObject:itm forKey:name];
    return itm;
}
@end
