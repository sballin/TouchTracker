//
//  TouchTrackerBrain.h
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchTrackerBrain : NSObject
@property (nonatomic, strong) NSMutableArray *liveTouches;
@property (nonatomic, strong) NSMutableArray *touchHistory;
@property (nonatomic, strong) NSString *primary;
@property (nonatomic, strong) NSString *secondary;
- (void)addToLiveTouches:(CGPoint)touch;
- (void)clearLiveTouches;
- (NSArray *)oldRankedCandidates:(NSNumber *)tolerance;
- (NSArray *)rankedCandidates:(NSNumber *)tolerance;
@end
