//
//  TwoDim.m
//  TouchTracker
//
//  Created by Sean on 6/30/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TwoDim.h"
#import "KeyMath.h"

@interface TwoDim ()
@property (nonatomic, strong) KeyMath *keyboard;
+ (NSString *)upDownFrom:(CGPoint)firstTouch
                      to:(CGPoint)secondTouch
           withTolerance:(int)pixels;
+ (NSString *)leftRightFrom:(CGPoint)firstTouch
                         to:(CGPoint)secondTouch
              withTolerance:(int)pixels;
+ (BOOL)repeatFor:(CGPoint)firstTouch
              and:(CGPoint)secondTouch
    withTolerance:(int)pixels;
@end

@implementation TwoDim

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

+ (NSString *)horizontalPathFor:(NSMutableArray *)touchSequence
                  withTolerance:(NSNumber *)pixels {
    int pixelValue = (int)[pixels integerValue];
    NSString *path = @"";
    for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstTouch, secondTouch;
        [touchSequence[i] getValue:&firstTouch];
        [touchSequence[i+1] getValue:&secondTouch];
        path = [path stringByAppendingString:[TwoDim leftRightFrom:firstTouch to:secondTouch withTolerance:pixelValue]];
    }
    return path;
}

+ (NSString *)verticalPathFor:(NSMutableArray *)touchSequence
                withTolerance:(NSNumber *)pixels {
    int pixelValue = (int)[pixels integerValue];
    NSString *path = @"";
    for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstTouch, secondTouch;
        [touchSequence[i] getValue:&firstTouch];
        [touchSequence[i+1] getValue:&secondTouch];
        path = [path stringByAppendingString:[TwoDim upDownFrom:firstTouch to:secondTouch withTolerance:pixelValue]];
    }
    return path;
}

+ (NSString *)repeatPathFor:(NSMutableArray *)touchSequence
              withTolerance:(NSNumber *)pixelValue {
    int pixels;
    [pixelValue getValue:&pixels];
    NSString *map = @"";
    for (int i = 0; i < [touchSequence count]-1; i++) {
        CGPoint firstTouch;
        [touchSequence[i] getValue:&firstTouch];
        CGPoint secondTouch;
        [touchSequence[i+1] getValue:&secondTouch];
        if ([TwoDim repeatFor:firstTouch and:secondTouch withTolerance:pixels])
            map = [map stringByAppendingString:@"r"];
        else map = [map stringByAppendingString:@"x"];
    }
    return map;
}

- (NSString *)repeatMapForWord:(NSString *)word
                 withTolerance:(NSNumber *)pixels {
    return [TwoDim repeatPathFor:[self.keyboard modelTouchSequenceFor:word] withTolerance:pixels];
}

+ (BOOL)repeatFor:(CGPoint)firstTouch
              and:(CGPoint)secondTouch
    withTolerance:(int)pixels {
    if ([KeyMath distanceBetween:firstTouch and:secondTouch] < pixels)
        return YES;
    return NO;
}

+ (BOOL)containsRepeat:(NSMutableArray *)touchSequence
         withTolerance:(NSNumber *)pixelValue {
    NSString *map = [TwoDim repeatPathFor:touchSequence withTolerance:pixelValue];
    if ([map containsString:@"r"])
        return YES;
    return NO;
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
