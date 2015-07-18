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
                  withTolerance:(NSNumber *)pixels;
+ (NSString *)verticalPathFor:(NSMutableArray *)touchSequence
                  withTolerance:(NSNumber *)pixels;
+ (NSString *)repeatPathFor:(NSMutableArray *)touchSequence
              withTolerance:(NSNumber *)pixels;
- (NSString *)repeatMapForWord:(NSString *)word
                 withTolerance:(NSNumber *)pixels;
+ (BOOL)containsRepeat:(NSMutableArray *)touchSequence
         withTolerance:(NSNumber *)pixels;
+ (NSMutableSet *)expand:(NSString *)path
             inDirection:(NSString *)direction;
@end
