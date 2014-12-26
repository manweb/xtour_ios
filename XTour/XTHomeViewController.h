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
#import "XTLoginViewController.h"
#import "XTSummaryViewController.h"

@interface XTHomeViewController : UIViewController <CLLocationManagerDelegate>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
    XTSummaryViewController *summary;
}

@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (retain, nonatomic) IBOutlet UILabel *longLabel;
@property (retain, nonatomic) IBOutlet UILabel *latLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceRateLabel;
@property (retain, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (retain, nonatomic) IBOutlet UILabel *altitudeRateLabel;
@property (retain, nonatomic) IBOutlet UILabel *elevationLabel;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (retain, nonatomic) CLGeocoder *geocoder;
@property (retain, nonatomic) CLPlacemark *placemark;
@property (retain, nonatomic) IBOutlet UIButton *PauseButton;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIImageView *GPSSignal;
@property (retain, nonatomic) NSTimer *pollingTimer;
@property (nonatomic) NSInteger runStatus;
@property (nonatomic) double oldAccuracy;
- (IBAction)startTimer:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (IBAction)LoadLogin:(id)sender;

@end
