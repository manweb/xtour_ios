//
//  XTFirstViewController.m
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTHomeViewController.h"

@interface XTHomeViewController ()

@end

@implementation XTHomeViewController

- (void) pollTime
{
    data.timer++;
    data.totalTime++;
    data.rateTimer++;
    int tm = (int)data.timer;
    NSString *currentTimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                   lround(floor(tm / 3600.)) % 100,
                                   lround(floor(tm / 60.)) % 60,
                                   lround(floor(tm)) % 60];
    _timerLabel.text = currentTimeString;
    
    int tm_total = (int)data.totalTime;
    NSString *currentTotalTimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                   lround(floor(tm_total / 3600.)) % 100,
                                   lround(floor(tm_total / 60.)) % 60,
                                   lround(floor(tm_total)) % 60];
    _totalTimeLabel.text = currentTotalTimeString;
    
    if (data.timer - _recoveryTimer > 120) {
        NSLog(@"Writing recovery file");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [data WriteRecoveryFile];
            _recoveryTimer = data.timer;
        });
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _timerSection.layer.cornerRadius = 12.0f;
    _distanceSection.layer.cornerRadius = 12.0f;
    _altitudeSection.layer.cornerRadius = 12.0f;
    _locationSection.layer.cornerRadius = 12.0f;
    
    [_totalTimeLabel setHidden:YES];
    [_totalDistanceLabel setHidden:YES];
    [_totalAltitudeLabel setHidden:YES];
    
    [_altitudeRateIcon setHidden:YES];
    
    data = [XTDataSingleton singleObj];
    data.timer = 0;
    
    NSLog(@"%@",[data GetDocumentFilePathForFile:@"/" CheckIfExist:NO]);
    
    //Create location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 10;
    
    _runStatus = 0;
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager requestAlwaysAuthorization];
    
    _geocoder = [[CLGeocoder alloc] init];
    _placemark = [[CLPlacemark alloc] init];
    
    _oldAccuracy = 10000.0;
    
    _recoveryTimer = 0;
    
    _didReachInitialAccuracy = false;
    
    _didRecoverTour = false;
    
    NSString *userFile = [data GetDocumentFilePathForFile:@"/user.nfo" CheckIfExist:NO];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:userFile]) {
        data.loggedIn = true;
        data.userID = [[NSString alloc] initWithContentsOfFile:userFile encoding:NSUTF8StringEncoding error:nil];
    }
    
    // Check whether the recovery file exist. If so, the app may have crashed, so re-load the data
    NSString *recoveryFile = [data GetDocumentFilePathForFile:@"/recovery.xml" CheckIfExist:YES];
    if (recoveryFile) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Recovery file found" message:@"Trying to recover last tour" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        NSLog(@"Found recovery file");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [data RecoverTour];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Tour was recovered");
                
                _didRecoverTour = true;
            });
        });
    }
    else {NSLog(@"No recovery file found");}
    
    //[data CleanUpTourDirectory];
    
    [data CreateTourDirectory];
    NSArray *tourFiles = [data GetAllGPXFiles];
    NSArray *imageFiles = [data GetAllImages];
    
    NSLog(@"GPX files: %@",tourFiles);
    NSLog(@"Image files: %@",imageFiles);
    
	// Do any additional setup after loading the view, typically from a nib.
    
    NSString *dir = [data GetDocumentFilePathForFile:@"/tours/" CheckIfExist:NO];
    NSArray *imagesInDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dir error:nil];
    NSLog(@"Content of tour directory: %@",imagesInDirectory);
    
    [_locationManager startUpdatingLocation];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_longLabel release];
    [_latLabel release];
    [_distanceLabel release];
    [_distanceRateLabel release];
    [_altitudeLabel release];
    [_altitudeRateLabel release];
    [_elevationLabel release];
    [_PauseButton release];
    [_loginButton release];
    [_pollingTimer release];
    [_locationManager release];
    [login release];
    [summary release];
    [_GPSSignal release];
    [_StartButton release];
    [_StopButton release];
    [_timerSection release];
    [_distanceSection release];
    [_altitudeSection release];
    [_locationSection release];
    [_totalDistanceLabel release];
    [_totalTimeLabel release];
    [_totalAltitudeLabel release];
    [_altitudeRateIcon release];
    [_header release];
    [_header_shadow release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)stopTimer:(id)sender {
    [_pollingTimer invalidate];
    _pollingTimer = nil;
    
    [_locationManager stopUpdatingLocation];
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:@"skier_up_button.png"] forState:UIControlStateNormal];
        [_StopButton setImage:[UIImage imageNamed:@"skier_down_button.png"] forState:UIControlStateNormal];
        [_PauseButton setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        
        _runStatus = 2;
        
        return;
    }
    
    if (_runStatus == 0) {
    
    }
    else if (_runStatus == 1) {
        [_PauseButton setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        _runStatus = 2;
    }
    else if (_runStatus == 2) {
        data.endTime = [NSDate date];
        data.TotalEndTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
        [self presentViewController:summary animated:YES completion:nil];
        
        [summary release];
        summary = nil;
        
        _runStatus = 0;
    }
    else if (_runStatus == 3) {
        [_PauseButton setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        _runStatus = 4;
    }
    else if (_runStatus == 4) {
        data.endTime = [NSDate date];
        data.TotalEndTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
        [self presentViewController:summary animated:YES completion:nil];
        
        [summary release];
        summary = nil;
        
        _runStatus = 0;
    }
    
    [_StartButton setImage:[UIImage imageNamed:@"skier_up_button.png"] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:@"skier_down_button.png"] forState:UIControlStateNormal];
    
    if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }
}

