//
//  RE_Observer.m
//  SimpleBox2dScroller
//
//  Created by  on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_EntityObserver.h"

@implementation RE_EntityObserver

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    //    if ([keyPath isEqual:@"myValue"]) 
    NSDictionary* d = (__bridge NSDictionary*) context;
    NSLog(@"We observed the key: %@",keyPath);
    {
        NSString* new =  [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"We observed the value: %@",new);
        NSString* f = [d valueForKey:keyPath];
        NSLog(@"We observed the context value: %@",f);
        
    }
    /*
     Be sure to call the superclass's implementation *if it implements it*.
     NSObject does not implement the method.
     */
    //    [super observeValueForKeyPath:keyPath
    //                         ofObject:object
    //                           change:change
    //                          context:context];
}

@end
