//
//  RE_Character.h
//  RPG_Engine
//
//  Created by  on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_Object.h"
//#import "RE_Attribute.h"
//#import "RE_Skill.h"
//#import "RE_Accessary.h"
#import "RE_item.h"
//#import "RE_Character_Observer.h"
//#import "RE_CharacterSpirit.h"
//#import "RE_CharacterState.h"
//#import "RE_StateMachine.h"
//#import "RE_Scene.h"
//#import "RE_WorldMap.h"
#import "RE_CharacterAttributes.h"
#import "RE_ItemFactory.h"
#import "RE_SpriteFactory.h"
#import "RE_ActionFactory.h"
//#import "RE_CocosActor.h"
#import "RE_Msg.h"

#define LEVEL_FACTOR 5

// 用于描述游戏中的角色
@interface RE_Character : RE_Object
{
    // 要考虑LEVEL_FACTOR在数值中的平衡作用。
    // 这样的背包配置，能不能有啥创新呢。。。
    // 理论上，这就是一个大的集合。。。
    NSMutableDictionary* Inbag_Items;
    NSMutableDictionary* Installed_Items;
    // 从性能的角度考虑，可以把Attributes静态化为一个数组。
    // 然后把属性名称静态化为一个枚举类型。
    // 所有的值都是int型么？单独建个array得了
    
//    NSMutableDictionary* Attributes;
//    NSMutableDictionary* Actions;
//    NSMutableDictionary* Sprites;
//    以上三个属性都放到RE_Object里面了
    NSMutableDictionary* States;

    // 以上三个字典集合都需要增加observer或者moniter来实现战报。
//    id<RE_Character_Observer> observers;
    NSMutableArray* observers;
//    NSMutableArray* queriers;
    NSMutableDictionary* Skills;
//    RE_Spirit* spirit;

    // 角色需要维护的状态。
    // 同时考虑对于不同角色是否要维护不同的状态机？
    // 现在把attributes都封装到StateMachine里面去了
    // 注意State里面可能有一些controller，因此现在暂且
    // 都封装到stateMachine里面，有新的state的时候后，会把
    // StateMachine直接替换掉。
        
//    RE_StateMachine* currentState;
//    RE_StateMachine* lastState;
//    RE_StateMachine* toBeRestored;
    
//  用于显示的角色的图形，可能是2D的也可能是3D的
//    RE_Spirit* curSpirit;
    id* _sprite;
//  在这里添加scene是为了计算角色移动的属性，
//  但是更理想的，我们希望可以把这些属性都封装在
//  一个类似闭包的结构里面，然后再透过闭包调用？
//    RE_Scene* curScene;
//  这个貌似就不怎么需要了呢
//    RE_WorldMap* nowworld;
    CGPoint* position;
//  以上三个都应该作为属性值存在的
}

@property (readonly) id* sprite;
// 预先计算各种属性的Selectors？
// 更具体的实现方式还没有想好。。。
// 起码的虚函数是要有的咯，



//- (void) performSpriteAction;

- (Boolean)compute_movement:(CGPoint*) movement
                           :(NSConstantString*)type;
// 这个就是实实在在的move动作了
// 稍后试着把它归到skill等类里面
// 此处的move是一个单向的move，只有一个方向和一个距离
// 多向的move由此move组成，或者由一个栈组成
// CGPoint里面x表示方向，y表示距离

// 战斗公式应该是独立于Character的，因此应该有个单独的函数，形式如下：
// FightFormular(RE_Character*from, RE_Character*to, RE_Skill_index*index);
// 群殴公式
// FightFormular(RE_Character*,   RE_Character*[], RE_SKIll_index);
// FightFormular(RE_Character*[], RE_Character*[], RE_Skill_index);

// 把战斗公式用Skill类包装起来就好，这样RE_CHaracter在使用skill时
// 就可以方便的把自己传给SKill了
// RE_Character * A;
// A.useSkill(RE_Skill_index,RE_CHaracter*bearor);

// void useSkill(RE_Skill_index i, RE_Character*bear)
//{
//    RE_Skill* skill = skills[i];
//    skill.formular(self,bear);
//}

// 稍后，把Skill和Item合并到一个抽象类，叫做Effect
// 然后调用公式的接口统一到takeEffect，就OK了。

// skills
//- (void) useSkill:(RE_Character *)bearor :(RE_Skill *)skill;
//- (void) useSkillWithName:(RE_Character *)bearor :(NSString*)skillname;
//- (id) useFirstHandyAttack:(RE_Character*)b;


