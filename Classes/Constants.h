//
//  Constants.h
//  SimpleBox2dScroller
//
//  Created by min on 3/17/11.
//  Copyright 2011 Min Kwon. All rights reserved.
//

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32

typedef enum {
    kGameObjectNone,
    kGameObjectPlayer,
    kGameObjectPlatform
} GameObjectType;

typedef enum {
    kFaceSmile,
    kFaceHold,
    kFaceSuspect,
    kFaceStare,
    kFaceAngry,
    kFaceSupprise,
    kFaceHappy
} dialogFaceType;