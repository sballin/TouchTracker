//
//  UpDown.m
//  TouchTracker
//
//  Created by Sean on 6/30/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "UpDown.h"

@interface UpDown ()
+ (NSString *)direction:(CGPoint)firstTouch
                     to:(CGPoint)secondTouch
          withTolerance:(int)pixels;
@end

@implementation UpDown

+ (NSString *)direction:(CGPoint)firstTouch
                     to:(CGPoint)secondTouch
          withTolerance:(int)pixels {
    return @"";
}

+ (NSString *)path:(NSMutableArray *)touchSequence
     withTolerance:(int)pixels {
    NSString *path = @"";
    if ([touchSequence count] >= 2)
		for (int i = 0; i < [touchSequence count] - 1; i++) {
			CGPoint firstTouch;
			[[touchSequence objectAtIndex:i] getValue:&firstTouch];
			CGPoint secondTouch;
			[[touchSequence objectAtIndex:i + 1] getValue:&secondTouch];
			path = [path stringByAppendingString:[UpDown direction:firstTouch to:secondTouch withTolerance:pixels]];
		}
	return path;
}

@end
