//
//  Fraction.h
//  TouchTracker
//
//  Created by Sean on 7/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fraction : NSObject
- (float)errorForWord:(NSString *)word
              against:(NSMutableArray *)touchSequence;
- (float)twoDimErrorForWord:(NSString *)word
                    against:(NSMutableArray *)touchSequence;
- (NSMutableArray *)twoDimFractionSort:(NSMutableArray *)words
                                 using:(NSMutableArray *)touchSequence;
- (NSMutableArray *)angleSort:(NSArray *)words
                        using:(NSArray *)touchSequence;
@end
