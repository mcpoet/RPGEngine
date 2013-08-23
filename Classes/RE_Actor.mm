//
//  RE_Actor.m
//  SimpleBox2dScroller
//
//  Created by min on 3/17/11.
//  Copyright 2011 Min Kwon. All rights reserved.
//

#import "RE_Actor.h"
#import "Constants.h"
#import "frames.h"

#pragma this factory is deprecated
@implementation RE_AnimationFactory

+(RE_AnimationFactory*)sharedFactory
{
    static RE_AnimationFactory* lonely;
    //@Synchronize() for multithread
    if (!lonely) {
        lonely = [[RE_AnimationFactory alloc]init]; 
    }
    return lonely;
}

-(id) initWithFilename:(NSString*)name
{
    self = [super init];
    if (self) {
        //get the bundle path
        NSString * path = nil;
        _actionBook = [[NSMutableDictionary alloc]initWithContentsOfFile:path];
    }
    return self;
}

-(id) init
{
    return [[RE_AnimationFactory alloc]initWithFilename:@"actionBook.plist"];
}

- (short) nameIndex:(NSString*)name
{
    NSArray* data = [_actionBook valueForKey:name];
    if (data) {
        NSNumber* index = [data objectAtIndex:0];
        return [index shortValue];
    }
    return -1;
}

- (short) nameLength:(NSString*)name
{
    NSArray* data = [_actionBook valueForKey:name];
    if (data) {
        NSNumber* length = [data objectAtIndex:1];
        return [length shortValue];
    }
    return -1;
}

- (CCAnimation*) makeAnimation:(NSString*)name 
                     withSheet:(CCSpriteBatchNode*)sheet 
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
@end


@implementation RE_Actor
@synthesize body;
@synthesize actorId;
@synthesize state;
@synthesize velocity;
@synthesize sheet;

// Temporery Selectors for actions

- (id) initWithBatchNode:(CCSpriteBatchNode *)batchNode rect:(CGRect)rect
{
	if (self = [super initWithBatchNode:batchNode rect:rect]) 
    {
        type = kGameObjectPlayer;
        actorId = 31415926;
	}
    sheet = batchNode;
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"actionBook.plist"];
    actionBook = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    actionMap = [[NSArray alloc]initWithObjects:@"hold",@"walk",
                 @"jump",@"fall",@"attk",@"fist",@"dash",@"damage",nil];
    
    // RE_Entity * character construction
    finalPath = [path stringByAppendingPathComponent:@"attributeBook.plist"];
    NSDictionary* attribValues = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    attributeBook = [[NSMutableDictionary alloc]init];
    for (NSString* a in [attribValues allKeys]) {
        NSNumber* n = [attribValues valueForKey:a];
        RE_CharacterAttribute * attr = [[RE_CharacterAttribute alloc]initwithLockable:NO andValue:[n floatValue]];
        [attributeBook setValue:attr forKey:a];
    }
    
    finalPath = [path stringByAppendingPathComponent:@"actionNames.plist"];
    actionNames = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    NSMutableDictionary* a = [[NSMutableDictionary alloc]init];
    for (NSString* actname in [actionNames allKeys]) {
        NSDictionary* computus = [actionNames valueForKey:actname];
        NSMutableDictionary* d = [[NSMutableDictionary alloc]init];

        for (NSString* selkey in [computus allKeys]) 
        {
            NSString* selname = [computus valueForKey:selkey];
            SEL selector = NSSelectorFromString(selname);
            RE_OnePassCompulector* cpl = [[RE_OnePassCompulector alloc]initWithSelector:selector];
            [d setValue:cpl forKey:selkey];
        }
        RE_Action* act = [[RE_Action alloc]initWithComputus:d andName:actname];
        [a setValue:act forKey:actname];
    }
    character = [[RE_Entity alloc]initWithAttributes:attributeBook withActions:a];

    stateStack = [[NSMutableArray alloc]init];
    stateMachine = [[NSMutableDictionary alloc] initWithCapacity:10];

    RE_State* hold1 = [[RE_State alloc]initWithTrigger:[[stanceTrigger alloc]initWithTarget:hold ] 
                                                action:@"hold" 
                                                repeat:YES 
                                                 sheet:sheet
                                                bullet:nil
                                                host:self
                       ];
    [stateMachine setValue:hold1 forKey:@"hold"];
    RE_State* walk = [[RE_State alloc]initWithTrigger:[[walkTrigger alloc]initWithTarget:hold ] 
                                               action:@"walk" 
                                               repeat:YES 
                                                sheet:sheet
                                               bullet:nil
                                                 host:self
                      ];
    [stateMachine setValue:walk forKey:@"walk"];
    RE_State* jump = [[RE_State alloc]initWithTrigger:[[jumpTrigger alloc]initWithTarget:fall ] 
                                               action:@"jump" 
                                               repeat:YES 
                                                sheet:sheet
                                               bullet:nil
                                                 host:self
                      ];
    [stateMachine setValue:jump forKey:@"jump"];
    RE_State* fall = [[RE_State alloc]initWithTrigger:[[fallTrigger alloc]initWithTarget:hold ] action:@"fall" repeat:YES sheet:sheet bullet:nil host:self];
    [stateMachine setValue:fall forKey:@"fall"];
    RE_State* fist = [[RE_State alloc]initWithTrigger:nil 
                                               action:@"fist" 
                                               repeat:NO 
                                                sheet:sheet
                                               bullet:@"dash"
                                                 host:self
                      ];
    [stateMachine setValue:fist forKey:@"fist"];
    RE_State* attk = [[RE_State alloc]initWithTrigger:nil 
                                               action:@"attk" 
                                               repeat:NO 
                                                sheet:sheet
                                               bullet:nil
                                                 host:self
];
    [stateMachine setValue:attk forKey:@"attk"];
    RE_State* damage = [[RE_State alloc]initWithTrigger:nil 
                                                 action:@"damage" 
                                                 repeat:NO 
                                                  sheet:sheet
                                                 bullet:nil
                                                   host:self
];
    [stateMachine setValue:damage forKey:@"damage"];
    RE_State* dash = [[RE_State alloc]initWithTrigger:nil 
                                               action:@"dash" 
                                               repeat:NO 
                                                sheet:sheet 
                                               bullet:nil                                              host:self
];
    [stateMachine setValue:dash forKey:@"dash"];    

    curState=[stateMachine valueForKey:@"hold"];
    [self setState:hold];
    [character setSprite:self];
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
    _world = world;
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
    NSLog(@"name ? %@", name);
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

