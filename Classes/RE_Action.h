//
//  RE_Action.h
//  RPG_Engine
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RE_AttributeController.h"
#import "RE_ControllerFactory.h"
#import "RE_Object.h"
/*
 RE_Action 实现了一个角色的动作，
 这个动作包含Model和View两个方面，
 View上就是可能播放的动画，
 Model上就是会影响攻受双方的数值。
 因此就是skill和spriteAction的打包。
 
 在此，RE_Action充当了Attribute Controller的角色
 可以绑定到一个或者一组Attribute，可以对其进行粒子
 
 */

/*
 action实现了两个作用，角色本身的数值操作封装
 和，对目标角色的数值操作封装。
 对于后者，我们发现，可以使用相同的实现方法，
 即，安装，再运行，只不过这种controller的life只有一个cycle一般情况下。
 这种pattern我们可以把0 cycle的controller或者是
 只运行一次的action放到一个cache里面，稍后再用。
 */

@class RE_ActionFactory;

@interface RE_ActionV1 : NSObject
{

//  绑定到CharacterSpirite的名字
//  需要用这个名字去character里面查询spiriteAction
//    并且把需要用到的参数传给它，
//    同样，可以用这个名字来查询skill....
//    索性用这个名字来驱动selector得了。
//    由得到的selector来计算attributes
//    和魔法技能？
    Boolean installed;
    NSString* _name;
//    宿主
//    对于目标角色使用的技能是基本上没有宿主的
//    更像是传递了一个打包好的变量。
    RE_Object* host;
    
//    由于该action中的attributes可能有存在依赖？
//    因此需要对controllerMap进行排序，保证按照依赖顺序更新
//    现阶段，我们只是使用依赖来保存矢量值，之后可能还会有别的用处。
//    该变量用于指示该action是否已按依赖排过序。
    Boolean _sorted;
    
//    主要想用这样一个结构，为了静态化倒是可以考虑后两个结构
    NSMutableDictionary* controllerMap;
    
//    需要和动作绑定的属性，
//    这些属性在controller更新完之后可能要用到
//    例如用于更新角色动画    
    NSMutableArray* attributes;
    
//    需要打包的Controllers
//    Index和attributes对应
//    现在的问题是，这些Controller是从哪里来的？
//    显然需要一个工厂模式了，并且可能需要一些输入。
//    这样的话，我们可能把controller这个类重写下
    
//    controller的需求：
//    (1) 可以/必须 绑定一个AttributeName
//    (2) 有自身执行的操作，简单的操作
//    (3) 可以接受参数
//    (4) 参数，或者输入，可能是另外一个或几个Attr
    
//    这么看来需要这样几个元素来构建一个controller
//    Name,Operation,Parameter_Names_List
//    最后一项的话，可以有，可以没有，可以是一个匿名项
//    在调用的时候再指定。
//    第一项也不要了,绑定的时候才有用

    NSMutableArray* controllers;
    
}

- (RE_AttributeController*) getController:(NSString*)attr_name;
- (NSArray*) getAttributes;


// 所有Action类都需要有的接口,并且这个接口内部会调用attributes
// 来合成将要生成的动作。
// run这个操作，就是一个RE_Action的执行过程，主要完成两个功能
// 播放动画和执行可能存在的skill，
// 对于前者，需要的参数是计算播放动画需要的参数或者是角色属性
// 对于后者，凑齐skill需要的targets就OK啦

// 也就是说，RE_Action是一个代理类，要替SpiritAction来计算一下
// 需要的运动参数，取得CharacterAttribute，然后计算属性。
// 另一方面就是替Skill来计算一下其TargetScope和Targets
// 可能，Skill的一些一来属性，也需要放在这里计算，
// 总之中箭的计算都放在这里就OK了。

// 例如对于Move类的Action，那么就需要计算一个角色的位置和
// 可行的位移值，这就需要一个具体的，操作，称为MapQuery或
// SceneQuery之类的。

// 至于我们唯一可以确定的是，这个Query是跟这个属性有关系的，
// 因此，完全可以交给CHaracter去做，也就是说属性是Character的，
// 相关的偏移量也可以设置为或者看成Character的属性，
// 那么，Character的属性，是不是要交给Character去处理呢；

// 架构上是这样的，细节上再雕琢。

// sort the controllers
- (Boolean) sortOnDependens;

// 非及物动作
- (void) run;

// 及物动作们
- (void) applyTo:(RE_Object*)t;
- (void) runWithTarget:(RE_Object*)t;
- (void) runWithTarget:(RE_Object *)t withData:(id)params;
- (void) runWithTarget:(RE_Object *)t withParams:(NSDictionary*)params;
- (void) runWithTargets:(NSArray*)ts;

// run helpper
- (NSDictionary*) renewControllers:(NSDictionary*)params;
// 这个可以有
//- (void) runWithFilter:(RE_ObjectFilter*)f;

// 怎么样来制造action，是现在的一个问题，
// 主要是在于，有的action需要输入，每次执行都需要输入
// 有的action，不需要输入，或者是可以间断性更新的
// 那么我们可以留一个更新的接口，然后视情况把这个更新绑定到输入
// 例如
// updateController:(NSString*)name withValue:(id)value
// updateControllersWithDict:(NSDictionary*)controllers
// updateControllers:(NSArray*)allcontrollers

// DictModel : HashMap<NSString, RE_Controller>
// DictModel : HashMap<NSString, RE_ControllerTemplate>
- (id) initWithArray:(NSArray*)map withName:(NSString*)name;
- (id) initWithDictFile:(NSString*)filename;
- (id) initWithDictFile:(NSString *)filename 
                       withName:(NSString*)attribname;

// @private
// factory
+ (RE_Action*) make:(NSString*)name;

@end
