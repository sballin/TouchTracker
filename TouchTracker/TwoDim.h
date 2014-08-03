//
//  TwoDim.h
//  TouchTracker
//
//  Created by Sean on 6/30/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwoDim : NSObject

+ (NSString *)horizontalPathFor:(NSMutableArray *)touchSequence
                  withTolerance:(int)pixels;
+ (NSString *)verticalPathFor:(NSMutableArray *)touchSequence
                withTolerance:(int)pixels;
- (NSString *)rowSequence:(NSMutableArray *)touchSequence;

@end
