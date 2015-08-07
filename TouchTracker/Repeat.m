//
//  Repeat.m
//  TouchTracker
//
//  Created by Sean on 7/6/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "Repeat.h"
#import "KeyMath.h"

@interface Repeat ()

@end

@implementation Repeat

+ (NSString *)repeatMap:(NSMutableArray *)touchSequence
          withTolerance:(int)pixels {
    NSString *map = @"";
    for (int i = 0; i < [touchSequence count]-1; i++) {
        CGPoint firstTouch;
        [[touchSequence objectAtIndex:i] getValue:&firstTouch];
        CGPoint secondTouch;
        [[touchSequence objectAtIndex:i+1] getValue:&secondTouch];
        if ([Repeat repeatFor:firstTouch and:secondTouch withTolerance:pixels])
            map = [map stringByAppendingString:@"y"];
        else map = [map stringByAppendingString:@"n"];
    }
    return @"";
}

+ (BOOL)repeatFor:(CGPoint)firstTouch
              and:(CGPoint)secondTouch
    withTolerance:(int)pixels {
    if ([KeyMath distanceBetween:firstTouch and:secondTouch] < pixels)
        return YES;
    return NO;
}

@end