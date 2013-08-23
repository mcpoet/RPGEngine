//
//  SimpleBox2dScrollerAppDelegate.h
//  SimpleBox2dScroller
//
//  Created by min on 1/13/11.
//  Copyright Min Kwon 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface SimpleBox2dScrollerAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
