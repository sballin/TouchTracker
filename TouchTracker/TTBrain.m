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
#import "Repeat.h"

@interface TouchTrackerBrain ()
@property (nonatomic, strong) TwoDim *twodim;
@property (nonatomic, strong) Fraction *fraction;
@property (nonatomic, strong) Repeat *repeat;
@end

@implementation TouchTrackerBrain

@synthesize liveTouches = _liveTouches;
@synthesize touchHistory = _touchHistory;
@synthesize twodim = _twodim;
@synthesize fraction = _fraction;
@synthesize repeat = _repeat;
@synthesize countDictionary = _countDictionary;
@synthesize repeatDictionary = _repeatDictionary;

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

- (Repeat *)repeat {
    if (!_repeat) _repeat = [[Repeat alloc] init];
    return _repeat;
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

/**
 Load letter repetition dictionary from file.
 */
- (NSDictionary *)repeatDictionary:(int)tolerance {
    if (!_repeatDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"repeatDictionary%d", tolerance] ofType:@"plist"];
        _repeatDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _repeatDictionary;
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
    if ([Repeat containsRepeat:self.liveTouches withTolerance:50])
        bestWords = [self getRankedRepeatWords:50];
    if ([bestWords count] == 0) {
        bestWords = [self getRankedUnionMatches];
        if ([bestWords count] < 5)
            bestWords = [self getRankedCountMatches];
    }
    return bestWords;
}

- (NSArray *)getRankedRepeatWords:(int)tolerance {
    NSString *map = [Repeat repeatMap:self.liveTouches withTolerance:tolerance];
    NSMutableArray *repeatWords = self.repeatDictionary[map];
    return [self.fraction combinedFractionOrderedMatchesFor:repeatWords against:self.liveTouches];
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

@end
