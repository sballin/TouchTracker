//
//  TouchTrackerBrain.m
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TouchTrackerBrain.h"
#import "Snake.h"

@interface TouchTrackerBrain()
@property (nonatomic, strong) NSMutableArray *touchSequence;
@property (nonatomic, strong) NSArray *dictionaryWords;
@property (nonatomic, strong) NSDictionary *alphabetCoordinates;
- (float)magnitude:(CGPoint)vector;
- (float)crossProduct2D:(CGPoint)vectorA
                       :(CGPoint)vectorB;
- (void)addToSequence:(CGPoint)touch;
- (CGPoint)getTouchAtIndex:(int)i;
- (CGPoint)getCoordinatesOf:(NSString *)letter;
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
- (NSString *)snakePathOfWord:(NSString *)word;
- (float)errorBetween:(float)a
                  and:(float)b;
- (NSArray *)fractionPathOfWord:(NSString *)word;
@end

@implementation TouchTrackerBrain

@synthesize snakeDictionary = _snakeDictionary;
@synthesize touchSequence = _touchSequence;
@synthesize dictionaryWords = _dictionaryWords;
@synthesize alphabetCoordinates = _alphabetCoordinates;


- (NSMutableDictionary *)snakeDictionary
{
    if (!_snakeDictionary)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"snakeDictionary" ofType:@"plist"];
        _snakeDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _snakeDictionary;
}


- (void)writeSnakeDictionary
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dictPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"snakeDictionary.plist"];
    _snakeDictionary = [NSMutableDictionary dictionaryWithCapacity:[self.dictionaryWords count]];
    for (NSString *word in self.dictionaryWords)
    {
        if ([word length] >= 3)
        {
            NSString *path = [self snakePathOfWord:word];
            NSMutableArray *list = [_snakeDictionary objectForKey:path];
            if (list == nil) list = [[NSMutableArray alloc] init];
            [list addObject:word];
            [_snakeDictionary setObject:list forKey:path];
        }
    }
    //[NSKeyedArchiver archiveRootObject:_snakeDictionary toFile:@"snakeDictionary.plist"];
    [self.snakeDictionary writeToFile:dictPath atomically:YES];
}


- (NSDictionary *)alphabetCoordinates
{
    if (!_alphabetCoordinates)
    {
        float r1 = 1269, r2 = 1099, r3 = 926; //y-coordinates of entire rows
    	float k1 = 182,  k2 = 184,  k3 = 186; //key+space width on different rows
    	float d1 = 274,  d2 = 167,  d3 = 91;  //offset of rows with respect to left margin
    	CGPoint a;    a.x = d2;         a.y = r2;
    	CGPoint b;    b.x = d1+4*k1;    b.y = r1;
    	CGPoint c;    c.x = d1+2*k1;    c.y = r1;
    	CGPoint d;    d.x = d2+2*k2;    d.y = r2;
    	CGPoint e;    e.x = d3+2*k3;    e.y = r3;
    	CGPoint f;    f.x = d2+3*k2;    f.y = r2;
    	CGPoint g;    g.x = d2+4*k2;    g.y = r2;
    	CGPoint h;    h.x = d2+5*k2;    h.y = r2;
    	CGPoint i;    i.x = d3+7*k3;    i.y = r3;
    	CGPoint j;    j.x = d2+6*k2;    j.y = r2;
    	CGPoint k;    k.x = d2+7*k2;    k.y = r2;
    	CGPoint l;    l.x = d2+8*k2;    l.y = r2;
    	CGPoint m;    m.x = d1+6*k1;    m.y = r1;
    	CGPoint n;    n.x = d1+5*k1;    n.y = r1;
    	CGPoint o;    o.x = d3+8*k3;    o.y = r3;
    	CGPoint p;    p.x = d3+9*k3;    p.y = r3;
    	CGPoint q;    q.x = d3;         q.y = r3;
    	CGPoint r;    r.x = d3+3*k3;    r.y = r3;
    	CGPoint s;    s.x = d2+k2;      s.y = r2;
    	CGPoint t;    t.x = d3+4*k3;    t.y = r3;
    	CGPoint u;    u.x = d3+6*k3;    u.y = r3;
    	CGPoint v;    v.x = d1+3*k1;    v.y = r1;
    	CGPoint w;    w.x = d3+k3;      w.y = r3;
    	CGPoint x;    x.x = d1+k1;      x.y = r1;
    	CGPoint y;    y.x = d3+5*k3;    y.y = r3;
    	CGPoint z;    z.x = d1;         z.y = r1;
        NSArray *coordinates = [NSArray arrayWithObjects:
            [NSValue value:&a withObjCType:@encode(CGPoint)],
            [NSValue value:&b withObjCType:@encode(CGPoint)],
            [NSValue value:&c withObjCType:@encode(CGPoint)],
            [NSValue value:&d withObjCType:@encode(CGPoint)],
            [NSValue value:&e withObjCType:@encode(CGPoint)],
            [NSValue value:&f withObjCType:@encode(CGPoint)],
            [NSValue value:&g withObjCType:@encode(CGPoint)],
            [NSValue value:&h withObjCType:@encode(CGPoint)],
            [NSValue value:&i withObjCType:@encode(CGPoint)],
            [NSValue value:&j withObjCType:@encode(CGPoint)],
            [NSValue value:&k withObjCType:@encode(CGPoint)],
            [NSValue value:&l withObjCType:@encode(CGPoint)],
            [NSValue value:&m withObjCType:@encode(CGPoint)],
            [NSValue value:&n withObjCType:@encode(CGPoint)],
            [NSValue value:&o withObjCType:@encode(CGPoint)],
            [NSValue value:&p withObjCType:@encode(CGPoint)],
            [NSValue value:&q withObjCType:@encode(CGPoint)],
            [NSValue value:&r withObjCType:@encode(CGPoint)],
            [NSValue value:&s withObjCType:@encode(CGPoint)],
            [NSValue value:&t withObjCType:@encode(CGPoint)],
            [NSValue value:&u withObjCType:@encode(CGPoint)],
            [NSValue value:&v withObjCType:@encode(CGPoint)],
            [NSValue value:&w withObjCType:@encode(CGPoint)],
            [NSValue value:&x withObjCType:@encode(CGPoint)],
            [NSValue value:&y withObjCType:@encode(CGPoint)],
            [NSValue value:&z withObjCType:@encode(CGPoint)],nil];
        NSArray *alphabet = [[NSString stringWithFormat:@"a b c d e f g h i j k l m n o p q r s t u v w x y z"] componentsSeparatedByString:@" "];
        _alphabetCoordinates = [NSDictionary dictionaryWithObjects:coordinates forKeys:alphabet];
    }
    return _alphabetCoordinates;
}


