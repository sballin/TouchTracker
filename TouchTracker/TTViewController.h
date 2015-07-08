//
//  TouchTrackerViewController.h
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TouchTrackerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *rankedMatchesDisplay;
@property (weak, nonatomic) IBOutlet UILabel *textDisplay;

@property (nonatomic, strong) NSMutableArray *userText;
@property (nonatomic, strong) NSMutableArray *rankedCandidates;
@property (weak, nonatomic) IBOutlet UISlider *uncertaintySlider;
@property (weak, nonatomic) IBOutlet UILabel *uncertaintyLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dictTypeControl;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)createPressed:(id)sender;
@end
