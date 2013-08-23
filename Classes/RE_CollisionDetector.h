//
//  RE_CollisionDetector.h
//  CocosPractice
//
//  Created by  on 12-7-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

// Rise event when the character polygon collide with
// some other entity polygons
// both the two subjects will be passed through.

#import <Foundation/Foundation.h>

@interface RE_CollisionDetector : NSObject
{
    
}

//- (void) onCollide:(ShapeObject*) s1 with:(ShapeObject*)s2
- (void) onCollide:(id)s1 with:(id)s2;
@end
