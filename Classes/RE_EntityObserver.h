//
//  RE_Observer.h
//  SimpleBox2dScroller
//
//  Created by  on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_Entity.h"

@interface RE_EntityObserver : NSObject
{
//    RE_Entity* entity;
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context;

- (id) initWithEntity:(RE_Entity*)observee withKeyPath:(NSString*)kp;
- (id) initWithEntity:(RE_Entity*)observee withKeyPaths:(NSArray*)kp;

@end
