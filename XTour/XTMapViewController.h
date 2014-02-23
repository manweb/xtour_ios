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
    GMSMapView *mapView;
    XTDataSingleton *singleTimer;
    NSTimer *pollingTimer;
}

@property (strong, nonatomic) IBOutlet UILabel *timerLabel;

@end
