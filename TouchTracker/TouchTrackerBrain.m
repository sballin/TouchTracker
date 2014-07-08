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
- (NSArray *)fractionPath:(NSMutableArray *)touchSequence;
@end

@implementation TouchTrackerBrain

@synthesize touchSequence = _touchSequence;
@synthesize keyboard = _keyboard;

- (NSMutableArray *)touchSequence {
	if (!_touchSequence) _touchSequence = [[NSMutableArray alloc] init];
	return _touchSequence;
}

- (KeyMath *)keyboard {
    if (!_keyboard) _keyboard = [[KeyMath alloc] init];
    return _keyboard;
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

- (NSArray *)fractionPath:(NSMutableArray *)touchSequence {
	float total = 0.0;
	NSMutableArray *path = [[NSMutableArray alloc] init];
	for (int i = 0; i < [touchSequence count] - 1; i++) {
        CGPoint firstPoint, secondPoint;
        [[touchSequence objectAtIndex:i] getValue:&firstPoint];
        [[touchSequence objectAtIndex:i+1] getValue:&secondPoint];
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
	NSArray *touchPath = [self fractionPath:self.touchSequence];
    NSMutableArray *wordSequence = [self.keyboard modelTouchSequenceFor:word];
	NSArray *wordPath = [self fractionPath:wordSequence];
	float totalError = 0.0;
	for (int i = 0; i < [touchPath count]; i++) {
		float touchFraction = [[touchPath objectAtIndex:i] floatValue];
		float wordFraction = [[wordPath objectAtIndex:i] floatValue];
        float increment = [KeyMath errorBetween:touchFraction and:wordFraction];
		totalError += increment;
	}
	return totalError;
}

- (NSString *)bestMatchFor:(NSMutableArray *)words {
	float leastError = INFINITY;
	NSString *bestMatch;
	for (NSString *word in words) {
		float error = [self errorForWord:word];
//        NSLog(@"%@, %f\n", word, error);
		if (error < leastError) {
			bestMatch = word;
			leastError = error;
		}
	}
	return [bestMatch stringByAppendingString:[NSString stringWithFormat:@" %f", leastError]];
}

@end
