//
//  TwoDim.h
//  TouchTracker
//
//  Created by Sean on 6/30/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwoDim : NSObject
@property (nonatomic, strong) NSDictionary *horizontalDictionary;
@property (nonatomic, strong) NSDictionary *binaryHorizontalDictionary;
+ (NSString *)horizontalPathFor:(NSMutableArray *)touchSequence
                  withTolerance:(int)pixels;
+ (NSString *)binaryHorizontalPathFor:(NSMutableArray *)touchSequence;
+ (NSString *)verticalPathFor:(NSMutableArray *)touchSequence
                withTolerance:(int)pixels;
+ (NSMutableSet *) xPansion:(NSString *)path;
- (NSString *)rowSequence:(NSMutableArray *)touchSequence;
@end
