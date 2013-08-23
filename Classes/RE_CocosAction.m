//
//  RE_CocosAction.m
//  CocosPractice
//
//  Created by  on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_CocosAction.h"

@interface RE_CocosAction()
- (CCAction *)makeMove:(NSDictionary *)params;
- (CCAction *)makeFrame:(NSDictionary*)params;
@end

@implementation RE_CocosAction

- (void) dealloc
{
    [super dealloc];
    // animFrames release????
}

// One Step Move

+ (CCAction*) makeMove:(NSDictionary*)params
{
    RE_Object* reobj = [params valueForKey:@"object"];
//  实际上这个更新是在spriteAction之前由objectAction做的
//  因此在此读出来就可以咯，这才是正解了。
    NSNumber* dir  = [reobj getAttribute:@"direction"];
    NSNumber* step = [reobj getAttribute:@"step"];
//    NSNumber* dir  = [params valueForKey:@"direction"];
//    NSNumber* step = [params valueForKey:@"step"];
    // 把这两个参数转化为x,y
    CGPoint p = CGPointMake(0, 0);
    switch ([dir intValue]) {
        case 0:
            p.x+=[step floatValue];
            break;
        case 1:
            p.y+=[step floatValue];
            break;
        case 2:
            p.y-=[step floatValue];
            break;
        case 3:
            p.x-=[step floatValue];
            break;
        case 4:
            p.x+=[step floatValue];
            break;
        default:
            break;
    }
    return [CCMoveBy actionWithDuration:.8 position:p];
}

+ (CCAction*) make:(NSDictionary*)params
{
    NSNumber* type = [params valueForKey:@"type"];
    int typei = [type intValue];
    switch (typei) {
        case 1:
            //move action
            return [self makeMove:params];
        case 2:
            // blink color action
//            return [makeBlink:params];
            break;
        case 3:
            // frame animation action
//            return [self makeFrame:params];
            break;
        case 4:
            // ....更多的效果和魔法blablabla
            break;
        default:
            break;
    }
    return nil;
}

- (RE_CocosAction*) initWithDict:(NSDictionary *)dict withSheet:(CCSpriteBatchNode*)ssheet
{
    
//  默认值不会就这么简单吧
    direction = 1;
    distance = 0;
    duration = 0.8;
    flip = NO;
    sheet = ssheet;
    
    NSNumber * dir = [dict objectForKey:@"direction"];
    if (dir) {
        direction = [dir intValue];
        flags|= 0x01;
    }
    NSNumber * dis = [ dict objectForKey:@"distance"];
    if(dis)
    {
        distance = [dis intValue];
        flags|= 0x02;

    }
    NSNumber * dur = [dict objectForKey:@"duration"];
    if(dur){
        duration = [dur floatValue];
        flags|= 0x04;

    }
    NSNumber * flp = [dict objectForKey:@"flip"];
    if(flp){
        flip = [dur boolValue];
        flags|= 0x08;
        
    }
    
    
    NSArray* frameArray =  [dict objectForKey:@"frames"];
    
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

        f=[CCSpriteFrame frameWithTexture:[sheet texture] rect:r];
        [animFrames addObject:f];
    }
    
    // this field need to be retainable;
    
    animation = [CCAnimation animationWithFrames:animFrames];
    
    return self;
    
}

- (CCAction*) action
{
    
    assert(direction !=0);
    assert(duration  !=0);
//    
    if(distance == 0) return nil;
    float x=0,y=0;
    // 对我们而言，direction只有两个维，1＝x，2＝y
//    实际上，默认得direction是角色自己得direction
//    现在做的变换，也无非是，一个幅角到笛卡尔坐标的变换。
    switch (direction) {
        case 1:
            x = distance;
            break;
        case 2:
            y = distance;
            break;
        default:
            break;
    }
    return [CCMoveBy actionWithDuration:duration position:CGPointMake(x, y)];
}

- (CCAction*) actionWithParams:(NSDictionary*)dict
{
    
    // all property is not updatable
    if(flags==0x07){
        return [self action];
    }
    int dir=direction;
    int dis=distance;
    float dur=duration;
    //  Direction  
    if ((flags&0x01)==0) {
        NSNumber* d = [dict objectForKey:@"direction"];
        if(d){
            dir = [d intValue];
        }
    }
    
    //  Distance
    if ((flags&0x02)==0) {
        NSNumber* d = [dict objectForKey:@"distance"];
        if(d){
            dur = [d intValue];
        }
    }
    
    //  Duration
    if ((flags&0x04)==0) {
        NSNumber* d = [dict objectForKey:@"duration"];
        if(d){
            dis = [d intValue];
        }
    }
    // 单纯的转向呢？
    if(dis == 0) return nil;
    float x=0,y=0;
    
    // 对我们而言，direction只有两个维，1＝x，2＝y
    //    实际上，默认得direction是角色自己得direction
    //    现在做的变换，也无非是，一个幅角到笛卡尔坐标的变换。
    switch (direction) {
        case 1:
            x = dis;
            break;
        case 2:
            y = dis;
            break;
        default:
            break;
    }
    
    CCAnimate * animate = [CCAnimate actionWithDuration:dur animation:animation restoreOriginalFrame:NO];
    return [CCSequence actions: animate,
            [CCMoveBy actionWithDuration:dur 
                                position:CGPointMake(x, y)], 
            [CCFlipX actionWithFlipX:flip],
            nil];
    
}


@end
