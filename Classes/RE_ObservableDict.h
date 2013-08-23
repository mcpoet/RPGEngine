//
//  RE_ObservableDict.h
//  SimpleBox2dScroller
//
//  Created by  on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RE_ObservableDict : NSMutableDictionary

-(void) setValue:(id)value forKey:(NSString *)key;
+(BOOL) automaticallyNotifiesObserversForKey:(NSString *)theKey;

-(void) addObserver:(NSObject *)observer 
          forKeyPath:(NSString *)keyPath; 
@end
