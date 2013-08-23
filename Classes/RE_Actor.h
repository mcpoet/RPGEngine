//
//  RE_Actor.h
//  SimpleBox2dScroller
//
//  Created by min on 3/17/11.
//  Copyright 2011 Min Kwon. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "GameObject.h"
#import "RE_Entity.h"
#import "RE_ActionV2.h"

@class stateTrigger;
@class RE_Actor;
@class RE_Entity;

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
    left,
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

@interface RE_AnimationFactory : NSObject 
{
    RE_AnimationFactory* lonely;
    NSMutableDictionary* _actionBook;
}

@end
/*
 THis class wraps the Box2d Bullet, to produce a moving box (may have apparence)
 for attack collision simulation and for inherence we also carry with it the 
 attack message and info to the attackee for responses.
 So this class just keep AABB and motion for collision part;
 On the other hand, it atains RE_Action Info for logic part;
 */

// Note, we can use the same pattern on skills based on particles,
// which just entities like many bullets.
// But the Performance and statics may be a heavy issue.

// 魔法效果也用这个实现或者作基类的话，会需要一些动画来作外衣什么的。

// 该类，是游戏的核心，所有的特效效果，这里都是实现的枢纽
// 所有的战斗逻辑，这里都是实现的枢纽，
// 所有的击打碰撞效果，这里都是实现的枢纽，
// 所有的物品掉落行为，这里都是实现的枢纽。
// ??物品掉落也在这里做么？

@interface RE_Bullet : CCSprite 
{
    // For participate in the collision detection
    b2Body* body;
    // Physics Infor
    b2PolygonShape* AABB;
//    float weight;
//    b2Vec2 initImpulse;
    // const speed
    b2Vec2* velocity;
    // May carry some impulse to impose on the victim.
//    b2Vec2* impulse;
     
    // RE_Action data
    // So we just carry this and when on collide 
    // just pass the Message to the collidee, ehhh, poor victim...
    // Some pattern can be done on skill based on particles.
    // 一种好的同步的实现方式是，用一个Selector，或者函数指针，
    // 碰撞的时候，调用这个动作的施放者和，受害者，前者是绑定的，
    // 后者是在碰撞的时候撞到的，然后算一个各自的状态，各自去更新就OK了。
    // 这样的话，是不是RE_State就不用带RE_Action和RE_Msg相关的信息了。
    // 而直接关联到,RE_Bullet就可以了。
    RE_Msg* carry;
    RE_Entity* host;
    NSString* actionName;
    float delay;
    float lifetime;
    BOOL repeat;//　纠结。。。
    BOOL shouldDelete;
    // Shall we try to specify enemy or friends?
    int targetMask;
    
    // We may need animations for those variable
    CCAction* curAction;
    NSDictionary* _actionBook;
    CCSprite* sprite;
    
    // 0 for shootable bullet
    // 1 for blade bullet
    // 2 for particle bullet
    // 3 for shootable path bullet
    
    // more complex bullet types are under consideration
    // like bullets that follow a sprite in some path animation pattern
    // or even you can consider implementing some pets as bullets? surely you can.
    // We call all things that can attack BULLETS !
    // And they just implement a category which can collide with the enermy category
    // and can send msg upon collision scenes.
    // As the character may have an energy shell or something,
    // this may need more bullets for a state,
    // or we may have more state simutaniously.
    int type;
    
    // after the hittimes the bullet should vanish
    int hittimes;
}
-(void) loadMessage:(RE_Actor*)host;
-(void) run;
-(void) setoff:(b2World*)world position:(CGPoint)pos;
-(void) finishCallback;
-(id) initWithBatchNode:(CCSpriteBatchNode *)batchNode rect:(CGRect)rect;
-(id) initWithBatchNode:(CCSpriteBatchNode *)sheet 
                   rect:(CGRect)rect
                   host:(CCSprite*)parent;
-(id) init;
-(void) type;
-(void) followHost;

@property (atomic, readonly) float delay;
@property (atomic, readonly) float lifetime;
@property (retain, readonly) NSString* actionName;
@property (atomic, readonly) BOOL repeat;//....
@property (atomic, readwrite) BOOL shouldDelete;
@property (retain, readwrite) CCSprite* sprite;


@end

