//
//  TouchTrackerBrain.h
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchTrackerBrain : NSObject

- (NSMutableArray *)snakePath:(CGPoint)touch;

typedef struct {
    float x;
    float y;
} vector_2d;

@end
