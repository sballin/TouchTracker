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

- (NSDictionary *)horizontalDictionary {
	if (!_horizontalDictionary) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"horizontalDictionary0" ofType:@"plist"];
		_horizontalDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	}
	return _horizontalDictionary;
}


- (NSDictionary *)binaryHorizontalDictionary {
	if (!_binaryHorizontalDictionary) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"binaryHorizontalDictionary" ofType:@"plist"];
		_binaryHorizontalDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	}
	return _binaryHorizontalDictionary;
}

- (NSDictionary *)binaryVerticalDictionary {
    if (!_binaryVerticalDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"binaryVerticalDictionary" ofType:@"plist"];
        _binaryVerticalDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _binaryVerticalDictionary;
}

+ (NSString *)upDownFrom:(CGPoint)firstTouch
                      to:(CGPoint)secondTouch
           withTolerance:(int)pixels {
    float difference = (float) firstTouch.y-secondTouch.y;
    if (fabs(difference) > pixels) {
        if (difference > 0) return @"d";
        else return @"u";
    }
    return @"x";
}

/**
 For use in dictionary creation. Defaults to up direction, nothing undefined.
 */
+ (NSString *)upDownFrom:(CGPoint)firstTouch
                      to:(CGPoint)secondTouch {
    if (firstTouch.y-secondTouch.y > 0) return @"d";
    return @"u";
}

+ (NSString *)leftRightFrom:(CGPoint)firstTouch
                         to:(CGPoint)secondTouch
              withTolerance:(int)pixels {
    float difference = firstTouch.x-secondTouch.x;
    if (fabs(difference) > pixels) {
        if (difference > 0) return @"l";
        else return @"r";
    }
    return @"x";
}

/**
 For use in dictionary creation. Defaults to right direction, nothing undefined.
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
 @param path
    Direction sequence to analyze
 @return NSSet of all possible paths.
 */
+ (NSMutableSet *)xPansion:(NSString *)path {
    NSMutableSet *set = [[NSMutableSet alloc] init]; // get rid of alloc/init
    if ([path rangeOfString:@"x"].location == NSNotFound)
        set = [NSMutableSet setWithObject:path];
    else {
        NSRange range = [path rangeOfString:@"x"];
        [set unionSet:[TwoDim xPansion:[path stringByReplacingCharactersInRange:range withString:@"l"]]];
        [set unionSet:[TwoDim xPansion:[path stringByReplacingCharactersInRange:range withString:@"r"]]];
    }
    return set;
}

- (NSString *)rowSequence:(NSMutableArray *)touchSequence {
    // must check whether row locations have been established after enough input
    return @"";
}

@end
