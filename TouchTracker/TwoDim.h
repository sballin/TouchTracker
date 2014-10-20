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
@property (nonatomic, strong) NSDictionary *harshLeftRightDictionary;
@property (nonatomic, strong) NSDictionary *harshUpDownDictionary;
+ (NSString *)horizontalPathFor:(NSMutableArray *)touchSequence
                  withTolerance:(int)pixels;
+ (NSString *)binaryHorizontalPathFor:(NSMutableArray *)touchSequence;
+ (NSString *)verticalPathFor:(NSMutableArray *)touchSequence
                withTolerance:(int)pixels;
+ (NSString *)binaryVerticalPathFor:(NSMutableArray *)touchSequence;
+ (NSMutableSet *)horizontalExpansion:(NSString *)path;
+ (NSMutableSet *)verticalExpansion:(NSString *)path;
- (NSString *)rowSequence:(NSMutableArray *)touchSequence;
@end
