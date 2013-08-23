//
//  RE_BoxScene.h
//  CocosPractice
//
//  Created by  on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//  HelloWorldScene.h
//  SimpleBox2dScroller
//
//  Created by min on 1/13/11.
//  Copyright Min Kwon 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "libs/Box2d/Box2D.h"
#import "ContactListener.h"
#import "RE_CocosActor.h"

@class RE_CocosActor;

@interface RE_BoxScene : CCLayer
{
    CGSize screenSize;
	b2World* world;
	GLESDebugDraw *m_debugDraw;
	CCTMXTiledMap *tileMapNode;	
    Player *player;
    Player *playerb;
    ContactListener *contactListener;
    CCSpriteBatchNode* sheet;
    CCMenu* menu;
}

+(id) scene;
- (void) upButtonCallback:(id)sender;
@end
