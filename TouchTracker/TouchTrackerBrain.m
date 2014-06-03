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
    if (!_touchSequence) _touchSequence = [[NSMutableArray alloc] init];
    return _touchSequence;
}

- (float)crossProduct2D:(float[])vectorA
                        :(float[])vectorB
{
    return vectorA[0]*vectorB[1] - vectorA[1]*vectorB[0];
}

- (void)addToSequence:(CGPoint)touch
{
    [self.touchSequence addObject:[NSValue value:&touch withObjCType:@encode(CGPoint)]];
}

- (CGPoint)getTouchAtIndex:(int)i
{
    CGPoint touch;
    [[self.touchSequence objectAtIndex:i] getValue:&touch];
    return touch;
}

- (BOOL)directionIsUndefined:(CGPoint)a
                            :(CGPoint)b
                            :(CGPoint)c
                            :(float)spread
{
    // rand?
    return YES;
}

- (NSString *)snakePath:(CGPoint)touch
{
    [self addToSequence:touch];
    if ([self.touchSequence count] >= 3)
    {
        NSString *path = [NSString stringWithFormat:@""];
        for (int i = 0; i < [self.touchSequence count]-2; i++)
        {
            CGPoint firstTouch = [self getTouchAtIndex:i];
            CGPoint secondTouch = [self getTouchAtIndex:i+1];
            CGPoint thirdTouch = [self getTouchAtIndex:i+2];
            float vectorA[2] = {secondTouch.x-firstTouch.x, secondTouch.y-firstTouch.y};
            float vectorB[2] = {thirdTouch.x-secondTouch.x, thirdTouch.y-secondTouch.y};
            float cross = [self crossProduct2D:vectorA:vectorB];
            NSLog(@"%.1f = %.1f,%.1f cross %.1f,%.1f", cross, secondTouch.x-firstTouch.x, secondTouch.y-firstTouch.y, thirdTouch.x-secondTouch.x, thirdTouch.y-secondTouch.y);
            if (cross > 0) path = [path stringByAppendingString:@"r"];
            else if (cross < 0) path = [path stringByAppendingString:@"l"];
        }
        NSLog(@"%@", path);
        return path;
    }
    return nil;
}

@end











