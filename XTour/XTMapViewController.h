//
//  XTSecondViewController.h
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "XTDataSingleton.h"
#import "XTLoginViewController.h"

@interface XTMapViewController : UIViewController
{
    XTDataSingleton *data;
    XTLoginViewController *login;
}

@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (retain, nonatomic) NSTimer *pollingTimer;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) GMSMapView *mapView;
@property (retain, nonatomic) GMSMutablePath *path;
@property (retain, nonatomic) GMSPolyline *polyline;
@property (retain, nonatomic) GMSCameraUpdate *cameraUpdate;

- (IBAction)LoadLogin:(id)sender;

@end
