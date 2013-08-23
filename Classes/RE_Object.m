//
//  RE_Object.m
//  RPG_Engine
//
//  Created by  on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_Object.h"
#import "RE_CharacterAttributes.h"
//#import "RE_Spirit.h"
//#import "RE_SpriteFactory.h"
#import "RE_ActionFactory.h"

@implementation RE_Object

- (void) setAttributeByKey:(id)attr :(NSString *)key
{
    [_attributes setValue:attr forKey:key];
}

- (void) modifyAttributeByKey:(id)attr :(NSString *)key
{
    // Moniter的角色就很像MVC里面的C了。
    // [AttributesMoniter push:self:key:attr];
    int value  = [[_attributes valueForKey:key]intValue];
    int modify = [(NSNumber*)attr intValue];
    NSNumber* newValue = [NSNumber numberWithInt:value+modify];
    // order of the following two lines?
    [self notifyCharacterObserver:@"attribute" :key :attr :@"modify"];
    [_attributes setValue:newValue forKey:key];
    
}

// first perform/gather parameters from one object like
// the host,then apply it on the target
- (RE_Action*) makeAction:(NSString *)actname
{
    RE_Action* bioflip = [RE_ActionFactory make:actname];
    return [self giveAction:bioflip];
}

//- (void) addCharacterObserver:(id<RE_Character_Observer>*)obs
//{
//    [observers addObject:(id)obs];
//}

//- (void) notifyCharacterObserver:(NSConstantString*)dictName:(NSString*)key
//                                :(id)value:(NSConstantString*)operationType
//{
//    //有没有一个锁呢？
//    NSEnumerator* obsenum = [observers objectEnumerator];
//    id<RE_Character_Observer> obs = [obsenum nextObject];
//    while (obs!=nil) {
//        [obs pushModification:dictName:key :value:operationType];
//        obs=[obsenum nextObject];
//    }
//    
//}

//- (Boolean) compute_movement:(CGPoint*)movement:(NSConstantString*)type
//{
//    // 类型主要是为了分辨跑和跳或者其它动作的移动
////     对跨越障碍物的区别。
//    return [curScene SceneMovementQuery:position 
//                                       :movement 
//                                       :type];
//}

//- (void) move:(int)dir:(float)step
//{
////   assert( dir !=0 );
//    if(dir%2==1)
//    {
//        position->x=step*dir/abs(dir)+position->x;
//    }
//    else
//    {
//        position->x=step*dir/abs(dir)+position->x;
//    }
//    
//}

- (int) installAttr:(NSString *)name :(RE_CharacterAttribute *)attr
{
    //    [currentState installValue:name :attr];
    [_attributes setValue:attr forKey:name];
    return 0;
}

//- (Boolean) tryUpdateAttb:(NSString *)name 
//                withDelta:(RE_AttributeValue *)delta
//{
//    RE_CharacterAttribute* cattr = [_attributes valueForKey:name];
//    return [cattr updateWithDelta:delta];
//}
//- (Boolean) tryUpdateAttr:(NSString *)name 
//                withValue:(RE_AttributeValue *)newValue
//{
//    RE_CharacterAttribute* cattr = [_attributes valueForKey:name];
//    return [cattr setValue:newValue];
//}

- (NSNumber*) getAttribute:(NSString *)name
{
    RE_CharacterAttribute* a = [_attributes valueForKey:name];
    if (a==nil) return nil;
    return [a getValue];
}

- (NSDictionary*) getAttributes:(NSArray *)attributes
{
    NSMutableDictionary* d = [[NSMutableDictionary alloc]initWithCapacity:5];
    for (NSString* s in attributes ) {
        RE_AttributeValue* n = [self getAttribute:s];
        [d setObject:n forKey:s];
    }
    return d;
}

- (void) applyControllers:(NSDictionary *)controllers
{
    for (NSString* name in [controllers allKeys]) {
        RE_CharacterAttribute* attr 
        = [_attributes valueForKey:name];
        if(attr)
            [attr applyController:
             [controllers valueForKey:name]];
    }
}


- (void) installController:(RE_AttributeController *)controller 
                  withAttr:(NSString *)name
{
    [[_attributes valueForKey:name]addController:controller];
}

// 在此呢，要查看需要更新的attributes之间是否有依赖，
// 然后按照依赖的更新顺序来更新array中的属性，
// 对于循环依赖的情况，自然是要排除的

// 多数情况下这个排序是可以复用的，因此cache是可以参考的。

- (void) updateAttributes:(NSArray *)array
{
    
    for (NSString*a  in array) 
    {
        [[_attributes valueForKey:a] runControllers];
    }
}

