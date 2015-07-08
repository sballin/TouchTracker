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
+ (NSString *)leftRightFrom:(CGPoint)firstTouch
                         to:(CGPoint)secondTouch;
+ (NSString *)upDownFrom:(CGPoint)firstTouch
                      to:(CGPoint)secondTouch;
@end

@implementation TwoDim

/**
 Lazy instantiation of horizontal dictionary with no undefined direction.
 */
- (NSDictionary *)harshLeftRightDictionary {
    if (!_harshLeftRightDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"binaryHorizontalDictionary" ofType:@"plist"];
        _harshLeftRightDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _harshLeftRightDictionary;
}

/**
 Lazy instantiation of vertical dictionary with no undefined direction.
 */
- (NSDictionary *)harshUpDownDictionary {
    if (!_harshUpDownDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"binaryVerticalDictionary" ofType:@"plist"];
        _harshUpDownDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _harshUpDownDictionary;
}

/**
 Vertical direction including undefined.
 */
+ (NSString *)upDownFrom:(CGPoint)firstTouch
                      to:(CGPoint)secondTouch
           withTolerance:(int)pixels {
    float difference = (float) firstTouch.y - secondTouch.y;
    if (fabs(difference) > pixels) {
        if (difference > 0) return @"d";
        else return @"u";
    }
    return @"x";
}

/**
 Vertical direction with no undefined. For use in dictionary creation.
 */
+ (NSString *)upDownFrom:(CGPoint)firstTouch
                      to:(CGPoint)secondTouch {
    if (firstTouch.y - secondTouch.y > 0) return @"d";
    return @"u";
}

/**
 Horizontal direction including undefined.
 */
+ (NSString *)leftRightFrom:(CGPoint)firstTouch
                         to:(CGPoint)secondTouch
              withTolerance:(int)pixels {
    float difference = firstTouch.x - secondTouch.x;
    if (fabs(difference) > pixels) {
        if (difference > 0) return @"l";
        else return @"r";
    }
    return @"x";
}

/**
 Horizontal direction with no undefined. For use in dictionary creation.
 */
+ (NSString *)leftRightFrom:(CGPoint)firstTouch
                         to:(CGPoint)secondTouch {
    if (firstTouch.x-secondTouch.x > 0) return @"l";
    return @"r";
}

#define DEFAULT_TOLERANCE 25
+ (NSString *)horizontalPathFor:(NSMutableArray *)touchSequence
                  withTolerance:(int)pixels {
    NSString *path = @"";
    for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstTouch, secondTouch;
        [touchSequence[i] getValue:&firstTouch];
        [touchSequence[i+1] getValue:&secondTouch];
        path = [path stringByAppendingString:[TwoDim leftRightFrom:firstTouch to:secondTouch withTolerance:pixels]];
    }
    return path;
}

/**
 For use in dictionary creation.
 */
+ (NSString *)binaryHorizontalPathFor:(NSMutableArray *)touchSequence {
    NSString *path = @"";
    for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstTouch, secondTouch;
        [touchSequence[i] getValue:&firstTouch];
        [touchSequence[i+1] getValue:&secondTouch];
        path = [path stringByAppendingString:[TwoDim leftRightFrom:firstTouch to:secondTouch]];
    }
    return path;
}

+ (NSString *)verticalPathFor:(NSMutableArray *)touchSequence
                withTolerance:(int)pixels {
    NSString *path = @"";
    for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstTouch, secondTouch;
        [touchSequence[i] getValue:&firstTouch];
        [touchSequence[i+1] getValue:&secondTouch];
        path = [path stringByAppendingString:[TwoDim upDownFrom:firstTouch to:secondTouch withTolerance:pixels]];
    }
    return path;
}

/**
 For use in dictionary creation.
 */
+ (NSString *)binaryVerticalPathFor:(NSMutableArray *)touchSequence {
    NSString *path = @"";
    for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstTouch, secondTouch;
        [touchSequence[i] getValue:&firstTouch];
        [touchSequence[i+1] getValue:&secondTouch];
        path = [path stringByAppendingString:[TwoDim upDownFrom:firstTouch to:secondTouch]];
    }
    return path;
}

/**
 Replace all xs in a path with l/r directions.
 @param path direction sequence to analyze
 @return NSSet of all possible paths
 */
+ (NSMutableSet *)horizontalExpansion:(NSString *)path {
    NSMutableSet *set = [[NSMutableSet alloc] init]; // get rid of alloc/init
    if ([path rangeOfString:@"x"].location == NSNotFound)
        set = [NSMutableSet setWithObject:path];
    else {
        NSRange range = [path rangeOfString:@"x"];
        [set unionSet:[TwoDim horizontalExpansion:[path stringByReplacingCharactersInRange:range withString:@"l"]]];
        [set unionSet:[TwoDim horizontalExpansion:[path stringByReplacingCharactersInRange:range withString:@"r"]]];
    }
    return set;
}

/**
 Replace all xs in a path with u/d directions.
 @param path direction sequence to analyze
 @return NSSet of all possible paths
 */
+ (NSMutableSet *)verticalExpansion:(NSString *)path {
    NSMutableSet *set = [[NSMutableSet alloc] init]; // get rid of alloc/init
    if ([path rangeOfString:@"x"].location == NSNotFound)
        set = [NSMutableSet setWithObject:path];
    else {
        NSRange range = [path rangeOfString:@"x"];
        [set unionSet:[TwoDim verticalExpansion:[path stringByReplacingCharactersInRange:range withString:@"u"]]];
        [set unionSet:[TwoDim verticalExpansion:[path stringByReplacingCharactersInRange:range withString:@"d"]]];
    }
    return set;
}

@end
