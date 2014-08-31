//
//  TouchTrackerBrain.m
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TouchTrackerBrain.h"
#import "Snake.h"
#import "TwoDim.h"
#import "Fraction.h"
#import "KeyMath.h"

@interface TouchTrackerBrain ()
@property (nonatomic, strong) Snake *snake;
@property (nonatomic, strong) TwoDim *twodim;
@property (nonatomic, strong) Fraction *fraction;
@end

@implementation TouchTrackerBrain

@synthesize touchSequence = _touchSequence;
@synthesize snake = _snake;
@synthesize twodim = _twodim;
@synthesize fraction = _fraction;

- (NSMutableArray *)touchSequence {
	if (!_touchSequence) _touchSequence = [[NSMutableArray alloc] init];
	return _touchSequence;
}

- (Snake *)snake {
	if (!_snake) _snake = [[Snake alloc] init];
	return _snake;
}

- (TwoDim *)twodim {
	if (!_twodim) _twodim = [[TwoDim alloc] init];
	return _twodim;
}

- (Fraction *)fraction {
    if (!_fraction) _fraction = [[Fraction alloc] init];
    return _fraction;
}

- (void)addToSequence:(CGPoint)touch {
	[self.touchSequence addObject:[NSValue value:&touch withObjCType:@encode(CGPoint)]];
}

- (CGPoint)getTouchAtIndex:(int)i {
	CGPoint touch;
	[(self.touchSequence)[i] getValue:&touch];
	return touch;
}

- (void)clearTouchSequence {
	self.touchSequence = nil;
}

- (NSArray *)getOrderedBestMatches {
    //NSMutableArray *bestWords = [self.fraction bestMatchFor:(self.snake.snakeDictionary)[path] against:self.brain.touchSequence];
    NSString *horizpath = [TwoDim horizontalPathFor:self.touchSequence withTolerance:10];
    NSMutableSet *neighborPaths = [TwoDim xPansion:horizpath];
    NSMutableArray *allNeighborWords = [[NSMutableArray alloc] init];
    for (NSString *neighborPath in neighborPaths) {
        [allNeighborWords addObjectsFromArray:self.twodim.binaryHorizontalDictionary[neighborPath]];
    }
    return [self.fraction combinedFractionOrderedMatchesFor:allNeighborWords against:self.touchSequence];
}

/* WRITE ME PLS */
- (NSString *)topScoringWords {
    // get all bashed snake path words
    // do other stuff
    return @"";
}

@end
