//
//  TouchTrackerBrain.m
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TouchTrackerBrain.h"

@interface TouchTrackerBrain()
@property (nonatomic, strong) NSMutableDictionary *snakeDict;
@property (nonatomic, strong) NSMutableArray *touchSequence;
@end

@implementation TouchTrackerBrain

@synthesize snakeDict = _snakeDict;
@synthesize touchSequence = _touchSequence;

- (NSMutableArray *)touchSequence
{
    if (_touchSequence) _touchSequence = [[NSMutableArray alloc] init];
    return _touchSequence;
}

- (double)crossProduct2D:(double[])vectorA
                        :(double[])vectorB
{
    return vectorA[0]*vectorB[1] - vectorA[1]*vectorB[0];
}

- (NSString *)snakePath:(NSMutableArray *)touches
                       :(UIView *)view
{
    if ([touches count] >= 3)
    {
        for (int i = 0; i < [touches count]-2; i++)
        {
            CGPoint firstTouch, secondTouch, thirdTouch;
            [[touches objectAtIndex:i] getValue:&firstTouch];
            [[touches objectAtIndex:i+1] getValue:&secondTouch];
            [[touches objectAtIndex:i+2] getValue:&thirdTouch];
            double vectorA[2] = {secondTouch.x-firstTouch.x, secondTouch.y-firstTouch.y};
            double vectorB[2] = {thirdTouch.x-secondTouch.x, thirdTouch.y-secondTouch.y};
            double cross = [self crossProduct2D:vectorA:vectorB];
            NSLog(@"%g = %g,%g cross %g,%g", cross, secondTouch.x-firstTouch.x, secondTouch.y-firstTouch.y, thirdTouch.x-secondTouch.x, thirdTouch.y-secondTouch.y);
            NSLog(@"points %g,%g to %g,%g to %g,%g", firstTouch.x, secondTouch.y, secondTouch.x, secondTouch.y, thirdTouch.x, thirdTouch.y);
        }
        NSLog(@"\n");
    } else
        return nil;
    return nil;
}

@end











