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
#import "KeyMath.h"

@interface TouchTrackerBrain ()
@property (nonatomic, strong) TwoDim *twodim;
@property (nonatomic, strong) Fraction *fraction;
@property (nonatomic, strong) Dictionary *dict;
@end

@implementation TouchTrackerBrain

@synthesize liveTouches = _liveTouches;
@synthesize touchHistory = _touchHistory;
@synthesize twodim = _twodim;
@synthesize fraction = _fraction;
@synthesize dict = _dict;
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

- (NSArray *)getFilteredRankedCandidates:(NSNumber *)tolerance {
    NSMutableSet *horizCandidates = [self getCandidatesFor:@"horizontal" withTolerance:tolerance];
    NSSet *vertCandidates = [self getCandidatesFor:@"vertical" withTolerance:tolerance];
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
    
    if ([TwoDim containsRepeat:self.liveTouches withTolerance:tolerance]) {
        NSSet *repeatCandidates = [self getRepeatCandidates:tolerance];
        NSLog(@"Repeats: %lu", (unsigned long)[repeatCandidates count]);
        [horizCandidates intersectSet:repeatCandidates];
        return [self.fraction twoDimFractionSort:[[horizCandidates allObjects] mutableCopy] using:self.liveTouches];
    }
    
    // TODO: Use angle of two taps in longer words
    
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
    return  [self.fraction twoDimFractionSort:[words mutableCopy] using:self.liveTouches];
}

- (NSSet *)getRepeatCandidates:(NSNumber *)tolerance {
    NSString *map = [TwoDim repeatPathFor:self.liveTouches withTolerance:tolerance];
    return [NSSet setWithArray:self.dict.dictionaries[[NSString stringWithFormat:@"repeat, tolerance %@px", tolerance]][map]];
}

- (NSMutableSet *)getCandidatesFor:(NSString *)direction
                     withTolerance:(NSNumber *)pixels {
    NSString *path; NSMutableSet *neighborPaths;
    if ([direction isEqualToString:@"horizontal"]) {
        path = [TwoDim horizontalPathFor:self.liveTouches withTolerance:pixels];
        neighborPaths = [TwoDim expand:path inDirection:direction];
    }
    else if ([direction isEqualToString:@"vertical"]) {
        path = [TwoDim verticalPathFor:self.liveTouches withTolerance:pixels];
        neighborPaths = [TwoDim expand:path inDirection:direction];
    }
    NSMutableSet *neighborWords = [[NSMutableSet alloc] init];
    for (NSString *neighborPath in neighborPaths)
        [neighborWords addObjectsFromArray:[self.dict.dictionaries[[NSString stringWithFormat:@"%@, tolerance 0px", direction]][neighborPath] copy]];
    return neighborWords;
}

- (NSArray *)getCountCandidates {
    return self.countDictionary[[NSString stringWithFormat:@"%lu", (unsigned long)[self.liveTouches count]]];
}

@end