- (CGPoint)getCoordinatesOf:(NSString *)letter
{
    CGPoint coordinates;
    [[self.alphabetCoordinates objectForKey:letter] getValue:&coordinates];
    return coordinates;
}


- (NSMutableArray *)touchSequence
{
    if (!_touchSequence) _touchSequence = [[NSMutableArray alloc] init];
    return _touchSequence;
}


- (void)clearTouchSequence
{
    self.touchSequence = nil;
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


- (NSArray *)dictionaryWords
{
    if (!_dictionaryWords)
    {
        _dictionaryWords = [[NSMutableArray alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"dict" ofType:@"txt"];
        NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        _dictionaryWords = [content componentsSeparatedByString:@"\r"];
    }
    
    return _dictionaryWords;
}


- (float)distanceBetween:(CGPoint)pointA
                     and:(CGPoint)pointB
{
    return sqrtf(powf(pointA.x, 2.0)+powf(pointB.y, 2.0));
}


- (float)errorBetween:(float)a
                  and:(float)b
{
    float base;
    if (a > b) base = a;
    else if (b > a) base = b;
    else return 0.0;
    return fabs((a-b)/base);
}


- (NSArray *)fractionPathOfWord:(NSString *)word
{
    float total = 0.0;
    NSMutableArray *path = [[NSMutableArray alloc] init];
    for (int i = 0; i < [word length]-1; i++)
    {
        NSString *firstLetter = [NSString stringWithFormat:@"%c", [word characterAtIndex:i]];
        NSString *secondLetter= [NSString stringWithFormat:@"%c", [word characterAtIndex:i+1]];
        CGPoint firstPoint = [self getCoordinatesOf:firstLetter];
        CGPoint secondPoint = [self getCoordinatesOf:secondLetter];
        float distance =  [self distanceBetween:firstPoint and:secondPoint];
        [path addObject:[NSNumber numberWithFloat:distance]];
        total += distance;
    }
    for (int i = 0; i < [path count]; i++)
    {
        float fraction = [[path objectAtIndex:i] floatValue]/total;
        [path replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:fraction]];
    }
    return [path copy];
}


- (float)crossProduct2D:(CGPoint)vectorA
                       :(CGPoint)vectorB
{
    return vectorA.x*vectorB.y - vectorA.y*vectorB.x;
}


- (NSString *)directionVerbatim:(CGPoint)firstTouch
                               :(CGPoint)secondTouch
                               :(CGPoint)thirdTouch
{
    CGPoint vectorA;
    vectorA.x = secondTouch.x-firstTouch.x;
    vectorA.y = secondTouch.y-firstTouch.y;
    CGPoint vectorB;
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


- (NSString *)snakePathOfWord:(NSString *)word
{
    NSString *path = @"";
    for (int i = 0; i < [word length]-2; i++)
    {
        CGPoint firstTouch = [self getCoordinatesOf:[NSString stringWithFormat:@"%c", [word characterAtIndex:i]]];
        CGPoint secondTouch = [self getCoordinatesOf:[NSString stringWithFormat:@"%c", [word characterAtIndex:i+1]]];
        CGPoint thirdTouch = [self getCoordinatesOf:[NSString stringWithFormat:@"%c", [word characterAtIndex:i+2]]];
        path = [path stringByAppendingString:[self directionBash:firstTouch:secondTouch:thirdTouch:50]];
    }
    return path;
}

@end










