//
//  Repeat.h
//  TouchTracker
//
//  Created by Sean on 7/6/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repeat : NSObject
+ (BOOL)containsRepeat:(NSMutableArray *)touchSequence
         withTolerance:(int)pixels;
+ (NSString *)repeatMap:(NSMutableArray *)touchSequence
          withTolerance:(int)pixels;
- (NSString *)repeatMapForWord:(NSString *)word
                 withTolerance:(int)pixels;
@end
