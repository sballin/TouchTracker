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
- (float)magnitude:(vector_2d)vector;
- (float)crossProduct2D:(vector_2d)vectorA
                       :(vector_2d)vectorB;
- (void)addToSequence:(CGPoint)touch;
- (CGPoint)getTouchAtIndex:(int)i;
- (NSString *)directionVerbatim:(CGPoint)firstTouch
                               :(CGPoint)secondTouch
                               :(CGPoint)thirdTouch;
- (CGPoint)displace:(CGPoint)point
                   :(int)spread
                   :(int)direction;
- (NSString *)directionBash:(CGPoint)firstTouch
                           :(CGPoint)secondTouch
                           :(CGPoint)thirdTouch
                           :(int)spread;
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


- (NSMutableArray *)dictionaryWords
{
    if (!_dictionaryWords)
    {
        _dictionaryWords = [[NSMutableArray alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dict" ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        _dictionaryWords = [[content componentsSeparatedByString:@"\r"] mutableCopy];
    }
    
    return _dictionaryWords;
}


- (float)magnitude:(vector_2d)vector
{
    return sqrtf(powf(vector.x, 2.0)+powf(vector.y, 2.0));
}


- (float)crossProduct2D:(vector_2d)vectorA
                        :(vector_2d)vectorB
{
    return vectorA.x*vectorB.y - vectorA.y*vectorB.x;
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
    vector_2d vectorA;
    vectorA.x = secondTouch.x-firstTouch.x;
    vectorA.y = secondTouch.y-firstTouch.y;
    vector_2d vectorB;
    vectorB.x = thirdTouch.x-secondTouch.x;
    vectorB.y = thirdTouch.y-secondTouch.y;
    float cross = [self crossProduct2D:vectorA:vectorB];
    if (cross > 0) return [NSString stringWithFormat:@"r"];
    else if (cross < 0) return [NSString stringWithFormat:@"l"];
    else return [NSString stringWithFormat:@"x"];
}


- (CGPoint)displace:(CGPoint)point
                   :(int)spread
                   :(int)direction
{
    if (direction > 0 && direction < 3)
        point.x += (1-2*(direction % 2))*spread;    // (-1 or 1)*spread
    else if (direction > 3)
        point.y += (1-2*(direction % 2))*spread;
    return point;
}


// take triple instead of 3 args?
- (NSString *)directionBash:(CGPoint)firstTouch
                           :(CGPoint)secondTouch
                           :(CGPoint)thirdTouch
                           :(int)spread
{
    NSString *originalDirection = [self directionVerbatim:firstTouch:secondTouch:thirdTouch];
    for (int i = 0; i <= 4; i++)
    {
        for (int j = 0; j <= 4; j++)
        {
            for (int k = 0; k <= 4; k++)
            {
                NSString *jostledDirection = [self directionVerbatim:[self displace:firstTouch:spread:i]:[self displace:secondTouch:spread:j]:[self displace:thirdTouch:spread:k]];
                if (![jostledDirection isEqualToString:originalDirection])
                    return [NSString stringWithFormat:@"x"];
            }
        }
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
        return path;
    }
    return nil;
}

@end











