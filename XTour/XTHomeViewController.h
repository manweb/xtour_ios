//
//  XTFirstViewController.h
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#include <CoreLocation/CoreLocation.h>
#include "XTXMLParser.h"
#import "XTLoginViewController.h"
#import "XTSummaryViewController.h"
#import "XTBackgroundTaskManager.h"
#import "XTNavigationViewContainer.h"
#import "XTProfileViewController.h"
#import "XTNotificationViewController.h"
#import "XTPointingNotificationView.h"

@interface XTHomeViewController : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, CLLocationManagerDelegate>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
    XTSummaryViewController *summary;
}

@property (retain, nonatomic) IBOutlet UIView *header;
@property (retain, nonatomic) IBOutlet UIView *header_shadow;
@property (retain, nonatomic) IBOutlet UIView *timerSection;
@property (retain, nonatomic) IBOutlet UIView *distanceSection;
@property (retain, nonatomic) IBOutlet UIView *altitudeSection;
@property (retain, nonatomic) IBOutlet UIView *locationSection;
@property (retain, nonatomic) IBOutlet UIView *distanceSectionSeparator;
@property (retain, nonatomic) IBOutlet UIView *altitudeSectionSeparator;
@property (retain, nonatomic) IBOutlet UIImageView *timerIcon;
@property (retain, nonatomic) IBOutlet UIImageView *distanceIcon;
@property (retain, nonatomic) IBOutlet UIImageView *altitudeIcon;
@property (retain, nonatomic) IBOutlet UIImageView *locationIcon;
@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (retain, nonatomic) IBOutlet UILabel *longLabel;
@property (retain, nonatomic) IBOutlet UILabel *latLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UILabel *distanceRateLabel;
@property (retain, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (retain, nonatomic) IBOutlet UILabel *altitudeRateLabel;
@property (retain, nonatomic) IBOutlet UILabel *elevationLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalDistanceLabel;
@property (retain, nonatomic) IBOutlet UILabel *totalAltitudeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *altitudeRateIcon;
@property (retain, nonatomic) UILabel *GPSSignalLabel;
@property (retain, nonatomic) CLGeocoder *geocoder;
@property (retain, nonatomic) CLPlacemark *placemark;
@property (retain, nonatomic) IBOutlet UIButton *StartButton;
@property (retain, nonatomic) IBOutlet UIButton *StopButton;
@property (retain, nonatomic) IBOutlet UIButton *PauseButton;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIImageView *GPSSignal;
@property (retain, nonatomic) NSTimer *pollingTimer;
@property (retain, nonatomic) NSTimer *locationStartTimer;
@property (retain, nonatomic) NSTimer *locationStopTimer;
@property (nonatomic) NSInteger runStatus;
@property (nonatomic) double oldAccuracy;
@property (nonatomic) NSInteger recoveryTimer;
@property (nonatomic) bool didReachInitialAccuracy;
@property (nonatomic) bool didRecoverTour;
@property (nonatomic) bool writeRecoveryFile;
@property (retain, nonatomic) CLLocation *bestLocation;
@property (retain, nonatomic) XTBackgroundTaskManager *backgroundTaskManager;
@property (retain, nonatomic) NSString *up_button_icon;
@property (retain, nonatomic) NSString *down_button_icon;
@property (retain, nonatomic) UIView *warningNotification;

- (IBAction)startUpTour:(id)sender;
- (IBAction)startDownTour:(id)sender;
- (IBAction)pauseTour:(id)sender;
- (void)startLocationUpdate;
- (void)stopLocationUpdate:(bool)saveLocation;
- (void)stopLocationUpdate;
- (void)LoadLogin:(id)sender;
- (void)ShowLoginOptions:(id)sender;
- (void)LoginViewDidClose:(id)sender;
- (void)UpdateDisplayWithLocation:(CLLocation*)location;
- (void)SaveCurrentLocation:(CLLocation*)location;
- (void)ResetTour;
- (void)FinishTour:(bool)batteryIsLow;

@end
