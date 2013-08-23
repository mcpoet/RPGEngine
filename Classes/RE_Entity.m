//
//  RE_Entity.m
//  SimpleBox2dScroller
//
//  Created by  on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_Entity.h"

@class RE_Msg;
@class RE_Actor;

@implementation RE_Entity
@synthesize installFlag=_install_flags;
@synthesize attributes = _attributes;
@synthesize actions = _actions;
@synthesize name = _name;
@synthesize sprite = _curSprite;

-(id) initWithAttributes:(NSDictionary *)attrs withActions:(NSDictionary *)acts
{
    if(!(self=[super init]))return nil;
    _attributes =[[NSMutableDictionary alloc]initWithDictionary:attrs];
    _actions = [[NSMutableDictionary alloc]initWithDictionary:acts];
    return self;
}
-(void) handleMessage:(RE_Msg *)message
{
    switch ([message type]) {
        case installAction:
            [self installAction:[message message]];
            break;
        case takeAction:
        {
//            [self takeActionWithName:[message message]];
            RE_Action* torun = [_actionMap valueForKey:[message message]];
            if(torun)
            {
                [self reply:message withAction:torun];
//                RE_Action* r = [self performAction:[message message]];
//                if(r)
//                    [self reply:message withAction:r];
            }else{
            //FIXME: ugly hack for directly get the machine for any action manufact.
                [self runAction:[message data]];
            }
            break;
        }
        case performAction:
        {
//            RE_Action* r = [self performAction:[message message]];
//            if(r)
            RE_Action* torun = [_actionMap valueForKey:[message message]];
            if(torun)
                [self reply:message withAction:torun];
            break;
        }
        case installAttribute:
        case dropOn:
        case equipOn:
        case uninstallAttribute:
        default:
            break;
    }
}

// Actually the destinatioin should be encode in the message itself
-(void) sendMessage:(RE_Msg *)message to:(RE_Entity *)target
{
    //FIXME: In the end, a synchronized implementation is in need.
    [target handleMessage:message];
}

-(void) reply:(RE_Msg *)message withAction:(RE_Action *)action
{
    RE_Entity* target = [message sender];
    [message setSender:self];
    [message setData:action];
    [self sendMessage:message to:target];
}

// Run an Action on the host, may return another
-(RE_Action*) runAction:(RE_Action *)action
{
    // Dummy for lummy.
    // Here we use the action's computus' keys 
    // for the updator's dictionary
    // which we hand over for RE_Actor triggers.
    NSArray* dirtyAttribs = [[action computus] allKeys];
    RE_Action* r = [action run:self];
    //So RE_Actor have to cache those the values for consistence？
    //or we just get it from the server time and time?
    
    // And we have to bind name to differentiat the states.
    
    // We finally decided to bind the action state to one 
    // of the character's attribute, and we can update 
    // the attribute in our action in some way, then we 
    // can use updateDirtyStates to get the frontend showing.
//    [_curSprite transite: _bindState];
    NSLog(@"We gonna run the action...");
    [_curSprite transite:6];
    [_curSprite updateDirtyStates:dirtyAttribs];
    return r;
}

-(void) installAction:(NSString *)action
{
    RE_Action* toInstall = [RE_ActionFactory make:action];
    [_actions setValue:toInstall forKey:action];
}

-(void) uninstallAction:(NSString *)attr
{
    [_actions removeObjectForKey:attr];
    // Or we use 
    // [_actions setValue:nil forKey:name];
}

-(RE_Action*) performAction:(NSString *)act_name
{
    RE_Action* local = [_actions valueForKey:act_name];
    return [self runAction:local];
}

-(RE_Action*) getAction:(NSString *)act
{
    return [_actions valueForKey:act];
}

-(BOOL) isAttributeLocked:(NSString *)attr
{
    RE_CharacterAttribute* a =  [_attributes valueForKey:attr];
    return [a lockable]&&[a locked];
}

-(BOOL) setAttribute:(float)value withName:(NSString *)attr
{
    RE_CharacterAttribute* a = [_attributes valueForKey:attr];
    [a setValue:value];
    return YES;
}

-(float) getAttribute:(NSString *)attr
{
    RE_CharacterAttribute* a = [_attributes valueForKey:attr];
    return  [a getFloatValue];
}
- (void) installAttribute:(RE_CharacterAttribute *)attribute 
                    named:(NSString *)attrib_name
{
    [_attributes setValue:attribute forKey:attrib_name];
}

- (void) uninstallAttribute:(NSString *)attr
{
    [_attributes setValue:nil forKey:attr];
}

