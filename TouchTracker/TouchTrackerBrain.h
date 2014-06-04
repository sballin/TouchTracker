//
//  TouchTrackerBrain.h
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchTrackerBrain : NSObject

- (NSString *)snakePath:(CGPoint)touch;

typedef struct {
    float x;
    float y;
} vector_2d;

#define R1 = 1269;
#define R2 = 1099;
#define R3 = 926;
#define K1 = 182;
#define K2 = 184;
#define K3 = 186;
#define D1 = 274;
#define D2 = 167;
#define D3 = 91;

@end
