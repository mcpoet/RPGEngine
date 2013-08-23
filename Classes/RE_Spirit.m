//
//  RE_Spirit.m
//  RPG_Engine
//
//  Created by  on 12-5-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_Spirit.h"

@implementation RE_Spirit

- (NSArray*) getFrameRects:(NSString *)name
{
    NSArray* array = [actionDictionary objectForKey:name];
    return array;
}

// 对于多维的运动我们应该想个办法让他们叠加在一起
// 想更好的办法来描述更完美而复杂的movement

// 对于皮影式的动画而言，基本上全是运动了。。。
// 因此此处称为translate更为合适些。

//- (CGPoint*) movePoint:(CGPoint*)p
//                      :(RE_Movement*)move
//{
//    switch (move->direction) 
//    {
//        case 1:
//            p->y+=move->distance;
//            break;
//        case 2:
//            p->y+= -1*move->distance;
//            break;
//        case 3:
//            p->x+=move->distance;
//            break;
//        case 4:
//            p->x+=-1*move->distance;
//            break;
//        default:
//            break;
//    }
//    return p;
//}
//
//- (CGPoint*) movebackPoint:(CGPoint*)p
//                      :(RE_Movement*)move
//{
//    int distance;
//    if (move->turnback) {
//        distance = -move->distance;
//    }else
//        return p;
//    switch (move->direction) 
//    {
//        case 1:
//            p->y+=distance;
//            break;
//        case 2:
//            p->y+=distance;
//            break;
//        case 3:
//            p->x+=distance;
//            break;
//        case 4:
//            p->x+=distance;
//            break;
//        default:
//            break;
//    }
//    return p;
//}
//
// 可以扩展到很多种的情况。。。
//- (CCSequence*) makeMove2:(RE_Movement*)move1
//                        :(RE_Movement*) move2
//{
//    CGPoint p =CGPointMake(0, 0);
//    [self movePoint:&p :move1];
//    [self movePoint:&p :move2];
//    
//    CCAction* a = [CCMoveBy actionWithDuration:0.8f 
//                                      position:p];
//    
//    CGPoint q =CGPointMake(0, 0);
//
//    if (move1->turnback || move2->turnback) 
//    {
//        [self movebackPoint:&q :move1];
//        [self movebackPoint:&q :move2];
//        CCAction* s = [CCMoveBy actionWithDuration:0.8f 
//                                          position:q];
//        return [CCSequence actionOne:a two:s];        
//    }
//    return [CCSequence actionOne:a two:nil];
//}
//
//- (CCSequence*) makeMove:(RE_Movement*)move
//{
//    CGPoint p =CGPointMake(0, 0);
//    [self movePoint:&p :move];
//    CCAction* a = [CCMoveBy actionWithDuration:0.8f 
//                                      position:p];
//    
//    if (move->turnback) 
//    {
//        CGPoint q =CGPointMake(0, 0);
//        [self movebackPoint:&q :move];
//        CCAction* s = [CCMoveBy actionWithDuration:0.8f 
//                                          position:q];
//        return [CCSequence actionOne:a two:s];        
//    }
//    return [CCSequence actionOne:a two:nil];
//
//}
//
//- (void) actionWithDict:(NSString *)name 
//                       :(NSDictionary *)params
//                       :(RE_Movement*)move
//{
//    CCSpriteBatchNode *scronBatch = [CCSpriteBatchNode batchNodeWithFile:batchNode];
//    [self addChild:scronBatch z:0 tag:1];
//    
//    NSMutableArray *animFrames = [NSMutableArray array];
//    CCSpriteFrame * f;
////    要考虑到对部分对称的动作的处理方法。
////    翻转神马的。
////    CCFlip搞定咯。
//    
//    NSArray* frameArray =  [actionDictionary objectForKey:name];
//    
//    for (int i =0 ; i<[frameArray count]; i++) 
//    {
////      确定这个转换可以哦？
//        CGRect *r = (CGRect*) [frameArray objectAtIndex:i];
////      在这里进行对祯的翻转操作。
//        f=[CCSpriteFrame frameWithTexture:[scronBatch texture] rect:*r];
//        [animFrames addObject:f];
//        
//    }
//    
//    CCAnimation *animation = [CCAnimation animationWithFrames:animFrames];
//
//    float* dur = (float*)[params objectForKey:@"duration"];
//    
////    动画和移动是分离的
//    [sprite1 runAction:[CCAnimate actionWithDuration:*dur animation:animation restoreOriginalFrame:YES]];
//    
//    [sprite1 runAction:[self makeMove:move]];
//    
//}
//
- (id) init
{
//    // always call "super" init
//	// Apple recommends to re-assign "self" with the "super" return value
//	if( (self=[super init])) {
//		
//        //        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"feats.plist"];
//        
//        CCSpriteBatchNode *scronBatch = [CCSpriteBatchNode batchNodeWithFile:batchNode];
//        [self addChild:scronBatch z:0 tag:1];
//        
//        //        [CCSpriteFrameCache sharedSpriteFrameCache ] addSpriteFramesWithFile:@"
////        sprite1 = [CCSprite spriteWithBatchNode:scronBatch rect:CGRectMake(0, 0, 150, 150)];
////        [sprite1 setPosition:CGPointMake(0, 200)];
////        [scronBatch addChild:sprite1 z:0 tag:3];
//        
//        NSMutableArray *animFrames = [NSMutableArray array];
//        CCSpriteFrame * f;
//        NSArray* frameArray =  [actionDictionary objectForKey:actionname];
//        for (CGRect r in [frameArray allValues]) {
//            f=[CCSpriteFrame frameWithTexture:[scronBatch texture] rect:r];
//            [animFrames addObject:f];
//            
//        }
//        
//        //
//        CCAnimation *animation = [CCAnimation animationWithFrames:animFrames];
//        //
//        [sprite1 runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithDuration:.8f animation:animation restoreOriginalFrame:NO] ]];
//        CGPoint cgp = CGPointMake(300 , 0 );
//        [sprite1 runAction:[CCMoveBy actionWithDuration:2.6 position:cgp]];
//
//	}

    return self; 
}

- (void) dealloc
{
    
}
@end