/*
 Install one entity's attributes and actions to self:
 different install actions are encoded in field of 'install_flags' :
 install category:attributes,actions, both,
 install type: merge, cross, exclusive, one_night_
 
 The one_night_ type is special type of cross, there is no uninstall oper, nor
 need for keep the installee for uninstallation.
 This field is here to make more sense for validation.
 
 On uninstall scenary, the same field is used to dicide which
 attributes should be stripped off.
 Also for the uninstall operation's consistence, 
 the entity must be static while equipped.
 Its attributes and actions cannot be touch
 (We keep a read-only-like field for this).
 
 Also this interface implements equipment-forging by which 
 some items canbe merged into one more powerful item, 
 so with characters in some case...
 
 As this pattern render's ,there would be a problem when 
 the merge actions grow the dict too big to be staticalized.
*/


-(RE_Entity*) InstallEntity:(RE_Entity *)entity withName:(NSString *)name
{
    RE_Entity* toReturn = nil;
    //If the arguement:name is not nil, it names a equipment slot,
    //then we have to unequip the slot first and return the unequiped item
    if (name) {
        RE_Entity* r = [_equips valueForKey:name];
        toReturn = [self UninstallEntityWithName:name];
        assert(r==toReturn);
    }
    [self InstallEntity:entity];
    if (name) {
        // put it into slot;
        [_equips setObject:entity forKey:name];
    }
    return toReturn;
}

/*
-(RE_Entity*) UninstallEntity:(RE_Entity *)entity withName:(NSString *)name
{
    int installflag = [entity installFlag];
    BOOL installAction = installflag&mInstallActionsMask;
    BOOL installAttribute = installflag&mInstallAttributesMask;
    int installType = installflag&mInstallTypeMask;
    assert(installType!=bInstallOneNight);
    RE_Entity* toReturn = nil;
    if (name) {
        toReturn = [_equips valueForKey:name];
        assert(toReturn!=nil);
        assert(entity==toReturn);
    }
    if (installAction) {
        NSDictionary* uninstallee = [entity actions];
        for (NSString* key in [uninstallee allKeys]) {
            assert([_actions objectForKey:key]!=nil);
            [_actions setObject:[uninstallee objectForKey:key] forKey:key];
        }
    }
    if (installAttribute) {
        NSDictionary* uninstallee = [entity attributes];
        for (NSString* key in [uninstallee allKeys]) {
            assert([_attributes objectForKey:key]!=nil);
            RE_CharacterAttribute* a = [_attributes objectForKey:key];
            RE_CharacterAttribute* f = [uninstallee objectForKey:key];
            float r = [[a getValue]floatValue]-[[f getValue]floatValue];
            // Hardcoding the Zero Clamping
            r = r<0?0.0:r;
            [a setValue:r];
        }
    }
    return toReturn;
}
*/
 
// This should be the public API as only equipment need uninstallatioin
// which only need a name for slot.
-(RE_Entity*) UninstallEntityWithName:(NSString *)name
{
    if (name) {
        RE_Entity* toR = [_equips valueForKey:name];
        if (toR) {
            [self UninstallEntity:toR];
            [_equips removeObjectForKey:name];
        }
        return toR;
    }else
        return nil;
}

-(void) InstallEntity:(RE_Entity *)entity
{
    int installflag = [entity installFlag];
    BOOL installAction = installflag&mInstallActionsMask;
    BOOL installAttribute = installflag&mInstallAttributesMask;
    short installType = installflag&mInstallTypeMask;
    
    assert(installAction && installType==bInstallOneNight);
    
    //We can put some cache to use here for entities with the same name or type
    NSDictionary* installee = [entity actions];
    NSMutableSet* crossKeys = [[NSMutableSet alloc]init];
    NSMutableSet* excludeKeys = [[NSMutableSet alloc]init];
    
    for (NSString* key in [installee allKeys]) {
        if ([_actions valueForKey:key]) {
            [crossKeys addObject:key];
        }else
            [excludeKeys addObject:key];
    }
    
    if (installAction) {
        switch (installType) {
            case bInstallMerge:
            {
                for (NSString* key  in [installee allKeys]) {
                    [_actions setObject:[installee objectForKey:key] forKey:key];
                }
                
            }
                break;
            case bInstallCross:
            {
                for (NSString* key in crossKeys) {
                    [_actions setObject:[installee objectForKey:key] forKey:key];
                }
            }
                break;
            case bInstallExclude:
            {
                for (NSString* key in excludeKeys) {
                    [_actions setObject:[installee objectForKey:key] forKey:key];
                }
            }
                break;
            default:
                break;
        }
    }
    
    [crossKeys removeAllObjects];
    [excludeKeys removeAllObjects];
    installee = [entity attributes];
    for (NSString* key in [installee allKeys]) {
        if ([_attributes valueForKey:key]) {
            [crossKeys addObject:key];
        }else
            [excludeKeys addObject:key];
    }
    
    if (installAttribute) {
        switch (installType) {
            case bInstallMerge:
            {
                for (NSString* key  in crossKeys) {
                    RE_CharacterAttribute* a = [_attributes valueForKey:key];
                    RE_CharacterAttribute* i = [installee valueForKey:key];
                    [a setValue:([[a getValue]floatValue]+ [[i getValue]floatValue])];
                }
                for (NSString* key  in excludeKeys) {
                    // We need a copy constructor
                    RE_CharacterAttribute* i = [[RE_CharacterAttribute alloc]initWithRCA:[installee valueForKey:key]];
                    [_attributes setObject:i forKey:key];
                }
                
            }
            break;
            case bInstallOneNight:
            case bInstallCross:
            {
                for (NSString* key  in crossKeys) {
                    RE_CharacterAttribute* a = [_attributes valueForKey:key];
                    RE_CharacterAttribute* i = [installee valueForKey:key];
                    [a setValue:([[a getValue]floatValue]+ [[i getValue]floatValue])];
                }
            }
            break;
            case bInstallExclude:
            {
                for (NSString* key  in excludeKeys) {
                    // We need a copy constructor
                    RE_CharacterAttribute* i = [[RE_CharacterAttribute alloc]initWithRCA:[installee valueForKey:key]];
                    [_attributes setObject:i forKey:key];
                }
                
            }
            break;
            default:
                break;
        }
    }
}

