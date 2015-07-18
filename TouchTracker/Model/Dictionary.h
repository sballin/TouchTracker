//
//  DictionaryBuilder.h
//  TouchTracker
//
//  Created by Sean on 6/10/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ProgressDelegate
-(void)setProgress:(NSNumber *)amount;
@end

@interface Dictionary : NSObject
@property (nonatomic, strong) NSMutableDictionary *dictionaries;
@property (nonatomic,assign) id delegate;
- (void)writeCountDictionary;
- (void)writeDictionary:(NSString *)direction
          withTolerance:(NSNumber *)pixels;
@end


