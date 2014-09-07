//
//  TouchTrackerBrain.m
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TTBrain.h"
#import "TwoDim.h"
#import "Fraction.h"
#import "KeyMath.h"

@interface TouchTrackerBrain ()
@property (nonatomic, strong) TwoDim *twodim;
@property (nonatomic, strong) Fraction *fraction;
@end

@implementation TouchTrackerBrain

@synthesize touchSequence = _touchSequence;
@synthesize twodim = _twodim;
@synthesize fraction = _fraction;

- (NSMutableArray *)touchSequence {
	if (!_touchSequence) _touchSequence = [[NSMutableArray alloc] init];
	return _touchSequence;
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

- (NSArray *)getRankedMatches {
    NSString *horizpath = [TwoDim horizontalPathFor:self.touchSequence withTolerance:10];
    NSMutableSet *neighborPaths = [TwoDim horizontalExpansion:horizpath];
    NSMutableArray *allNeighborWords = [[NSMutableArray alloc] init];
    for (NSString *neighborPath in neighborPaths) {
        [allNeighborWords addObjectsFromArray:self.twodim.binaryHorizontalDictionary[neighborPath]];
    }
    return [self.fraction combinedFractionOrderedMatchesFor:allNeighborWords against:self.touchSequence];
}

- (NSArray *)getRankedIntersectMatches {
    NSString *horizpath = [TwoDim horizontalPathFor:self.touchSequence withTolerance:10];
    NSString *vertpath = [TwoDim verticalPathFor:self.touchSequence withTolerance:10];
    NSMutableSet *horizontalNeighborPaths = [TwoDim horizontalExpansion:horizpath];
    NSMutableSet *verticalNeighborPaths = [TwoDim verticalExpansion:horizpath];
    NSMutableSet *horizontalNeighborWords = [[NSMutableSet alloc] init];
    NSMutableSet *verticalNeighborWords = [[NSMutableSet alloc] init];
    for (NSString *neighborPath in horizontalNeighborPaths) {
        [horizontalNeighborWords addObjectsFromArray:[self.twodim.binaryHorizontalDictionary[neighborPath] copy]];
    }
    for (NSString *neighborPath in verticalNeighborPaths) {
        [verticalNeighborWords addObjectsFromArray:[self.twodim.binaryVerticalDictionary[neighborPath] copy]];
    }
    [horizontalNeighborWords intersectSet:verticalNeighborWords];
    NSMutableArray *allCandidateWords = [[horizontalNeighborWords allObjects] mutableCopy];
    return [self.fraction combinedFractionOrderedMatchesFor:allCandidateWords against:self.touchSequence];
}

/* WRITE ME PLS */
- (NSString *)topScoringWords {
    // get all bashed snake path words
    // do other stuff
    return @"";
}

@end