-(void) UninstallEntity:(RE_Entity *)entity;
{
    int installflag = [entity installFlag];
    BOOL installAction = installflag&mInstallActionsMask;
    BOOL installAttribute = installflag&mInstallAttributesMask;
    int installType = installflag&mInstallTypeMask;
    assert(installType!=bInstallOneNight);

    if (installAction) {
        NSDictionary* uninstallee = [entity actions];
        for (NSString* key in [uninstallee allKeys]) {
            assert([_actions objectForKey:key]!=nil);
            [_actions setObject:[uninstallee objectForKey:key] forKey:key];
        }
    }
    if (installAttribute) {
        NSDictionary* uninstallee = [entity attributes];
        for (NSString* key in [uninstallee allKeys]) {
            assert([_attributes objectForKey:key]!=nil);
            RE_CharacterAttribute* a = [_attributes objectForKey:key];
            RE_CharacterAttribute* f = [uninstallee objectForKey:key];
            float r = [[a getValue]floatValue]-[[f getValue]floatValue];
            // Hardcoding the Zero Clamping
            r = r<0?0.0:r;
            [a setValue:r];
        }
    }

}

@end

@implementation RE_EntityGroup
/*
Purpose for Class EntityGroup
(1) wraps message api for upper class.
) manages to name every member.
)Everybody has unique ID,identical ID's entities are compiled together.
)So the unique IDs are just string names world wide!
(2) handles inter-entity messages.
(3) manages entities group wide.
(4) routes messages to member entities.
(5) main message loop.

Message Types:
(1)  ActionMessages:pos_name(null for leader) &action
(2)  Buddies Actions:pos_name &action
(3)  New Item
(4)  New Buddy
(5)  New leader
(6)  New Sprites
(7)  Switch Leader
(8)  Switch sprite
(10) Drop Item
(11) Drop Action (SHall we turn this to action message?)
(12) Drop Buddy ....
(13) Item expired
(14) Buddy expired
(15) Apply Item:name,target(default to leader)
(16) Equipments and vice:name,target(default to leader)
(17) Route out messages: SourceID?
// (18) Sub-groups for monster in the box ?
(19) New Attribute ?
(20) Inter-Entity messaging

// The protocal 
// Binary message format
// | source_id | dest_id | dest_type | dest_index | message_type | message_body |
//    24            0        8            16             8             ...
// source_id:0->group internal message; others just hand to the router
// dest_type: 1->group message,2->character_message, 3->item_message,others are invalid
// dest_index: array index or dict key when implemented in python dict
// Above informations should be used for message validations
// We'll wrap this with protobuf later

*/
//class dest_type(object):
//group='group'
//chara='buddy'
//item ='item'
//class message_type(object):
//newItem = 1
//newChara= 2
//newLeader=3
//newSprite=4
//switchLeader=5
//switchSprite=6
// dropItem,dropBuddy,itemExpired,buddyExpired,Apply,unapply,equip,unequip=range(7,14)

