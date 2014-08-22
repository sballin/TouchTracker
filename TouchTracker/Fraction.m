//
//  Fraction.m
//  TouchTracker
//
//  Created by Sean on 7/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "Fraction.h"
#import "KeyMath.h"

@interface Fraction ()
@property (nonatomic, strong) KeyMath *keyboard;
- (NSArray *)fractionPath:(NSMutableArray *)touchSequence;
@end

@implementation Fraction

@synthesize keyboard = _keyboard;

- (KeyMath *)keyboard {
    if (!_keyboard) _keyboard = [[KeyMath alloc] init];
    return _keyboard;
}

- (NSArray *)fractionPath:(NSMutableArray *)touchSequence {
	float total = 0.0;
	NSMutableArray *path = [[NSMutableArray alloc] init];
	for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstPoint, secondPoint;
        [touchSequence[i] getValue:&firstPoint];
        [touchSequence[i+1] getValue:&secondPoint];
		float distance =  [KeyMath distanceBetween:firstPoint and:secondPoint];
		[path addObject:@(distance)];
		total += distance;
	}
	for (int i = 0; i < [path count]; i++) {
		float fraction = [path[i] floatValue] / total;
		path[i] = @(fraction);
	}
	return [path copy];
}

- (float)errorForWord:(NSString *)word
              against:(NSMutableArray *)touchSequence {
	NSArray *touchPath = [self fractionPath:touchSequence];
    NSArray *wordPath = [self fractionPath:[self.keyboard modelTouchSequenceFor:word]];
	float totalError = 0.0;
    // Add errors in quadrature.
	for (int i = 0; i < [touchPath count]; i++)
        totalError += powf([KeyMath errorBetween:[touchPath[i] floatValue] and:[wordPath[i] floatValue]], 2.0);
	return sqrtf(totalError);
}

- (NSMutableArray *)bestMatchFor:(NSMutableArray *)words
                   against:(NSMutableArray *)touchSequence {
	float leastError = INFINITY;
	NSString *bestMatch;
    NSMutableArray *bestMatches = [[NSMutableArray alloc] init];
	for (NSString *word in words) {
		float error = [self errorForWord:word against:touchSequence];
		if (error < leastError) {
			bestMatch = word;
			leastError = error;
		}
        [bestMatches addObject:[NSString stringWithFormat:@"%.2f %@", error, word]];
	}
    [bestMatches sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return bestMatches;
}

@end
