//
//  TouchTrackerBrain.m
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TouchTrackerBrain.h"
#import "KeyMath.h"

@interface TouchTrackerBrain ()
@property (nonatomic, strong) KeyMath *keyboard;
- (void)addToSequence:(CGPoint)touch;
- (CGPoint)getTouchAtIndex:(int)i;
- (NSArray *)fractionPathOfWord:(NSString *)word;
- (NSArray *)fractionPath;
- (float)errorForWord:(NSString *)word;
@end

@implementation TouchTrackerBrain

@synthesize touchSequence = _touchSequence;
@synthesize keyboard = _keyboard;

- (NSMutableArray *)touchSequence {
	if (!_touchSequence) _touchSequence = [[NSMutableArray alloc] init];
	return _touchSequence;
}

- (void)clearTouchSequence {
	self.touchSequence = nil;
}

- (void)addToSequence:(CGPoint)touch {
	[self.touchSequence addObject:[NSValue value:&touch withObjCType:@encode(CGPoint)]];
}

- (CGPoint)getTouchAtIndex:(int)i {
	CGPoint touch;
	[[self.touchSequence objectAtIndex:i] getValue:&touch];
	return touch;
}

- (NSArray *)fractionPathOfWord:(NSString *)word {
	float total = 0.0;
	NSMutableArray *path = [[NSMutableArray alloc] init];
	for (int i = 0; i < [word length] - 1; i++) {
		NSString *firstLetter = [NSString stringWithFormat:@"%c", [word characterAtIndex:i]];
		NSString *secondLetter = [NSString stringWithFormat:@"%c", [word characterAtIndex:i + 1]];
		CGPoint firstPoint = [self.keyboard getCoordinatesOf:firstLetter];
		CGPoint secondPoint = [self.keyboard getCoordinatesOf:secondLetter];
		float distance =  [KeyMath distanceBetween:firstPoint and:secondPoint];
		[path addObject:[NSNumber numberWithFloat:distance]];
		total += distance;
	}
	for (int i = 0; i < [path count]; i++) {
		float fraction = [[path objectAtIndex:i] floatValue] / total;
		[path replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:fraction]];
	}
	return [path copy];
}

- (NSArray *)fractionPath {
	float total = 0.0;
	NSMutableArray *path = [[NSMutableArray alloc] init];
	for (int i = 0; i < [self.touchSequence count] - 1; i++) {
		CGPoint firstPoint = [self getTouchAtIndex:i];
		CGPoint secondPoint = [self getTouchAtIndex:i + 1];
		float distance =  [KeyMath distanceBetween:firstPoint and:secondPoint];
		[path addObject:[NSNumber numberWithFloat:distance]];
		total += distance;
	}
	for (int i = 0; i < [path count]; i++) {
		float fraction = [[path objectAtIndex:i] floatValue] / total;
		[path replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:fraction]];
	}
	return [path copy];
}

- (float)errorForWord:(NSString *)word {
	NSArray *touchPath = [self fractionPath];
	NSArray *wordPath = [self fractionPathOfWord:word];
	float totalError = 0.0;
	for (int i = 0; i < [touchPath count]; i++) {
		float touchFraction = [[touchPath objectAtIndex:i] floatValue];
		float wordFraction = [[wordPath objectAtIndex:i] floatValue];
		totalError += [KeyMath errorBetween:touchFraction and:wordFraction];
	}
	return totalError;
}

- (NSString *)bestMatchFor:(NSMutableArray *)words {
	float leastError = INFINITY;
	NSString *bestMatch;
	for (NSString *word in words) {
		float error = [self errorForWord:word];
		if (error < leastError) {
			bestMatch = word;
			leastError = error;
		}
	}
	return bestMatch;
}

@end
