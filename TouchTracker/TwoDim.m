//
//  TwoDim.m
//  TouchTracker
//
//  Created by Sean on 6/30/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TwoDim.h"

@interface TwoDim ()
+ (NSString *)upDownFrom:(CGPoint)firstTouch
                      to:(CGPoint)secondTouch
           withTolerance:(int)pixels;
+ (NSString *)leftRightFrom:(CGPoint)firstTouch
                         to:(CGPoint)secondTouch
              withTolerance:(int)pixels;
@end

@implementation TwoDim

+ (NSString *)upDownFrom:(CGPoint)firstTouch
                      to:(CGPoint)secondTouch
           withTolerance:(int)pixels {
    float difference = firstTouch.y-secondTouch.y;
    if (fabs(difference) < pixels) {
        if (difference > 0) return @"d";
        else return @"u";
    }
    return @"x";
}

+ (NSString *)leftRightFrom:(CGPoint)firstTouch
                         to:(CGPoint)secondTouch
              withTolerance:(int)pixels {
    float difference = firstTouch.x-secondTouch.x;
    if (fabs(difference) < pixels) {
        if (difference > 0) return @"l";
        else return @"r";
    }
    return @"x";
}

#define DEFAULT_TOLERANCE 25
+ (NSString *)horizontalPathFor:(NSMutableArray *)touchSequence
                  withTolerance:(int)pixels {
    NSString *path = @"";
    for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstTouch, secondTouch;
        [[touchSequence objectAtIndex:i] getValue:&firstTouch];
        [[touchSequence objectAtIndex:i+1] getValue:&secondTouch];
        path = [path stringByAppendingString:[TwoDim leftRightFrom:firstTouch to:secondTouch withTolerance:pixels]];
    }
    return path;
}

+ (NSString *)verticalPathFor:(NSMutableArray *)touchSequence
                withTolerance:(int)pixels {
    NSString *path = @"";
    for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstTouch, secondTouch;
        [[touchSequence objectAtIndex:i] getValue:&firstTouch];
        [[touchSequence objectAtIndex:i+1] getValue:&secondTouch];
        path = [path stringByAppendingString:[TwoDim upDownFrom:firstTouch to:secondTouch withTolerance:pixels]];
    }
    return path;
}

- (NSString *)rowSequence:(NSMutableArray *)touchSequence {
    // must check whether row locations have been established after enough input
    return @"";
}

@end
