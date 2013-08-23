//
//  RE_Action.m
//  RPG_Engine
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_Action.h"

@implementation RE_ActionV1

- (Boolean) sortOnDependens
{
//  action存在的意义就是一个controller组，
//  或者叫做状态组，从这个意义上而言，跟矢量的概念差不多
//  那么，在此我们规定，attribute的依赖关系，
//  只能存在于一个action之内，否则就是invalid
//  至于依赖的层次，可以有多层，但是不能循环，否则就悲催了。。。
    
    return _sorted;
}

-(RE_AttributeController*) getController:(NSString *)attr_name
{
    return [controllerMap valueForKey:attr_name];
}

-(NSArray*) getAttributes
{
    return [controllerMap allKeys];
}

// 群杀技的话貌似要arglist或者groupArgs了

// 例如 walk?
- (void) run
{
    [self runWithTarget:host];
}

// 这个函数要重写，RE_Action是看不到RE_Message类的

/*
- (void) runWithTarget:(RE_Object *)t
{
    //    按照现在的设定，大概是这样的两个步骤，
    //    先发消息，这个消息多半是发给对手的，但是也可能是发给自己的。
    //    之后读状态，然后根据状态来更新动画，这个状态都是自己的，
    //    更新的动画也是自己的，因此每个action对应的两个参数是
    //    主题：执行者；受体：目标
    //    其中，主体可以作为一个属性，也可以作为一个参数。
//    用一个工厂模式么？
    RE_Msg * msg = [[RE_Msg alloc]initWithSender:host
                                      withTarget:t
                                 withControllers:controllerMap
                                        withInfo:name];

//    这样一来RE_Object成为了处理消息和执行动作的主体
//    这样设计过于集中了
//    逻辑上RE_Object 负责实现处理消息的接口
//    RE_Character 负责实现执行动画动作的接口
//    因此Host应该是RE_Character 类型
    [t handleMessage:msg];
    //    这个之间，会有一个不同步的间隙，如果target＝host的话
    //    要保证这个间隙是close的
//        貌似这样执行walk也不那么顺溜？
//        在此，name和attributes形成了一种耦合，
//        然后这种耦合却要通过host来桥接？
    [host performSpriteAction:name
                   withParams:[host getAttributes:attributes]];

}
 */

- (NSDictionary*) renewControllers:(NSDictionary *)params
{
//    明晃晃的Memory Leak
    NSMutableDictionary* d = [[NSMutableDictionary alloc]init];
    for (NSString* s in [controllerMap allKeys]) {
        RE_AttributeController* c = [[controllerMap 
                                     valueForKey:s] 
                                     reinit:[params valueForKey:s]];
        [d setValue:c forKey:s];
    }
    return d;
}

- (void) applyto:(RE_Object *)t
{
    [t runAction:self withDict:nil];
}

- (void) runWithTarget:(RE_Object *)t
{
//  最朴素和原始的模式是:
//    [t updateAttributes:[controllerMap allKeys]];
//  给 RE_Action添加install参数是为了lazy加载
//  那么索性lazy到底呃
    if (!installed) {
        [t installAction:_name];
        installed=YES;
    }
    [t updateAttributes:[controllerMap allKeys]];
    return;
}

//- (void) runWithTarget:(RE_Object *)t withData:(id)params
//{
//    NSDictionary* nc= [self renewControllers:params];
//    [t updateAttributesWithControllers:nc];
//}

// 这里面的value是喂给controller的，然后再由controller去更新attribute
// 坚决不能用这里的value直接update_attribute
// 并且我们决定把这个controller作为一个一次性controller来使用
// 之后还restore之前的controller value，这样做有点麻烦
// 可以考虑放在controller里实现，runwith value 神马的。
// 对于永久性修改controller的api，留给withParams接口吧。
- (void) runWithTarget:(RE_Object *)t withValues:(NSDictionary*)values
{
    for (NSString* attr in [values allKeys]) {
        RE_AttributeController* c = [controllerMap valueForKey:attr];
        [c runOnce:[values valueForKey:attr]];
    }
//    [t updateAttributes:attributes];
    [t updateAttributes:[controllerMap allKeys]];
    return;
}

//- (void) runWithTarget:(RE_Object *)t withParams:(NSDictionary *)params
//{
//    // params is meant to feed into controllers
//    NSDictionary* newcontroller = [self renewControllers:params];
//    [t updateAttributesWithControllers:newcontroller];
//    return;
//}
// 实际上，一个更好受用的接口是postMSg withFIlter
// 也就是说，一个msg可能不知道自己的直接听众是谁
// 但是它知道复合的条件，这样我们就可以发送到一个
// 潜在的受众，然后通过filter来筛选接受者是否该接受该消息

