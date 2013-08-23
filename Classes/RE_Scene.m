//
//  RE_Scene.m
//  RPG_Engine
//
//  Created by  on 12-4-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_Scene.h"

@implementation RE_Scene

// 直接把某个数组拷贝进去就可以了吧。。。
// 初始化时候的一个问题是，同一个位置上是否有多个对象呢？
// 考虑到毒草的存在，这个问题的回答是肯定的。
- (id) initWithFile:(NSString*)filepath
{
    // 同其它所有元素一样，一个scene的初始化过程，基本上跟
    // Character的初始化过程是一样的，从层次上而言，是
    // 更高一层的初始化。
    // 主要的数据即是，一个对象列表，包括：
    // 每个对象的初始位置，以及对象的初始化数据指针。
    return self;
}

- (RE_Object*) getObjectAtX:(int)x AtY:(int)y
{
//    if (x>column || y>row) {
//        return nil;
//    }
//    if (_sceneContainor) {
//        return [_sceneContainor objectAtIndex:(x*row+y)];
//    }
     // 有这么一种飘渺的地图是每个点的可如性都是随机的。。。
//    if (rand()>0) {
//        return [[RE_Object alloc]getGhostInstance];
//    }else
//        return nil;
}

// 现在这个Updator暂时就是这个状况咯，第一眼看去感觉接口比较乱
// 但是总体的逻辑还是满意的，功能上算是圆满了。

- (NSNumber*) tryUpdate:(RE_Object *)obj 
            withValue:(NSNumber *)delta
{
    // First get the RE_Object's position and direction
    int x   = [[obj getAttribute:@"position_x"] intValue];
    int y   = [[obj getAttribute:@"position_y"] intValue];
    int dir = [[obj getAttribute:@"direction"] intValue];
    //    理论上，step的值应该通过withValue传进来呢
    int stp = [[obj getAttribute:@"step"] intValue];
    //    以上代码可以明显看出step对dir的依赖性和x,y对dir和step的依赖性。
    switch (dir) {
        case 1:
            x+=stp;
            break;
        case 2:
            x-=stp;
            break;
        case 3:
            y+=stp;
            break;
        case 4:
            y-=stp;
            break;
        default:
            break;
    }
    // Then check the step positon
    //    在此，其实x,y已经被更新了，优化的方法是在此更新这两个属性，
    //    这样的话，updator将有权利更新一组属性，特别是相互联系的。
    //    更加细化的控制是继续查询该位置的RE_Object 的
    //    enter_able和contact_able属性。
    //    并且出发相应的事件：onEnter和onCOntact
//    Boolean enter_able = [self getObjectAtX:x AtY:y]==nil;
    // come on little hack
    Boolean enter_able =rand()>0;
    //     显然在此Boolean的返回值是不好用的。
    if (enter_able) 
    {
        // 引用计数，你懂的
        return [obj getAttribute:@"step"];
    }
    return  [[NSNumber alloc]initWithInt:0];
}

@end
