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

@synthesize liveTouches = _liveTouches;
@synthesize touchHistory = _touchHistory;
@synthesize twodim = _twodim;
@synthesize fraction = _fraction;
@synthesize countDictionary = _countDictionary;

- (NSMutableArray *)liveTouches {
	if (!_liveTouches) _liveTouches = [[NSMutableArray alloc] init];
	return _liveTouches;
}

- (NSMutableArray *)touchHistory {
    if (!_touchHistory) _touchHistory = [[NSMutableArray alloc] init];
    return _touchHistory;
}

- (TwoDim *)twodim {
	if (!_twodim) _twodim = [[TwoDim alloc] init];
	return _twodim;
}

- (Fraction *)fraction {
    if (!_fraction) _fraction = [[Fraction alloc] init];
    return _fraction;
}

/**
 Load word length dictionary from file.
 */
- (NSDictionary *)countDictionary {
    if (!_countDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"countDictionary" ofType:@"plist"];
        _countDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _countDictionary;
}

- (void)addToLiveTouches:(CGPoint)touch {
	[self.liveTouches addObject:[NSValue value:&touch withObjCType:@encode(CGPoint)]];
}

- (CGPoint)getTouchAtIndex:(int)i {
	CGPoint touch;
	[(self.liveTouches)[i] getValue:&touch];
	return touch;
}

- (void)clearLiveTouches {
	self.liveTouches = nil;
}

- (NSArray *)getBestWords {
    NSArray *bestWords = [self getRankedIntersectMatches];
    if ([bestWords count] == 0) {
        bestWords = [self getRankedUnionMatches];
        if ([bestWords count] < 10)
            bestWords = [self getRankedCountMatches];
    }
    return bestWords;
}

- (NSArray *)getRankedMatches {
    NSString *horizpath = [TwoDim horizontalPathFor:self.liveTouches withTolerance:10];
    NSMutableSet *neighborPaths = [TwoDim horizontalExpansion:horizpath];
    NSMutableArray *allNeighborWords = [[NSMutableArray alloc] init];
    for (NSString *neighborPath in neighborPaths) {
        [allNeighborWords addObjectsFromArray:self.twodim.harshLeftRightDictionary[neighborPath]];
    }
    return [self.fraction combinedFractionOrderedMatchesFor:allNeighborWords against:self.liveTouches];
}

#define TOLERANCE 25
- (NSArray *)getRankedIntersectMatches {
    NSString *horizpath = [TwoDim horizontalPathFor:self.liveTouches withTolerance:TOLERANCE];
    NSString *vertpath = [TwoDim verticalPathFor:self.liveTouches withTolerance:TOLERANCE];
    NSMutableSet *horizontalNeighborPaths = [TwoDim horizontalExpansion:horizpath];
    NSMutableSet *verticalNeighborPaths = [TwoDim verticalExpansion:vertpath];
    NSMutableSet *horizontalNeighborWords = [[NSMutableSet alloc] init];
    NSMutableSet *verticalNeighborWords = [[NSMutableSet alloc] init];
    for (NSString *neighborPath in horizontalNeighborPaths) {
        [horizontalNeighborWords addObjectsFromArray:[self.twodim.harshLeftRightDictionary[neighborPath] copy]];
    }
    for (NSString *neighborPath in verticalNeighborPaths) {
        [verticalNeighborWords addObjectsFromArray:[self.twodim.harshUpDownDictionary[neighborPath] copy]];
    }
    [horizontalNeighborWords intersectSet:verticalNeighborWords];
    NSMutableArray *allCandidateWords = [[horizontalNeighborWords allObjects] mutableCopy];
    return [self.fraction combinedFractionOrderedMatchesFor:allCandidateWords against:self.liveTouches];
}

- (NSArray *)getRankedUnionMatches {
    NSString *horizpath = [TwoDim horizontalPathFor:self.liveTouches withTolerance:TOLERANCE];
    NSString *vertpath = [TwoDim verticalPathFor:self.liveTouches withTolerance:TOLERANCE];
    NSMutableSet *horizontalNeighborPaths = [TwoDim horizontalExpansion:horizpath];
    NSMutableSet *verticalNeighborPaths = [TwoDim verticalExpansion:vertpath];
    NSMutableSet *horizontalNeighborWords = [[NSMutableSet alloc] init];
    NSMutableSet *verticalNeighborWords = [[NSMutableSet alloc] init];
    for (NSString *neighborPath in horizontalNeighborPaths) {
        [horizontalNeighborWords addObjectsFromArray:[self.twodim.harshLeftRightDictionary[neighborPath] copy]];
    }
    for (NSString *neighborPath in verticalNeighborPaths) {
        [verticalNeighborWords addObjectsFromArray:[self.twodim.harshUpDownDictionary[neighborPath] copy]];
    }
    [horizontalNeighborWords unionSet:verticalNeighborWords];
    NSMutableArray *allCandidateWords = [[horizontalNeighborWords allObjects] mutableCopy];
    return [self.fraction combinedFractionOrderedMatchesFor:allCandidateWords against:self.liveTouches];
}

- (NSArray *)getRankedCountMatches {
    NSMutableArray *words = self.countDictionary[[NSString stringWithFormat:@"%d", [self.liveTouches count]]];
    return [self.fraction combinedFractionOrderedMatchesFor:words against:self.liveTouches];
}

/* TODO: scoring method */
- (NSString *)topScoringWords {
    // get all bashed snake path words
    // do other stuff
    return @"";
}

@end
