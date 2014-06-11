//
//  KeyMath.h
//  TouchTracker
//
//  Created by Sean on 6/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyMath : NSObject
@property (nonatomic, strong) NSDictionary *alphabetCoordinates;
- (CGPoint)getCoordinatesOf:(NSString *)letter;
+ (float)crossProduct2D:(CGPoint)vectorA
                       :(CGPoint)vectorB;
+ (float)distanceBetween:(CGPoint)pointA
                     and:(CGPoint)pointB;
+ (float)errorBetween:(float)a
                  and:(float)b;
+ (CGPoint)displace:(CGPoint)point
                   :(int)spread
                   :(int)direction;
@end
