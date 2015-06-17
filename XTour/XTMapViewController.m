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
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:10];
    _mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    _mapView.myLocationEnabled = YES;
    
    [_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.view insertSubview:_mapView atIndex:0];
    [_mapView setDelegate:self];
    
    _path = [[GMSMutablePath alloc] init];
    _polyline = [[GMSPolyline alloc] init];
    
    [_polyline setPath:_path];
    _polyline.strokeColor = [UIColor blueColor];
    _polyline.strokeWidth = 5.f;
    _polyline.map = _mapView;
    
    _mapHasMoved = false;
    
    [_centerButton setHidden:YES];
    _centerButton.backgroundColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:0.6];
    _centerButton.layer.cornerRadius = 5.0f;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self LoginViewDidClose:nil];
    
    for (int i = 0; i < [data GetNumImages]; i++) {
        if ([data GetImageLongitudeAt:i] && [data GetImageLatitudeAt:i]) {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([data GetImageLatitudeAt:i], [data GetImageLongitudeAt:i]);
            
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.icon = [UIImage imageNamed:@"camera_marker@2x.png"];
            marker.map = _mapView;
        }
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
    if (!_mapHasMoved) {
        _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:currentZoom];
    }
    
    NSUInteger coordinateSize = [[data GetCoordinatesForCurrentRun] count];
    NSUInteger pathSize = [_path count];
    
    if (coordinateSize < 2) {return;}
    
    if (pathSize > coordinateSize) {
        [_path removeAllCoordinates];
        pathSize = 0;
    }
    
    if (!(coordinateSize > pathSize)) {return;}
    
    // Add new coordinates to the path
    NSUInteger i;
    NSMutableArray *locations = [data GetCoordinatesForCurrentRun];
    for (i = pathSize; i < coordinateSize; i++) {
        CLLocation * location = [locations objectAtIndex:i];
        [_path addCoordinate:location.coordinate];
    }
    
    /*[_path removeAllCoordinates];
    NSMutableArray *locations = [data GetCoordinatesForCurrentRun];
    for (int i = 0; i < [locations count]; i++) {
        CLLocation *location = [locations objectAtIndex:i];
        [_path addCoordinate:location.coordinate];
    }*/
    
    [_polyline setPath:_path];
    /*_polyline.strokeColor = [UIColor blueColor];
    _polyline.strokeWidth = 5.f;
    _polyline.map = _mapView;*/
    
    [currentBounds release];
    return;
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    if (gesture) {
        _mapHasMoved = true;
        [_centerButton setHidden:NO];
    }
}

- (void) mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.title = [NSString stringWithFormat:@"Gefahrenstelle bei Koordinate: %.5f %.5f",coordinate.longitude,coordinate.latitude];
    marker.icon = [UIImage imageNamed:@"ski_pole_camera@3x.png"];
    marker.groundAnchor = CGPointMake(0.88, 1.0);
    marker.map = _mapView;
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
    [_centerButton release];
    [_header release];
    [_header_shadow release];
    [super dealloc];
}

- (void)LoadLogin:(id)sender {
    if (login) {[login.view removeFromSuperview];}
    
    login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewDidClose:) name:@"LoginViewDismissed" object:nil];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:login.view];
    [login animate];
}

- (void)ShowLoginOptions:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewDidClose:) name:@"LoginViewDismissed" object:nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Du bist eingelogged!" delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Ausloggen" otherButtonTitles:@"Profil anzeigen", nil];
    
    [actionSheet showInView:self.view];
}

- (void) LoginViewDidClose:(id)sender
{
    [_loginButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(ShowLoginOptions:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(LoadLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (IBAction)centerMap:(id)sender {
    _mapHasMoved = false;
    [_centerButton setHidden:YES];
}

@end
