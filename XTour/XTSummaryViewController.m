//
//  XTSummaryViewController.m
//  XTour
//
//  Created by Manuel Weber on 25/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTSummaryViewController.h"

@interface XTSummaryViewController ()

@end

@implementation XTSummaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [XTDataSingleton singleObj];
    
    XTTourInfo *tourInfo = [[XTTourInfo alloc] init];
    tourInfo.tourID = data.tourID;
    tourInfo.userID = data.userID;
    tourInfo.profilePicture = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
    tourInfo.date = [data.TotalStartTime timeIntervalSince1970];
    tourInfo.userName = @"";
    tourInfo.longitude = data.StartLocation.coordinate.longitude;
    tourInfo.latitude = data.StartLocation.coordinate.latitude;
    tourInfo.distance = data.sumDistance;
    tourInfo.altitude = data.sumAltitude;
    tourInfo.descent = data.sumDescent;
    tourInfo.highestPoint = data.sumhighestPoint;
    tourInfo.lowestPoint = data.sumlowestPoint;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    XTTourDetailView *detailView = [[XTTourDetailView alloc] initWithFrame:CGRectMake(0, 70, width, height-70-tabBarHeight)];
    detailView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    [self.view addSubview:detailView];
    
    [detailView Initialize:tourInfo fromServer:NO];
    
    [detailView LoadTourDetail:tourInfo fromServer:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Close {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data CreateXMLForCategory:@"sum"];
        [data WriteImageInfo];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [data ResetAll];
            
            XTFileUploader *uploader = [[XTFileUploader alloc] init];
            [uploader UploadGPXFiles];
            [uploader UploadImages];
            [uploader UploadImageInfo];
        });
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [_TimeLabel release];
    [_AltitudeLabel release];
    [_UpLabel release];
    [_DownLabel release];
    [_scrollView release];
    [_TimeIcon release];
    [_DistanceIcon release];
    [_UpIcon release];
    [_DownIcon release];
    [_mapViewContainer release];
    [_summaryViewContainer release];
    [_imageViewContainer release];
    [super dealloc];
}
@end
