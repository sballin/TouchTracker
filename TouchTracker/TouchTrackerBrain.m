//
//  TouchTrackerBrain.m
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TouchTrackerBrain.h"
#import "KeyMath.h"

@implementation TouchTrackerBrain

@synthesize touchSequence = _touchSequence;

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
	[(self.touchSequence)[i] getValue:&touch];
	return touch;
}

/* WRITE ME PLS */
- (NSString *)topScoringWords {
    // get all bashed snake path words
    // do other stuff
    return @"";
}

@end
