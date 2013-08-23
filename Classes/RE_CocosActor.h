
//
//  RE_CocosActor.h
//  CocosPractice
//
//  Created by  on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

//
//  Player.h
//  SimpleBox2dScroller
//
//  Created by min on 3/17/11.
//  Copyright 2011 Min Kwon. All rights reserved.
//

#import "libs/cocos2d/cocos2d.h"

@class stateTrigger;
@class RE_CocosActor;

enum instruct
{
    // normal states
    hold=0,// right here waiting
    walk=1,
    jump=2,
    fall=3,
    attk=4,
    fist=5,
    dash=6,
    damage=7,
    right,
    jumpleft,
    jumpright,
    slip,
    coach,    
    // attacking states
    jumpattack,
    attack,
    hardattack,
    defense,
    counter,
    
    //every other before this
    none
};

@interface action : NSObject 
{
    NSString* name;
    NSArray* frames;
    BOOL* repeatOrElseAutoRestore;
    //    short* flags;
    CCAction* action;
    
}

-(void) playback;
@end

// Correspond to some aspect of the apparence of a character
// like all actions performed by the character,
// and some magic effects and pets etc.
@interface RE_State : NSObject 
{
    //    One trigger only can be bound to one attribute
    //    for one state, this rule simplify the T-S-A design
    //    Currently you can use compound attribute like the b2Vec struct.
    
    //    FIXME: How to import the trigger datas?
    NSArray* triggers;
    long attribMask;
    long attribDirty;
    CCAction* curAction;
    //  NSString* name;
    //    instruct name;
    
    //  Encapsure the animation action here
    NSString* actionName;
    BOOL repeatORrestore;
    NSString* message;
}

- (void) installTriggers:(RE_CocosActor*) host;
- (void) deactivateTriggers:(RE_CocosActor*) host;
- (instruct) tryTriggers:(RE_CocosActor*) host;
- (void) markDirty:(short)bit;

- (id) initWithTrigger:(stateTrigger*) trigger 
                action:(NSString*)actName
                repeat:(BOOL)ORrestore;

- (id) initWithTriggers:(NSArray*)triggers
                 action:(NSString*)actName
                 repeat:(BOOL)ORrestore;

//@property (atomic,readwrite) instruct name;
@property (retain,readwrite) NSString* action_name;
@property (retain,readwrite) NSString* bumpMessage;
@property (atomic,readonly) BOOL repeat;

@end

@interface RE_CocosActor : CCSprite 
{   
    // the physics part
    b2Body          *body;
    // the actor part
    int              actorId;
    NSArray* actionMap;
    NSDictionary * actionBook;
    NSDictionary * stateMachine;
    // the dialog play also need icons and stateMachine.
    NSDictionary * dialogAvatars;
    id             dialogMachine;
    float          AOIRadis; // for NPC AOI collision computing.
    CCSpriteBatchNode* sheet;
    //  CCSprite* actor;
    CCAction* curAction;
    CCAnimationCache* actionCache;
    NSMutableArray* stateStack;
    
    instruct       state;
    RE_State* curState;
    stateTrigger* curTigger;
    b2Vec2  velocity;
}

// Further more we will import Dialog triggers 
// which just sit on collisions with NPCs
-(void) buildStateMachine;
-(void) buildDialogMachine;

// Triggers sleep on attributes like velocity and health-points
// While messages and actions may modify attributes.
-(void) handleMessage:(NSString*)msg;

-(void) playAction:(NSString*)name;
-(void) transite:(instruct)state;
-(void) changeState:(instruct) state;
-(void) nextState:(int)cur_state;
-(void) attributeTrigger:(int)cur_state;
// THis was called on the Collision Site
-(void) onBumpWith:(RE_CocosActor*)other;
-(void) handleMessage:(NSString *)msg;
-(void) sendMessage:(NSString*)msg to:(RE_CocosActor*)receiver;

-(void) createBox2dObject:(b2World*)world;
-(void) command:(instruct)msg;
-(void) jump;
-(void) moveRight;
-(void) moveLeft;
-(void) moveRightBit;

-(id) init;
-(void) mayTransite:(b2Vec2)velocity;

@property (nonatomic, readwrite) b2Body *body;
@property (atomic, readwrite) int actorId;
@property (atomic, readwrite) instruct state;
@property (atomic, readwrite) b2Vec2 velocity;
@property (retain, readwrite) CCSpriteBatchNode* sheet;

@end

@interface stateTrigger : NSObject 
{
    int sourceStateMask;
    instruct targetState;
    NSString* bindAttrib;
    // decide where to install this trigger
    // something like 
    /*
     typedef enum {
     _physical,  // listen physical params 
     _attribute, // listen attributes
     _collision, // awaken on collision
     }
     installTYpe;
     */
    int installType;
    BOOL repeat;
    BOOL hasCallback;
}

- (id) initWithTarget:(instruct)target;
// This arbitor should be hand-made
- (BOOL) shouldtrig:(RE_CocosActor*)host;
- (void) onFinish:(id)node;
@property (atomic,readwrite) instruct target;
@end

@interface stanceTrigger : stateTrigger 
@end
@interface walkTrigger : stateTrigger 
@end
@interface jumpTrigger : stateTrigger 
@end
@interface fallTrigger : stateTrigger 
@end
@interface attkTrigger : stateTrigger 
@end
@interface fistTrigger : stateTrigger 
@end

@interface dialogTrigger : stateTrigger 
{
@private
    // dialogTrigger only sleep on collisions
    // but the arbitor is more complex 
    // as it would examine the actor's clue-items 
    // to carry on the play
    NSString* lines;
}
@end

