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
#import "Dictionary.h"

@interface TouchTrackerViewController ()
@property (nonatomic, strong) TouchTrackerBrain *brain;
@property (nonatomic, strong) Dictionary *dictBuild;
@property (nonatomic, strong) UIView *uncertaintyLength;
@end

@implementation TouchTrackerViewController

@synthesize rankedMatchesDisplay = _rankedMatchesDisplay;
@synthesize textDisplay = _textDisplay;
@synthesize brain = _brain;
@synthesize dictBuild = _dictBuild;

- (Dictionary *)dictBuild {
	if (!_dictBuild) _dictBuild = [[Dictionary alloc] init];
	return _dictBuild;
}

- (TouchTrackerBrain *)brain {
	if (!_brain) _brain = [[TouchTrackerBrain alloc] init];
	return _brain;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dictProgress.progress = 0;
    self.dictBuild.delegate = self;
}

- (void)setProgress:(NSNumber *)amount {
    [self.dictProgress setProgress:[amount floatValue] animated:YES];
}

- (UIView *)uncertaintyLength {
    if (!_uncertaintyLength) {
        _uncertaintyLength = [[UIView alloc] init];
        _uncertaintyLength.backgroundColor = [UIColor lightGrayColor];
        [self.uncertaintySlider addSubview:_uncertaintyLength];
    }
    return _uncertaintyLength;
}

- (NSMutableArray *)userText {
    if (!_userText) _userText = [[NSMutableArray alloc] init];
    return _userText;
}

- (NSMutableArray *)rankedCandidates {
    if (!_rankedCandidates) _rankedCandidates = [[NSMutableArray alloc] init];
    return _rankedCandidates;
}

- (IBAction)swipeLeft:(UISwipeGestureRecognizer *)sender {
    [self spacePressed];
}

- (IBAction)sliderValueChanged:(id)sender {
    int sliderInt = (int)roundf(self.uncertaintySlider.value);
    self.uncertaintySlider.value = (float)sliderInt;
    self.uncertaintyLabel.text = [NSString stringWithFormat:@"%d", sliderInt];
    self.uncertaintyLength.frame = CGRectMake(2, 40, self.uncertaintySlider.value, 1);
}

- (IBAction)createPressed:(id)sender {
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        switch (self.dictTypeControl.selectedSegmentIndex) {
            case 0:
                [self.dictBuild writeDictionary:@"horizontal" withTolerance:[NSNumber numberWithInteger:(int)self.uncertaintySlider.value]];
                break;
            case 1:
                [self.dictBuild writeDictionary:@"vertical" withTolerance:0];
                break;
            case 2:
                [self.dictBuild writeDictionary:@"repeat" withTolerance:[NSNumber numberWithInteger:(int)self.uncertaintySlider.value]];
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.dictProgress setProgress:0];
        });
    });
}

- (NSString *)getFormattedUserText {
    NSString *outputText = @"";
    for (NSString *word in self.userText)
        outputText = [outputText stringByAppendingString:[NSString stringWithFormat:@"%@ ", word]];
    return outputText;
}

- (void)spacePressed {
    // Get ranked words if enough touches have been made
    if ([self.brain.liveTouches count] >= 1) {
        self.rankedCandidates = [[self.brain getFilteredRankedCandidates:[NSNumber numberWithInteger:(int)self.uncertaintySlider.value]] mutableCopy];
        self.rankedMatchesDisplay.text = [self.rankedCandidates description];
        
        // Add top candidate to user text
        if ([self.rankedCandidates count] > 0) {
            [self.userText addObject:[self.rankedCandidates[0] substringWithRange:NSMakeRange(7, [self.rankedCandidates[0] length]-7)]];
            [self.brain.touchHistory addObject:self.brain.liveTouches];
            NSLog(@"Latest word: %@", [[self.userText lastObject] description]);
        }
        else {
            self.textDisplay.text = [self.textDisplay.text stringByAppendingString: @"∅"];
        }
        
        // Rewrite display
        self.textDisplay.text = [self getFormattedUserText];
    }
    else self.textDisplay.text = [self.textDisplay.text stringByAppendingString:@"∅"];
    
    // Clear slate for live touches
	[self.brain clearLiveTouches];
}

- (void)deleteLastWord {
    // Remove unwanted word from user text
    [self.userText removeLastObject];
    [self.brain.touchHistory removeLastObject];
    
    // Clear liveTouches
    [self.brain clearLiveTouches];
    
    // Reset display
    self.textDisplay.text = [self getFormattedUserText];
    self.rankedMatchesDisplay.text = @"";
}

- (void)pickNextCandidate {
    if ([self.rankedCandidates count] > 1) {
        // Replace last word printed with one popped off rankedCandidates
        [self.userText removeLastObject];
        [self.rankedCandidates removeObjectAtIndex:0];
        [self.userText addObject:[self.rankedCandidates[0] substringWithRange:NSMakeRange(7, [self.rankedCandidates[0] length]-7)]];
        // Update text.
        self.textDisplay.text = [self getFormattedUserText];
    }
}

#define THUMB_THRESHOLD 40
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event {
    // One finger -> letter or space
    if ([[event allTouches] count] == 1) {
        for (UITouch *t in touches) {
            CGPoint point = [t locationInView:self.view];
            float thickness = [[t valueForKey:@"pathMajorRadius"] floatValue];
            
            // Non-thumb finger -> letter
            if (thickness < THUMB_THRESHOLD) {
                [self.brain addToLiveTouches:point];
                [self addGrowingCircleAtPoint:[[touches anyObject] locationInView:self.view] withColor:[UIColor colorWithRed:0 green:.7490 blue:1 alpha:1]];
            }
            
            // Thumb -> space
            else {
                [self spacePressed];
                [self addGrowingCircleAtPoint:[[touches anyObject] locationInView:self.view] withColor:[UIColor greenColor]];
            }
            
        }
    }
    
    else if ([[event allTouches] count] == 2) {
        [self pickNextCandidate];
        for (UITouch *touch in [event.allTouches allObjects])
            [self addGrowingCircleAtPoint:[touch locationInView:self.view] withColor:[UIColor colorWithRed:.678431373 green:.517647059 blue:1 alpha:1]];
    }
    
    // 3 or more fingers -> backspace
    else if ([[event allTouches] count] >= 3) {
        [self deleteLastWord];
        for (UITouch *touch in [event.allTouches allObjects])
            [self addGrowingCircleAtPoint:[touch locationInView:self.view] withColor:[UIColor redColor]];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // When the fade animation is complete, remove the layer
    if (flag && [[anim valueForKey:@"name"] isEqual:@"fade"]) {
        CALayer* layer = [anim valueForKey:@"layer"];
        [layer removeFromSuperlayer];
    }
}

- (void)addGrowingCircleAtPoint:(CGPoint)point withColor:(UIColor *)color {
    // Create circle path
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGPathAddArc(circlePath, NULL, 0.f, 0.f, 20.f, 0.f, (float)2.f*M_PI, true);
    
    // Create shape layer
    CAShapeLayer* layer = [[CAShapeLayer alloc] init];
    layer.path = circlePath;
    
    // Don't leak
    CGPathRelease(circlePath);
    layer.delegate = self;
    
    // Set up attributes of shape layer and add it to our view's layer
    layer.fillColor = [color CGColor];
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
