//
//  CenterOfGravity.m
//  TouchTracker
//
//  Created by Sean on 8/3/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "CenterOfGravity.h"

@interface CenterOfGravity ( )

@end

@implementation CenterOfGravity

+ (CGPoint)getCenterPointFor:(NSMutableArray *)touchSequence {
    CGPoint center;
    center.x = 0.0;
    center.y = 0.0;
    for (NSValue *touch in touchSequence) {
        CGPoint point;
        [touch getValue:&point];
        center.x += point.x;
        center.y += point.y;
    }
    center.x /= [touchSequence count];
    center.y /= [touchSequence count];
    return center;
}

@end
