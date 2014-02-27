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

@interface XTMapViewController : UIViewController
{
    XTDataSingleton *data;
}

@property (retain, nonatomic) IBOutlet UILabel *timerLabel;
@property (retain, nonatomic) NSTimer *pollingTimer;
@property (retain, nonatomic) GMSMapView *mapView;
@property (retain, nonatomic) GMSMutablePath *path;
@property (retain, nonatomic) GMSPolyline *polyline;
@property (retain, nonatomic) GMSCameraUpdate *cameraUpdate;

@end
