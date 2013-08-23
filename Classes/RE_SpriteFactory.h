//
//  RE_SpriteFactory.h
//  RPG_Engine
//
//  Created by  on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_Spirit.h"

@interface RE_SpriteFactory : NSObject
{
    
}

+ (void) buildFactory:(NSString*)filename;
+ (RE_Spirit*) make:(NSString*)name;
@end
