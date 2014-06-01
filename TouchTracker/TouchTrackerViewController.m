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

@interface TouchTrackerViewController ()
//@property (nonatomic, strong) UIView *myView;
@property (nonatomic, strong) NSMutableArray *touchList;
@property (nonatomic, strong) TouchTrackerBrain *brain;
@end

@implementation TouchTrackerViewController

@synthesize xDisplay = _xDisplay, yDisplay = _yDisplay;
@synthesize touchList = _touchList;
@synthesize textDisplay = _textDisplay;
@synthesize brain = _brain;

- (TouchTrackerBrain *)brain
{
    if (!_brain) _brain = [[TouchTrackerBrain alloc] init];
    return _brain;
}

//@synthesize myView = _myView;

//- (void)loadView
//{
//    [self setView:[[TouchDrawView alloc] initWithFrame:CGRectZero]];
//}

- (NSMutableArray *)touchList
{
    if (!_touchList) _touchList = [[NSMutableArray alloc] init];
    return _touchList;
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
        //[self.touchList addObject:(NSObject *) location;
        self.textDisplay.text = [self.textDisplay.text stringByAppendingString:[NSString stringWithFormat:@"(%g,%g)", location.x, location.y]];
    }
}

@end