- (IBAction)startTimer:(id)sender {
    if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
    
    [_locationManager startUpdatingLocation];
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:@"skier_up_button_inactive.png"] forState:UIControlStateNormal];
        [_StopButton setImage:[UIImage imageNamed:@"skier_down_button.png"] forState:UIControlStateNormal];
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        _runStatus = 1;
        return;
    }
    
    if (_runStatus == 0) {
        data.startTime = [NSDate date];
        data.TotalStartTime = [NSDate date];
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
    
        NSString *userID;
        if (data.loggedIn && data.userID) {userID = data.userID;}
        else {userID = @"0000";}
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%s", [formatter stringFromDate:[NSDate date]], [userID UTF8String]];
        
        data.tourID = tourID;
        data.upCount++;
        
        [formatter release];
        [userID release];
        [tourID release];
    }
    else if (_runStatus == 1) {
    
    }
    else if (_runStatus == 2) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
    }
    else if (_runStatus == 3) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        data.upCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    else if (_runStatus == 4) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        data.upCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    
    [_StartButton setImage:[UIImage imageNamed:@"skier_up_button_inactive.png"] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:@"skier_down_button.png"] forState:UIControlStateNormal];
    
    _runStatus = 1;
    
    if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }
}

- (IBAction)resetTimer:(id)sender {
    if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
    
    [_locationManager startUpdatingLocation];
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:@"skier_up_button.png"] forState:UIControlStateNormal];
        [_StopButton setImage:[UIImage imageNamed:@"skier_down_button_inactive.png"] forState:UIControlStateNormal];
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        _runStatus = 3;
        return;
    }
    
    if (_runStatus == 0) {
        data.startTime = [NSDate date];
        data.TotalStartTime = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
        
        NSString *userID;
        if (data.loggedIn && data.userID) {userID = data.userID;}
        else {userID = @"0000";}
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%s", [formatter stringFromDate:[NSDate date]], [userID UTF8String]];
        
        data.tourID = tourID;
        data.downCount++;
        
        [formatter release];
        [userID release];
        [tourID release];
    }
    else if (_runStatus == 1) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        data.downCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    else if (_runStatus == 2) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        data.downCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    else if (_runStatus == 3) {
    
    }
    else if (_runStatus == 4) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
    }
    
    [_StartButton setImage:[UIImage imageNamed:@"skier_up_button.png"] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:@"skier_down_button_inactive.png"] forState:UIControlStateNormal];
    
    _runStatus = 3;
    
    if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }
}

