//
//  RE_Object.h
//  RPG_Engine
//
//  Created by  on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RE_AttributeController.h"
//#import "RE_item.h"
#import "RE_CharacterAttributes.h"

@class RE_Msg;
@class RE_Action;
@class RE_Sprite;
@class RE_AttributeController;
// 游戏内物品的总类，抽    象类，可以接受技能的主体和受体。
// 消息机制的实现接口，
// 行为映射的实现接口
// 實現Attributes集合和接口
// 可以从Character移動過來
@interface RE_Object : NSObject
{
    // 现阶段的map是一个String -> String的map
    // 然后由String再去查询Action或者Skill
    NSMutableDictionary* _actionMap;
    NSMutableDictionary* _actions;
    NSMutableDictionary* _attributes;
    NSMutableDictionary* _sprites;
}

// from RE_Character
// 现在用action了
// action interface move to RE_OBject next version
- (void) installAction:(NSString*)name;
- (void) installActions:(NSArray*)actions;
- (void) installAction:(NSString*)name 
              fromFile:(NSString*)file;
- (void) performAction:(NSString*)name;
- (RE_Action*) takeAction:(NSString*)actname;

// attributes 
- (id) getInstalledByKey:(NSString*)key;
- (void) setAttributeByKey:(id)attr:(NSString*)key;
- (void) modifyAttributeByKey:(id)attr:(NSString*)key;

- (void) installWithIndex:(int)index;
- (void) installWithName:(NSString*)name;

- (void) applyControllers:(NSDictionary*)controllers;



/* new Attribute Interface
 */
- (int) installAttr:(NSString*)name:(RE_CharacterAttribute*)attr;
- (Boolean) tryUpdateAttb:(NSString*)name 
                withDelta:(RE_AttributeValue*)delta;
- (Boolean) tryUpdateAttr:(NSString*)name  
                withValue:(RE_AttributeValue*)newValue; 

- (void) setAttribute:(NSString*) name :(RE_CharacterAttribute*)attr;
- (void)removeAttribute:(NSString*)name;

- (NSNumber*) getAttribute:(NSString*)name;
- (NSDictionary*) getAttributes:(NSArray*)attributes;


//受体
//- (RE_Effect*) takeEffect:(RE_Object*)takee:(RE_Effect*)effect;
//主体
//- (RE_Effect*) makeEffect:(RE_Object*)makee:(RE_Effect*)effect;

// 把这个放到 RE_CharacterAttribute 里面
//- (void) updateAttribute:(NSString*)name;
- (void) installController:(RE_AttributeController*)controller 
                  withAttr:(NSString*)name;
- (void) updateAttributes:(NSArray*)array;
- (void) updateAttributesWithControllers:(NSDictionary*)controllerDict;

- (NSNumber*) getAttributeValue:(NSString*)name;

- (void) newAction:(RE_Action*)action withName:(NSString*)name;
- (void) newMapEntry:(NSString*)trigger withAction:(NSString*)action;
// runAction
- (void) runActionWithName:(NSString*)name withParam:(id)data;
- (void) runActionWithName:(NSString *)name withDict:(NSDictionary*)data;
- (void) runAction:(RE_Action*)action withParam:(id)data;
- (void) runAction:(RE_Action*)action withDict:(NSDictionary *)data;

- (RE_Action*) reActionOn:(NSString*)trigger;
//消息机制只实现接收和转发，主要是转发接口
- (void) repostMessage:(RE_Msg*)msg targets:(RE_Object*)tgt;
- (void) handleMessage:(RE_Msg*)msg;

//消息发送接口，实现再看看吧
- (void) sendMessage:(RE_Msg*) scope:(RE_Object*)scp;
// 主要的问题是消息的听众的确定和规则，


- (id) initWithFile:(NSString *)filename;
- (id) initWithDict:(NSDictionary*)dict;

/*
 例如场景这个元素，是天然的消息网络
 其中元素的一部分异步互动作用是通过这个实现的，
 例如一个精灵踏入一个NPC的领地，这时一个事件发生了，
 NPC自然会得到消息，并做出反应；
 另外一方面，NPC的其它伙伴是不是也会得到消息呢？
 因此，我们需要找到一条消息传递的途径？
 现在看来是一个NSArray，里面放满了RE_Object
 */

