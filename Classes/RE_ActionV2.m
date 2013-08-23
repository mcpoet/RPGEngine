//
//  RE_ActionV2.m
//  SimpleBox2dScroller
//
//  Created by  on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_ActionV2.h"
//
//  RE_Action.m
//  RPG_Engine
//
//  Created by  on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_Action.h"

@implementation RE_OnePassCompulector

-(NSNumber*) SharpAttack:(RE_Entity*)host
{
    NSLog(@"Is this me ? sharp");
    float solid = [host getAttribute:@"solidness"];
    float strength = [host getAttribute:@"strength"];
    float r = (1000-solid)/(1000-strength);
    return [NSNumber numberWithFloat:r];
}

-(void) ShallowAttack
{
//    float solid = [host getAttribute:@"solidness"];
//    float strength = [host getAttribute:@"strength"];
//    return (500-solid)/(500-strength);
    NSLog(@"Is this me ? attack");    
}

-(void) MedicHeal
{
//    float health = [host getAttribute:@"health"];
//    float strength = [host getAttribute:@"strength"];
//    return health*(1000+strength)/1000;
    NSLog(@"Is this me ? medic");    
}

-(void) MagicHeal
{
//    float health = [host getAttribute:@"health"];
//    float strength = [host getAttribute:@"strength"];
//    return health*(1000+strength)/1000;
    NSLog(@"Is this me ?magic ");

}


-(id) initWithSelector:(SEL)selector
{
    if(!(self=[super init]))
        return  nil;
    computor=selector;
    return self;
}

-(NSNumber*) computeOn:(RE_Entity *)host
{
//    NSArray* values = [host getArrayFromKeys:arguements];
    // FIXME:ulgy hack: Just push the host to the selector nakedly.
    // Attributes Validatons can be done here
  return [self performSelector:computor withObject:host];
}

@end

@implementation RE_TwoPassCompulector

-(id) initWithSelector:(SEL)selector parameters:(NSDictionary *)params
{
    if(!(self=[super init])) return nil;
    pass=0;
    computor = selector;
    parameters = [[NSDictionary alloc]initWithDictionary:params];
    return self;
}

-(NSNumber*) computeOn:(RE_Entity *)host
{
    if (pass==0) {
        for (NSString* p in [parameters allKeys]) {
            float f = [host getAttribute:p];
            [parameters setValue:[NSNumber numberWithFloat:f] forKey:p];
        }
        pass++;
        return nil;
    }else if (pass==1){
        return [self performSelector:computor withObject:host withObject:parameters];
        pass=0;
    }
    //This should never be reached.
    return nil;
}

-(id<RE_Computus>) copy:(id<RE_Computus>)copee
{
    return  self;
}

@end

@implementation RE_Action

@synthesize computus = _computus;
// 群杀技的话貌似要arglist或者groupArgs了

// 例如 walk?

- (id) initWithComputus:(NSDictionary *)computus andName:(NSString *)actname
{
    if (!(self = [super init])) {
        return nil;
    }
    _computus = [[NSMutableDictionary alloc]initWithDictionary:computus];
    _name = actname;
    return self;
}

- (RE_Action*) run:(RE_Entity*)host
{
    NSMutableDictionary * a = [[NSMutableDictionary alloc]init];
    for ( NSString* name in [_computus allKeys]) {
        if ([host isAttributeLocked:name]) {
            continue;
        }
        id<RE_Computus> c= [_computus objectForKey:name];
        NSNumber* r = [c computeOn:host];
        if (r) {
            [host setAttribute:[r floatValue] withName:name];
//                return;
        }else 
        {
            // THis may be malice
            [a setValue:c forKey:name];
        }
    }
    if ([a count]==0) {
        return  nil;
    }
    return  [[RE_Action alloc]initWithComputus:a andName:_name];
}

- (BOOL) setComputu:(id<RE_Computus>)computu withName:(NSString *)name
{
    [_computus setValue:computu forKey:name];
    return YES;
}
// 仅仅告诉名字肯定还是不行的，我们仍然需要一个字典来做
// 只不过这个名字是靠字典来索引的，而已
// 因此这个字典是
+ (RE_Action*) make:(NSString *)name
{
    return [RE_ActionFactory make:name];
}

@end

