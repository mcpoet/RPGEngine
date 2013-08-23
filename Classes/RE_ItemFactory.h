//
//  RE_ItemFactory.h
//  RPG_Engine
//
//  Created by  on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_item.h"

// 鉴于Item和CHaracter一样可能会关联剧情
// 
@interface RE_ItemFactory : NSObject
{
    NSMutableDictionary* _itempool;
    NSMutableDictionary* _itemcache;
    
}
+ (RE_ItemFactory*) getInstance;

- (RE_ItemFactory*) buildFactory:(NSString*)filename;
+ (RE_Item*) make:(NSString*)name;
@end
