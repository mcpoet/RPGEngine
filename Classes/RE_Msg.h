//
//  RE_Msg.h
//  RPG_Engine
//
//  Created by  on 12-5-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RE_Entity;

// The protocal 
// Binary message format
// | source_id | dest_id | dest_type | dest_index | message_type | message_body |
//    24            0        8            16             8             ...
// source_id:0->group internal message; others just hand to the router
// dest_type: 1->group message,2->character_message, 3->item_message,others are invalid
// dest_index: array index or dict key when implemented in python dict
// Above informations should be used for message validations
// We'll wrap this with protobuf later

enum msg_type 
{
    installAction,
    //execute given action
    takeAction,
    // execute local action
    performAction,
    //Inter-Entity Operations 
    equipOn,
    dropOn,
    //Attribute Operations
    installAttribute,
    uninstallAttribute,
    //Group Message type begin
    //
    newItem,
    newBuddy,
    newLeader,
    newSprite,
    switchLeader,
    switchSprite,
    dropItem,
    dropBuddy,
    expireItem,
    expireBuddy,
    installItem,
    uninstallItem,
    //Testing
    testMessage
};
typedef enum msg_type RE_MSG_TYPE;

enum dest_type 
{
    group,
    character,
    item
};
typedef enum dest_type RE_MSG_DEST_TYPE;
@interface RE_Msg : NSObject
{
    id _data;
    RE_Entity* _sender;
    NSString* _message;
    RE_MSG_TYPE _type;
    RE_MSG_DEST_TYPE _desttype;
    NSString* _destindex;
}

//getters
@property (retain, readwrite) id data;
@property (retain, readwrite) NSString* message;
@property (retain, readwrite) NSString* destindex;
@property (atomic, readwrite) RE_MSG_TYPE type;
@property (atomic, readwrite) RE_MSG_DEST_TYPE desttype;
@property (retain, readwrite) RE_Entity* sender;

- (id)init:(RE_MSG_TYPE)type 
        message:(NSString*)name
         sender:(RE_Entity*)s 
           data:(id)d;

@end
