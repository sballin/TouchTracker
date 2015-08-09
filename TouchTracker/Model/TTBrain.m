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
#import "Dictionary.h"

@interface TouchTrackerBrain ()
@property (nonatomic, strong) TwoDim *twodim;
@property (nonatomic, strong) Fraction *fraction;
@property (nonatomic, strong) Dictionary *dict;
@end

@implementation TouchTrackerBrain

@synthesize twodim = _twodim;
@synthesize fraction = _fraction;
@synthesize dict = _dict;
@synthesize liveTouches = _liveTouches;
@synthesize touchHistory = _touchHistory;
@synthesize primary = _primary;
@synthesize secondary = _secondary;
@synthesize delegate;

- (TwoDim *)twodim {
	if (!_twodim) _twodim = [[TwoDim alloc] init];
	return _twodim;
}

- (Fraction *)fraction {
    if (!_fraction) _fraction = [[Fraction alloc] init];
    return _fraction;
}

- (Dictionary *)dict {
    if (!_dict) _dict = [[Dictionary alloc] init];
    return _dict;
}

- (NSMutableArray *)liveTouches {
	if (!_liveTouches) _liveTouches = [[NSMutableArray alloc] init];
	return _liveTouches;
}

- (NSMutableArray *)touchHistory {
    if (!_touchHistory) _touchHistory = [[NSMutableArray alloc] init];
    return _touchHistory;
}

- (NSString *)primary {
    if (!_primary) _primary = @"horizontalDict0";
    return _primary;
}

- (NSString *)secondary {
    if (!_secondary) _secondary = @"verticalDict0";
    return _secondary;
}

#pragma mark -

- (void)addToLiveTouches:(CGPoint)touch {
	[self.liveTouches addObject:[NSValue value:&touch withObjCType:@encode(CGPoint)]];
}

- (void)clearLiveTouches {
	self.liveTouches = nil;
}

- (NSArray *)oldRankedCandidates:(NSNumber *)tolerance {
    if (self.liveTouches.count == 1)
        return @[@"0.0000 a"];
    else if (self.liveTouches.count == 2) {
        NSArray *candidates = @[@"if", @"or", @"we", @"on", @"go", @"hi", @"at", @"is", @"an", @"it", @"no", @"of", @"my", @"to", @"up", @"in", @"us"];
        return [self.fraction angleSort:candidates using:self.liveTouches];
    }

    NSMutableSet *horizCandidates = [self candidatesInDirection:@"horizontal" withTolerance:tolerance].mutableCopy;
    NSSet *vertCandidates = [self candidatesInDirection:@"vertical" withTolerance:tolerance];
    NSMutableSet *horizCandidatesCopy = horizCandidates.mutableCopy;

    if ([TwoDim containsRepeat:self.liveTouches withTolerance:tolerance]) {
        NSSet *repeatCandidates = [self repeatCandidates:tolerance];
        [horizCandidates intersectSet:repeatCandidates];
        return [self.fraction twoDimFractionSort:horizCandidates.allObjects.mutableCopy using:self.liveTouches];
    }

    [horizCandidates intersectSet:vertCandidates];

    NSArray *words = [horizCandidates allObjects];
    if ([words count] == 0) {
        [horizCandidatesCopy unionSet:vertCandidates];
        words = horizCandidatesCopy.copy;

        if ([words count] < 5) {
            words = [self countCandidates];
        }
    }
    return  [self.fraction twoDimFractionSort:words.mutableCopy using:self.liveTouches];
}

- (void)sendCandidatesUpdate:(NSString *)text {
    if([delegate respondsToSelector:@selector(setCandidatesLabelText:)])
        [delegate performSelectorOnMainThread:@selector(setCandidatesLabelText:) withObject:text waitUntilDone:NO];
}

- (NSArray *)rankedCandidates:(NSNumber *)tolerance {
    if (self.liveTouches.count == 1)
        return @[@"0.0000 a"];
    else if (self.liveTouches.count == 2) {
        NSArray *candidates = @[@"if", @"or", @"we", @"on", @"go", @"hi", @"at", @"is", @"an", @"it", @"no", @"of", @"my", @"to", @"up", @"in", @"us"];
        return [self.fraction angleSort:candidates using:self.liveTouches];
    }

    NSMutableSet *primaries = [self candidatesForDictionary:self.primary withTolerance:tolerance].mutableCopy;
    NSSet *secondaries = [self candidatesForDictionary:self.secondary withTolerance:tolerance];
    NSMutableSet *primariesCopy = primaries.mutableCopy;
    int primariesCount = primaries.count;

    [primaries intersectSet:secondaries];
    [self sendCandidatesUpdate:[NSString stringWithFormat:@"Primary:\t\t%d\nSecondary:\t%d\nIntersect:\t%d", primariesCount, secondaries.count, primaries.count]];

    NSArray *finalWords = primaries.allObjects;
    if (finalWords.count == 0) {
        [primariesCopy unionSet:secondaries];
        finalWords = primariesCopy.allObjects;
        if (finalWords.count == 0) {
            finalWords = [self countCandidates];
        }
    }
    return [self.fraction twoDimFractionSort:finalWords.mutableCopy using:self.liveTouches];
}

- (NSSet *)candidatesForDictionary:(NSString *)name
                     withTolerance:(NSNumber *)pixels {
    if ([name containsString:@"horizontal"]) {
        if ([name containsString:@"Dict0"]) return [self candidatesInDirection:@"horizontal" withTolerance:pixels];
        else return [NSSet setWithArray:self.dict.dictionaries[name][[TwoDim horizontalPathFor:self.liveTouches withTolerance:pixels]]];
    }
    else if ([name containsString:@"vertical"]) {
        if ([name containsString:@"Dict0"]) return [self candidatesInDirection:@"vertical" withTolerance:pixels];
        else return [NSSet setWithArray:self.dict.dictionaries[name][[TwoDim verticalPathFor:self.liveTouches withTolerance:pixels]]];
    }
    else if ([name containsString:@"count"])
        return [NSSet setWithArray:self.dict.dictionaries[@"countDict"][[NSString stringWithFormat:@"%lu", (unsigned long)self.liveTouches.count]]];
    else return [self repeatCandidates:pixels];
}


- (NSSet *)candidatesInDirection:(NSString *)direction
                   withTolerance:(NSNumber *)pixels {
    NSString *path;
    NSMutableSet *neighborPaths;
    if ([direction isEqualToString:@"horizontal"]) {
        path = [TwoDim horizontalPathFor:self.liveTouches withTolerance:pixels];
        neighborPaths = [TwoDim horizontalExpansion:path];
    } else {
        path = [TwoDim verticalPathFor:self.liveTouches withTolerance:pixels];
        neighborPaths = [TwoDim verticalExpansion:path];
    }
    NSMutableSet *neighborWords = [[NSMutableSet alloc] init];
    for (NSString *neighborPath in neighborPaths)
        [neighborWords addObjectsFromArray:[self.dict.dictionaries[[NSString stringWithFormat:@"%@Dict0", direction]][neighborPath] copy]];
    return neighborWords;
}

- (NSSet *)repeatCandidates:(NSNumber *)tolerance {
    NSString *path = [TwoDim repeatPathFor:self.liveTouches withTolerance:tolerance];
    return [NSSet setWithArray:self.dict.dictionaries[@"repeatDict"][path]];
}

- (NSArray *)countCandidates {
    return self.dict.dictionaries[@"countDict"][[NSString stringWithFormat:@"%lu", (unsigned long)self.liveTouches.count]];
}

@end
