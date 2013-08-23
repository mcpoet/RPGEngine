//
//  RE_GridScene.h
//  CocosPractice
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
// This is part of the game called navigation!
// There is actually three part of an RPG game:
// (1) Dialogs
// (2) Scene Lounge
// (3) Scene Battle 
// So the navigation part belongs to the Scene Loung part.

#import <Foundation/Foundation.h>
#import "RE_Character.h"

@interface RE_GridScene : NSObject
{
    NSArray* tileMap;
    NSArray* itemsInPos;
    NSArray* bitMasks;
}

- (void) navigateTo:(int)x Y:(int)y Bear:(RE_Object*)bear;

// This method was called when some character try to entry
// some pos in the scene where positioned another item/character
// already
- (void) visitPos:(int)x Y:(int)y Visitor:(RE_Object*)host;

// Before this was called we have to assert the visitor is at the door
// i.e. somewhere in the neighbourhood
- (void) tryVisitNeighbour:(int)xDir YDir:(int)yDir;

// For short distance attacking
- (void) tryAttackNeighbour:(int)xDir YDir:(int)yDir;


@end