- (void) runWithTargets:(NSArray *)ts
{
    
}

- (void) runfrom :(RE_Object *)f to:(RE_Object *)t
{
//    传递三个参数》sender，message／actionName，数据
//    其中数据，作为攻击而言，就是攻击的参数，防守亦然，
//    这些数据是需要定协议的显然。
//    那么这个数据从哪来呢，显然是要先由发起者f计算一下下的
//    最终把Action归类成为一个函数
//    performAction相当于执行了一个OC里面的Selector
//    最好把这个过程交给Skill吧
//    同时，我们把公式放到Attribute里面
//    求Attribute的时候自然而然的会应用其公式
//    怎么样绑定动作是一个问题
//    这样的话Skill可能就是一个简单的装配体了

//    按照现在的设定，大概是这样的两个步骤，
//    先发消息，这个消息多半是发给对手的，但是也可能是发给自己的。
//    之后读状态，然后根据状态来更新动画，这个状态都是自己的，
//    更新的动画也是自己的，因此每个action对应的两个参数是
//    主题：执行者；受体：目标
//    其中，主体可以作为一个属性，也可以作为一个参数。
    
//    RE_ActionData* d = [f performAction:name];
    
    NSDictionary* d = [self assemble:f];
    [f performSpriteAction:_name:d];
    RE_Msg* msg = [RE_Msg makeMsg:f:_name:d];
    [RE_Msg post:msg:t];
    
}

//- (RE_AttributeController*)makeController:(NSDictionary*)template
//{
//    
//}

- (id) initWithDictFile:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:filename];
    NSMutableDictionary* actionDict = 
        [[NSMutableDictionary alloc] 
            initWithContentsOfFile:finalPath];
    NSDictionary* actions = [actionDict valueForKey:@"Actions"];
    NSArray* controller_array = [actions valueForKey:_name];
    
    for (NSDictionary* template in controller_array) 
    {
        NSString* attrib_name = [template valueForKey:@"attribute_name"];
        NSNumber* type = [template valueForKey:@"type"];
        NSNumber* value = [template valueForKey:@"initvalue"];
        
        RE_AttributeController* c =[RE_ControllerFactory makeController:[type intValue] withCycle:0 withValue:[value intValue] withParams:nil];
        [controllerMap setValue:c forKey:attrib_name];
    }
        return self;
}

- (id) initWithDictFile:(NSString *)filename
withName:(NSString *)attribname
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:filename];
    NSMutableDictionary* actionDict = 
    [[NSMutableDictionary alloc] 
     initWithContentsOfFile:finalPath];
    NSDictionary* actions = [actionDict valueForKey:@"Actions"];
//  话说这个_name属性
    NSArray* controller_array = [actions valueForKey:_name];
    
    if(!controllerMap)
        controllerMap = [[NSMutableDictionary alloc]initWithCapacity:5];
    
    for (NSDictionary* template in controller_array) 
    {
        NSString* attrib_name = [template valueForKey:@"attribute_name"];
        if([attrib_name compare:attrib_name])
        {
        NSNumber* type = [template valueForKey:@"type"];
        NSNumber* value = [template valueForKey:@"initvalue"];
        
        RE_AttributeController* c =[RE_ControllerFactory makeController:[type intValue] withCycle:0 withValue:[value intValue] withParams:nil];
        [controllerMap setValue:c forKey:attrib_name];
        }else
            continue;
    }
    installed=NO;
    return self;
}

- (id) initWithArray:(NSArray *)controller_array 
            withName:(NSString *)name
{  
    if(!controllerMap)
        controllerMap = [[NSMutableDictionary alloc]initWithCapacity:5];
    for (NSDictionary* template in controller_array) 
    {
        NSString* attr  = [template valueForKey:@"attribute"];
        NSNumber* type  = [template valueForKey:@"type"];
        NSNumber* value = [template valueForKey:@"value"];        
        NSNumber* life  = [template valueForKey:@"life"];
        NSNumber* data  = [template valueForKey:@"data"];
        RE_AttributeController* c =
            [RE_ControllerFactory makeController:[type intValue] 
                                       withCycle:[life intValue] 
                                       withValue:[value intValue] 
                                      withParams:data];
        [controllerMap setValue:c forKey:attr];
    }
    _name=name;
    installed=NO;
    return self;
}

// 仅仅告诉名字肯定还是不行的，我们仍然需要一个字典来做
// 只不过这个名字是靠字典来索引的，而已
// 因此这个字典是
+ (RE_Action*) make:(NSString *)name
{
    return [RE_ActionFactory make:name];
}

@end
