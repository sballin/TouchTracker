//
//  TouchTrackerBrain.h
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchTrackerBrain : NSObject

@property (nonatomic, strong) NSMutableDictionary *snakeDictionary;
- (NSString *)snakePath:(CGPoint)touch;
- (void)writeSnakeDictionary;
- (void)clearTouchSequence;

@end
