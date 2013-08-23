//
//  RE_GridScene.m
//  CocosPractice
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_GridScene.h"

@implementation RE_GridScene

//- (NSArray*) navigateTo:(int)x Y:(int)y Bear:(RE_Object *)bear
//{
//    int bX = [bear:positionX];
//    int bY = [bear:positionY];
//    NSArray* AstartPath = [self astar:x Y:y fX:bX fY:bY];
//    return AstartPath;
//}

- (void) visitPos:(int)x Y:(int)y Visitor:(RE_Object *)host
{
    if ([itemsInPos objectAtIndex:x*y]) {
        RE_Object* i = [itemsInPos objectAtIndex:x*y ];
        [i onVisit:host];
    }
}

@end
