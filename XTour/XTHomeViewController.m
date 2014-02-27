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
    int tm = (int)data.timer;
    NSString *currentTimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                   lround(floor(tm / 3600.)) % 100,
                                   lround(floor(tm / 60.)) % 60,
                                   lround(floor(tm)) % 60];
    _timerLabel.text = currentTimeString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [XTDataSingleton singleObj];
    data.timer = 0;
    
    //Create location manager
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 2;
    
    _runStatus = 0;
    
    NSString *userFile = [data GetDocumentFilePathForFile:@"/user.nfo" CheckIfExist:NO];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:userFile]) {
        data.loggedIn = true;
        data.userID = [[NSString alloc] initWithContentsOfFile:userFile encoding:NSUTF8StringEncoding error:nil];
    }
    
    NSString *tourImagePath = [data GetDocumentFilePathForFile:@"/tours" CheckIfExist:NO];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tourImagePath]) {[[NSFileManager defaultManager] createDirectoryAtPath:tourImagePath withIntermediateDirectories:YES attributes:nil error:nil];}
	// Do any additional setup after loading the view, typically from a nib.
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
    
    if (_runStatus == 0) {
    
    }
    else if (_runStatus == 1) {
        UIImage *img = [UIImage imageNamed:@"stop_button.png"];
        [_PauseButton setImage:img forState:UIControlStateNormal];
        [img release];
        _runStatus = 2;
    }
    else if (_runStatus == 2) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
        [self presentViewController:summary animated:YES completion:nil];
        
        _runStatus = 0;
        [data ResetAll];
    }
    else if (_runStatus == 3) {
        UIImage *img = [UIImage imageNamed:@"stop_button.png"];
        [_PauseButton setImage:img forState:UIControlStateNormal];
        [img release];
        _runStatus = 4;
    }
    else if (_runStatus == 4) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
        [self presentViewController:summary animated:YES completion:nil];
        
        _runStatus = 0;
        [data ResetAll];
    }
}

- (IBAction)startTimer:(id)sender {
    if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
    
    [_locationManager startUpdatingLocation];
    
    if (_runStatus == 0) {
        data.startTime = [NSDate date];
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
    
        NSString *userID;
        if (data.loggedIn && data.userID) {userID = data.userID;}
        else {userID = @"0000";}
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%s", [formatter stringFromDate:[NSDate date]], [userID UTF8String]];
        
        data.tourID = tourID;
        [data CreateTourDirectory];
        data.upCount++;
        
        [formatter release];
        [userID release];
        [tourID release];
    }
    else if (_runStatus == 1) {
    
    }
    else if (_runStatus == 2) {
        UIImage *img = [UIImage imageNamed:@"pause_button.png"];
        [_PauseButton setImage:img forState:UIControlStateNormal];
        [img release];
    }
    else if (_runStatus == 3) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        data.startTime = [NSDate date];
        
        data.upCount++;
        [data ResetDataForNewRun];
    }
    else if (_runStatus == 4) {
        UIImage *img = [UIImage imageNamed:@"pause_button.png"];
        [_PauseButton setImage:img forState:UIControlStateNormal];
        [img release];
        
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        data.startTime = [NSDate date];
        
        data.upCount++;
        [data ResetDataForNewRun];
    }
    
    _runStatus = 1;
}

- (IBAction)resetTimer:(id)sender {
    if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
    
    [_locationManager startUpdatingLocation];
    
    if (_runStatus == 0) {
        data.startTime = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
        
        NSString *userID;
        if (data.loggedIn && data.userID) {userID = data.userID;}
        else {userID = @"0000";}
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%s", [formatter stringFromDate:[NSDate date]], [userID UTF8String]];
        
        data.tourID = tourID;
        [data CreateTourDirectory];
        data.downCount++;
        
        [formatter release];
        [userID release];
        [tourID release];
    }
    else if (_runStatus == 1) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        data.startTime = [NSDate date];
        
        data.downCount++;
        [data ResetDataForNewRun];
    }
    else if (_runStatus == 2) {
        UIImage *img = [UIImage imageNamed:@"pause_button.png"];
        [_PauseButton setImage:img forState:UIControlStateNormal];
        [img release];
        
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        data.startTime = [NSDate date];
        
        data.downCount++;
        [data ResetDataForNewRun];
    }
    else if (_runStatus == 3) {
    
    }
    else if (_runStatus == 4) {
        UIImage *img = [UIImage imageNamed:@"pause_button.png"];
        [_PauseButton setImage:img forState:UIControlStateNormal];
        [img release];
    }
    
    _runStatus = 3;
}

- (IBAction)LoadLogin:(id)sender {
    if (!login) {login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];}
    [self presentViewController:login animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocationDegrees lon = newLocation.coordinate.longitude;
    CLLocationDegrees lat = newLocation.coordinate.latitude;
    CLLocationDistance alt = newLocation.altitude;
    
    double longitude = (double)lon;
    NSString *lonEW;
    if (longitude < 0) {lonEW = [[NSString alloc] initWithString:@"W"]; longitude = abs(longitude);}
    else {lonEW = [[NSString alloc] initWithString:@"E"];}
    
    double latitude = (double)lat;
    NSString *latNS;
    if (latitude < 0) {latNS = [[NSString alloc] initWithString:@"S"]; latitude = abs(latitude);}
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
    
    [data AddCoordinate:newLocation];
    double d = [data CalculateHaversineForCurrentCoordinate];
    double altitudeDiff = [data CalculateAltitudeDiffForCurrentCoordinate];
    if (altitudeDiff < 0) {altitudeDiff = 0;}
    [data AddDistance:d andHeight:altitudeDiff];
    
    NSString *distTotal;
    if (data.totalDistance < 0.1) {distTotal = [[NSString alloc] initWithFormat:@"%.0f m", (data.totalDistance)*1000];}
    else {distTotal = [[NSString alloc] initWithFormat:@"%.1f km", data.totalDistance];}
    NSString *altTotal = [[NSString alloc] initWithFormat:@"%.0f m", data.totalAltitude];
    
    _distanceLabel.text = distTotal;
    _altitudeLabel.text = altTotal;
    
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