-(void) playAction:(NSString*)name 
            repeat:(BOOL)ornot
          duration:(float)duration
             delay:(float)delay
{
    // This fuction is here because
    // the animations are stored by the Character
    // but they are bound to the stateMachines;
    CCAnimation * act = [self makeAnimation:name];
    [curAction stop];
    // give it back to action pool
    
    curAction = [CCAnimate actionWithDuration:duration animation:act restoreOriginalFrame:YES];
    curAction = [CCSequence actions:[CCDelayTime actionWithDuration:delay],
                                     curAction, nil];
    if(ornot){
        curAction = [CCRepeatForever actionWithAction:curAction];
    }else{
        // push last state
        CCAction* tail = [CCCallFunc actionWithTarget:self 
                                             selector:@selector(restoreLast)];
        curAction = [CCSequence actions:curAction,tail, nil];
    }
    
    [self runAction:curAction];
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



- (void) onBumpWith:(RE_Actor *)other
{
    // We want construct an actionMessage from 
    // the bumpMessage which is an action name;
    // should be like this

    // So here we hand over part of the state machine
    // to the RE_EntityGroup/RE_Entity for state transitions
    // And you have to bind the state with RE_Entity Actions
    // in some sense.
    
    // RE_Action <-----> RE_StateTransition <-----> RE_State
    // RE_Action <--[target state]--> RE_State   
    // RE_Action <--[state trigger]--> RE_StateTransition   
    
    NSString * msg =[curState bumpMessage];
    RE_Msg* remsg = [[RE_Msg alloc]init:takeAction message:msg sender:character data:[character getAction:msg]];
    [self sendMessage:remsg to:other];
}

- (void) sendMessage:(RE_Msg *)msg to:(RE_Actor *)receiver
{
    [receiver handleMessage:msg];
}

- (void) handleMessage:(RE_Msg*)msg
{
    //switch on messages to different states
    // if message is 'attack' 
    // we randomly transite to damage or defends
    // on damage we don't collide
    // while on defend, we collide.

//    if ([msg isEqualToString:@"attk"]) {
//        [self transite:damage];
//    }else if ([msg isEqualToString:@"dash"]){
//        [self transite:dash];
//    }else if ([msg isEqualToString:@"fist"]){
//        [self transite:damage];
//    }    

    // use the RE_Character to handle message
    [character handleMessage:msg];
//    try to update state if character is dirty
/*  if([character isDirty])
    {
        [self updateStates];
    }
 */
    
}

- (void) updateDirtyStates:(NSArray*)attributes
{
    for(RE_State* s in curStates){
        if ([s isDirtyWith:attributes]) {
            instruct target;
            if((target=[s tryTriggers:self])!=none)
            {
                [s transite:target];
            }
        }
    }
}

// We call this in every system iteration for new animations?
// so this updates would be asynchronic.
- (void) updateStates
{
    for(RE_State* s in curStates){
        if (/*[character dirtyBits]& [s dirtyMask]*/1) {
            instruct target;
            if((target=[s tryTriggers:self])!=none)
            {
                [s transite:target];
//                return
            }
        }
    }
}

- (void) transite:(instruct)s
{
    NSString* name = [actionMap objectAtIndex:s];
    if (![[curState action_name] isEqualToString:name] ) {
//        NSLog(@"new state: %@",name);
        RE_State* nextState = [stateMachine valueForKey:name];
        if (![nextState repeat]) {
            if ([nextState fallon]==none) {
                [stateStack addObject:[NSNumber numberWithInt:state]];
            }else
                [stateStack addObject:[NSNumber numberWithInt:[nextState fallon]]];
        }
        state = s;
        curState = nextState;
        // Make experiment here for AABB switch on state transitions
        b2Fixture *f = ([self body]->GetFixtureList());
        b2PolygonShape * s = (b2PolygonShape*)f->GetShape();
        s->SetAsBox(.5, .8);
        // experiment End.
        
        // THe spriteSheet make us put the animation action out of 
        // the RE_State
        [self playAction:[curState action_name] repeat:[curState repeat]];
//        RE_Bullet* bullet =  [curState bullet];
//        if (bullet) 
//        {
//            [bullet setoff:_world position:[self position]];
//        }
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

@implementation dialogState

-(id)initWithLines:(NSArray *)Lines Triggers :(NSArray *)trigs
{
    if (self = [super init]) {
        lines = [[NSArray alloc]initWithArray:Lines];
        triggers = [[NSMutableArray alloc]initWithArray:trigs];
        cursor = 0 ;
    }
    return  self;
}
-(NSString*)nextLines
{
    if (cursor==[lines count]) {
        cursor=0;
    }
    return [lines objectAtIndex:cursor++];
}
-(NSString*)whatNext:(RE_Actor *)host
{
    //FIXME:Ensure the itertation is in previllege order.
    for (dialogTrigger* t in triggers) {
        if ([t shouldtrig:host]) {
            return  [t target];
        }
    }
    return nil;
}

@end
@implementation dialogTrigger
@synthesize target=targetDialog;

-(id) initWithTarget:(NSString*)tgt selector:(SEL)s
{
    targetDialog = tgt;
    shouldtrig = s;
    return self;
}

- (BOOL) shouldtrig:(RE_Actor *)host
{
    bool ret = (bool)[self performSelector:shouldtrig withObject:(id)host ];
    return ret;
}

@end


@implementation stateTrigger
@synthesize target=targetState;
@synthesize bindAttrib;

-(id) initWithTarget:(instruct)tgt
{
    targetState = tgt;
    return self;
}

- (BOOL) shouldtrig:(RE_Actor *)host
{
    return YES;
}

@end


@implementation stanceTrigger
- (BOOL) shouldtrig:(RE_Actor *)host
{
    return NO;
}
@end

@implementation walkTrigger
-(BOOL) shouldtrig:(RE_Actor *)host
{
    BOOL a = ([host velocity].x==0.0 && [host velocity].y ==0.0);
    return a;
}
@end

@implementation jumpTrigger

-(BOOL) shouldtrig:(RE_Actor *)host
{
    CCLOG(@"shall we jump :Vx %f, Vy %f",[host velocity].x,[host velocity].y);
    return ([host velocity].y < 0.0);
}
@end

@implementation fallTrigger
-(BOOL) shouldtrig:(RE_Actor *)host
{
    return [host velocity].y == 0.0;
}
@end

@implementation fistTrigger
-(BOOL) shouldtrig:(RE_Actor *)host
{
    return [host velocity].x == 0.0;
}
@end

@implementation attkTrigger
-(BOOL) shouldtrig:(RE_Actor *)host
{
    return [host velocity].x == 0.0;
}
@end

@implementation RE_State

@synthesize action_name = actionName;
@synthesize repeat = repeatORrestore;
@synthesize bumpMessage = message;
@synthesize fallon=fallTarget;
@synthesize bullet = bullet;

- (id) initWithTrigger:(stateTrigger *)trigger 
                action:(NSString *)actName 
                repeat:(BOOL)ORrestore
                 sheet:(CCSpriteBatchNode *)node
                bullet:(NSString*)bname
                  host:(CCSprite*)sprite
{
    if (self = [super init]) 
    {
        triggers = [[NSMutableArray alloc]initWithObjects:trigger, nil];
        actionName = actName;
        repeatORrestore=ORrestore;
        curAction = nil;
        attribMask = 1;
        attribDirty = 1;
        message = actName;
        if (![boundAttribs objectForKey:[trigger bindAttrib]]) 
        {
            [boundAttribs setObject:[[NSNumber alloc]initWithInt:1] 
                             forKey:[trigger bindAttrib]];
        }
        // Manage to modify attribMask
        sheet = node;
        if (bname && sheet) {
            CGRect r = CGRectMake(38.0,493.0,43.0,73.0);
            bullet = [[RE_Bullet alloc]initWithBatchNode:sheet rect:r ];
            [bullet setSprite:sprite];
        }
    }
    return self;
}

- (id) initWithTriggers:(NSArray *)_triggers 
                 action:(NSString *)actName 
                 repeat:(BOOL)ORrestore
                  sheet:(CCSpriteBatchNode *)node
                 bullet:(NSString*)bname
{
    if (self = [super init]) 
    {
        triggers = [[NSMutableArray alloc]initWithArray:_triggers];
        actionName = actName;
        repeatORrestore=ORrestore;
        curAction = nil;
        attribMask = 1;
        attribDirty = 1;
        message = actName;
        // Add the triggers bound attribute to State-Bound attribute name array.
        for (stateTrigger* t in _triggers) 
        {            
            if (![boundAttribs objectForKey:[t bindAttrib]]) 
            {
                [boundAttribs setObject:[[NSNumber alloc]initWithInt:1] 
                                 forKey:[t bindAttrib]];
            }
            // Manage to modify attribMask
        }
        sheet = node;
        if (bname && sheet) {
            CGRect r = CGRectMake(0.0, 0.0, 1.0, 1.0);
            bullet = [[RE_Bullet alloc]initWithBatchNode:sheet rect:r];
        }else
            bullet = nil;
    }
    return self;
}

- (instruct) tryTriggers:(RE_Actor*)host
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

-(void) applyOn:(b2Body *)b
{
    switch (flag&0x03) {
        case 1:
            b->ApplyForce(applied, b->GetWorldCenter());
            break;
        case 2:
            b->ApplyLinearImpulse(applied, b->GetWorldCenter());
            break;
        case 3:
            b->SetLinearVelocity(applied);
            break;
        default:
            break;
    }
}

-(BOOL) isDirtyWith:(NSArray*)attribs
{
    for (NSString* d in attribs) 
    {
        if ([boundAttribs objectForKey:d]) {
            return YES;
        }
    }
    return NO;
}

- (void) sendBullets:(RE_Actor*)reactor
{
    // Lazy initialization.    
    if (bullet) {
        // Is this all ?
        // We have to manage to first update the RE_MSG field.
        // to wrap the RE_Action in it.
        // [bullet loadMessage:reactor];
        [bullet run];
    }
}
@end

@implementation RE_Bullet

@synthesize lifetime = lifetime;
@synthesize delay = delay;
@synthesize actionName = actionName;
@synthesize repeat = repeat;
@synthesize shouldDelete = shouldDelete;
@synthesize sprite = sprite;

- (short) nameIndex:(NSString*)name
{
    NSArray* data = [_actionBook valueForKey:name];
    if (data) {
        NSNumber* index = [data objectAtIndex:0];
        return [index shortValue];
    }
    return -1;
}

- (short) nameLength:(NSString*)name
{
    NSArray* data = [_actionBook valueForKey:name];
    if (data) {
        NSNumber* length = [data objectAtIndex:1];
        return [length shortValue];
    }
    return -1;
}

- (CCAnimation*) makeAnimation:(NSString*)name 
                     withSheet:(CCSpriteBatchNode*)sheet 
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

-(void) disappear
{
    shouldDelete = true;
    [self setVisible:FALSE];
    NSLog(@"Disappear callback get called...");
}

-(void) playAction:(NSString*)name 
            repeat:(BOOL)ornot
          duration:(float)duration
             delay:(float)defer
{
    // This fuction is here because
    // the animations are stored by the Character
    // but they are bound to the stateMachines;
    CCAnimation * act = [self makeAnimation:name withSheet:[self batchNode]];
    // give it back to action pool
    
    curAction = [CCAnimate actionWithDuration:duration animation:act restoreOriginalFrame:NO];
    curAction = [CCSequence actions:[CCDelayTime actionWithDuration:defer],
                 curAction, nil];
    if(ornot){
        curAction = [CCRepeatForever actionWithAction:curAction];
    }else{
        // push last state
        CCAction* tail = [CCCallFunc actionWithTarget:self 
                                             selector:@selector(disappear)];
        curAction = [CCSequence actions:curAction,tail, nil];
    }
    [self setVisible:TRUE];
    [self runAction:curAction];
}

- (void) setoff:(b2World*) world position:(CGPoint)pos
{
    // create body or get the body visible.    
    b2BodyDef bulletBodyDef;
    bulletBodyDef.type = b2_kinematicBody;
    //FIXME:
    bulletBodyDef.position.Set(pos.x/PTM_RATIO, pos.y/PTM_RATIO);
    bulletBodyDef.userData = self;
    bulletBodyDef.fixedRotation = true;
    bulletBodyDef.bullet = true;
    
    if(body){
        world->DestroyBody(body);
    }
    body = world->CreateBody(&bulletBodyDef);        
    
    b2PolygonShape box;
    box.SetAsBox(0.5, 0.5, b2Vec2(0.8, 0.4), 0.0);
    b2CircleShape circleShape;
    circleShape.m_radius = 0.7;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &box;
    fixtureDef.density = 0.0f;
    fixtureDef.friction = .00f;
    fixtureDef.restitution =  0.0f;
    b2Fixture* f = body->CreateFixture(&fixtureDef);
    f->SetSensor(YES);
//  body->ApplyLinearImpulse(initImpulse, body->GetWorldCenter());
    body->SetLinearVelocity(b2Vec2(2.0,0.0));
}

-(void) followHost
{
    CGPoint p = [sprite position];
    body->SetTransform(b2Vec2(p.x/PTM_RATIO,p.y/PTM_RATIO), 0.0);
}
-(void) type
{
    NSLog(@"what's new for that ?");
}

-(id) initFromPlist:(NSString*)plistname
{
    if (self = [super init]) {
        return self;
    }else
        return nil;
}
-(id) initWithBatchNode:(CCSpriteBatchNode *)sheet 
                   rect:(CGRect)rect
                   host:(CCSprite*)parent
{
    if (self = [super init]) {
        [parent addChild:self z:0];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"actionBook.plist"];
        _actionBook = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    }
    actionName = @"fist";
    lifetime = 1;
    delay = 0.8;
    repeat = NO;
    sprite = parent;
    
    return self;
}

-(id) initWithBatchNode:(CCSpriteBatchNode *)sheet rect:(CGRect)rect
{
    if (self = [super initWithBatchNode:sheet rect:rect]) 
    {
        [sheet addChild:self z:0];
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSString *finalPath = [path stringByAppendingPathComponent:@"actionBook.plist"];
        _actionBook = [[NSDictionary alloc] initWithContentsOfFile:finalPath];
    }
    actionName = @"fist";
    lifetime = 1;
    delay = 0.8;
    repeat = NO;
    
    return self;
}
-(void) loadMessage:(RE_Actor *)target
{
    RE_Msg* remsg = [[RE_Msg alloc]init:takeAction message:@"fist" sender:host data:[host getAction:@"fist"]];
    [target handleMessage:remsg];
}

@end