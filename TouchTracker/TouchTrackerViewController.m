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

@interface TouchTrackerViewController ()
//@property (nonatomic, strong) UIView *myView;
@end

@implementation TouchTrackerViewController

@synthesize xDisplay = _xDisplay, yDisplay = _yDisplay;
//@synthesize myView = _myView;

//- (void)loadView
//{
//    [self setView:[[TouchDrawView alloc] initWithFrame:CGRectZero]];
//}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    //[self loadView];
    for (UITouch *t in touches)
    {
        CGPoint location = [t locationInView:[[TouchDrawView alloc] initWithFrame:CGRectZero]];
        self.xDisplay.text = [NSString stringWithFormat:@"x: %g", location.x];
        self.yDisplay.text = [NSString stringWithFormat:@"y: %g", location.y];
    }
}

@end