// items
- (void) newItem:(NSString*)name:(RE_Item*)item:(int)count;
- (void) moreItems:(NSString*)name:(int)count;
- (void) lessItems:(NSString*)name:(int)count;
- (void) removeItem:(NSString*)name;
- (void) installItem:(RE_Item*)item;

// observers
//- (void) addCharacterObserver:(id<RE_Character_Observer>*)obs;
- (void) notifyCharacterObserver:(NSConstantString*)dictName:(NSString*)key
                                :(id)value:(NSConstantString*)operationType;

// constructor
// (1) 作为RE_Object 需要初始化自己的属性列表
//     这之间属性之间的关系怎么指定是个麻烦事
// (2) 作为RE_CHaracter 需要初始化自己的背包和身上的装备
//     这个装备部分，是需要一个RE_Factory来做的
// (3) 还有action列表, action_Factory
// (4) 还有绑定自己的sprite, Sprite_Factory
// 要注意有一部分动画是武器自己的动画
// 是RE_Item绑定的sprite

- (RE_Character*) initWithFile:(NSString*)filename;
- (RE_Character*) initWithDict:(NSDictionary*)dict;
// 一个类似工厂模式的接口，可以从一个文本或plist来读入角色的属性列表值
// 这个接口是必须的，生产环境。
//- (RE_Character*) initWithTemplate;

// 暂时的工场模式
+ (RE_Character*) factory:(NSString*)name;

// super class implementations
- (void)handleMessage:(RE_Msg *)msg;

//- (RE_Effect*) makeEffect:(RE_Object *)makee :(RE_Effect *)effect;
// 动态增加属性，我们希望，程序设计尽量的扁平化，而游戏设计，尽量的立体化
// 也就是尽量把所有的用来操纵的属性都放在一个容器里
// 但是游戏玩的过程中，又不是简单的属性对拼，加油实现吧！


// 为了保持游戏模型的复杂度，我们可以考虑把三国杀和魔兽争霸RPG
// 版本里面的设计引入到现在程序里面来考虑。
// 比如dota甚至魔兽世界。

// 也要想到，太复杂的设计，对于PVP网游而言，是很高的要求的。
// 因此，初期我们还是坚持简单的设计的，复杂的设计只会再游戏后期出现。

/*  因此，RPG的游戏设计核心是两条：一条属性集合，
    我们可以简单的看作是一个字典，OK,没问题。
    但是另外一个方面就比较麻烦了，技能，
    每个角色，是属性的集合，也是技能的集合，这些技能被用来作用于
    不同的玩家，而获得不同的反应，这种反应对于每种游戏来说
    效果都不尽相同，魔兽里面，技能基本是用于攻击和防守，
    计算的数值可以看成是加法和减法了，因为操作占了很大一部分（软技能）
    
    但是回合制RPG可能就更类似于卡牌了，（比卡牌更快捷），介于之间。
    那么我们说回合RPG倒也不用故弄玄虚的把技能计算弄的更复杂了吧，
    我们只是想弥补用户再操作之外遗失的那部分乐趣而已呢。
*/

/* <技能系统>
 
    技能和角色的耦合：
    几个基本的技能：攻击、防守、补血、团队攻击，团队防守和团队补血。
    
    还有一个属性很普遍的是：精气
    因此，一个最基本的RPG技能设计技巧是围绕：攻、防、精三者来做文章
    并使得其达到一个平衡。
    因此，可以把技能看成是一个公式，但是我们喜欢公式有立体感，而不是一味的平铺加减
    例如：一个基本的攻击公式是：
        blood_injury - = (attack-defend)*somefactor;
        spem_enhance + = (blood_injury)*some_other_factor;
    此spem_rebounce是借鉴了张无忌的乾坤大挪移和慕容博的以彼之道换之彼身的道理。
        spem_rebounce  = (spem_enhance)*some_other_factor;
    spem的enhance和rebounce都是急厉害的功力，但是按照平衡理论和艺高人胆大理论：
    越厉害的功力，在使用时，可能存在越厉害的罩门和造成越厉害的伤害。
    这种几率可以控制在50％的几率内，或者30％，来防止使用者滥用？
    
    
 */

/* <道具系统>
 
    另外在逆转裁判里面学来的另外一种 方式是道具解锁的概念
    当然北欧女神也有这个概念，例如，钥匙可以用来开门，等等。
    这个属于道具系统的范畴，需要一个单独的道具系统来支撑。
 
 */

/*
    和图形体统绑定，让角色更丰满，让角色有生命。
    （数值才是真的生命么不是。。。）
 */

@end
