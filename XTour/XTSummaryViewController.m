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
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:6];
    if (!mapView) {mapView = [GMSMapView mapWithFrame:CGRectMake(5, 5, 300, 240) camera:camera];}
    
    //[self.view addSubview:mapView];
    
    NSMutableArray *GPXFiles = [data GetGPXFilesForCurrentTour];
    
    XTXMLParser *xml = [[XTXMLParser alloc] init];
    GMSMutablePath *currentPath = [[GMSMutablePath alloc] init];
    NSMutableArray *polylines = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [GPXFiles count]; i++) {
        NSString *currentFile = [GPXFiles objectAtIndex:i];
        
        [xml ReadGPXFile:currentFile];
        
        NSMutableArray *locationData = [xml GetLocationDataFromFile];
        [currentPath removeAllCoordinates];
        
        for (int k = 0; k < [locationData count]; k++) {
            CLLocation *location = [locationData objectAtIndex:k];
            [currentPath addCoordinate:location.coordinate];
        }
        
        GMSPolyline *polyline = [[GMSPolyline alloc] init];
        [polyline setPath:currentPath];
        if ([currentFile containsString:@"up"]) {polyline.strokeColor = [UIColor blueColor];}
        else {polyline.strokeColor = [UIColor redColor];}
        polyline.strokeWidth = 5.f;
        
        [polylines addObject:polyline];
    }
    
    for (int i = 0; i < [GPXFiles count]; i++) {
        GMSPolyline *currentPolyline = [polylines objectAtIndex:i];
        
        currentPolyline.map = mapView;
    }
    
    if ([data GetNumCoordinates] < 2) {
        NSMutableArray *bounds = [data GetCoordinateBounds];
        CLLocation *corner1 = [bounds objectAtIndex:0];
        CLLocation *corner2 = [bounds objectAtIndex:1];
        CLLocationCoordinate2D c1 = CLLocationCoordinate2DMake(corner1.coordinate.latitude, corner1.coordinate.longitude);
        CLLocationCoordinate2D c2 = CLLocationCoordinate2DMake(corner2.coordinate.latitude, corner2.coordinate.longitude);
        GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:[[GMSCoordinateBounds alloc]initWithCoordinate:c1 coordinate:c2] withPadding:50.0f];
        [mapView moveCamera:cameraUpdate];
    }
    
    _scrollView.contentSize = CGSizeMake(320, 586);
    _scrollView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    _mapViewContainer = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 250)];
    _summaryViewContainer = [[UIView alloc] initWithFrame:CGRectMake(5, 260, 310, 116)];
    _imageViewContainer = [[UIView alloc] initWithFrame:CGRectMake(5, 381, 310, 200)];
    
    _mapViewContainer.backgroundColor = [UIColor whiteColor];
    _summaryViewContainer.backgroundColor = [UIColor whiteColor];
    _imageViewContainer.backgroundColor = [UIColor whiteColor];
    
    _mapViewContainer.layer.cornerRadius = 5.0f;
    _summaryViewContainer.layer.cornerRadius = 5.0f;
    _imageViewContainer.layer.cornerRadius = 5.0f;
    
    _TimeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 40, 40)];
    _DistanceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(160, 8, 40, 40)];
    _UpIcon = [[UIImageView alloc] initWithFrame:CGRectMake(8, 68, 40, 40)];
    _DownIcon = [[UIImageView alloc] initWithFrame:CGRectMake(160, 68, 40, 40)];
    
    _TimeIcon.image = [UIImage imageNamed:@"clock_icon.png"];
    _DistanceIcon.image = [UIImage imageNamed:@"distance_icon.png"];
    _UpIcon.image = [UIImage imageNamed:@"skier_up_icon_2.png"];
    _DownIcon.image = [UIImage imageNamed:@"skier_down_icon_2.png"];
    
    NSString *TimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                   lround(floor(data.totalTime / 3600.)) % 100,
                                   lround(floor(data.totalTime / 60.)) % 60,
                                   lround(floor(data.totalTime)) % 60];
    
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 17, 94, 21)];
    _AltitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(207, 17, 94, 21)];
    _UpLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 77, 94, 21)];
    _DownLabel = [[UILabel alloc] initWithFrame:CGRectMake(207, 77, 94, 21)];
    
    _TimeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _AltitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _UpLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _DownLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    
    [_TimeLabel setText:TimeString];
    [_AltitudeLabel setText:[NSString stringWithFormat:@"%.1f km",data.sumDistance]];
    [_UpLabel setText:[NSString stringWithFormat:@"%.1f m",data.sumAltitude]];
    [_DownLabel setText:[NSString stringWithFormat:@"%.1f m",data.sumDescent]];
    
    [_mapViewContainer addSubview:mapView];
    [_summaryViewContainer addSubview:_TimeIcon];
    [_summaryViewContainer addSubview:_DistanceIcon];
    [_summaryViewContainer addSubview:_UpIcon];
    [_summaryViewContainer addSubview:_DownIcon];
    [_summaryViewContainer addSubview:_TimeLabel];
    [_summaryViewContainer addSubview:_AltitudeLabel];
    [_summaryViewContainer addSubview:_UpLabel];
    [_summaryViewContainer addSubview:_DownLabel];
    
    [_scrollView addSubview:_mapViewContainer];
    [_scrollView addSubview:_summaryViewContainer];
    [_scrollView addSubview:_imageViewContainer];
    // Do any additional setup after loading the view from its nib.
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
