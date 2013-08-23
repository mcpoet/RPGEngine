//
//  RE_AttributeFunctioner.h
//  CocosPractice
//
//  Created by  on 12-6-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_AttributeController.h"

@interface RE_AttributeFunction : NSObject
{
    NSString *formul;
    NSDictionary*args;
    // ASt nester
    // 找一种适合存放AST的结构，大概一个硬编码的数组就可以了。
}

-(void) interpreFunc;

@end

@interface RE_AttributeFunctioner : RE_AttributeController

- (id) initWithInt:(int)value
         withCycle:(int)cycle 
        withParams:(id)params;

//- (Boolean) runwithValue:(NSNumber*)newValue;
- (Boolean) run;
//- (void) runOnce:(NSNumber*)once;
@end
