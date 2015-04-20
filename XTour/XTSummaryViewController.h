//
//  XTSummaryViewController.h
//  XTour
//
//  Created by Manuel Weber on 25/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTFileUploader.h"
#import "GoogleMaps/GoogleMaps.h"
#import "XTXMLParser.h"

@interface XTSummaryViewController : UIViewController
{
    XTDataSingleton *data;
    GMSMapView *mapView;
}

- (IBAction)Close;
- (IBAction)Back:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *TimeLabel;
@property (retain, nonatomic) IBOutlet UILabel *AltitudeLabel;
@property (retain, nonatomic) IBOutlet UILabel *UpLabel;
@property (retain, nonatomic) IBOutlet UILabel *DownLabel;

@end
