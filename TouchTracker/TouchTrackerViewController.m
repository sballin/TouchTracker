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
//    UIView *muhView = [[TouchDrawView alloc] initWithFrame:CGRectZero];
    for (UITouch *t in touches)
    {
        CGPoint point = [t locationInView:self.view];
        self.xDisplay.text = [NSString stringWithFormat:@"x: %f", point.x];
        self.yDisplay.text = [NSString stringWithFormat:@"y: %f", point.y];
        self.pathDisplay.text = [self.brain snakePath:point];
        self.textDisplay.text = [self.textDisplay.text stringByAppendingString:[NSString stringWithFormat:@"(%f,%f)\n", point.x, point.y]];
    }
}

@end












