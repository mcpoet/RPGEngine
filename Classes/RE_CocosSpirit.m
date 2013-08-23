//
//  RE_CocosSpirit.m
//  RPG_Engine
//
//  Created by  on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_CocosSpirit.h"
#import "RE_CocosAction.h"

@implementation RE_CocosSpirit

@synthesize sprite=sprite1;
@synthesize host = _host;
@synthesize batch=_batch;
// 对于多维的运动我们应该想个办法让他们叠加在一起
// 想更好的办法来描述更完美而复杂的movement

// 对于皮影式的动画而言，基本上全是运动了。。。
// 因此此处称为translate更为合适些。

- (CGPoint*) movePoint:(CGPoint*)p
                      :(RE_Movement*)move
{
    switch (move->direction) 
    {
        case 1:
            p->y+=move->distance;
            break;
        case 2:
            p->y+= -1*move->distance;
            break;
        case 3:
            p->x+=move->distance;
            break;
        case 4:
            p->x+=-1*move->distance;
            break;
        default:
            break;
    }
    return p;
}

- (CGPoint*) movebackPoint:(CGPoint*)p
                      :(RE_Movement*)move
{
    int distance;
    if (move->turnback) {
        distance = -move->distance;
    }else
        return p;
    switch (move->direction) 
    {
        case 1:
            p->y+=distance;
            break;
        case 2:
            p->y+=distance;
            break;
        case 3:
            p->x+=distance;
            break;
        case 4:
            p->x+=distance;
            break;
        default:
            break;
    }
    return p;
}



- (void) moveSpirite
{
    NSLog(@"move me");
    CGPoint p = CGPointMake(100, 100);
    [sprite1 setPosition:p];
    
//    [sprite1 runAction:[CCMoveBy actionWithDuration:0.8f position:p]];

}


// 需要想个办法把RE_Object的属性传过来，好的办法是直接给它
// 传一个RE_Object，或者透过一个代理来访问RE_Object

// 还有一个办法就是，给每个sprite action绑定自己的参数。
// 显然不如前一个好。

- (void) actionWithName:(NSString *)name
{
    RE_CocosAction* act = [actionCache objectForKey:name];
    if (!act) 
    {
        
        act = [[RE_CocosAction alloc]initWithDict:[actionDictionary objectForKey:name] 
                                   withSheet:_batch];
        [actionCache setValue:act forKey:name];
    }
    [sprite1 runAction:[act action]];
    
    NSLog(@"new animation ...%@",name);

}

// 关键的地方在于，动画的参数需要定一个协议。
// 比如运动的时间，距离，方向，变色，其它特效等等
// 显然这个非常之麻烦。
// 最简单的方法是把这些参数静态化，
// 好吧，现在也没有别的方法咯。
// 例如walk，可以分解为一个帧动画＋一个Move动画
// 帧动画，可以细化为一种工场模式；
// Move，动画必须细化为一种工场模式了。
// 因此我们需要一个CocosActionFactory
// 通过params来生成CCAction
// 之后这个NSDictionary可以固化为一个struct

// 工厂模式 工厂模式

- (void) actionWithName:(NSString *)actname 
                       withParams:(NSDictionary *)params
{
//    NSString* name = [params valueForKey:@"name"];
    NSMutableArray* acts = [actionCache valueForKey:actname];
    if (!acts) 
    {
        acts = [[NSMutableArray alloc]init];
//        先这么丑陋的包一下吧
//        稍后想个办法，类似内嵌类之类的，处理下
        NSMutableDictionary* newP = [[NSMutableDictionary alloc]initWithDictionary:params];
        [newP setValue:_host forKey:@"object"];
        CCAction * act2 = [RE_CocosAction make:newP];
//      稍后把这个FrameAnimation应该放到RE_CocosAction里面去。
//      主要是要传sheet，有点别扭。放在这个类里也不错。
//        CCAction* frames = [self frameWithName:actname];
//        if (frames==nil) {
//            NSString* category = [params valueForKey:@"category"];
//            frames = [self frameWithName:category];
//            if (frames == nil) {
//                return ;
//            }
//        }
        [acts addObject:act2];
//        [acts addObject:frames];
        [actionCache setValue:acts forKey:actname];
    }
    for (CCAction*a in acts) {
        [sprite1 runAction:a];
    }
    NSLog(@"new dict animation ...%@",actname);
}

