//
//  RE_Character.m
//  RPG_Engine
//
//  Created by  on 12-4-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_Character.h"

@implementation RE_Character

@synthesize sprite=_sprite;
// 具体的技能和法术的作用方式，跟我们之前谈的三国杀差不多啊。。。
// 好吧，回头去看看三国杀的代码好了
//- (id) init
//{
//    Skills = [[NSDictionary alloc]init ];
//    return self;
//}

- (id) getInstalledByKey:(NSString *)key
{
    return [Installed_Items objectForKey:key];
}

- (void) installWithIndex:(int)index
{
    RE_Item* value = [[Inbag_Items allValues]objectAtIndex:index];
    NSString* key  = [[Inbag_Items allKeys]objectAtIndex:index];
    [Installed_Items setValue:value forKey:key];
}

- (void) installWithName:(NSString*)name
{
    RE_Item* item = [Inbag_Items objectForKey:name];
    [Installed_Items setValue:item forKey:name];
}

- (void) newItem:(NSString*)name:(RE_Item*)item:(int)count
{
    // count这个字段你必须处理掉
    // 比较笨的办法是放到RE_Item里，很情愿呢，
    // 更倾向于单独的字段
    [Installed_Items setValue:item forKey:name];
}

- (void) moreItems:(NSString*)name:(int)count
{
    
}

- (void) lessItems:(NSString*)name:(int)count
{
    
}

- (void) removeItem:(NSString*)name
{
    
}

- (id) useFirstHandyAttack:(RE_Character *)b
{
    //    RE_Skill* first = [[Skills allValues]objectAtIndex:0];
    //    [first formulate:self :b];
    return nil;
}

// 从一个plist构造一个RE_Character
// 主要是需要一个attributes列表，并且这个列表是比较吭爹的
// 还需要一个action列表，这个action列表，
// 应该是先初始化actionFactory，然后直接用action的名字
// 和参数从actionFactory里面生产就可以了。

// 更喜欢把这个函数叫做一个setup

- (id) initWithFile:(NSString *)filename
{
    [super initWithFile:filename];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:filename];
    NSMutableDictionary* Chardict = 
        [[NSMutableDictionary alloc] 
            initWithContentsOfFile:finalPath];
    NSArray* inbag = [Chardict valueForKey:@"inbag_items"];
    NSArray* installed = [Chardict valueForKey:@"installed_items"];

    for (NSString* i in inbag)
    {
        RE_Item * itm = [RE_ItemFactory make:i];
        [Inbag_Items setValue:itm forKey:i];
    }
    
    for (NSString* i in installed)
    {
        RE_Item * itm = [RE_ItemFactory make:i];
        [Installed_Items setValue:itm forKey:i];
    }
    
//    for (RE_Item* i in Installed_Items) {
//        [self applyItem:i];
//    }
    
    return self;
}

- (id) initWithDict:(NSDictionary *)Chardict
{
//    NSArray* inbag = [Chardict valueForKey:@"inbag_items"];
//    NSArray* installed = [Chardict valueForKey:@"installed_items"];
//    
//    for (NSString* i in inbag)
//    {
//        RE_Item * itm = [RE_ItemFactory make:i];
//        [Inbag_Items setValue:itm forKey:i];
//    }
//    
//    for (NSString* i in installed)
//    {
//        RE_Item * itm = [RE_ItemFactory make:i];
//        [Installed_Items setValue:itm forKey:i];
//    }
//    
//    for (RE_Item* i in Installed_Items) {
//        [self applyItem:i];
//    }
//    debug sprite first
    //此处先不用工场模式

    self = [super initWithDict:Chardict];
    NSArray* sprites = [Chardict valueForKey:@"sprites"];
    NSString* spritefile = [sprites objectAtIndex:0];
//    _sprite = [RE_CocosSpirit make:spritefile];
//  Really ugly HACK....
//    [_sprite setHost:self];
    
    return self;
}

- (void) performAction:(NSString *)name
{
    [self runActionWithName:name withDict:nil];
    [_sprite actionWithName:name];
    return;
}


+ (RE_Character*) factory:(NSString *)name
{
    // 文件名先写死了吧
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"character_book.plist"];
    NSMutableDictionary* Chardict = 
        [[NSMutableDictionary alloc] 
            initWithContentsOfFile:finalPath];
    if (Chardict ) {
        NSDictionary* c = [Chardict valueForKey:name];
        if (c) {
            return [[RE_Character alloc]initWithDict:c];
        }
    }else
    {
//      下半阕很不靠谱。。。
        NSString *finalPath = [path stringByAppendingPathComponent:@"character_map.plist"];
        NSMutableDictionary* Chardict = 
        [[NSMutableDictionary alloc] 
         initWithContentsOfFile:finalPath];
        if (Chardict) {
            NSString* charfile = [Chardict valueForKey:name];
            finalPath = [path stringByAppendingPathComponent:charfile];
            return [[RE_Character alloc] initWithFile:charfile];
        }
    }
    
    return nil;
}


// actually message protocol is not implemented
- (void) handleMessage:(RE_Msg *)msg
{
//    take action for command type msg
//    最好可以把COMMAND内嵌到类里面去。。
//  switch([msg type]){case COMMAND:break;}
    if([msg type] == installAction){
//        if ([m isEqualToString:@"walk"]) {
            //这两个应该合并到一个本地的方法里面
            [self runActionWithName:[msg message] withDict:[msg data]];
//            NSDictionary* d =
//                [_sprite offset:CGPointMake(100, 100) :CGPointMake(150, 120)];
            [_sprite actionWithName:[msg message] withParams:[msg data]];
//        }
    }
}

@end
