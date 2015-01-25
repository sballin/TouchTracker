//
//  Fraction.h
//  TouchTracker
//
//  Created by Sean on 7/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fraction : NSObject
- (float)twoDimErrorForWord:(NSString *)word
                    against:(NSArray *)touchSequence;
- (NSMutableArray *)twoDimFractionSort:(NSArray *)words
                                 using:(NSArray *)touchSequence;
- (NSMutableArray *)angleSort:(NSArray *)words
                        using:(NSArray *)touchSequence;
@end
