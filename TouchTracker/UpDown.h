//
//  UpDown.h
//  TouchTracker
//
//  Created by Sean on 6/30/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpDown : NSObject
+ (NSString *)path:(NSMutableArray *)touchSequence
     withTolerance:(int)pixels;
@end
