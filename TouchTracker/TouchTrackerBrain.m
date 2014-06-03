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
@property (nonatomic, strong) NSMutableArray *dictionaryWords;
@end

@implementation TouchTrackerBrain

@synthesize snakeDict = _snakeDict;
@synthesize touchSequence = _touchSequence;
@synthesize dictionaryWords = _dictionaryWords;

- (NSMutableArray *)touchSequence
{
    if (!_touchSequence) _touchSequence = [[NSMutableArray alloc] init];
    return _touchSequence;
}

// really necessary?
- (NSMutableArray *)dictionaryWords
{
    if (!_dictionaryWords) _dictionaryWords = [[NSMutableArray alloc] init];
    return _dictionaryWords;
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

- (NSString *)directionVerbatim:(CGPoint)firstTouch
                               :(CGPoint)secondTouch
                               :(CGPoint)thirdTouch
{
    float vectorA[2] = {secondTouch.x-firstTouch.x, secondTouch.y-firstTouch.y};
    float vectorB[2] = {thirdTouch.x-secondTouch.x, thirdTouch.y-secondTouch.y};
    float cross = [self crossProduct2D:vectorA:vectorB];
    if (cross > 0) return [NSString stringWithFormat:@"r"];
    else if (cross < 0) return [NSString stringWithFormat:@"l"];
    else return [NSString stringWithFormat:@"x"];
}

// worthwhile to speed up
- (CGPoint)displace:(CGPoint)point
                   :(int)spread
{
    // displace by (-1 or 1)*(0 to spread-1)
    int dx = (1-2*(arc4random() % 2))*(arc4random() % spread);
    int dy = (1-2*(arc4random() % 2))*(arc4random() % spread);
    point.x = point.x + dx;
    point.y = point.y + dy;
    return point;
}

// take triple instead of 3 args?
- (NSString *)directionBash:(CGPoint)firstTouch
                           :(CGPoint)secondTouch
                           :(CGPoint)thirdTouch
                           :(int)spread
{
    NSString *originalDirection = [self directionVerbatim:firstTouch:secondTouch:thirdTouch];
    for (int i = 0; i < 1000; i++)
    {
        NSString *jostledDirection = [self directionVerbatim:[self displace:firstTouch:spread]:[self displace:secondTouch:spread]:[self displace:thirdTouch:spread]];
        if (![jostledDirection isEqualToString:originalDirection])
            return [NSString stringWithFormat:@"x"];
    }
    return originalDirection;
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
            path = [path stringByAppendingString:[self directionBash:firstTouch:secondTouch:thirdTouch:50]];
        }
        NSLog(@"%@", path);
        return path;
    }
    return nil;
}

@end











