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

@property (weak, nonatomic) IBOutlet UITextView *textDisplay;
@property (weak, nonatomic) IBOutlet UILabel *pathDisplay;
@property (weak, nonatomic) IBOutlet UILabel *matchesDisplay;
@property (weak, nonatomic) IBOutlet UILabel *bestMatchDisplay;

@end
