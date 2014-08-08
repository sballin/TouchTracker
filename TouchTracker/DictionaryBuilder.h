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
- (void)writeSnakeDictionary:(int)spread;
@end
