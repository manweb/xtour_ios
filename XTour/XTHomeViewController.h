//
//  XTFirstViewController.h
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#include "ASIHTTPRequest.h"
#include "ASIFormDataRequest.h"
#include <CoreLocation/CoreLocation.h>
#include "XTXMLParser.h"

@interface XTHomeViewController : UIViewController <CLLocationManagerDelegate>
{
    UILabel *timerLabel;
    NSTimer *pollingTimer;
    XTDataSingleton *data;
    CLLocationManager *locationManager;
}

@property (strong, nonatomic, retain) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UILabel *phpLabel;
@property (retain, nonatomic) IBOutlet UILabel *longLabel;
@property (retain, nonatomic) IBOutlet UILabel *latLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceRateLabel;
@property (retain, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (retain, nonatomic) IBOutlet UILabel *altitudeRateLabel;
@property (retain, nonatomic) IBOutlet UILabel *elevationLabel;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (retain, nonatomic) IBOutlet UIButton *PauseButton;
@property (nonatomic) NSInteger runStatus;
- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (IBAction)getPHP:(id)sender;

@end