//  如果是用controllers更新的，还是要运行一遍的。
- (void) updateAttributesWithControllers:(NSDictionary *)controllerDict
{
    for (NSString* attr in [controllerDict allKeys]) {
        RE_AttributeController* ctrl = 
                    [controllerDict valueForKey:attr];
        [[_attributes valueForKey:attr]installController:ctrl 
                                                withAttr:nil];
    }
    // 为了属性间依赖性的着想，需要两个循环
    [self updateAttributes:[controllerDict allKeys]];
}

// 


- (RE_Action*) reActionOn:(NSString *)trigger
{
    NSString* actionName = [_actionMap objectForKey:trigger];
    return [_actions objectForKey:actionName];
}

- (void) newAction:(RE_Action *)action 
          withName:(NSString *)name
{
    [_actions setValue:action forKey:name];
}

- (void) newMapEntry:(NSString *)trigger 
          withAction:(NSString *)action
{
    [_actionMap setValue:action forKey:trigger];
}

// runAction
- (void) runActionWithName:(NSString*)name withParam:(id)data
{
    RE_Action* action = [_actions valueForKey:name];
    [self runAction:action withParam:data];
}

- (void) runActionWithName:(NSString *)name withDict:(NSDictionary*)data
{
    RE_Action* action = [_actions valueForKey:name]; 
    [self runAction:action withDict:data];
}

- (void) runAction:(RE_Action*)action withParam:(id)data
{
//    这样饶了一圈其实还是runAction通过RE_Action来调用自己的方法
//    这样RE_Action的壳包得也太薄了。
    
//    并且现在还没想到Params的用处，
//    需要一个RE_Action接口，runWithTarget withParams:
    [action runWithTarget:self];
}

- (void) runAction:(RE_Action*)action withDict:(NSDictionary *)data
{
    [action runWithTarget:self];
}

- (id) initWithDict:(NSDictionary *)Chardict
{
    NSArray* actions = [Chardict valueForKey:@"actions"];
    NSDictionary* attributes = 
    [Chardict valueForKey:@"attributes"];
    //    for (NSString* s in sprites) 
    //    {
    //        RE_Spirit* sp = [RE_SpriteFactory make:s];
    //        [sprites setValue:sp forKey:s];
    //    }
    if(!_actions)
        _actions=[[NSMutableDictionary alloc]init];
    if(!_actionMap)
        _actionMap=[[NSMutableDictionary alloc]init];
    if(!_attributes)
        _attributes=[[NSMutableDictionary alloc]init];
//      sprites 暂时不弄了
//    if(!_sprites)
//        _sprites=[[NSMutableDictionary alloc]init];
        

    for (NSString* attr in [attributes allKeys]) 
    {
        NSDictionary* d = [attributes valueForKey:attr];
        NSNumber* n = [d valueForKey:@"init_value"];
        NSArray* depends = [d valueForKey:@"depends"];
        RE_CharacterAttribute* rca =
        [[RE_CharacterAttribute alloc]
         initWithNSNumber:n 
         withDepends:depends];
        [_attributes setValue:rca forKey:attr];
    }
    
    for (NSString* a in actions)
    {
        RE_Action* act = [RE_Action make:a];
        [_actions setValue:act forKey:a];
    }
    return self;
}

- (id) initWithFile:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:filename];
    NSMutableDictionary* Chardict = 
    [[NSMutableDictionary alloc] 
     initWithContentsOfFile:finalPath];
//    NSArray* sprites = [Chardict valueForKey:@"sprites"];
    NSArray* actions = [Chardict valueForKey:@"actions"];
    NSDictionary* attributes = 
    [Chardict valueForKey:@"attributes"];
//    for (NSString* s in sprites) 
//    {
//        RE_Spirit* sp = [RE_SpriteFactory make:s];
//        [sprites setValue:sp forKey:s];
//    }

    for (NSString* a in actions)
    {
        RE_Action* act = [RE_Action make:a];
        [actions setValue:act forKey:a];
    }
    for (NSString* attr in [attributes allKeys]) 
    {
        NSDictionary* d = [attributes valueForKey:attr];
        NSNumber* n = [d valueForKey:@"init_value"];
        NSArray* depends = [d valueForKey:@"depends"];
        RE_CharacterAttribute* rca =
        [[RE_CharacterAttribute alloc]
         initWithNSNumber:n 
         withDepends:depends];
        [attributes setValue:rca forKey:attr];
    }
    return self;
}

- (void) handleMessage:(RE_Msg *)msg
{
    // implementations should be in subclasses.
}
 

- (void) installAction:(RE_Action*)action withName:(NSString *)name
{
    RE_Action* a = [_actions valueForKey:name];
    for (NSString* cname in [a getAttributes]) {
        [self installController:[a getController:cname] 
                       withAttr:cname];
    }
}


@end
