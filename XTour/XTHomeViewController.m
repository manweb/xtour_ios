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

@synthesize timerLabel;
@synthesize locationManager;
@synthesize runStatus;
@synthesize PauseButton;

int timer = 0;
bool running = false;

- (void) pollTime
{
    data.timer++;
    int tm = (int)data.timer;
    NSString *currentTimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                                   lround(floor(tm / 3600.)) % 100,
                                   lround(floor(tm / 60.)) % 60,
                                   lround(floor(tm)) % 60];
    self.timerLabel.text = currentTimeString;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data = [XTDataSingleton singleObj];
    data.timer = 0;
    
    //Create location manager
    self.locationManager = [[[CLLocationManager alloc] init] autorelease];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 2;
    
    runStatus = 0;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setTimerLabel:nil];
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
    [super dealloc];
    [pollingTimer invalidate];
    pollingTimer = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stopTimer:(id)sender {
    [pollingTimer invalidate];
    pollingTimer = nil;
    running = false;
    
    if (runStatus == 2) {
        [data SetEndTime:[NSDate date]];
        [data Finalize];
        runStatus = 0;
    }
    else if (runStatus == 1) {
        UIImage *img = [UIImage imageNamed:@"stop_button.png"];
        [PauseButton setImage:img forState:UIControlStateNormal];
        [img release];
        runStatus = 2;
    }
}

- (IBAction)startTimer:(id)sender {
    [pollingTimer invalidate];
    pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
    [locationManager startUpdatingLocation];
    running = true;
    
    switch (runStatus) {
        case 0: {
            [data SetStartTime:[NSDate date]];
        }
        case 1: {
            
        }
        case 2: {
            UIImage *img = [UIImage imageNamed:@"pause_button.png"];
            [PauseButton setImage:img forState:UIControlStateNormal];
            [img release];
        }
    }
    
    runStatus = 1;
}

- (IBAction)resetTimer:(id)sender {
    [pollingTimer invalidate];
    
    data.timer = 0;
    if (running) {
        pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];
    }
    else {
        self.timerLabel.text = @"00h 00m 00s";
    }
}

- (IBAction)getPHP:(id)sender {
    /*NSURL *url = [NSURL URLWithString:@"http://www.cheisacher.ch/testRequest.php"];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"It works!" forKey:@"text"];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        self.phpLabel.text = response;
    }
    else {self.phpLabel.text = @"Error";}*/
    
    XTXMLParser *xml = [[XTXMLParser alloc] init];
    [xml TestXML];
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
    
    self.longLabel.text = lonString;
    self.latLabel.text = latString;
    self.elevationLabel.text = altString;
    
    [data AddCoordinate:newLocation];
    double d = [data CalculateHaversineForCurrentCoordinate];
    
    NSLog(@"Haversine distance: %f", d);
}

@end
