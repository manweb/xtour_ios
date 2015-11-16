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
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    _width = screenBound.size.width;
    _height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    data = [XTDataSingleton singleObj];
    _pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _header.frame = CGRectMake(0, 0, _width, 69);
    _header_shadow.frame = CGRectMake(0, 69, _width, 1);
    
    _loginButton.frame = CGRectMake(_width-50, 25, 40, 40);
    
    double zoom = 10.0;
    if (data.runStatus != 0) {zoom = 15.0;}
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:zoom];
    _mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    //_mapView.myLocationEnabled = YES;
    
    //[_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
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
    _centerButton.frame = CGRectMake(_width/2-60, _height-tabBarHeight-40, 120, 30);
    
    _addWarningBackground = [[UIView alloc] initWithFrame:CGRectMake(_width-50, 80, 40, 40)];
    
    _addWarningBackground.backgroundColor = [UIColor colorWithRed:80.0f/255.0f green:80.0f/255.0f blue:80.0f/255.0f alpha:0.6];
    _addWarningBackground.layer.cornerRadius = 5.0f;
    
    _addWarningButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 30, 30)];
    
    [_addWarningButton setImage:[UIImage imageNamed:@"add_warning_icon@3x.png"] forState:UIControlStateNormal];
    [_addWarningButton addTarget:self action:@selector(AddWarning:) forControlEvents:UIControlEventTouchUpInside];
    
    _addWarningText = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 250, 30)];
    
    _addWarningText.text = @"Klicke auf die Karte für midestens 2s um eine Gefahrenstelle zu markieren.";
    _addWarningText.textColor = [UIColor whiteColor];
    _addWarningText.font = [UIFont fontWithName:@"Helvetica" size:12];
    _addWarningText.contentInset = UIEdgeInsetsMake(-8, 0, 0, 0);
    _addWarningText.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    
    _editWarningText = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 250, 100)];
    
    _editWarningText.alpha = 1.0;
    _editWarningText.layer.borderWidth = 1.0f;
    _editWarningText.layer.borderColor = [[UIColor whiteColor] CGColor];
    _editWarningText.layer.cornerRadius = 5.0f;
    _editWarningText.textColor = [UIColor whiteColor];
    _editWarningText.font = [UIFont fontWithName:@"Helvetica" size:12];
    _editWarningText.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.0f];
    
    _enterWarning = [[UIButton alloc] initWithFrame:CGRectMake(_width-55, 75, 30, 30)];
    
    [_enterWarning setImage:[UIImage imageNamed:@"check_icon@3x.png"] forState:UIControlStateNormal];
    [_enterWarning addTarget:self action:@selector(EnterWarning:) forControlEvents:UIControlEventTouchUpInside];
    
    [_editWarningText setHidden:YES];
    
    [_addWarningText setHidden:YES];
    
    [_enterWarning setHidden:YES];
    
    [_addWarningBackground addSubview:_addWarningButton];
    [_addWarningBackground addSubview:_addWarningText];
    [_addWarningBackground addSubview:_editWarningText];
    [_addWarningBackground addSubview:_enterWarning];
    [self.view addSubview:_addWarningBackground];
    
    _addWarning = false;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:nil];
    
    [self LoginViewDidClose:nil];
    
    for (int i = 0; i < [data GetNumImages]; i++) {
        if ([data GetImageLongitudeAt:i] && [data GetImageLatitudeAt:i]) {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake([data GetImageLatitudeAt:i], [data GetImageLongitudeAt:i]);
            
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.icon = [UIImage imageNamed:@"ski_pole_camera@3x.png"];
            marker.map = _mapView;
        }
    }
    
    _mapView.myLocationEnabled = YES;
    
    [_mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context:NULL];
    
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

