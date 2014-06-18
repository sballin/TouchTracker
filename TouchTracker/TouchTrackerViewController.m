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

@interface TouchTrackerViewController ()
@property (nonatomic, strong) NSMutableArray *touchList;
@property (nonatomic, strong) TouchTrackerBrain *brain;
@property (nonatomic, strong) Snake *snake;
@property (nonatomic, strong) DictionaryBuilder *dictBuild;
- (NSString *)matchesText:(NSString *)path;
@end

@implementation TouchTrackerViewController

@synthesize xDisplay = _xDisplay, yDisplay = _yDisplay;
@synthesize textDisplay = _textDisplay;
@synthesize pathDisplay = _pathDisplay;
@synthesize matchesDisplay = _matchesDisplay;
@synthesize bestMatchDisplay = _bestMatchDisplay;
@synthesize brain = _brain;
@synthesize snake = _snake;
@synthesize dictBuild = _dictBuild;

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

- (IBAction)clearPressed:(id)sender {
	[self.brain clearTouchSequence];
	self.matchesDisplay.text = @"";
	self.pathDisplay.text = @"";
	self.textDisplay.text = @"";
	self.bestMatchDisplay.text = @"";
}

- (NSString *)matchesText:(NSString *)path {
	NSMutableArray *list = [self.snake.snakeDictionary objectForKey:path];
	NSString *matches = @"";
	for (NSString *word in list)
		matches = [matches stringByAppendingString:[word stringByAppendingString:@" "]];
	matches = [matches stringByAppendingString:[NSString stringWithFormat:@"%lu", (unsigned long)[list count]]];
	return matches;
}

#define SPREAD 50

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
	for (UITouch *t in touches) {
        [self.dictBuild writeSnakeDictionary:SPREAD];
		CGPoint point = [t locationInView:self.view];
		self.xDisplay.text = [NSString stringWithFormat:@"x: %f", point.x];
		self.yDisplay.text = [NSString stringWithFormat:@"y: %f", point.y];
		[self.brain addToSequence:point];
		NSString *path = [Snake snakePath:self.brain.touchSequence withSpread:SPREAD];
		self.pathDisplay.text = path;
		self.textDisplay.text = [self.textDisplay.text stringByAppendingString:[NSString stringWithFormat:@"(%f,%f)\n", point.x, point.y]];
		if (self.pathDisplay.text) {
			self.matchesDisplay.text = [self matchesText:path];
			self.bestMatchDisplay.text = [self.brain bestMatchFor:[self.snake.snakeDictionary objectForKey:path]];
		}
	}
}

@end
