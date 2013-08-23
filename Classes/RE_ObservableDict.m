//
//  RE_ObservableDict.m
//  SimpleBox2dScroller
//
//  Created by  on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_ObservableDict.h"

@implementation RE_ObservableDict

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey
{
    
    BOOL automatic = NO;
    
    return automatic;
}

-(void) setValue:(id)value forKey:(NSString *)key
{
    [self willChangeValueForKey:key];
    {
        [super setValue:value forKey:key];
    }
    [self didChangeValueForKey:key];
    
}

- (void) addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath 
{
    [self addObserver:observer 
           forKeyPath:keyPath 
              options:0 
              context:self
     ];
}
@end
