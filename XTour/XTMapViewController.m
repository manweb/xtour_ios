//
//  XTSecondViewController.m
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTMapViewController.h"

@interface XTMapViewController ()

@end

@implementation XTMapViewController

- (void)pollTime {
    int tm = (int)data.timer;
    NSString *currentTimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                   lround(floor(tm / 3600.)) % 100,
                                   lround(floor(tm / 60.)) % 60,
                                   lround(floor(tm)) % 60];
    
    NSString *currentDistanceString = [NSString stringWithFormat:@"%.1f km", data.totalDistance];
    _timerLabel.text = currentTimeString;
    _distanceLabel.text = currentDistanceString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [XTDataSingleton singleObj];
    _pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:6];
    _mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    _mapView.myLocationEnabled = YES;
    
    [_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.view insertSubview:_mapView atIndex:0];
    
    _path = [[GMSMutablePath alloc] init];
    _polyline = [[GMSPolyline alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    }
    
    /*if ([data GetNumCoordinates] < 2) {return;}
    
    NSArray *bounds = [data GetCoordinateBounds];
    CLLocation *corner1 = [bounds objectAtIndex:0];
    CLLocation *corner2 = [bounds objectAtIndex:1];
    CLLocationCoordinate2D c1 = CLLocationCoordinate2DMake(corner1.coordinate.latitude, corner1.coordinate.longitude);
    CLLocationCoordinate2D c2 = CLLocationCoordinate2DMake(corner2.coordinate.latitude, corner2.coordinate.longitude);
    
    [_path removeAllCoordinates];
    for (int i = 0; i < [data GetNumCoordinates]; i++) {
        CLLocation *location = [data GetCoordinatesAtIndex:i];
        [_path addCoordinate:location.coordinate];
    }
    
    [_polyline setPath:_path];
    _polyline.strokeColor = [UIColor blueColor];
    _polyline.strokeWidth = 5.f;
    _polyline.map = _mapView;
    
    _cameraUpdate = [GMSCameraUpdate fitBounds:[[GMSCoordinateBounds alloc] initWithCoordinate:c1 coordinate:c2] withPadding:100.0f];
    
    [_mapView moveCamera:_cameraUpdate];
    
    [bounds release];
    [corner1 release];
    [corner2 release];*/
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    CGFloat currentZoom = _mapView.camera.zoom;
    GMSVisibleRegion visibleRegion = _mapView.projection.visibleRegion;
    GMSCoordinateBounds *currentBounds = [[GMSCoordinateBounds alloc] initWithRegion:visibleRegion];
    if ([currentBounds containsCoordinate:[location coordinate]]) {[currentBounds release]; return;}
    
    _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:currentZoom];
    
    if ([data GetNumCoordinates] < 2) {return;}
    
    [_path removeAllCoordinates];
    for (int i = 0; i < [data GetNumCoordinates]; i++) {
        CLLocation *location = [data GetCoordinatesAtIndex:i];
        [_path addCoordinate:location.coordinate];
    }
    
    [_polyline setPath:_path];
    _polyline.strokeColor = [UIColor blueColor];
    _polyline.strokeWidth = 5.f;
    _polyline.map = _mapView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_mapView removeObserver:self forKeyPath:@"myLocation" context:NULL];
    
    [_timerLabel release];
    [_pollingTimer release];
    [_mapView release];
    [_path release];
    [_polyline release];
    [_cameraUpdate release];
    [_distanceLabel release];
    [_loginButton release];
    [_distanceLabel release];
    [super dealloc];
}

- (IBAction)LoadLogin:(id)sender {
    if (!login) {login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];}
    [self presentViewController:login animated:YES completion:nil];
    
    [login release];
    login = nil;
}

@end
