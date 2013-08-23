//
//  RE_DataAgent.h
//  CocosPractice
//
//  Created by marro on 12-6-23.
//  Copyright (c) 2012年 FishStone. All rights reserved.
//

/* **********
 Implements file-based data manipulate api for the Model in MVC pattern
 ************ */

#import <Foundation/Foundation.h>

// All RE_ classes get data through this class
// This is a single instance class
// And this class is on duty for the Memory Management 
// of the data it provides.

@interface RE_DataAgent : NSObject
{

    NSMutableDictionary* saveBook;
}

+ (RE_DataAgent*)sharedAgent;

// For game engine
- (NSArray*) getArrayFromFile:(NSString*)filename;
- (NSDictionary*) getDictFromFile:(NSString*)filename;

// For Editors
- (NSMutableDictionary*) getMutableDictFromFile:(NSString*)filename;
- (NSMutableArray*) getMutableArrayFromFile:(NSString*)filename;

- (void) saveArray:(NSArray*)array toFile:(NSString*)filename;
- (void) saveDict:(NSDictionary*)dict toFile:(NSString*)filename;

// 这种情况下需要保存每个数据结构对应的文件名。

// Implementation suspended.
//- (void) saveArray:(NSArray*)array;
//- (void) saveDict:(NSDictionary*)dict;


@end
