//
//  DictionaryBuilder.h
//  TouchTracker
//
//  Created by Sean on 6/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DictionaryBuilder : NSObject
@property (nonatomic, strong) NSMutableDictionary *snakeDictionary;
@property (nonatomic, strong) NSMutableDictionary *countDictionary;
@property (nonatomic, strong) NSMutableDictionary *repeatDictionary;
@property (nonatomic, strong) NSMutableDictionary *horizontalDictionary;
@property (nonatomic, strong) NSMutableDictionary *binaryHorizontalDictionary;
@property (nonatomic, strong) NSMutableDictionary *binaryVerticalDictionary;
- (void)writeSnakeDictionary:(int)spread;
- (void)writeCountDictionary;
- (void)writeRepeatDictionary:(int)tolerance;
- (void)writeHorizontalDictionary:(int)tolerance;
- (void)writeBinaryHorizontalDictionary;
- (void)writeBinaryVerticalDictionary;
@end