- (void) viewWillDisappear:(BOOL)animated
{
    _mapView.myLocationEnabled = NO;
    
    @try {
        [_mapView removeObserver:self forKeyPath:@"myLocation" context:NULL];
    }
    @catch (id exception) {
        
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    @try {
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    CGFloat currentZoom = _mapView.camera.zoom;
    GMSVisibleRegion visibleRegion = _mapView.projection.visibleRegion;
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
    }
    @catch (id exception) {
        
    }
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
    if (!_addWarning) {return;}
    
    if (!warningInfo) {warningInfo = [[XTWarningsInfo alloc] init];}
    
    [warningInfo ClearData];
    
    warningInfo.userID = data.userID;
    warningInfo.tourID = data.tourID;
    warningInfo.userName = data.userInfo.userName;
    warningInfo.submitDate = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    warningInfo.longitude = coordinate.longitude;
    warningInfo.latitude = coordinate.latitude;
    
    [self ShowEditWarning];
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
    [_addWarningBackground release];
    [_addWarningText release];
    [_addWarningButton release];
    [_editWarningText release];
    [_enterWarning release];
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
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Du bist eingelogged als %@",data.userInfo.userName] delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Ausloggen" otherButtonTitles:@"Profil anzeigen", nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Ausloggen"]) {[data Logout];}
    else if ([buttonTitle isEqualToString:@"Profil anzeigen"]) {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        float width = screenBound.size.width;
        float height = screenBound.size.height;
        
        XTProfileViewController *profile = [[XTProfileViewController alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        
        [profile initialize];
        
        XTNavigationViewContainer *navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil view:profile title:data.userInfo.userName isFirstView:YES];
        
        [self.view addSubview:navigationView.view];
        
        [navigationView ShowView];
        
        [profile release];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginViewDismissed" object:nil userInfo:nil];
}

- (void) LoginViewDidClose:(id)sender
{
    [_loginButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(ShowLoginOptions:) forControlEvents:UIControlEventTouchUpInside];
        
        [img release];
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

- (void)AddWarning:(id)sender {
    if (!_addWarning) {
        [self ShowAddWarning];
    }
    else {
        [self HideAddWarning];
    }
}

- (void) EnterWarning:(id)sender {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(warningInfo.latitude, warningInfo.longitude);
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coordinate;
    marker.title = [NSString stringWithFormat:@"Gefahrenstelle bei Koordinate: %.5f %.5f",coordinate.longitude,coordinate.latitude];
    marker.icon = [UIImage imageNamed:@"ski_pole_warning@3x.png"];
    marker.groundAnchor = CGPointMake(0.88, 1.0);
    marker.map = _mapView;
    
    warningInfo.comment = _editWarningText.text;
    
    [data AddWarningInfo:warningInfo];
    
    if (!request) {request = [[XTServerRequestHandler alloc] init];}
    
    [request SubmitWarningInfo:warningInfo];
    
    [self HideAddWarning];
}

- (void) ShowAddWarning
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _addWarningBackground.frame = CGRectMake(10, 80, _width-20, 40);
        _addWarningButton.frame = CGRectMake(_width-55, 5, 30, 30);
        [_addWarningButton setImage:[UIImage imageNamed:@"cancel_icon@3x.png"] forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            [_addWarningText setHidden:NO];
        } completion:nil];
    }];
    
    _addWarning = true;
}

- (void) HideAddWarning
{
    [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        [_addWarningText setHidden:YES];
        [_editWarningText setHidden:YES];
        [_enterWarning setHidden:YES];
        [_editWarningText resignFirstResponder];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            _addWarningBackground.frame = CGRectMake(_width-50, 80, 40, 40);
            _addWarningButton.frame = CGRectMake(5, 5, 30, 30);
            [_addWarningButton setImage:[UIImage imageNamed:@"add_warning_icon@3x.png"] forState:UIControlStateNormal];
        } completion:nil];
    }];
    
    _addWarning = false;
}

- (void) ShowEditWarning
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _addWarningBackground.frame = CGRectMake(10, 80, _width-20, 110);
        [_addWarningText setHidden:YES];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
            [_enterWarning setHidden:NO];
            [_editWarningText setHidden:NO];
            [_editWarningText becomeFirstResponder];
        } completion:nil];
    }];
}

@end