@interface RE_ShootableBullet : RE_Bullet 
{
    b2Vec2 * target;
    


}
-(void) playAction;
-(void) setoff:(b2World *)world position:(CGPoint)pos;
@end

@interface RE_CarriableBullet : RE_Bullet 
{
    
}
-(void) setoff:(b2World *)world position:(CGPoint)pos;

@end

@interface RE_PathBullet : RE_ShootableBullet 
{
    ccBezierConfig* pathConfig;
}
-(void) setoff:(b2World *)world position:(CGPoint)pos;

@end

@interface RE_ParticleBullet : RE_Bullet 
{
    int * num_particles;
}
-(void) setoff:(b2World *)world position:(CGPoint)pos;

@end
/*
 There are two categories of information in the RE_State:
 (1) Animation Informations:Correspond to some aspect of the apparence of a character
 like all actions performed by the character,
 and some magic effects and pets etc.
 (2) Transition informations:
 Also ,there are two kinds of methods for RE_State transitions
 (1) Using triggers for some asynchronized transitions.
 (2) Using message for synchronized transitions.
 Maybe we should try to figure it out to merge or 
 develop another class.
*/

@interface RE_State : NSObject 
{
//  OK, KVO is ready, But Not sure about the PERFORMANCE.
    NSMutableArray* watchAttributes;
    
    NSMutableDictionary* boundAttribs;
//  BoundAttributes:
//  NSMutableArray* boundAttribNames;
    long attribMask;
    long attribDirty;

    int flag;

    // THis triggers still live with confusion in that 
    // some sleep on body parameters while other may 
    // sleep on RE_Entity attributes.
    NSArray* triggers;
    //  For conjunctive actions to defaultly transite to the next.
    instruct fallTarget;
    
//  Encapsure the animation parameters below later,
//  FIXME: This should be merged with boundAttributes,  
//  may be force/impulse/velocity depend on the flag bits
    b2Vec2 applied;
    BOOL repeatORrestore;
    NSString* animationName;
//  local cache
    CCAction* curAction;
    
//  This two fields should later move to RE_Bullet
//  and RE_State no longer couple with RE_Action
    NSString* actionName;
    NSString* message;
    
//  Think up a method to name the bullet.
    NSString* bulletName;
    RE_Bullet* bullet;
    
    // We use this property to handon for bullet creations
    CCSpriteBatchNode* sheet;
}

- (void) installTriggers:(RE_Actor*) host;
- (void) deactivateTriggers:(RE_Actor*) host;
- (instruct) tryTriggers:(RE_Actor*) host;
- (void) markDirty:(short)bit;

- (id) initWithTrigger:(stateTrigger*) trigger 
                action:(NSString*)actName
                repeat:(BOOL)ORrestore
                 sheet:(CCSpriteBatchNode*)node
                bullet:(NSString*)bname
                  host:(CCSprite*)sprite;


- (id) initWithTriggers:(NSArray*)triggers
                 action:(NSString*)actName
                 repeat:(BOOL)ORrestore
                  sheet:(CCSpriteBatchNode*)node
                 bullet:(NSString*)bname;

- (void) applyOn:(b2Body*)b;
- (BOOL) isDirtyWith:(NSArray*)d;

- (void) sendBullet:(RE_Actor*)sender;

//@property (atomic,readwrite) instruct name;
@property (retain,readwrite) NSString* action_name;
@property (retain,readwrite) NSString* bumpMessage;
@property (atomic,readonly) BOOL repeat;
@property (atomic,readwrite) instruct fallon;
@property (retain, readwrite) RE_Bullet* bullet;
@property (retain, readwrite) CCSpriteBatchNode* sheet;

@end

// This class take a RE_ActionState or RE_Sprite
// as the render input.
// Just add some visual effects or particles
// depend on the bound renders
@interface RE_RenderState : NSObject 
{
    // OK, KVO is ready, But Not sure about the PERFORMANCE.
    // The inside attributes should in dependency priority.
    NSMutableArray* watchAttributes;
    int flag;
    // This triggers still live with confusion in that 
    // some sleep on body parameters while other may 
    // sleep on RE_Entity attributes.
    NSArray* triggers;
    // Encapsure the animation parameters below later,
    // FIXME: This should be merged with boundAttributes,  
    // may be force/impulse/velocity depend on the flag bits
    BOOL repeatORrestore;
    NSString* animationName;
    // local cache
    CCAction* curAction;    
    // base state
    RE_State* inputState;
}
- (void) updateState;
- (void) observeOnAttributes:(id)observee;

