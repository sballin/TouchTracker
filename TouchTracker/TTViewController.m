//
//  TouchTrackerViewController.m
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import "TTViewController.h"
#import "TouchDrawView.h"
#import "TTAppDelegate.h"
#import "TTBrain.h"
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
        NSArray *bestWords = [self.brain getRankedIntersectMatches];
        self.rankedMatchesDisplay.text = [bestWords description];
        NSLog(@"%@", [bestWords description]);
        if ([bestWords count] > 0)
            self.bigCandidateDisplay.text = [bestWords[0] substringWithRange:NSMakeRange(5, [bestWords[0] length]-5)];
        else self.bigCandidateDisplay.text = @"";
    }
    else self.bigCandidateDisplay.text = @"";
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
    [self addGrowingCircleAtPoint:[[touches anyObject] locationInView:self.view]];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag && [[anim valueForKey:@"name"] isEqual:@"fade"]) {
        // when the fade animation is complete, we remove the layer
        CALayer* layer = [anim valueForKey:@"layer"];
        [layer removeFromSuperlayer];
    }
}

- (void)addGrowingCircleAtPoint:(CGPoint)point {
    // create a circle path
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddArc(circlePath, NULL, 0.f, 0.f, 20.f, 0.f, (float)2.f*M_PI, true);
    
    // create a shape layer
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.path = circlePath;
    
    // don't leak, please
    CGPathRelease(circlePath);
    layer.delegate = self;
    
    // set up the attributes of the shape layer and add it to our view's layer
    layer.fillColor = [[UIColor purpleColor] CGColor];
    layer.position = point;
    layer.anchorPoint = CGPointMake(.5f, .5f);
    [self.view.layer addSublayer:layer];
    
    CABasicAnimation *grow = [CABasicAnimation animationWithKeyPath:@"transform"];
    grow.fromValue = [layer valueForKey:@"transform"];
    CATransform3D t = CATransform3DMakeScale(12.f, 12.f, 1.f);
    grow.toValue = [NSValue valueWithCATransform3D:t];
    grow.duration = 1.f;
    grow.delegate = self;
    layer.transform = t;
    [grow setValue:@"grow" forKey:@"name"];
    [grow setValue:layer forKey:@"layer"];
    [layer addAnimation:grow forKey:@"transform"];
    
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = [layer valueForKey:@"opacity"];
    fade.toValue = [NSNumber numberWithFloat:0.f];
    fade.duration = .5f;
    fade.delegate = self;
    layer.opacity = 0.f;
    [fade setValue:@"fade" forKey:@"name"];
    [fade setValue:layer forKey:@"layer"];
    [layer addAnimation:fade forKey:@"opacity"];
}

@end
