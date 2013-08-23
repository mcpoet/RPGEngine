//
//  RE_CocosActor.m
//  CocosPractice
//
//  Created by  on 12-7-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_CocosActor.h"
//
//  Player.m
//  SimpleBox2dScroller
//
//  Created by min on 3/17/11.
//  Copyright 2011 Min Kwon. All rights reserved.
//
#import "Constants.h"
#import "frames.h"

@implementation RE_CocosActor
@synthesize body;
@synthesize actorId;
@synthesize state;
@synthesize velocity;
@synthesize sheet;

- (id) init
{
	if ((self = [super init])) 
    {
        type = kGameObjectPlayer;
        actorId = 31415926;
	}
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"actionBook.plist"];
    actionBook = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    actionMap = [[NSArray alloc]initWithObjects:@"hold",@"walk",
                 @"jump",@"fall",@"attk",@"fist",@"dash",@"damage",nil];
    
    stateStack = [[NSMutableArray alloc]init];
    stateMachine = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    RE_State* hold1 = [[RE_State alloc]initWithTrigger:[[stanceTrigger alloc]initWithTarget:hold ] action:@"hold" repeat:YES];
    [stateMachine setValue:hold1 forKey:@"hold"];
    RE_State* walk = [[RE_State alloc]initWithTrigger:[[walkTrigger alloc]initWithTarget:hold ] action:@"walk" repeat:YES];
    [stateMachine setValue:walk forKey:@"walk"];
    RE_State* jump = [[RE_State alloc]initWithTrigger:[[jumpTrigger alloc]initWithTarget:fall ] action:@"jump" repeat:YES];
    [stateMachine setValue:jump forKey:@"jump"];
    RE_State* fall = [[RE_State alloc]initWithTrigger:[[fallTrigger alloc]initWithTarget:hold ] action:@"fall" repeat:YES];
    [stateMachine setValue:fall forKey:@"fall"];
    RE_State* fist = [[RE_State alloc]initWithTrigger:nil action:@"fist" repeat:NO];
    [stateMachine setValue:fist forKey:@"fist"];
    RE_State* attk = [[RE_State alloc]initWithTrigger:nil action:@"attk" repeat:NO];
    [stateMachine setValue:attk forKey:@"attk"];
    RE_State* damage = [[RE_State alloc]initWithTrigger:nil action:@"damage" repeat:NO];
    [stateMachine setValue:damage forKey:@"damage"];
    RE_State* dash = [[RE_State alloc]initWithTrigger:nil action:@"dash" repeat:NO];
    [stateMachine setValue:dash forKey:@"dash"];    
    
    curState=[stateMachine valueForKey:@"hold"];
    [self setState:hold];
	return self;
}

-(void) createBox2dObject:(b2World*)world {
    b2BodyDef playerBodyDef;
	playerBodyDef.type = b2_dynamicBody;
	playerBodyDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
	playerBodyDef.userData = self;
	playerBodyDef.fixedRotation = true;
	
	body = world->CreateBody(&playerBodyDef);
	
    b2PolygonShape box;
    box.SetAsBox(.50, .50);
	b2CircleShape circleShape;
	circleShape.m_radius = 0.7;
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &box;
	fixtureDef.density = 2.0f;
	fixtureDef.friction = .50f;
	fixtureDef.restitution =  0.0f;
	body->CreateFixture(&fixtureDef);
}

// some pattern of state machines

-(void) command:(instruct)inst
{
    switch (inst) {
        case (walk):
            if ([self state]!=walk ) {
                [self transite:walk];
                [self moveRight];
            }
            break;
        case attk:
            [self transite:attk];
            [self moveRightBit];
            break;
        case fist:
            [self transite:fist];
            [self moveRightBit];
            break;
        case dash:
            [self transite:dash];
            [self moveRightBit];
            break;
        case jump:
            if ([self state]!=jump && [self state]!=fall) {
                [self transite:jump];
                [self jump];
            }
            break;
        default:
            break;
    }
}

- (short) nameIndex:(NSString*)name
{
    NSArray* data = [actionBook valueForKey:name];
    if (data) {
        NSNumber* index = [data objectAtIndex:0];
        return [index shortValue];
    }
    return -1;
}

- (short) nameLength:(NSString*)name
{
    NSArray* data = [actionBook valueForKey:name];
    if (data) {
        NSNumber* length = [data objectAtIndex:1];
        return [length shortValue];
    }
    return -1;
}

- (CCAnimation*) makeAnimation:(NSString*)name 
{
    short indx = [self nameIndex:name];
    short len = [self nameLength:name];
    if (indx == -1 || len == -1) {
        return nil;
    }    
    
    CCSpriteFrame * f;
    NSMutableArray *animFrames = [NSMutableArray array];
    
    for (int i =0; i<len; i++) {
        short row = npcItem0[indx+i][0];
        CGRect r = CGRectMake((CGFloat)nDrawPos[row][1],
                              (CGFloat)nDrawPos[row][2],
                              (CGFloat)nDrawPos[row][3],
                              (CGFloat)nDrawPos[row][4]);
        f = [CCSpriteFrame frameWithTexture:[sheet texture] rect:r];
        [animFrames addObject:f];
        
    }
    
    return [CCAnimation animationWithFrames:animFrames];
}

- (void) restoreLast
{
    NSNumber* lastState = [stateStack lastObject];
    [stateStack removeLastObject];
    instruct r = (instruct)[lastState intValue];
    [self transite:r];
}

