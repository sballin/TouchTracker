//
//  TouchTrackerBrain.h
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchTrackerBrain : NSObject

- (float)crossProduct2D:(float[])vectorA
                      :(float[])vectorB;
- (void)addToSequence:(CGPoint)touch;
- (CGPoint)getTouchAtIndex:(int)i;
- (NSString *)directionVerbatim:(CGPoint)firstTouch
                               :(CGPoint)secondTouch
                               :(CGPoint)thirdTouch;
- (CGPoint)displace:(CGPoint)point
                   :(int)spread;
- (NSString *)directionBash:(CGPoint)firstTouch
                           :(CGPoint)secondTouch
                           :(CGPoint)thirdTouch
                           :(int)spread;
- (NSMutableArray *)snakePath:(CGPoint)touch;

@end
