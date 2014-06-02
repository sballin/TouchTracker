//
//  TouchTrackerViewController.m
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TouchTrackerViewController.h"
#import "TouchDrawView.h"
#import "TouchTrackerAppDelegate.h"
#import "TouchTrackerBrain.h"

@interface TouchTrackerViewController()
@property (nonatomic, strong) NSMutableArray *touchList;
@property (nonatomic, strong) TouchTrackerBrain *brain;
@end

@implementation TouchTrackerViewController

@synthesize xDisplay = _xDisplay, yDisplay = _yDisplay;
@synthesize textDisplay = _textDisplay;
@synthesize pathDisplay = _pathDisplay;
@synthesize brain = _brain;

- (TouchTrackerBrain *)brain
{
    if (!_brain) _brain = [[TouchTrackerBrain alloc] init];
    return _brain;
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    UIView *muhview = [[TouchDrawView alloc] initWithFrame:CGRectZero];
    for (UITouch *t in touches)
    {
        CGPoint location = [t locationInView:muhview];
        self.xDisplay.text = [NSString stringWithFormat:@"x: %g", location.x];
        self.yDisplay.text = [NSString stringWithFormat:@"y: %g", location.y];
        self.pathDisplay.text = [self.brain snakePath:location];
        self.textDisplay.text = [self.textDisplay.text stringByAppendingString:[NSString stringWithFormat:@"(%g,%g)\n", location.x, location.y]];
    }
}

@end












