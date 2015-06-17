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

@interface XTMapViewController : UIViewController <UIActionSheetDelegate, GMSMapViewDelegate>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
}

@property (retain, nonatomic) IBOutlet UIView *header;
@property (retain, nonatomic) IBOutlet UIView *header_shadow;
@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (retain, nonatomic) NSTimer *pollingTimer;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIButton *centerButton;
@property (retain, nonatomic) GMSMapView *mapView;
@property (retain, nonatomic) GMSMutablePath *path;
@property (retain, nonatomic) GMSPolyline *polyline;
@property (retain, nonatomic) GMSCameraUpdate *cameraUpdate;
@property (nonatomic) bool mapHasMoved;

- (void)LoadLogin:(id)sender;
- (void)ShowLoginOptions:(id)sender;
- (void)LoginViewDidClose:(id)sender;
- (IBAction)centerMap:(id)sender;

@end
