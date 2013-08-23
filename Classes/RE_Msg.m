//
//  RE_Msg.m
//  RPG_Engine
//
//  Created by  on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_Msg.h"

@implementation RE_Msg
@synthesize data=_data;
@synthesize message=_message;
@synthesize type = _type;
@synthesize sender=_sender;
@synthesize desttype=_desttype;
@synthesize destindex=_destindex;

-(id) init:(RE_MSG_TYPE)t message:(NSString *)name sender:(RE_Entity *)s data:(id)d
{
    _data =d;
    _type =t;
    _sender=s;
    _message=name;
    _desttype = character;
    return self;
}


@end
