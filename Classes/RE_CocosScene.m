//
//  RE_CocosScene.m
//  CocosPractice
//
//  Created by  on 12-5-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_CocosScene.h"

@implementation RE_CocosScene

- (void) messageRelay:(RE_Msg *)msg
{
    [_curCharacter handleMessage:msg];
}

- (void) addCharacter:(RE_Character *)character 
                atPos:(CGPoint*)pos
{
    assert(character!=nil);
    // add RE_Character to container;
    [container setValue:character forKey:@"actor"];
    _curCharacter = character;
    // add sprite to scene;
    // 暂时先用RE_CocosScene这个类,
    // 这两个sprite接口太蛋疼了。
    [self addChild:[[character sprite] batch] z:-1 ];
    if (pos) {
        [[[character sprite]batch] setPosition:*pos];
    }else
        [[[character sprite]batch] setPosition:entry];
}

+ (CCScene*) scene
{
    NSLog(@"Scene");
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	RE_CocosScene *layer = [RE_CocosScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) genCharacter:(NSString *)name
{
    //  现在先把工场方法放在RE_Character里面实现了
//    CGPoint p = [self randomPos];
    RE_Character* c = [RE_Character factory:name];
    [self addCharacter:c atPos:nil];
}

- (id) init
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
    entry = CGPointMake(100, 100);
    if( (self=[super init])) 
    {
        [RE_ActionFactory buildFactory:@"actionDicts.plist"];
        [self genCharacter:@"neoboy"];
//        _curCharacter = [container valueForKey:@"actor"];
	}
    //Also we need construct some buttons for control here.
    CCMenuItem *upButton = [CCMenuItemImage itemFromNormalImage:@"Icon-Small-50.png" selectedImage:@"Icon-Small-50.png" target:self selector:@selector(upButtonCallback:)];
    CCMenuItem *downButton = [CCMenuItemImage itemFromNormalImage:@"yuki-Icon.png" selectedImage:@"yuki-Icon.png" target:self selector:@selector(downButtonCallback:)];
//    CCMenuItem *leftButton = [CCMenuItemImage itemFromNormalImage:@"leftButton.png" selectedImage:@"leftButton.png" target:self selector:@selector(upButtonCallback:)];
//    CCMenuItem *rightButton = [CCMenuItemImage itemFromNormalImage:@"rightButton.png" selectedImage:@"rightButton.png" target:self selector:@selector(upButtonCallback:)];
//    
    [upButton setPosition:CGPointMake(100, 100)];
    [downButton setPosition:CGPointMake(200, 100)];
    
    CCMenu *menu = [CCMenu menuWithItems: upButton,downButton,nil];
    [self addChild: menu];

    [self setIsTouchEnabled:YES];
    
    NSLog(@"init happend");
    return self; 
}

- (void) upButtonCallback:(id)sender
{
    NSLog(@"where do you want to go ?");
}

- (NSDictionary*) offset:(CGPoint)p1:(CGPoint)p2
{
    NSString* name;
    int dir;
    int step;
    int oy = p1.y-p2.y;
    int ox = p1.x-p2.x;
    if(abs(oy)>abs(ox)) 
    {
        if (oy>0) {
            name = @"walkup";
            dir =1;
        }else{
            name = @"walkdown";
            dir =2;
        }
        step = abs(oy);
        
    }
    else
    {
        if (ox<0) {
            name = @"walkleft";
            dir = 3;
        }else{
            name = @"walkright";
            dir = 4;
        }
        step = abs(ox);
    }
    NSMutableDictionary* d = [[NSMutableDictionary alloc]initWithCapacity:4];
    [d setValue:name forKey:@"name"];
    [d setValue:@"walk" forKey:@"category"];
    [d setValue:[[NSNumber alloc]initWithInt:1] forKey:@"type"];
    [d setValue:[[NSNumber alloc]initWithInt:dir] forKey:@"direction"];
    [d setValue:[[NSNumber alloc]initWithInt:step] forKey:@"step"];
    return d;
}


- (void) downButtonCallback:(id)sender
{
//    其实我们希望在触到透明的区域的时候不反应的
    NSLog(@"where do you ssss to go ?");
    
//    [RE_Character sendMsg: to:]
//    [self sendMsg: to:];
    NSDictionary* d = [self offset:CGPointMake(200, 200) :CGPointMake(180, 180)];
//  上面的数据是必须要有滴，只是可以通过静态化压缩一下。
    RE_Msg* m = [[RE_Msg alloc] init:COMMAND message:@"walk" sender:nil data:d];
    [_curCharacter handleMessage:m];
}

- (void) dealloc
{

    [super dealloc];
}

@end
