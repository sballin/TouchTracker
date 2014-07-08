//
//  TouchTrackerBrain.h
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchTrackerBrain : NSObject
@property (nonatomic, strong) NSMutableArray *touchSequence;
- (void)addToSequence:(CGPoint)touch;
- (CGPoint)getTouchAtIndex:(int)i;
- (void)clearTouchSequence;
- (NSString *)bestMatchFor:(NSMutableArray *)words;
- (float)errorForWord:(NSString *)word;
@end
