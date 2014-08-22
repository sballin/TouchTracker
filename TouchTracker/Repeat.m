//
//  Repeat.m
//  TouchTracker
//
//  Created by Sean on 7/6/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "Repeat.h"
#import "KeyMath.h"

@interface Repeat ()
@property (nonatomic, strong) KeyMath *keyboard;
+ (BOOL)repeatFor:(CGPoint)firstTouch
              and:(CGPoint)secondTouch
    withTolerance:(int)pixels;
+ (NSString *)repeatMap:(NSMutableArray *)touchSequence
          withTolerance:(int)pixels;
@end

@implementation Repeat

@synthesize keyboard = _keyboard;

- (KeyMath *)keyboard {
    if (!_keyboard) _keyboard = [[KeyMath alloc] init];
    return _keyboard;
}

- (NSString *)repeatMapForWord:(NSString *)word
                 withTolerance:(int)pixels {
    return [Repeat repeatMap:[self.keyboard modelTouchSequenceFor:word] withTolerance:pixels];
}

+ (NSString *)repeatMap:(NSMutableArray *)touchSequence
          withTolerance:(int)pixels {
    NSString *map = @"";
    for (int i = 0; i < [touchSequence count]-1; i++) {
        CGPoint firstTouch;
        [touchSequence[i] getValue:&firstTouch];
        CGPoint secondTouch;
        [touchSequence[i+1] getValue:&secondTouch];
        if ([Repeat repeatFor:firstTouch and:secondTouch withTolerance:pixels])
            map = [map stringByAppendingString:@"r"];
        else map = [map stringByAppendingString:@"x"];
    }
    return @"";
}

+ (BOOL)repeatFor:(CGPoint)firstTouch
              and:(CGPoint)secondTouch
    withTolerance:(int)pixels {
    if ([KeyMath distanceBetween:firstTouch and:secondTouch] < pixels)
        return YES;
    return NO;
}

@end
