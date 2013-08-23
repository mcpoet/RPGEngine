//
//  RE_ControllerTemplate.h
//  RPG_Engine
//
//  Created by  on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_AttributeController.h"
@interface RE_ControllerTemplate : NSObject
{
    int type;
    int cycle;
    int value;
    id data;
    RE_AttributeController* cache;
    BOOL invalid;
}

//+ (RE_AttributeController*) make:(NSDictionary*)data;
- (RE_AttributeController*) maker;

@end
