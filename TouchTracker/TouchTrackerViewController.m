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
@synthesize touchList = _touchList;
@synthesize textDisplay = _textDisplay;
@synthesize brain = _brain;

- (TouchTrackerBrain *)brain
{
    if (!_brain) _brain = [[TouchTrackerBrain alloc] init];
    return _brain;
}

- (NSMutableArray *)touchList
{
    if (!_touchList)_touchList = [[NSMutableArray alloc] init];
    return _touchList;
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    //self.touchList = [[NSMutableArray alloc] init];
    UIView *muhview = [[TouchDrawView alloc] initWithFrame:CGRectZero];
    for (UITouch *t in touches)
    {
        CGPoint location = [t locationInView:muhview];
        self.xDisplay.text = [NSString stringWithFormat:@"x: %g", location.x];
        self.yDisplay.text = [NSString stringWithFormat:@"y: %g", location.y];
        brain_touch touch;
        touch.x = location.x;
        touch.y = location.y;
        NSLog(@"STRUCT TEST %g", touch.x);
//        NSArray *touchCoordinates = [NSArray arrayWithObjects:[NSNumber numberWithDouble:location.x], [NSNumber numberWithDouble:location.y], nil];
        [self.touchList addObject:[NSValue value:&touch withObjCType:@encode(brain_touch)]];
//        [self.touchList addObject:touchCoordinates];
        NSLog(@"T----------------------:%@", t);
        NSLog(@"TOUCHLIST------------------:%@", self.touchList);
//        for (int i = 0; i < [self.touchList count]; i++)
//            NSLog(@"(%g,%g)", [[self.touchList objectAtIndex:i] locationInView:muhview].x, [[self.touchList objectAtIndex:i] locationInView:muhview].y);
        [self.brain snakePath:self.touchList:muhview];
        self.textDisplay.text = [self.textDisplay.text stringByAppendingString:[NSString stringWithFormat:@"(%g,%g)", location.x, location.y]];
    }
}

@end












