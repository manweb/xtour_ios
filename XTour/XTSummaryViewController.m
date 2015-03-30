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
    _mapView = [GMSMapView mapWithFrame:CGRectMake(0, 70, 320, 250) camera:camera];
    
    [self.view addSubview:_mapView];
    
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
        
        currentPolyline.map = _mapView;
    }
    
    NSString *TimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                   lround(floor(data.totalTime / 3600.)) % 100,
                                   lround(floor(data.totalTime / 60.)) % 60,
                                   lround(floor(data.totalTime)) % 60];
    
    [_TimeLabel setText:TimeString];
    [_AltitudeLabel setText:[NSString stringWithFormat:@"%f.1 m",data.sumAltitude]];
    [_UpLabel setText:[NSString stringWithFormat:@"%f.1 km",data.sumDistance/1000.]];
    [_DownLabel setText:[NSString stringWithFormat:@"%f.1 m",data.sumDescent]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Close {
    [data ResetDataForNewRun];
    [data CreateXMLForCategory:@"sum"];
    [data ResetAll];
    
    XTFileUploader *uploader = [[XTFileUploader alloc] init];
    [uploader UploadGPXFiles];
    [uploader UploadImages];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [_mapView release];
    [_TimeLabel release];
    [_AltitudeLabel release];
    [_UpLabel release];
    [_DownLabel release];
    [super dealloc];
}
@end
