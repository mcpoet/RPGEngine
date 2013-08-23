//
//  ContactListener.m
//  Scroller
//
//  Created by min on 1/16/11.
//  Copyright 2011 Min Kwon. All rights reserved.
//

#import "ContactListener.h"
#import "Constants.h"
#import "GameObject.h"
#import "RE_Actor.h"

#define IS_PLAYER(x, y)         (x.type == kGameObjectPlayer || y.type == kGameObjectPlayer)
#define IS_PLATFORM(x, y)       (x.type == kGameObjectPlatform || y.type == kGameObjectPlatform)

#define IS_ONEPLAYER(x)         (x.type == kGameObjectPlayer)
#define IS_ONEPLATFORM(x)       (x.type == kGameObjectPlatform)
#define BOTH_ARE_PLAYERS(x, y)         (x.type == kGameObjectPlayer && y.type == kGameObjectPlayer)

#define IS_Bullet(x)         ([x isKindOfClass:[RE_Bullet class]])

ContactListener::ContactListener() {
    counter = 0;
}

ContactListener::~ContactListener() {
}

void ContactListener::BeginContact(b2Contact *contact) {
	CCSprite *o1 = (GameObject*)contact->GetFixtureA()->GetBody()->GetUserData();
	CCSprite *o2 = (GameObject*)contact->GetFixtureB()->GetBody()->GetUserData();
	
//	if (IS_PLATFORM(o1, o2) && IS_PLAYER(o1, o2)) {
//        CCLOG(@"-----> Player made contact with platform! %d", 123);
//    }
    if (IS_Bullet(o1)) {
        NSLog(@"We get a bullet 1");
        if ([o2 isKindOfClass:[RE_Actor class]]) {
            RE_Actor* ra = (RE_Actor*)o2;
            RE_Bullet* rb = (RE_Bullet*)o1;
            [rb loadMessage:ra];
//            [ra handleMessage:[rb carry]];
        }
    }else if (IS_Bullet(o2)) {
        NSLog(@"We get a bullet 2");
        if ([o1 isKindOfClass:[RE_Actor class]]) {
            RE_Actor* ra = (RE_Actor*)o1;
            RE_Bullet* rb = (RE_Bullet*)o2;
            [rb loadMessage:ra];
//            [ra handleMessage:[rb carry]];
        }
    }
    
}

void ContactListener::EndContact(b2Contact *contact) 
{
//	GameObject *o1 = (GameObject*)contact->GetFixtureA()->GetBody()->GetUserData();
//	GameObject *o2 = (GameObject*)contact->GetFixtureB()->GetBody()->GetUserData();
//    
//	if (IS_PLATFORM(o1, o2) && IS_PLAYER(o1, o2)) {
//        CCLOG(@"-----> Player lost contact with platform!");
//    }
}

void ContactListener::PreSolve(b2Contact *contact, const b2Manifold *oldManifold) 
{
    b2WorldManifold worldManifold;
    contact->GetWorldManifold(&worldManifold);
    GameObject *o1 = (GameObject*)contact->GetFixtureA()->GetBody()->GetUserData();
	GameObject *o2 = (GameObject*)contact->GetFixtureB()->GetBody()->GetUserData();
//
//    b2Body *b1 = contact->GetFixtureA()->GetBody();
//    b2Vec2 impulse = b2Vec2(1.0f, 0.0f);
//    b1->ApplyLinearImpulse(impulse , b1->GetWorldCenter());
//    if (BOTH_ARE_PLAYERS(o1,o2))
//    {
//        // We must compute the will-collide result here fast enough
//        // for the physics engine to react.
//        // something like willCollide(actorA,actorB)
//        // so the game logic need to be really robust.
//        float Yn = worldManifold.normal.y;
////        CCLOG(@"players don't collide vertically %f", Yn);
//        if (Yn > 0.0)
//            contact->SetEnabled(false);
//    }
    if (BOTH_ARE_PLAYERS(o1,o2) )
    {
        RE_Actor* p1 = (RE_Actor*)o1;
        RE_Actor* p2 = (RE_Actor*)o2;
        //May this cause some bad recurrations?
        [p1 onBumpWith:p2];
        //[p2 onBumpWith:p1];
        contact->SetEnabled(false);
    }
}

void ContactListener::PostSolve(b2Contact *contact, const b2ContactImpulse *impulse) 
{}