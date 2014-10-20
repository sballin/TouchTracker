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
@property (nonatomic, strong) NSDictionary *countDictionary;
- (void)addToLiveTouches:(CGPoint)touch;
- (CGPoint)getTouchAtIndex:(int)i;
- (void)clearLiveTouches;
- (NSArray *)getRankedMatches;
- (NSArray *)getRankedIntersectMatches;
- (NSArray *)getRankedUnionMatches;
- (NSArray *)getRankedCountMatches;
@end
