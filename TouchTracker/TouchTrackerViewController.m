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
#import "DictionaryBuilder.h"
#import "TypingSpace.h"

@interface TouchTrackerViewController ()
@property (nonatomic, strong) TouchTrackerBrain *brain;
@property (nonatomic, strong) DictionaryBuilder *dictBuild;
@property (weak, nonatomic) IBOutlet TypingSpace *typingSpace;
@end

@implementation TouchTrackerViewController

@synthesize rankedMatchesDisplay = _rankedMatchesDisplay;
@synthesize bigCandidateDisplay = _bigCandidateDisplay;
@synthesize brain = _brain;
@synthesize dictBuild = _dictBuild;

- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
    [self clearPressed:nil];
}

- (DictionaryBuilder *)dictBuild {
	if (!_dictBuild) _dictBuild = [[DictionaryBuilder alloc] init];
	return _dictBuild;
}

- (TouchTrackerBrain *)brain {
	if (!_brain) _brain = [[TouchTrackerBrain alloc] init];
	return _brain;
}

#define SPREAD 25
- (IBAction)clearPressed:(id)sender {
	self.rankedMatchesDisplay.text = @"";
    self.bigCandidateDisplay.adjustsFontSizeToFitWidth = YES;
    self.bigCandidateDisplay.minimumScaleFactor = 0;
    if ([self.brain.touchSequence count] > 2) {
        NSArray *bestWords = [self.brain getRankedMatches];
        self.rankedMatchesDisplay.text = [bestWords description];
        NSLog(@"%@", [bestWords description]);
        if ([bestWords count] > 0)
            self.bigCandidateDisplay.text = [bestWords[0] substringWithRange:NSMakeRange(5, [bestWords[0] length]-5)];
        else self.bigCandidateDisplay.text = @"";
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

- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
	for (UITouch *t in touches) {
		CGPoint point = [t locationInView:self.view];
		[self.brain addToSequence:point];
	}
}

@end
