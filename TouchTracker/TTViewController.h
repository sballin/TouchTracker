//
//  TouchTrackerViewController.h
//  TouchTracker
//
//  Created by Sean on 6/1/14.
//  Copyright (c) 2014 Sean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface TouchTrackerViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *rankedMatchesDisplay;
@property (weak, nonatomic) IBOutlet UILabel *textDisplay;

@property (nonatomic, strong) NSMutableArray *userText;
@property (nonatomic, strong) NSMutableArray *rankedCandidates;
@property (weak, nonatomic) IBOutlet UISlider *toleranceSlider;
@property (weak, nonatomic) IBOutlet UILabel *toleranceLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dictTypeControl;
@property (weak, nonatomic) IBOutlet UIProgressView *dictProgress;
@property (weak, nonatomic) IBOutlet UIPickerView *dictPicker;
- (IBAction)sliderValueChanged:(id)sender;
- (IBAction)createPressed:(id)sender;
@end
