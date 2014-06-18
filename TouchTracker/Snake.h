//
//  Snake.h
//  TouchTracker
//
//  Created by Sean on 6/5/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Snake : NSObject
@property (nonatomic, strong) NSDictionary *snakeDictionary;
+ (NSString *)snakePath:(NSMutableArray *)touchSequence
             withSpread:(int)spread;
- (NSString *)snakePathOfWord:(NSString *)word
                   withSpread:(int)spread;
@end