@end

@interface RE_Actor : GameObject 
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
    
    // 从逻辑上而言，这部分角色动画数据，应该封装到一个单独得RE_State实例中，
    // 并且保存一个单独的指针，like _mainState ， 作为其它state渲染的参考，
    // 并且最终会有个类似pipeline的RenderStack，来得到最终的动作帧，
    // 现在的问题是，我们把这些封装到一起，还是放到一个组相对独立的（但是有序）
    // 状态量中？
    CCSpriteBatchNode* sheet;
//  CCSprite* actor;
    CCAction* curAction;
    CCAnimationCache* actionCache;
    //FIXME: Later put this to RE_State
    NSMutableArray* stateStack;
    
    instruct       state;
    // This should be a group of paralelle animations on one actor
    // And on every render/display loop, we just check every active states
    // and render them parallely.
    // As it's a mutable array, states can be add and removed on the fly.
    // But for every Game Character, we ensure that there is one base/main
    // state for character rendering.
    NSMutableArray*  curStates;
    // Maybe we need a Dictionary
//    NSMutableDictionary* curStates;
    
    RE_State* curState;
    b2Vec2  velocity;
    
    RE_Entity* character;
    
    // This two were for temporery RE_Entity COnstructors
    NSDictionary * attributeBook;
    NSDictionary * actionNames;
    b2World* _world;

}

// bound states to the RE_Entity _attributes] NSDictionary;
// as states and RE_Entity _attributes are both dynamic,
// these wires should be update periodically?
// FIXME: ?
-(void) wireOnStates;



// Further more we will import Dialog triggers 
// which just sit on collisions with NPCs
-(void) buildStateMachine;
-(void) buildDialogMachine;

// Triggers sleep on attributes like velocity and health-points
// While messages and actions may modify attributes.
-(void) handleMessage:(RE_Msg*)msg;

-(void) playAction:(NSString*)name;
-(void) transite:(instruct)state;
// API for state group in which you use the name to index
-(void) transite:(NSString*)name To:(instruct)state;

// Trig all the triggers that sleep on the attributes in upadte 
-(void) wakeupTriggers:(NSArray*)update;

-(void) changeState:(instruct) state;
-(void) nextState:(int)cur_state;
-(void) attributeTrigger:(int)cur_state;
// THis was called on the Collision Site
-(void) onBumpWith:(RE_Actor*)other;
-(void) sendMessage:(RE_Msg*)msg to:(RE_Actor*)receiver;
-(void) updateStates;
-(void) updateDirtyStates:(NSArray*)d;

-(void) createBox2dObject:(b2World*)world;
-(void) command:(instruct)msg;
-(void) jump;
-(void) moveRight;
-(void) moveLeft;
-(void) moveRightBit;

-(id) initWithBatchNode:(CCSpriteBatchNode *)batchNode rect:(CGRect)rect;
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
//  BOOL repeat;
//  BOOL hasCallback;
    
}

- (id) initWithTarget:(instruct)target;
// This arbitor should be hand-made or by TOOL
- (BOOL) shouldtrig:(RE_Actor*)host;
@property (atomic,readwrite) instruct target;
@property (retain,readwrite) NSString *bindAttrib;
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

@interface dialogState : NSObject 
{
    NSArray* lines;
    // array of dialogTriggers
    NSMutableArray* triggers; 
    dialogFaceType face;
    BOOL repeat;
    int cursor;
}

-(id)initWithLines:(NSArray*)lines Triggers:(NSArray*)triggers;
-(NSString*)nextLines;
-(dialogState*)whatNext:(RE_Actor*)host;
@end

@interface dialogTrigger : NSObject 
{
    // dialogTrigger only sleep on collisions
    // but the arbitor is more complex 
    // as it would examine the actor's clue-items 
    // to carry on the play
    
    // Character may have words on Dialog transition
    // this is the best place to hold it.
    NSString* lines;
    SEL shouldtrig;
    NSString* targetDialog;
}

-(BOOL) shouldtrig:(RE_Actor*)host;
@property (retain,readwrite) NSString* target;
@end