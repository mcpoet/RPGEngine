//
//  RE_item.h
//  RPG_Engine
//
//  Created by  on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_Object.h"

@interface RE_Item : RE_Object
{
    int count;//物品的数量
    int cost;// 单个物品的价钱/价值
    
}

@end
