//
//  RE_CharacterAttributes.m
//  RPG_Engine
//
//  Created by  on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_CharacterAttributes.h"
//#import "RE_AttributeValue.h"

@implementation RE_CharacterAttribute
@synthesize lockable;
@synthesize locked;

- (Boolean) lock
{
    // 比较好的解决方式当然是用委托来做这个艰难的决定咯
    locked=TRUE;
    return locked;
}

- (Boolean) unlock
{
    locked=NO;
    return locked;
}

- (void) setController:(id)passcontroller
{
    if(lockable&&!locked)
        _controller=passcontroller;
}

- (void) unsetController
{
    if(lockable&&!locked)
        _controller=nil;
}

- (Boolean) setValue:(float)value
{
//  这里要权衡下updator和lock的优先级，显然是lock高
//  以后可以设计低于updator的lock
    if (_lockable && _locked) {
        return false;
    }
//    if (hasUpdator) 
//    {
//        res = [updator tryUpdate:value withValue:value];
//    }else
    _value=value;
    return true;
}

//-(Boolean) updateWithDelta:(NSNumber *)delta
//{
//    Boolean res = false;
//    //  这里要权衡下updator和lock的优先级，显然是lock高
//    //  以后可以设计低于updator的lock
//    if (locked) {
//        return false;
//    }
//    if (hasUpdator) 
//    {
//        res = [updator tryUpdate:_value withDelta:delta];
//    }else
//    {
//        // NSNumber的算数操作实在是操淡啊
//        NSLog(@"we got the value %f",[_value floatValue]);
//        NSNumber*tmp =_value;
////      像以上这么做显然是autorelease出了问题
////      好的办法是用@property (retain)
//        _value = [[NSNumber numberWithFloat:[tmp floatValue]+[delta floatValue]]retain];
//        [tmp release];
//    }
//    return res;
//}

- (NSNumber*) getValue
{
    return [NSNumber numberWithFloat:_value];
}

-(float) getFloatValue
{
    return _value;
}

- (Boolean) hasController
{
    return controllers==nil?false:([controllers count]>0);
}

- (void) runControllers
{
    // controller 是一个函数指针，
    // 在这里要想办法调用这个函数指针，
//    并且这个函数只能操作本attribute的值。
//    something like this
    NSLog(@"have %d controller",[controllers count]);
    for (RE_AttributeController* ac in controllers) {
//      如果是这样的话，依赖怎么解决呢亲？
//      解决依赖的方法很简单，
//      比较复杂的情境是依赖树，那么对树进行一个遍历就可以了
//      总体的原则，总是一样的，就是给出一个有序结果
//      例如树可以序列化为一个有序的数组
//      然后按照顺序自然就解开依赖了
//      因此，这个有序化是在更新一组attribute前做的
//      也就是在runAction里面做的。
        [ac run];
    }
    return;
}

// 作为友元开放给controller就OK。
- (void) addController:(id)contr
{
    RE_AttributeController* ac = contr;
    [ac setRetarget:self];
    [controllers addObject:contr];
    
}

//- (void) applyController:(RE_AttributeController *)controller
//{
//    [controller run:self];
////   如果有必要，controller会将自己添加到队列么？
////   还是显式的添加呢？
////   暂时倾向于前者。
////   那么这样看来，controller应该是一个足够封闭的对象
////   可能对输入会有几个比较开放的接口
////   但是对输出，例如此处，接口就很少，并且很封闭了，
////   大概呈现这个样子：
////   [controller run:self];
//}

- (RE_CharacterAttribute*) initWithFloat:(float)Float
{
    if(!(self=[super init]))
        return nil;
    _value = Float;
    _lockable=false;
    _locked=false;
//    controllers = [[NSMutableArray alloc] init];
    _depends = [[NSMutableArray alloc]init];
    return self;
}

//- (id) initWithNSArray:(NSArray *)array
//{
//    //    _value = [[RE_AttributeValue alloc]initWithData:num];
//    var = array;
//    controllers = [[NSMutableArray alloc] init];
//    _depends = [[NSMutableArray alloc]init];
//    return self;
//}

//- (id) initWithNSNumber:(NSNumber *)num 
//            withDepends:(NSArray *)depends
//{
////    _value = [[RE_AttributeValue alloc]initWithData:num];
//    _value = num;
//    controllers = [[NSMutableArray alloc] init];
//    _depends = [[NSMutableArray alloc]initWithArray:depends];
//    return self;
//}

- (id) initwithLockable:(BOOL)Lockable andValue:(float)value
{
    if(!(self=[super init]))
        return nil;
    _lockable=Lockable;
    _locked = false;
    _value = value;
    return  self;
}
@end