- (IBAction)LoadLogin:(id)sender {
    if (login) {[login.view removeFromSuperview];}
    
    login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:login.view];
    [login animate];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* Location = [locations lastObject];
    CLLocationDegrees lon = Location.coordinate.longitude;
    CLLocationDegrees lat = Location.coordinate.latitude;
    CLLocationDistance alt = Location.altitude;
    
    NSLog(@"Accuracy: %.1f",Location.horizontalAccuracy);
    
    double accuracy = Location.horizontalAccuracy;
    if (accuracy != _oldAccuracy) {
        if (accuracy >= 1000.0) {[_GPSSignal setImage:[UIImage imageNamed:@"GPS_none.png"]]; if (!_didReachInitialAccuracy) {return;}}
        if (accuracy >= 100.0 && accuracy < 1000.0) {[_GPSSignal setImage:[UIImage imageNamed:@"GPS_weak.png"]]; if (!_didReachInitialAccuracy) {return;}}
        if (accuracy > 10.0 && accuracy < 100.0) {[_GPSSignal setImage:[UIImage imageNamed:@"GPS_medium.png"]]; if (!_didReachInitialAccuracy) {return;}}
        if (accuracy <= 10.0) {
            [_GPSSignal setImage:[UIImage imageNamed:@"GPS_strong.png"]];
            if (!_didReachInitialAccuracy) {
                _didReachInitialAccuracy = true;
                [_locationManager stopUpdatingLocation];
            }
        }
    }
    //else if (accuracy > 10.0 && _didReachInitialAccuracy == false) {return;}
    if (!_didReachInitialAccuracy) {return;}
    
    double longitude = (double)lon;
    NSString *lonEW;
    if (longitude < 0) {lonEW = [[NSString alloc] initWithString:@"W"]; longitude = fabs(longitude);}
    else {lonEW = [[NSString alloc] initWithString:@"E"];}
    
    double latitude = (double)lat;
    NSString *latNS;
    if (latitude < 0) {latNS = [[NSString alloc] initWithString:@"S"]; latitude = fabs(latitude);}
    else {latNS = [[NSString alloc] initWithString:@"N"];}
    
    NSString *lonString = [[NSString alloc] initWithFormat:@"%.0f°%.0f'%.1f\" %s",
                           floor(longitude),
                           floor((longitude - floor(longitude)) * 60),
                           ((longitude - floor(longitude)) * 60 - floor((longitude - floor(longitude)) * 60)) * 60, [lonEW UTF8String]];
    NSString *latString = [[NSString alloc] initWithFormat:@"%.0f°%.0f'%.1f\" %s",
                           floor(latitude),
                           floor((latitude - floor(latitude)) * 60),
                           ((latitude - floor(latitude)) * 60 - floor((latitude - floor(latitude)) * 60)) * 60, [latNS UTF8String]];
    NSString *altString = [[NSString alloc] initWithFormat:@"%.0f müm", alt];
    
    _longLabel.text = lonString;
    _latLabel.text = latString;
    _elevationLabel.text = altString;
    
    if (_runStatus == 0 || _runStatus == 2 || _runStatus == 4) {return;}
    
    if (data.StartLocation == 0) {
        data.StartLocation = Location;
        
        [_geocoder reverseGeocodeLocation:Location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                _placemark = [placemarks lastObject];
                data.country = _placemark.country;
            }
            else {
                NSLog(@"%@", error.debugDescription);
            }
        }];
    }
    NSLog(@"Calculating haversine distance...");
    [data AddCoordinate:Location];
    double d = [data CalculateHaversineForCurrentCoordinate];
    
    if (d == -1) {[data RemoveLastCoordinate]; return;}
    
    double altitudeDiff = [data CalculateAltitudeDiffForCurrentCoordinate];
    [data AddDistance:d andHeight:altitudeDiff];
    
    if (alt < data.lowestPoint) {data.lowestPoint = alt;}
    if (alt > data.highestPoint) {data.highestPoint = alt;}
    if (alt < data.sumlowestPoint) {data.sumlowestPoint = alt;}
    if (alt > data.sumhighestPoint) {data.sumhighestPoint = alt;}
    
    NSString *distTotal;
    if (data.totalDistance < 0.1) {distTotal = [[NSString alloc] initWithFormat:@"%.0f m", (data.totalDistance)*1000];}
    else {distTotal = [[NSString alloc] initWithFormat:@"%.1f km", data.totalDistance];}
    NSString *altTotal = [[NSString alloc] initWithFormat:@"%.0f m", data.totalAltitude];
    
    _distanceLabel.text = distTotal;
    _altitudeLabel.text = altTotal;
    
    _totalDistanceLabel.text = [NSString stringWithFormat:@"%.1f km",data.sumDistance];
    _totalAltitudeLabel.text = [NSString stringWithFormat:@"%.1f m",data.sumAltitude];
    
    if (data.rateTimer > 10) {
        double diffDistance = data.totalDistance - data.rateLastDistance;
        double diffAltitude = data.totalAltitude - data.rateLastAltitude;
        data.DistanceRate = diffDistance/data.rateTimer * 3600.0;
        data.AltitudeRate = diffAltitude/data.rateTimer * 3600.0;
        
        NSString *r_dist_str = [[NSString alloc] initWithFormat:@"%.1f km/h", data.DistanceRate];
        NSString *r_alt_str = [[NSString alloc] initWithFormat:@"%.1f m/h", data.AltitudeRate];
        
        _distanceRateLabel.text = r_dist_str;
        _altitudeRateLabel.text = r_alt_str;
        
        if (data.AltitudeRate > 0) {_altitudeRateIcon.image = [UIImage imageNamed:@"arrow_up@3x.png"]; [_altitudeRateIcon setHidden:NO];}
        else if (data.AltitudeRate < 0) {_altitudeRateIcon.image = [UIImage imageNamed:@"arrow_down@3x.png"]; [_altitudeRateIcon setHidden:NO];}
        else {[_altitudeLabel setHidden:YES];}
        
        data.rateTimer = 0;
        data.rateLastDistance = data.totalDistance;
        data.rateLastAltitude = data.totalAltitude;
    }
    
    NSLog(@"Haversine distance: %f", d);
    
    [lonEW release];
    [latNS release];
    [lonString release];
    [latString release];
    [altString release];
    [distTotal release];
    [altTotal release];
}

@end