- (CCAction *)frameWithName:(NSString*)name
{
    NSDictionary* actionframes = [actionDictionary objectForKey:name];
    if (actionframes == nil) {
        return nil;
    }
    NSArray* frameArray =  [actionframes objectForKey:@"frames"];
    if (frameArray == nil) {
        return nil;
    }
    
    CCSpriteFrame * f;
    NSMutableArray *animFrames = [NSMutableArray array];
    for (int i =0 ; i<[frameArray count]; i++) 
    {
        //  确定这个转换可以哦？
        NSArray* rect = [frameArray objectAtIndex:i];
        
        CGRect r = CGRectMake([(NSNumber*)[rect objectAtIndex:0] floatValue]
                              , [(NSNumber*)[rect objectAtIndex:1] floatValue]
                              , [(NSNumber*)[rect objectAtIndex:2] floatValue]
                              , [(NSNumber*)[rect objectAtIndex:3] floatValue]);
        //  在这里进行对祯的翻转操作。CCFlip
        
        f=[CCSpriteFrame frameWithTexture:[_batch texture] rect:r];
        [animFrames addObject:f];
    }
    CCAnimation* a = [CCAnimation animationWithFrames:animFrames];
    return [CCAnimate actionWithDuration:0.8 
                        animation:a restoreOriginalFrame:YES];
}


- (RE_CocosSpirit*) initWithSheet:(NSString *)sheetName
                        withPlist:(NSString *)plistpath
{    
//    if( (self=[super init])) 
    {
        _batch = [CCSpriteBatchNode batchNodeWithFile:sheetName];
//        [self addChild:_batch z:0 tag:1];
	}
    
    sprite1 = [CCSprite spriteWithBatchNode:_batch rect:CGRectMake(0, 0, 150, 150)];
    [sprite1 setPosition:CGPointMake(0, 200)];
    [_batch addChild:sprite1 z:0 tag:3];
//    CGPoint p = CGPointMake(100, 100);
//    [sprite1 runAction:[CCMoveBy actionWithDuration:0.8f position:p]];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:plistpath];

    actionDictionary =  [[[NSMutableDictionary alloc] 
                         initWithContentsOfFile:finalPath] 
                         objectForKey:@"actions"];
        
//    [self setIsTouchEnabled:YES];
    
    NSLog(@"init with names happend");
    return self; 
}

- (id) init
{
    // always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	
    NSString * sheet = @"KOTR_Braford.png";
    
//    if( (self=[super init])) 
    {
        _batch = [CCSpriteBatchNode batchNodeWithFile:sheet];
//        [self addChild:_batch z:0 tag:1];
	}
    
    sprite1 = [CCSprite spriteWithBatchNode:_batch rect:CGRectMake(0, 0, 150, 150)];
    [sprite1 setPosition:CGPointMake(10, 10)];
    position = [sprite1 position];
    [_batch addChild:sprite1 z:0 tag:3];
    CGPoint p = CGPointMake(100, 100);
    [sprite1 runAction:[CCMoveBy actionWithDuration:0.8f position:p]];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSString *finalPath = [path stringByAppendingPathComponent:@"actionDicts.plist"];
    
    actionDictionary =  [[NSMutableDictionary alloc] initWithContentsOfFile:finalPath ];
    
    actionDictionary = [actionDictionary objectForKey:@"actions"];
    
    NSLog(@"init happend");
    return self; 
}

- (void) dealloc
{
    [sprite1 release];
    [_batch release];
       [super dealloc];
}

- (NSDictionary*) offset:(CGPoint)p1:(CGPoint)p2
{
    NSString* name;
    int dir;
    int step;
    int oy = p1.y-p2.y;
    int ox = p1.x-p2.x;
    if(abs(oy)>abs(ox)) 
    {
        if (oy>0) {
            name = @"walkup";
            dir =1;
        }else{
            name = @"walkdown";
            dir =2;
        }
        step = abs(oy);

    }
    else
    {
        if (ox<0) {
            name = @"walkleft";
            dir = 3;
        }else{
            name = @"walkright";
            dir = 4;
        }
        step = abs(ox);
    }
    NSMutableDictionary* d = [[NSMutableDictionary alloc]initWithCapacity:4];
    [d setValue:name forKey:@"name"];
    [d setValue:@"walk" forKey:@"category"];
    [d setValue:[[NSNumber alloc]initWithInt:1] forKey:@"type"];
//    [d setValue:[[NSNumber alloc]initWithInt:dir] forKey:@"direction"];
//    [d setValue:[[NSNumber alloc]initWithInt:step] forKey:@"step"];
    [ d setValue:_host forKey:@"host"];
    return d;
}

//- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"new tcouh end...");
//    UITouch* touch = [[touches allObjects] objectAtIndex:0];
//    CGPoint location = [touch locationInView: [touch view]];
////    NSMutableDictionary* moveDict = 
////    [[NSMutableDictionary alloc]initWithCapacity:3];
//    // type  = 1 = @move
//    NSDictionary *moveDict =[self offset:location:[sprite1 position]];
////    [moveDict setValue:[[NSNumber alloc]initWithUnsignedShort:1] forKey:@"type"];
//    
////    由location计算一个moveDict出来，然后传给actionWithName
//    [self actionWithName:@"walk" withParams:moveDict];
////    [self moveSpirite];
//}

+ (RE_CocosSpirit*)make:(NSString *)filename
{
    RE_CocosSpirit* r = [[RE_CocosSpirit alloc]initWithSheet:filename 
                                                   withPlist:@"actionDicts.plist"];
    return r;
}

@end
