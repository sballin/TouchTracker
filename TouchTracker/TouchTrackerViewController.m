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
#import "Snake.h"
#import "DictionaryBuilder.h"
#import "Fraction.h"
#import "TypingSpace.h"

@interface TouchTrackerViewController ()
@property (nonatomic, strong) NSMutableArray *touchList;
@property (nonatomic, strong) TouchTrackerBrain *brain;
@property (nonatomic, strong) Snake *snake;
@property (nonatomic, strong) DictionaryBuilder *dictBuild;
@property (nonatomic, strong) Fraction *fraction;
@property (nonatomic) double lastTouchTime;
@property (weak, nonatomic) IBOutlet TypingSpace *typingSpace;
- (NSString *)matchesText:(NSString *)path;
@end

@implementation TouchTrackerViewController

@synthesize pathDisplay = _pathDisplay;
@synthesize bestMatchDisplay = _bestMatchDisplay;
@synthesize brain = _brain;
@synthesize snake = _snake;
@synthesize dictBuild = _dictBuild;
@synthesize fraction = _fraction;
@synthesize lastTouchTime = _lastTouchTime;

- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
    [self clearPressed:nil];
}

- (double)lastTouchTime {
    if (!_lastTouchTime) _lastTouchTime = INFINITY;
    return _lastTouchTime;
}

- (Fraction *)fraction {
    if (!_fraction) _fraction = [[Fraction alloc] init];
    return _fraction;
}

- (DictionaryBuilder *)dictBuild {
	if (!_dictBuild) _dictBuild = [[DictionaryBuilder alloc] init];
	return _dictBuild;
}

- (Snake *)snake {
	if (!_snake) _snake = [[Snake alloc] init];
	return _snake;
}

- (TouchTrackerBrain *)brain {
	if (!_brain) _brain = [[TouchTrackerBrain alloc] init];
	return _brain;
}

#define SPREAD 25
- (IBAction)clearPressed:(id)sender {
//	self.matchesDisplay.text = @"";
//	self.pathDisplay.text = @"";
//	self.bestMatchDisplay.text = @"";
    NSString *path = [Snake snakePath:self.brain.touchSequence withSpread:SPREAD];
    self.pathDisplay.text = path;
    if (self.pathDisplay.text) {
        NSLog(@"%@", [self matchesText:path]);
        NSString *bestWords = [self.fraction bestMatchFor:[self.snake.snakeDictionary objectForKey:path] against:self.brain.touchSequence];
        self.bestMatchDisplay.text = bestWords;
    }
	[self.brain clearTouchSequence];
}

- (IBAction)dumpPressed {
    NSString *dumpText = @"";
    for (int i = 0; i < [self.brain.touchSequence count]; i++) {
        CGPoint touch =  [self.brain getTouchAtIndex:i];
        dumpText = [dumpText stringByAppendingString:[NSString stringWithFormat:@"(%f,%f),", touch.x, touch.y]];
    }
    NSLog(@"%@", dumpText);
}

- (NSString *)matchesText:(NSString *)path {
	NSMutableArray *list = [self.snake.snakeDictionary objectForKey:path];
	NSString *matches = @"";
	for (NSString *word in list)
		matches = [matches stringByAppendingString:[word stringByAppendingString:@" "]];
	matches = [matches stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)[list count]]];
	return matches;
}


- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
	for (UITouch *t in touches) {
//        [self.dictBuild writeSnakeDictionary:SPREAD];
		CGPoint point = [t locationInView:self.view];
		[self.brain addToSequence:point];
	}
}

@end
