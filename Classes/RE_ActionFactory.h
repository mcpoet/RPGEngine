//
//  RE_ActionFactory.h
//  RPG_Engine
//
//  Created by  on 12-5-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_Action.h"

@interface RE_ActionFactory : NSObject
{
    NSMutableDictionary* _data;
}

+ (void) buildFactory:(NSString*)filename;
+ (RE_Action*) make:(NSString*)name;
@end
