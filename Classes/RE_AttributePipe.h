//
//  RE_AttributePipe.h
//  RPG_Engine
//
//  Created by  on 12-5-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_AttributeController.h"

@interface RE_AttributePipe : RE_AttributeController
{
    RE_Object*host;
    NSString* sourceAttribute;
    NSNumber* cache;
//    希望这两个参数能用上；
    NSNumber* factor;
    NSNumber* offset;
//    希望这个参数也能用上；
    SEL  computee;
}

- (RE_AttributeController*) initWithInt:(int)value
                              withCycle:(int)cycle 
                             withParams:(id)params;
//- (Boolean) runwithValue:(NSNumber*)newValue;
//- (Boolean) run;
//- (void) runOnce:(NSNumber*)once;
//- (NSNumber*) update:(RE_Object *)object;
//- (NSNumber*) update:(RE_Object *)object 
//           withValue:(NSNumber *)object;
@end
