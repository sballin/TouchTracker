//
//  Snake.m
//  TouchTracker
//
//  Created by Sean on 6/5/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "Snake.h"
#import "KeyMath.h"

@interface Snake ()
@property (nonatomic, strong) KeyMath *keyboard;
+ (NSString *)directionVerbatim:(CGPoint)firstTouch
							   :(CGPoint)secondTouch
							   :(CGPoint)thirdTouch;
+ (NSString *)directionBash:(CGPoint)firstTouch
						   :(CGPoint)secondTouch
						   :(CGPoint)thirdTouch
						   :(int)spread;
@end

@implementation Snake

@synthesize snakeDictionary = _snakeDictionary;
@synthesize keyboard = _keyboard;

- (KeyMath *)keyboard {
    if (!_keyboard) _keyboard = [[KeyMath alloc] init];
    return _keyboard;
}

- (NSDictionary *)snakeDictionary {
	if (!_snakeDictionary) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"snakeDictionary25" ofType:@"plist"];
		_snakeDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
	}
	return _snakeDictionary;
}

+ (NSString *)directionVerbatim:(CGPoint)firstTouch
							   :(CGPoint)secondTouch
							   :(CGPoint)thirdTouch {
	CGPoint vectorA;
	vectorA.x = secondTouch.x - firstTouch.x;
	vectorA.y = secondTouch.y - firstTouch.y;
	CGPoint vectorB;
	vectorB.x = thirdTouch.x - secondTouch.x;
	vectorB.y = thirdTouch.y - secondTouch.y;
	float cross = [KeyMath crossProduct2D:vectorA:vectorB];
	if (cross > 0) return [NSString stringWithFormat:@"r"];
	else if (cross < 0) return [NSString stringWithFormat:@"l"];
	else return [NSString stringWithFormat:@"x"];
}

+ (NSString *)directionBash:(CGPoint)firstTouch
						   :(CGPoint)secondTouch
						   :(CGPoint)thirdTouch
						   :(int)spread {
	NSString *originalDirection = [[self class] directionVerbatim:firstTouch:secondTouch:thirdTouch];
	for (int i = 0; i <= 4; i++) {
		for (int j = 0; j <= 4; j++) {
			for (int k = 0; k <= 4; k++) {
				NSString *jostledDirection = [Snake directionVerbatim:[KeyMath displace:firstTouch:spread:i]:[KeyMath displace:secondTouch:spread:j]:[KeyMath displace:thirdTouch:spread:k]];
				if (![jostledDirection isEqualToString:originalDirection])
					return [NSString stringWithFormat:@"x"];
			}
		}
	}
	return originalDirection;
}

+ (NSString *)snakePath:(NSMutableArray *)touchSequence
             withSpread:(int)spread {
	if ([touchSequence count] >= 3) {
		NSString *path = [NSString stringWithFormat:@""];
		for (int i = 0; i < [touchSequence count] - 2; i++) {
			CGPoint firstTouch;
			[[touchSequence objectAtIndex:i] getValue:&firstTouch];
			CGPoint secondTouch;
			[[touchSequence objectAtIndex:i + 1] getValue:&secondTouch];
			CGPoint thirdTouch;
			[[touchSequence objectAtIndex:i + 2] getValue:&thirdTouch];
			path = [path stringByAppendingString:[Snake directionBash:firstTouch:secondTouch:thirdTouch:spread]];
		}
		return path;
	}
	return nil;
}

- (NSString *)snakePathOfWord:(NSString *)word
                   withSpread:(int)spread {
	NSString *path = @"";
	for (int i = 0; i < [word length] - 2; i++) {
		CGPoint firstTouch = [self.keyboard getCoordinatesOf:[NSString stringWithFormat:@"%c", [word characterAtIndex:i]]];
		CGPoint secondTouch = [self.keyboard getCoordinatesOf:[NSString stringWithFormat:@"%c", [word characterAtIndex:i + 1]]];
		CGPoint thirdTouch = [self.keyboard getCoordinatesOf:[NSString stringWithFormat:@"%c", [word characterAtIndex:i + 2]]];
		path = [path stringByAppendingString:[Snake directionBash:firstTouch:secondTouch:thirdTouch:spread]];
	}
	return path;
}

@end