-(void) playAction:(NSString*)name repeat:(BOOL)ornot
{
    // This fuction is here because
    // the animations are stored by the Character
    // but they are bound to the stateMachines;
    CCAnimation * act = [self makeAnimation:name];
    [curAction stop];
    // give it back to action pool
    curAction = [CCAnimate actionWithDuration:0.8 animation:act restoreOriginalFrame:YES];
    if(ornot){
        curAction = [CCRepeatForever actionWithAction:curAction];
    }else{
        // push last state
        CCAction* tail = [CCCallFunc actionWithTarget:self 
                                             selector:@selector(restoreLast)];
        curAction = [CCSequence actionOne:curAction two:tail];
    }
    
    [self runAction:curAction];
}

- (void) mayTransite:(b2Vec2)v
{
    [self setVelocity:v];
    instruct target_state = [curState tryTriggers:self];
    if(target_state!=none && target_state!=state)
    {
        [self transite:target_state];
    }
    
}

- (void) onBumpWith:(Player *)other
{
    NSString * msg =[curState bumpMessage];
    [self sendMessage:msg to:other];
}

- (void) sendMessage:(NSString *)msg to:(Player *)receiver
{
    [receiver handleMessage:msg];
}

- (void) handleMessage:(NSString *)msg
{
    //switch on messages to different states
    // if message is 'attack' 
    // we randomly transite to damage or defends
    // on damage we don't collide
    // while on defend, we collide.
    if ([msg isEqualToString:@"attk"]) {
        [self transite:damage];
    }else if ([msg isEqualToString:@"dash"]){
        [self transite:dash];
    }else if ([msg isEqualToString:@"fist"]){
        [self transite:damage];
    }
}

- (void) transite:(instruct)s
{
    NSString* name = [actionMap objectAtIndex:s];
    if (![[curState action_name] isEqualToString:name] ) {
        NSLog(@"new state: %@",name);
        RE_State* nextState = [stateMachine valueForKey:name];
        if (![nextState repeat]) {
            [stateStack addObject:[NSNumber numberWithInt:state]];
        }
        state = s;
        curState = nextState;
        b2Fixture *f = ([self body]->GetFixtureList());
        b2PolygonShape * s = (b2PolygonShape*)f->GetShape();
        s->SetAsBox(.5, .8);
        [self playAction:[curState action_name] repeat:[curState repeat]];
    }
}

-(void) moveRight {
    b2Vec2 impulse = b2Vec2(20.0f, 0.0f);
    body->ApplyLinearImpulse(impulse, body->GetWorldCenter());		
}

-(void) moveLeft {
    b2Vec2 impulse = b2Vec2(-25.0f, 0.0f);
    body->ApplyLinearImpulse(impulse, body->GetWorldCenter());		
}

-(void) moveRightBit {
    b2Vec2 impulse = b2Vec2(5.0f, 0.0f);
    body->ApplyLinearImpulse(impulse, body->GetWorldCenter());		
}

-(void) jump {
    b2Vec2 impulse = b2Vec2(6.0f, 40.0f);
    body->ApplyLinearImpulse(impulse, body->GetWorldCenter());		    
}
@end

@implementation stateTrigger
@synthesize target=targetState;

-(id) initWithTarget:(instruct)tgt
{
    targetState = tgt;
    return self;
}

- (BOOL) shouldtrig:(Player *)host
{
    return NO;
}

@end


@implementation stanceTrigger
- (BOOL) shouldtrig:(Player *)host
{
    return NO;
}
@end

@implementation walkTrigger
-(BOOL) shouldtrig:(Player *)host
{
    BOOL a = ([host velocity].x==0.0 && [host velocity].y ==0.0);
    return a;
}
@end

@implementation jumpTrigger

-(BOOL) shouldtrig:(Player *)host
{
    CCLOG(@"shall we jump :Vx %f, Vy %f",[host velocity].x,[host velocity].y);
    return ([host velocity].y < 0.0);
}
@end

@implementation fallTrigger
-(BOOL) shouldtrig:(Player *)host
{
    return [host velocity].y == 0.0;
}
@end

@implementation fistTrigger
-(BOOL) shouldtrig:(Player *)host
{
    return [host velocity].x == 0.0;
}
@end

@implementation attkTrigger
-(BOOL) shouldtrig:(Player *)host
{
    return [host velocity].x == 0.0;
}
@end

@implementation RE_State

//@synthesize name;
@synthesize action_name = actionName;
@synthesize repeat = repeatORrestore;
@synthesize bumpMessage = message;

- (id) initWithTrigger:(stateTrigger *)trigger action:(NSString *)actName repeat:(BOOL)ORrestore
{
    if (self = [super init]) {
        triggers = [[NSMutableArray alloc]initWithObjects:trigger, nil];
        actionName = actName;
        repeatORrestore=ORrestore;
        curAction = nil;
        attribMask = 1;
        attribDirty = 1;
        message = actName;
    }
    return self;
}

- (id) initWithTriggers:(NSArray *)_triggers action:(NSString *)actName repeat:(BOOL)ORrestore
{
    if (self = [super init]) {
        triggers = [[NSMutableArray alloc]initWithArray:_triggers];
        actionName = actName;
        repeatORrestore=ORrestore;
        curAction = nil;
        attribMask = 1;
        attribDirty = 1;
        message = actName;
    }
    return self;
}

- (instruct) tryTriggers:(Player*)host
{
    if ((attribMask & attribDirty) == 0) {
        return none;
    }
    // More optimisly we can use the above
    // bit mask to try triggers specifcally
    for (stateTrigger* t  in triggers) {
        if ([t shouldtrig:host]) {
            return  [t target];
        }
    }
    return none;
}

- (void) markDirty:(short)bit
{
    attribDirty|=1<<bit;
}
@end

