//
//  Repeat.h
//  TouchTracker
//
//  Created by Sean on 7/6/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repeat : NSObject

+ (NSString *)repeatMap:(NSMutableArray *)touchSequence
              withTolerance:(int)pixels;
+ (BOOL)repeatFor:(CGPoint)firstTouch
              and:(CGPoint)secondTouch
    withTolerance:(int)pixels;

@end
