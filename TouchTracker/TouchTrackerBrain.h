//
//  TouchTrackerBrain.h
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchTrackerBrain : NSObject

- (double)crossProduct2D:(double[])vectorA
                      :(double[])vectorB;
- (void)addToSequence:(CGPoint)touch;
- (CGPoint)getTouchAtIndex:(int)i;
- (NSMutableArray *)snakePath:(CGPoint)touch;

@end
