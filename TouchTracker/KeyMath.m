//
//  KeyMath.m
//  TouchTracker
//
//  Created by Sean on 6/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "KeyMath.h"

@implementation KeyMath

@synthesize alphabetCoordinates = _alphabetCoordinates;

- (NSDictionary *)alphabetCoordinates {
    if (!_alphabetCoordinates) {
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
        NSArray *coordinates = @[[NSValue value:&a withObjCType:@encode(CGPoint)],
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
                                [NSValue value:&z withObjCType:@encode(CGPoint)]];
        NSArray *alphabet = [[NSString stringWithFormat:@"a b c d e f g h i j k l m n o p q r s t u v w x y z"] componentsSeparatedByString:@" "];
        _alphabetCoordinates = [NSDictionary dictionaryWithObjects:coordinates forKeys:alphabet];
    }
    return _alphabetCoordinates;
}

- (NSMutableArray *)modelTouchSequenceFor:(NSString *)word {
    NSMutableArray *touchSequence = [[NSMutableArray alloc] init];
    for (int i = 0; i < [word length]; i++) {
        CGPoint point = [self getCoordinatesOf:[word substringWithRange:NSMakeRange(i, 1)]];
        [touchSequence addObject:[NSValue value:&point withObjCType:@encode(CGPoint)]];
    }
    return touchSequence;
}

- (CGPoint)getCoordinatesOf:(NSString *)letter {
	CGPoint coordinates;
	[(self.alphabetCoordinates)[letter] getValue:&coordinates];
	return coordinates;
}

+ (float)errorBetween:(float)a
                  and:(float)b {
	float base;
	if (a > b) base = a;
	else if (b > a) base = b;
	else return 0.0;
	return fabs((a - b) / base);
}

+ (float)distanceBetween:(CGPoint)pointA
                     and:(CGPoint)pointB {
	return sqrtf(powf(pointA.x-pointB.x, 2.0) + powf(pointA.y-pointB.y, 2.0));
}

+ (float)crossProduct2D:(CGPoint)vectorA
					   :(CGPoint)vectorB {
	return vectorA.x * vectorB.y - vectorA.y * vectorB.x;
}

+ (CGPoint)displace:(CGPoint)point
				   :(int)spread
				   :(int)direction {
	if (direction > 0 && direction < 3)
		point.x += (1 - 2 * (direction % 2)) * spread; // (-1 or 1)*spread
	else if (direction > 3)
		point.y += (1 - 2 * (direction % 2)) * spread;
	return point;
}

@end
