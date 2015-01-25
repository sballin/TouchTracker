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

#pragma mark -

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
- (NSDictionary *)repeatDictionary {
    if (!_repeatDictionary) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"repeatDictionary10" ofType:@"plist"];
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

- (NSArray *)getFilteredRankedCandidates {
    NSMutableSet *horizCandidates = [self getHorizontalCandidates];
    NSSet *vertCandidates = [self getVerticalCandidates];
    NSMutableSet *horizCandidatesCopy = [horizCandidates mutableCopy];
    NSLog(@"horiz: %lu", (unsigned long)[horizCandidates count]);
    NSLog(@"vert: %lu", (unsigned long)[vertCandidates count]);
    
    if ([self.liveTouches count] == 1) {
        return @[@"0.0000 a"];
    }
    
    if ([self.liveTouches count] == 2) {
        NSArray *candidates = @[@"if", @"or", @"we", @"on", @"go", @"hi", @"at", @"is", @"an", @"it", @"no", @"of", @"my", @"to", @"up", @"in", @"us"];
        return [self.fraction angleSort:candidates using:self.liveTouches];
    }
    
    if ([Repeat containsRepeat:self.liveTouches withTolerance:50]) {
        NSSet *repeatCandidates = [self getRepeatCandidates:50];
        NSLog(@"Repeats: %lu", (unsigned long)[repeatCandidates count]);
        [horizCandidates intersectSet:repeatCandidates];
        return [self.fraction twoDimFractionSort:[[horizCandidates allObjects] mutableCopy] using:self.liveTouches];
        // TODO: Early return
    }
    
    // TODO: use angle of two taps in longer words
    
    [horizCandidates intersectSet:vertCandidates];
    NSLog(@"Intersect: %lu", (unsigned long)[horizCandidates count]);
    
    NSArray *words = [horizCandidates allObjects];
    if ([words count] == 0) {
        [horizCandidatesCopy unionSet:vertCandidates];
        words = [horizCandidatesCopy copy];
        NSLog(@"Union: %lu", (unsigned long)[horizCandidatesCopy count]);
        
        if ([words count] < 5) {
            words = [self getCountCandidates];
            NSLog(@"Letter count: %lu", (unsigned long)[words count]);
        }
    }
    return [self.fraction twoDimFractionSort:[words mutableCopy] using:self.liveTouches];
}

- (NSSet *)getRepeatCandidates:(int)tolerance {
    NSString *map = [Repeat repeatMap:self.liveTouches withTolerance:tolerance];
    return [NSSet setWithArray:self.repeatDictionary[map]];
}

#define TOLERANCE 25
- (NSMutableSet *)getHorizontalCandidates {
    NSString *horizpath = [TwoDim horizontalPathFor:self.liveTouches withTolerance:TOLERANCE];
    NSMutableSet *horizontalNeighborPaths = [TwoDim horizontalExpansion:horizpath];
    NSMutableSet *horizontalNeighborWords = [[NSMutableSet alloc] init];
    for (NSString *neighborPath in horizontalNeighborPaths)
        [horizontalNeighborWords addObjectsFromArray:[self.twodim.harshLeftRightDictionary[neighborPath] copy]];
    return horizontalNeighborWords;
}

- (NSMutableSet *)getVerticalCandidates {
    NSString *vertpath = [TwoDim verticalPathFor:self.liveTouches withTolerance:TOLERANCE];
    NSMutableSet *verticalNeighborPaths = [TwoDim verticalExpansion:vertpath];
    NSMutableSet *verticalNeighborWords = [[NSMutableSet alloc] init];
    for (NSString *neighborPath in verticalNeighborPaths)
        [verticalNeighborWords addObjectsFromArray:[self.twodim.harshUpDownDictionary[neighborPath] copy]];
    return verticalNeighborWords;
}

- (NSArray *)getCountCandidates {
    return self.countDictionary[[NSString stringWithFormat:@"%lu", (unsigned long)[self.liveTouches count]]];
}

@end