/*
 关于 Event和Listener，Listener是一个触发器，会
 根据条件来判断是否需要触发一个事件，所以Listener
 可以考虑绑定到角色的属性或者属性组上。
 */

/* 2012-7-5
 从云风大人处学来的办法是：把AOI和Scene都做成单独的服务，
 然后同每个Character的Agent联合运行。
 */


/* 2012-7-5
 现在重新规范下Character的接口，也就是Object的接口：
    首先是处理Message，包括：（1）接收 （2）反馈 （3）发送（＋群发） （4）转发
    其次是状态机，状态机要高于Message层，例如在非战抖模式时，
 发送和接受战抖类的消息都是无效或者禁止的，因此状态机的一个方面就是控制消息收发的集合。
    再次是Action的处理，低于消息层的单独封装，有些message会作为Action来处理，
 主要是作用于本身的属性的，另外一类消息可能会操作背包云云。注意有一类关于Action的操作，
 应该也不是作为Actoin类消息来处理的，这就是InstallAction类的消息，参数是一个Action，
 但是这个Action是用来Install的，而不是Apply的。
    最后，就是Items了，包括，Install和Apply两种操作，注意Install和Apply操作的实质
 都是属性操作，（这也就是说合体在技术上是透明的么。。。。）
    [
    对于Items的属性合并，关键是要给交集的处理留出余地，最好的做法，莫过于用新的属性覆盖原来的属性，但是在集合分离以后原来的属性还可以还原，一种好的做法就是保留差值，或者直接由公式来控制属性的计算，而不是用不同的存储器来存储属性，但是这种公式的设计势必是复杂的，而保留差值的做法一样要占有一个存储器。另外一种方法就是链接，属性的总和没有变，但是每个属性会有一个备用属性的链接。。。总之是还没想好各种。。一个短视的方法是，做一个对象集合，然后把所有的同名属性都加起来。。。同样的一个方法是把对于每个install的Item的属性都加到Host身上，之后，拆掉的时候会再减去或者卸下。还算是靠谱。第一种模型很诱人呃。
    ]
 
 另外，还有一个Object的接口是event，这个基本可以归到Message来实现，或者叫timer异步？
 例如，武器强化要冷却，再例如毒伤，醒刀，喂刀，云云。
 这个事件，其实跟Message的关系是不大的，可能需要另外一个接口来做，更多希望，Object内部就能实现？
 
 对于MessageHandler，希望一个高效的调度接口，因为基本上，所有的服务器内通信和服务器间通信都要用到这个接口，所以效率的考量主要来自，数据传输和解码以及调用的层次；这种情况下，基本上一个函数数组，是最快的了。消息被过滤后就可以直接索引了。
 如果Message的效率足够高，Event就走Message接口，否则，就走单独的内置接口，这样的话，只是省了解码和索引的步骤。
 内置接口的话，就是一个timer来驱动每个类的timer更新事件，这个time采用一个既定的周期，例如一秒或者两秒。
 但是除了timer事件以外基本上想不出什么别的事件了。对于timer而言，我们更希望，网络上的通信可以慢些或者自适应些。
 
 --- 2012.7.6 ---
 关于timer的实现，被划分到单独的服务里面，这个服务非常简单，就是给Agent或者其它Entity提供定时消息服务，包括单条和批量定时消息服务，这个服务，其实也是一个简单的pub/sub模型，因此可以考虑用redis来搭原型，或者用一个python wrapper来订制一个基于redis的pub/sub模型。
 这样，我们基本的框架就定下来了，就剩下Agent和Entity之间的一个界定了。
 
 Agent在逻辑上的定义是通过Session与客户端通信的实体，因此Agent要包含地图实体来更新地图，也要包含一个Character实体来处理客户端事件，其中，地图服务是共享的服务，而Character实体是Agent独占的服务，
 也就是，基本上，Agent可以理解为一个单独的处理机（Corountine或者Thread），主要封装了一个Character实体，或者Character Group实体，同时申请一个Scene的服务，作为Scene的Subber，自然Scene是一个Pubber了。 
 另外，Client也是Agent的一个Subber，每个Subber都会注册一组服务，或者称消息接口，MessageMask来指定自己订阅的消息名称，之后Pubber会把相应的消息推送给Subber。
 Client是一个终端，terminal，只是一个Subber，
 另外一方面，Scene和Agent，更多的就是Subber和Pubber兼有的，称为Piper是可以的。
 最后，就是很少见的Pubber Terminal，那么，这些Pubber多半是用户输入接口和系统事件接口，还有就是timer事件接口。
 好了，这下，要想办法设计高效的Pub&Sub模型了，
 好的经验是，消息的路径越短越好。
 
 --- 2012.7.5 ---
 
 表面上我们是不喜欢event走网路的，这样带宽消耗太大了。或者，更情愿，用慢event来同步一下。
 
 以上这些接口明确以后，就是数据的网路之问题了：Data Loop：
 用户的输入，首先在客户端转化为前端的效果，另外，前端转化为消息，发给服务端，包括状态和其它的事件，
 服务端在session内，由相应的（ID匹配）agent来处理消息，同时，把各个agent的状态发回客户端，来更新
 当前的场景和场景中的角色。这样看来，客户端和服务器的session之间要更新的主体还蛮多这个要梳理一下。
 和客户端的通信中要包括Character和Scene，玩家的Character和Scene的更新是由client完成的，而其它玩家的更新是由服务器完成的，那么NPC放在哪边呢？介于先进的AOI和ScenePub都是服务器端实现的，那么，
 若想增强互动，很多计算是要放到服务器端的，但是异步的互动，可以在互动和网络压力间做个折中。
 
 另外一方面，可以把timer做到客户端，然后由客户端给服务器发状态消息。
 这里，有必要定一下CS的通信协议，基本上是一个Scene对象的proto buf的封装，基本上Scene是一个容器，其间的主要对象是各种Object，所以另外一种协议就是Object了，因此有两种消息，一种是对Scene的操作，一种是对Object的操作。一种中立的设计即是，客户端的每个个体和Scene对象均可接收消息，消息可能来自服务端，也可能来自用户输入事件驱动，更可能来自其它的子系统（AI和AOI和NPC互动等等消息和事件，基本上所有事件都被封装成消息了）。这样是可以保持用户体验的，但是问题在于状态的同步，和合理的带宽设计。
 并且这样的话，客户端的负担可能会加重，因为其承担了一部分逻辑运算，（粗略估算应该在能承受范围内）
    剩下的问题是，客户端的实体和服务端的实体，本质是一个东西，这样，两者的所有状态更新是要同步的，那么，来自客户端的逻辑产生的状态更新数值会不会造成大量冗余数据来占据带宽呢？
    OK，折中设计的合理折中就是减少客户端逻辑。
 
 剩下的一个设计是剧情系统，或者叫作自动剧情系统，这个是我们最期待的哦，
 剧情系统主要的是绑定物品，例如，每个物品有一个clue，clue之间会有依赖，然后clue会形成一条链，在某个
 clue点到达以后，可能存在新的clue和trigger，那么trigger可能会有很多扩展了，新的剧情，这样，剧情就可以包括Scene和NPC（NPC自动包括了Dialog和剧情），自动剧情生成系统就是把玩家的一些信息转化成NPC（包括剧情和Dialog）
 OK，下面大概设计一下剧情系统，首先是clue集合，注意，clue是无序的，但是是有依赖的，很好的情况就是一个图，座落在一个集合之上；clue里面有trigger，可以出发更多元素：新的clue，新的物品和新的Scene，trigger是的触发条件是满足clue的依赖（也是clue的依赖存在的意义），因此一种合理的设计是clue要依赖其本身，之后就是clue的出口是一个包，这个包可能什么都没有，也可能有Scene、Item、和Clue，甚至可以有Character（基本可以肯定是NPC了），这些可能是新的也可能是旧的，也可能是旧的with新的数值。
 新的剧情系统可以更开放一些，最关键的技术是能让玩家间协作（PVP的一种），同时也能把玩家的数据转化成NPC，
 例如被厉鬼控制，（这点肯定是要在服务器端进行一定的搜索和推荐的）
 
 // 写到这里发现，这种属性集合的操作，真是太适合用Redis之类的NoSql了，有着先天的列优势呀，
 并且这个属性可以放到一个集合或者字典里（如果字典提供合并操作的话。。。）
    
 */


@end
