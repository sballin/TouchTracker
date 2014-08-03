//
//  CenterOfGravity.h
//  TouchTracker
//
//  Created by Sean on 8/3/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterOfGravity : UIDynamicBehavior

+ (CGPoint)getCenterPointFor:(NSMutableArray *)touchSequence;

@end
