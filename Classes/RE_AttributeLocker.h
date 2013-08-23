//
//  RE_AttributeLocker.h
//  RPG_Engine
//
//  Created by  on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_AttributeController.h"

@interface RE_AttributeLocker : RE_AttributeController
{
    int lock_start;
    NSNumber* lock_value;
}

- (RE_AttributeController*) initWithInt:(int)value
withCycle:(int)cycle withParams:(id)params;

//- (Boolean) runwithValue:(NSNumber*)newValue;
- (Boolean) run;
//- (void) runOnce:(NSNumber*)once;

@end
