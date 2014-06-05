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
- (NSString *) matchesText:(NSString *)path;
@end

@implementation TouchTrackerViewController

@synthesize xDisplay = _xDisplay, yDisplay = _yDisplay;
@synthesize textDisplay = _textDisplay;
@synthesize pathDisplay = _pathDisplay;
@synthesize matchesDisplay = _matchesDisplay;
@synthesize brain = _brain;

- (TouchTrackerBrain *)brain
{
    if (!_brain) _brain = [[TouchTrackerBrain alloc] init];
    return _brain;
}

- (IBAction)clearPressed:(id)sender
{
    [self.brain clearTouchSequence];
    self.matchesDisplay.text = @"";
    self.pathDisplay.text = @"";
    self.textDisplay.text = @"";
}

- (NSString *) matchesText:(NSString *)path
{
    NSMutableArray *list = [self.brain.snakeDictionary objectForKey:path];
    NSString *matches = @"";
    for (NSString *word in list)
        matches = [matches stringByAppendingString:[word stringByAppendingString:@" "]];
    matches = [matches stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)[list count]]];
    return matches;
}

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event
{
    for (UITouch *t in touches)
    {
        CGPoint point = [t locationInView:self.view];
        self.xDisplay.text = [NSString stringWithFormat:@"x: %f", point.x];
        self.yDisplay.text = [NSString stringWithFormat:@"y: %f", point.y];
        NSString *path = [self.brain snakePath:point];
        self.pathDisplay.text = path;
        self.textDisplay.text = [self.textDisplay.text stringByAppendingString:[NSString stringWithFormat:@"(%f,%f)\n", point.x, point.y]];
        if (self.pathDisplay.text)
            self.matchesDisplay.text = [self matchesText:path];
    }
}

@end












