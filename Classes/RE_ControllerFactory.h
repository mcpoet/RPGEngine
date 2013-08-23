//
//  RE_ControllerFactory.h
//  RPG_Engine
//
//  Created by  on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_AttributeController.h"

enum controllertype 
{
    ordinary =0,
    locker = 1,
    bumpper = 2,
    incrementer =3,
    piper = 4,
    functer = 5
};

typedef enum controllertype RE_ControllerType;

@interface RE_ControllerFactory : NSObject
{
    
}
+ (RE_AttributeController*) makeController:(RE_ControllerType)tpye withCycle:(int)cycle withValue:(int)value withParams:(id)params;

@end
