//
//  TouchTrackerBrain.h
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchTrackerBrain : NSObject

struct _brain_touch {
    double x, y;
};
typedef struct _brain_touch brain_touch;

- (double)crossProduct2D:(double[])vectorA
                      :(double[])vectorB;
- (NSMutableArray *)snakePath:(NSMutableArray *)touches
                             :(UIView *)view;

@end
