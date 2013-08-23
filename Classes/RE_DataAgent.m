//
//  RE_DataAgent.m
//  CocosPractice
//
//  Created by  on 12-6-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RE_DataAgent.h"

@interface RE_DataAgent(localMethods)
// local private routines
- (NSString*) getFilePath:(NSString*)filename;
- (void)saveData:(id)data toFile:(NSString*)filename;
@end

@implementation RE_DataAgent

static RE_DataAgent* _sharedAgent = nil;

#pragma singleton methods
- (id) init
{
    saveBook =[[NSMutableDictionary alloc]initWithCapacity:5];
    return self;
}
- (void) dealloc
{
    [saveBook release];
    [super dealloc];
}

+ (RE_DataAgent*)sharedAgent
{
    if (_sharedAgent == nil) {
        _sharedAgent = [[super allocWithZone:NULL] init];
    }
    return _sharedAgent;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [[self sharedAgent] retain];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return NSUIntegerMax;  //denotes an object that cannot be released
}

- (void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;
}


#pragma category local
- (NSString*)getFilePath:(NSString *)filename
{
    // Search in Document first
    NSString* docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath = [docDir stringByAppendingPathComponent:filename];
    BOOL existInDoc = [[NSFileManager defaultManager] 
                       fileExistsAtPath:filePath];
    // Fetch from bundle then.
    if (!existInDoc) {
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        filePath = [bundlePath stringByAppendingPathComponent:filename];
    }
    // If bundle have not such a file, we just throw nil back.
    return filePath;
}

- (void)saveData:(id)data toFile:(NSString*)filename
{
    NSData * d = (NSData*)data;
    NSString* docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* filePath = [docDir stringByAppendingPathComponent:filename];
    [d writeToFile:filePath atomically:YES];
}

#pragma singleton facilities
- (NSArray*) getArrayFromFile:(NSString*)filename
{
    NSString* filepath = [self getFilePath:filename];
    return 
        [[NSArray alloc] initWithContentsOfFile:filepath];
}

- (NSMutableArray*) getMutableArrayFromFile:(NSString *)filename
{
    NSString* filepath = [self getFilePath:filename];
    return 
    [[NSMutableArray alloc] initWithContentsOfFile:filepath];

}

- (NSDictionary*) getDictFromFile:(NSString *)filename
{
    NSString* filepath = [self getFilePath:filename];
    return 
    [[NSDictionary alloc] initWithContentsOfFile:filepath];
}

- (NSMutableDictionary*) getMutableDictFromFile:(NSString *)filename
{
    NSString* filepath = [self getFilePath:filename];
    return 
    [[NSMutableDictionary alloc] initWithContentsOfFile:filepath];
}

- (void) saveDict:(NSDictionary *)dict toFile:(NSString*)filename
{
    [self saveData:dict toFile:filename];
}

- (void) saveArray:(NSArray *)array toFile:(NSString *)filename
{
    [self saveData:array toFile:filename];
}

@end