-(void) handleGroupMessage:(RE_Msg*)message
{
    switch ([message type]) {
        case newItem:
        {
            NSString* itemname = [message data];
            if ([_items objectForKey:itemname] ) {
                NSNumber* count = [_items_compile objectForKey:itemname];
                NSNumber* newcount = [[NSNumber alloc]initWithInt:[count intValue]+1];
                [_items_compile setObject:newcount forKey:itemname];
            }else{
                // Just beg it from some factory...
//                RE_Entity* r = [RE_EntityFactory make:itemname];
//                [_items setObject:r forKey:itemname];
//                [_items_compile setObject:[[NSNumber alloc]initWithInt:1] 
//                                   forKey:itemname];
            }
        }
            break;
        case newBuddy:
        {
            RE_Entity* buddy = [message data];
            NSString* name = [message message];
            if ([_buddies objectForKey:name] ) {
                //FIXME: We should dispose the previous object first
                [_buddies setObject:buddy forKey:name];
            }else{
                [_buddies setObject:buddy forKey:name];
            }

        }
            break;
        case newLeader:
        {
            RE_Entity* buddy = [message data];
            NSString* name = [message message];
            if ([_buddies objectForKey:name] ) {
                //FIXME: We should dispose the previous object first
                [_buddies setObject:buddy forKey:name];
            }else{
                [_buddies setObject:buddy forKey:name];
            }
            _leader = buddy;

        }
            break;
        case newSprite:
        {
            RE_Actor* sprite = [message data];
            NSString* name = [message message];
            if ([_sprites objectForKey:name]); 
            {
                [_sprites setObject:sprite forKey:name];
            }
        }
            break;
        case switchLeader:
        {
            
        }
            break;
        case switchSprite:
        {
            
        }
            break;
        case dropItem:
        {
            //This action only drop one named item.
            NSString* itemname = [message message];
            if ([_items objectForKey:itemname]) {
                NSNumber* count = [_items_compile objectForKey:itemname];
                int c = [count intValue];
                if (--c<=0) {
                    [_items_compile removeObjectForKey:itemname];
                    [_items removeObjectForKey:itemname];
                }else{
                    [_items_compile setObject:[[NSNumber alloc] initWithInt:c]
                                       forKey:itemname];
                }
            }
        }
            break;
        case dropBuddy:
        {
            NSString* name = [message message];
            if ([_buddies objectForKey:name]) {
                // FIXME: Before the removal, 
                // we should do some disposal one the object first.
                [_buddies removeObjectForKey:name];
            }
        }
            break;
        case expireItem:
        {
            
        }
            break;
        case expireBuddy:
        {
            
        }
            break;
        case installItem:
        {
            NSString* slotname = [message message];
            NSString* itemname = [message data];
            RE_Entity* r = [_items objectForKey:itemname];
            assert([itemname isEqualToString:[r name]]);
            
            if (!r) {
                break;
            }
            NSString* dest = [message destindex];
            RE_Entity* host;
            if (dest) {
                host = [_buddies objectForKey:dest];
            }else
                host = _leader;
            
            //FIXME: We have to prepare some equipment slot in RE_ENtity.
            RE_Entity* retired = nil;
            if (slotname) {
                retired = [host InstallEntity:r withName:slotname];
            }else
            {
                [host InstallEntity:r];
            }
            //FIXME: drop the item from the group bag.
            [self dropItemWithName:[r name]];
            if (retired) {
                [self addItem:retired withName:[retired name]];
            }
            
        }
            break;
        case uninstallItem:
        {
            // So this message is designated to unequipping?
            NSString* slotname = [message message];
//            NSString* itemname = [message data];
//            RE_Entity* r = [_items objectForKey:itemname];
//            if (!r)break;
            NSString* dest = [message destindex];
            RE_Entity* host;
            if (dest) {
                host = [_buddies objectForKey:dest];
            }else
                host = _leader;
            
            RE_Entity* retired =[host UninstallEntityWithName:slotname];
            assert(([retired installFlag]&mInstallAttributesMask)!=bInstallOneNight);
            {
                // put the equipment back to group bag
                [self addItem:retired withName:[retired name]];
            }
        }
            break;
        case testMessage:
        {
            NSLog(@"Testing messages for the rest of all...");
        }
            break;
        default:
            break;
    }
}

-(void) handleMessage:(RE_Msg*)message
{
    switch ([message desttype]) {
        case item:
        case character:
        {
            RE_Entity* c = [_buddies objectForKey:[message destindex]];
            [c handleMessage:message];
        }
            break;
        case group:
        {
            [self handleGroupMessages:message];
        }
            break;
        default:
            break;
    }
}

/*
As some need response some not, we just reply all..
Battle Messages are async while Control Msgs are Sync

We believe this list should be as short as possible.
*/
// bunch of asserts for message validation
// assert()
// assert()

@end