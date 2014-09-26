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
- (NSArray *)horizontalFractionPath:(NSMutableArray *)touchSequence;
- (NSArray *)verticalFractionPath:(NSMutableArray *)touchSequence;
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

- (NSArray *)horizontalFractionPath:(NSMutableArray *)touchSequence {
	float total = 0.0;
	NSMutableArray *path = [[NSMutableArray alloc] init];
	for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstPoint, secondPoint;
        [touchSequence[i] getValue:&firstPoint];
        [touchSequence[i+1] getValue:&secondPoint];
        firstPoint.y = 0.0;
        secondPoint.y = 0.0;
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

- (NSArray *)verticalFractionPath:(NSMutableArray *)touchSequence {
	float total = 0.0;
	NSMutableArray *path = [[NSMutableArray alloc] init];
	for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstPoint, secondPoint;
        [touchSequence[i] getValue:&firstPoint];
        [touchSequence[i+1] getValue:&secondPoint];
        firstPoint.x = 0.0;
        secondPoint.x = 0.0;
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

- (float)twoDimErrorForWord:(NSString *)word
                    against:(NSMutableArray *)touchSequence {
	NSArray *horizontalPath = [self horizontalFractionPath:touchSequence];
	NSArray *verticalPath = [self verticalFractionPath:touchSequence];
    NSArray *horizontalWordPath = [self horizontalFractionPath:[self.keyboard modelTouchSequenceFor:word]];
    NSArray *verticalWordPath = [self verticalFractionPath:[self.keyboard modelTouchSequenceFor:word]];
	float horizontalError = 0.0;
	float verticalError = 0.0;
    // Add individual errors in quadrature.
	for (int i = 0; i < [horizontalPath count]; i++) {
        horizontalError += powf([KeyMath errorBetween:[horizontalPath[i] floatValue] and:[horizontalWordPath[i] floatValue]], 2.0);
        verticalError += powf([KeyMath errorBetween:[verticalPath[i] floatValue] and:[verticalWordPath[i] floatValue]], 2.0);
    }
    // Add total errors in quadrature.
    return sqrtf(horizontalError+verticalError);
}

- (NSMutableArray *)combinedFractionOrderedMatchesFor:(NSMutableArray *)words
                                              against:(NSMutableArray *)touchSequence {
	float leastError = INFINITY;
	NSString *bestMatch;
    NSMutableArray *bestMatches = [[NSMutableArray alloc] init];
	for (NSString *word in words) {
		float error = [self twoDimErrorForWord:word against:touchSequence];
        [bestMatches addObject:[NSString stringWithFormat:@"%.2f %@", error, word]];
	}
    [bestMatches sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    return bestMatches;
}

@end
