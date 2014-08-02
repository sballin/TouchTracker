//
//  TypingSpace.m
//  TouchTracker
//
//  Created by Sean on 7/23/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TypingSpace.h"

@implementation TypingSpace

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setup {
    //self.backgroundColor = nil;
    self.opaque = NO;
}

- (void)awakeFromNib {
    [self setup];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
