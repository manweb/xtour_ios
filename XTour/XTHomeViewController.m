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

+ (CLLocationManager *)sharedLocationManager {
    static CLLocationManager *_locationManager;
    
    @synchronized(self) {
        if (_locationManager == nil) {
            _locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        }
    }
    return _locationManager;
}

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
    
    if (data.timer - _recoveryTimer > 120 && _writeRecoveryFile) {
        NSLog(@"Writing recovery file");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [data WriteRecoveryFile];
            _recoveryTimer = data.timer;
        });
    }
}

- (void) startLocationUpdate
{
    NSLog(@"Starting location service");
    
    if (_locationStartTimer) {
        [_locationStartTimer invalidate];
        _locationStartTimer = nil;
    }
    
    //Create location manager
    CLLocationManager *locationManager = [XTHomeViewController sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10;
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager setAllowsBackgroundLocationUpdates:YES];
    
    [locationManager startUpdatingLocation];
}

- (void) stopLocationUpdate:(bool)saveLocation
{
    NSLog(@"Stopping location service");
    
    if (_locationStopTimer) {
        [_locationStopTimer invalidate];
        _locationStopTimer = nil;
    }
    
    //Create location manager
    CLLocationManager *locationManager = [XTHomeViewController sharedLocationManager];
    
    [locationManager stopUpdatingLocation];
    
    if (!saveLocation) {return;}
    
    [self UpdateDisplayWithLocation:_bestLocation];
    
    if (_oldAccuracy < 300) {[self SaveCurrentLocation:_bestLocation];}
    
    _oldAccuracy = 10000.0;
}

- (void) stopLocationUpdate
{
    [self stopLocationUpdate:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    double dy = 10;
    double yOffset = 10;
    double _timerSectionHeight = 80.0;
    double _sectionHeight = 60.0;
    double iconScale = 1.0;
    
    // iPhone 4
    if (height == 480) {
        dy = 3;
        yOffset = 73;
        _timerSectionHeight = 80.0;
        _sectionHeight = 60.0;
        iconScale = 1.0;
    }
    
    // iPhone 5
    if (height == 568) {
        dy = 20;
        yOffset = 80;
        _timerSectionHeight = 80.0;
        _sectionHeight = 60.0;
        iconScale = 1.0;
    }
    
    // iPhone 6
    if (height == 667) {
        dy = 20;
        yOffset = 80;
        _timerSectionHeight = 100.0;
        _sectionHeight = 80.0;
        iconScale = 1.2;
    }
    
    // iPhone 6 Plus
    if (height == 736) {
        dy = 20;
        yOffset = 80;
        _timerSectionHeight = 80.0;
        _sectionHeight = 60.0;
        iconScale = 1.0;
    }
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _header.frame = CGRectMake(0, 0, width, 69);
    _header_shadow.frame = CGRectMake(0, 69, width, 1);
    
    _loginButton.frame = CGRectMake(width-50, 25, 40, 40);
    
    _timerSection.frame = CGRectMake(10, yOffset, width-20, _timerSectionHeight);
    
    yOffset += _timerSectionHeight + dy;
    
    _distanceSection.frame = CGRectMake(10, yOffset, width-20, _sectionHeight);
    
    yOffset += _sectionHeight + dy;
    
    _altitudeSection.frame = CGRectMake(10, yOffset, width-20, _sectionHeight);
    
    yOffset += _sectionHeight + dy;
    
    _locationSection.frame = CGRectMake(10, yOffset, width-20, _sectionHeight);
    
    yOffset += _sectionHeight + dy;
    
    _StartButton.frame = CGRectMake(20, yOffset, iconScale*80, iconScale*80);
    _PauseButton.frame = CGRectMake(width/2-iconScale*20, yOffset+iconScale*20, iconScale*40, iconScale*40);
    _StopButton.frame = CGRectMake(width-iconScale*100, yOffset, iconScale*80, iconScale*80);
    
    _timerIcon.frame = CGRectMake(5, (_timerSectionHeight-iconScale*60)/2, iconScale*60, iconScale*60);
    _distanceIcon.frame = CGRectMake(10, (_sectionHeight-iconScale*40)/2, iconScale*40, iconScale*40);
    _altitudeIcon.frame = CGRectMake(10, (_sectionHeight-iconScale*40)/2, iconScale*40, iconScale*40);
    _locationIcon.frame = CGRectMake(10, (_sectionHeight-iconScale*40)/2, iconScale*40, iconScale*40);
    
    _distanceSectionSeparator.frame = CGRectMake((width-20)/2, 5, 2, _sectionHeight-10);
    _altitudeSectionSeparator.frame = CGRectMake((width-20)/2, 5, 2, _sectionHeight-10);
    
    _timerSection.layer.cornerRadius = 12.0f;
    _distanceSection.layer.cornerRadius = 12.0f;
    _altitudeSection.layer.cornerRadius = 12.0f;
    _locationSection.layer.cornerRadius = 12.0f;
    
    UIColor *boxBorderColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    _timerSection.layer.borderWidth = 1.0f;
    _distanceSection.layer.borderWidth = 1.0f;
    _altitudeSection.layer.borderWidth = 1.0f;
    _locationSection.layer.borderWidth = 1.0f;
    
    _timerSection.layer.borderColor = boxBorderColor.CGColor;
    _distanceSection.layer.borderColor = boxBorderColor.CGColor;
    _altitudeSection.layer.borderColor = boxBorderColor.CGColor;
    _locationSection.layer.borderColor = boxBorderColor.CGColor;
    
    _timerLabel.frame = CGRectMake(iconScale*85, _timerSectionHeight/2-iconScale*30, width-25-iconScale*85, iconScale*60);
    _timerLabel.font = [UIFont fontWithName:@"Helvetica" size:35*iconScale];
    
    _distanceLabel.frame = CGRectMake(iconScale*65, _sectionHeight/2-iconScale*10, width/2-70, iconScale*20);
    _distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _distanceRateLabel.frame = CGRectMake(width/2+iconScale*10, _sectionHeight/2-iconScale*10, width/2-15-iconScale*10, iconScale*20);
    _distanceRateLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _altitudeLabel.frame = CGRectMake(iconScale*65, _sectionHeight/2-iconScale*10, width/2-70, iconScale*20);
    _altitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _altitudeRateLabel.frame = CGRectMake(width/2+iconScale*10, _sectionHeight/2-iconScale*10, width/2-15-iconScale*10, iconScale*20);
    _altitudeRateLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _longLabel.frame = CGRectMake(iconScale*65-10, _sectionHeight/2-iconScale*15-5, width/2-iconScale*65+25, iconScale*15);
    _longLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _latLabel.frame = CGRectMake(iconScale*65-10, _sectionHeight/2+5, width/2-iconScale*65+25, iconScale*15);
    _latLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _elevationLabel.frame = CGRectMake(width/2, _sectionHeight/2-iconScale*10, width/2-35, iconScale*20);
    _elevationLabel.font = [UIFont fontWithName:@"Helvetica" size:16*iconScale];
    
    _totalTimeLabel.frame = CGRectMake(width-30-width/3, _timerSectionHeight-iconScale*20, width/3, iconScale*20);
    _totalTimeLabel.font = [UIFont fontWithName:@"Helvetica" size:12*iconScale];
    
    _totalDistanceLabel.frame = CGRectMake(width/4, _sectionHeight-iconScale*20, width/2-20-width/4, iconScale*20);
    _totalDistanceLabel.font = [UIFont fontWithName:@"Helvetica" size:12*iconScale];
    
    _totalAltitudeLabel.frame = CGRectMake(width/4, _sectionHeight-iconScale*20, width/2-20-width/4, iconScale*20);
    _totalAltitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:12*iconScale];
    
    [_totalTimeLabel setHidden:YES];
    [_totalDistanceLabel setHidden:YES];
    [_totalAltitudeLabel setHidden:YES];
    
    _GPSSignalLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 200, 20)];
    
    _GPSSignalLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    _GPSSignalLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _GPSSignalLabel.text = @"Suche GPS Signal...";
    
    [_GPSSignal setHidden:NO];
    
    [_altitudeRateIcon setHidden:YES];
    
    [_longLabel setHidden:YES];
    [_latLabel setHidden:YES];
    [_elevationLabel setHidden:YES];
    
    [_locationSection addSubview:_GPSSignalLabel];
    
    data = [XTDataSingleton singleObj];
    data.timer = 0;
    
    NSLog(@"%@",[data GetDocumentFilePathForFile:@"/" CheckIfExist:NO]);
    
    data.runStatus = 0;
    
    _bestLocation = nil;
    
    _locationStartTimer = nil;
    _locationStopTimer = nil;
    
    _geocoder = [[CLGeocoder alloc] init];
    _placemark = [[CLPlacemark alloc] init];
    
    _oldAccuracy = 10000.0;
    
    _recoveryTimer = 0;
    
    _didReachInitialAccuracy = false;
    
    _didRecoverTour = false;
    _writeRecoveryFile = false;
    
    [data CheckLogin];
    
    // Check whether the recovery file exist. If so, the app may have crashed, so re-load the data
    NSString *recoveryFile = [data GetDocumentFilePathForFile:@"/recovery.xml" CheckIfExist:YES];
    if (recoveryFile && _writeRecoveryFile) {
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
    
    [data GetUserSettings];
    
    [self startLocationUpdate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    /*NSString *tourDirectory = [data GetDocumentFilePathForFile:@"/" CheckIfExist:NO];
    NSArray *content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tourDirectory error:nil];
    
    for (int i = 0; i < [content count]; i++) {
        NSString *file = [NSString stringWithFormat:@"%@/%@", tourDirectory, [content objectAtIndex:i]];
        if ([[file pathExtension] isEqualToString:@"txt"]) {
            NSLog(@"Background session task: %@",file);
            
            [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
        }
    }*/
    
    if ([data GetNumberOfFilesInTourDirectory] > 0) {
        
        XTFileUploader *uploader = [[XTFileUploader alloc] init];
        
        [uploader UploadGPXFiles];
        [uploader UploadImages];
        [uploader UploadImageInfo];
        
        XTNotificationViewController *notification = [[XTNotificationViewController alloc] init];
        
        //[[UIApplication sharedApplication].keyWindow addSubview:notification.view];
        
        [self.view addSubview:notification.view];
        
        notification.messageView.text = @"Einige Touren-Daten wurden noch nicht auf den Server hochgeladen. Versuche es jetzt nochmals.";
        
        notification.delayTime = 2.0f;
        notification.displayTime = 10.0f;
        
        [notification ShowView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [_timerSection release];
    [_distanceSection release];
    [_altitudeSection release];
    [_locationSection release];
    [_timerLabel release];
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
    [_GPSSignalLabel release];
    [_geocoder release];
    [_placemark release];
    [_pollingTimer release];
    [_distanceSectionSeparator release];
    [_altitudeSectionSeparator release];
    [_timerIcon release];
    [_distanceIcon release];
    [_altitudeIcon release];
    [_locationIcon release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self LoginViewDidClose:nil];
    
    if (data.runStatus == 5) {[self ResetTour];}
    
    NSString *up_icon;
    NSString *down_icon;
    
    switch (data.profileSettings.equipment) {
        case 0:
            if (data.runStatus == 1) {up_icon = @"skier_up_button_inactive.png";}
            else {up_icon = @"skier_up_button.png";}
            if (data.runStatus == 3) {down_icon = @"skier_down_button_inactive.png";}
            else {down_icon = @"skier_down_button.png";}
            _up_button_icon = @"skier";
            _down_button_icon = @"skier";
            break;
        case 1:
            if (data.runStatus == 1) {up_icon = @"snowboarder_up_button_inactive.png";}
            else {up_icon = @"snowboarder_up_button.png";}
            if (data.runStatus == 3) {down_icon = @"snowboarder_down_button_inactive.png";}
            else {down_icon = @"snowboarder_down_button.png";}
            _up_button_icon = @"snowboarder";
            _down_button_icon = @"snowboarder";
            break;
        case 2:
            if (data.runStatus == 1) {up_icon = @"skier_up_button_inactive.png";}
            else {up_icon = @"skier_up_button.png";}
            if (data.runStatus == 3) {down_icon = @"snowboarder_down_button_inactive.png";}
            else {down_icon = @"snowboarder_down_button.png";}
            _up_button_icon = @"skier";
            _down_button_icon = @"snowboarder";
            break;
            
    }
    
    [_StartButton setImage:[UIImage imageNamed:up_icon] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:down_icon] forState:UIControlStateNormal];
}

- (void)applicationEnterBackground
{
    //Create location manager
    /*CLLocationManager *locationManager = [XTHomeViewController sharedLocationManager];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10;
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager startUpdatingLocation];*/
    
    /*self.backgroundTaskManager = [XTBackgroundTaskManager sharedBackgroundTaskManager];
    [self.backgroundTaskManager beginNewBackgroundTask];*/
}

- (void)applicationEnterForeground
{
    
}

- (IBAction)pauseTour:(id)sender {
    [_pollingTimer invalidate];
    _pollingTimer = nil;
    
    [self stopLocationUpdate:NO];
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
        [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
        [_PauseButton setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        
        data.runStatus = 2;
        
        return;
    }
    
    if (data.runStatus == 0) {
    
    }
    else if (data.runStatus == 1) {
        [_PauseButton setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        data.runStatus = 2;
    }
    else if (data.runStatus == 2) {
        data.endTime = [NSDate date];
        data.TotalEndTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
        [self presentViewController:summary animated:YES completion:nil];
        
        [summary release];
        summary = nil;
    }
    else if (data.runStatus == 3) {
        [_PauseButton setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateNormal];
        data.runStatus = 4;
    }
    else if (data.runStatus == 4) {
        data.endTime = [NSDate date];
        data.TotalEndTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
        [self presentViewController:summary animated:YES completion:nil];
        
        [summary release];
        summary = nil;
    }
    
    [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
    
    if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }
}

- (IBAction)startUpTour:(id)sender {
    if (_didReachInitialAccuracy && data.loggedIn) {
        if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
    }
    
    [self startLocationUpdate];
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button_inactive.png",_up_button_icon]] forState:UIControlStateNormal];
        [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.runStatus = 1;
        return;
    }
    
    if (data.runStatus == 0) {
        if (!data.loggedIn) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Du musst dich einloggen um eine Tour zu starten. Klicke auf das Profil-Icon." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
            return;
        }
        
        if (!_didReachInitialAccuracy) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Achtung" message:@"Das GPS Signal ist noch etwas schwach. Möchtest du die Tour trotzdem starten?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
            
            [alert show];
            [alert release];
            
            data.runStatus = 1;
            
            return;
        }
        data.startTime = [NSDate date];
        data.TotalStartTime = [NSDate date];
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%@", [formatter stringFromDate:[NSDate date]], data.userID];
        
        data.tourID = tourID;
        data.upCount++;
        
        [formatter release];
        [tourID release];
    }
    else if (data.runStatus == 1) {
    
    }
    else if (data.runStatus == 2) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
    }
    else if (data.runStatus == 3) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        data.upCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    else if (data.runStatus == 4) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"down"];
        
        data.upCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    
    [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button_inactive.png",_up_button_icon]] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button.png",_down_button_icon]] forState:UIControlStateNormal];
    
    data.runStatus = 1;
    
    if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }
}

- (IBAction)startDownTour:(id)sender {
    if (_didReachInitialAccuracy && data.loggedIn) {
        if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
    }
    
    [self startLocationUpdate];
    
    if (_didRecoverTour) {
        _didRecoverTour = false;
        
        [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
        [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button_inactive.png",_down_button_icon]] forState:UIControlStateNormal];
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.runStatus = 3;
        return;
    }
    
    if (data.runStatus == 0) {
        if (!data.loggedIn) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Du musst dich einloggen um eine Tour zu starten. Klicke auf das Profil-Icon." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
            return;
        }
        
        if (!_didReachInitialAccuracy) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Achtung" message:@"Das GPS Signal ist noch etwas schwach. Möchtest du die Tour trotzdem starten?" delegate:self cancelButtonTitle:@"Nein" otherButtonTitles:@"Ja", nil];
            
            [alert show];
            [alert release];
            
            data.runStatus = 3;
            
            return;
        }
        data.startTime = [NSDate date];
        data.TotalStartTime = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%@", [formatter stringFromDate:[NSDate date]], data.userID];
        
        data.tourID = tourID;
        data.downCount++;
        
        [formatter release];
        [tourID release];
    }
    else if (data.runStatus == 1) {
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        data.downCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    else if (data.runStatus == 2) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
        
        data.endTime = [NSDate date];
        [data CreateXMLForCategory:@"up"];
        
        data.downCount++;
        [data ResetDataForNewRun];
        data.startTime = [NSDate date];
    }
    else if (data.runStatus == 3) {
    
    }
    else if (data.runStatus == 4) {
        [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
    }
    
    [_StartButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_up_button.png",_up_button_icon]] forState:UIControlStateNormal];
    [_StopButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_down_button_inactive.png",_down_button_icon]] forState:UIControlStateNormal];
    
    data.runStatus = 3;
    
    if (data.upCount > 0 && data.downCount > 0 && [_totalTimeLabel isHidden]) {
        [_totalTimeLabel setHidden:NO];
        [_totalDistanceLabel setHidden:NO];
        [_totalAltitudeLabel setHidden:NO];
    }
}

- (void) FinishTour:(bool)batteryIsLow
{
    [_pollingTimer invalidate];
    _pollingTimer = nil;
    
    [self stopLocationUpdate:NO];
    
    if (data.runStatus == 0 || data.runStatus == 5) {return;}
    
    NSString *tourType = @"up";
    
    switch (data.runStatus) {
        case 1:
            tourType = @"up";
            break;
        case 2:
            tourType = @"up";
            break;
        case 3:
            tourType = @"down";
            break;
        case 4:
            tourType = @"down";
            break;
    }
    
    data.endTime = [NSDate date];
    data.TotalEndTime = [NSDate date];
    [data CreateXMLForCategory:tourType];
    
    data.lowBatteryLevel = batteryIsLow;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [data CreateXMLForCategory:@"sum"];
        [data WriteImageInfo];
        
        data.runStatus = 5;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [data ResetAll];
            
            XTFileUploader *uploader = [[XTFileUploader alloc] init];
            [uploader UploadGPXFiles];
            [uploader UploadImages];
            [uploader UploadImageInfo];
        });
    });
}

- (void) UpdateDisplayWithLocation:(CLLocation*)location
{
    if (!location) {return;}
    
    CLLocationDegrees lon = location.coordinate.longitude;
    CLLocationDegrees lat = location.coordinate.latitude;
    CLLocationDistance alt = location.altitude;
    
    double longitude = (double)lon;
    NSString *lonEW;
    if (longitude < 0) {lonEW = @"W"; longitude = fabs(longitude);}
    else {lonEW = @"E";}
    
    double latitude = (double)lat;
    NSString *latNS;
    if (latitude < 0) {latNS = @"S"; latitude = fabs(latitude);}
    else {latNS = @"N";}
    
    NSString *lonString = [NSString stringWithFormat:@"%.0f°%.0f'%.1f\" %s",
                           floor(longitude),
                           floor((longitude - floor(longitude)) * 60),
                           ((longitude - floor(longitude)) * 60 - floor((longitude - floor(longitude)) * 60)) * 60, [lonEW UTF8String]];
    NSString *latString = [NSString stringWithFormat:@"%.0f°%.0f'%.1f\" %s",
                           floor(latitude),
                           floor((latitude - floor(latitude)) * 60),
                           ((latitude - floor(latitude)) * 60 - floor((latitude - floor(latitude)) * 60)) * 60, [latNS UTF8String]];
    NSString *altString = [NSString stringWithFormat:@"%.0f müm", alt];
    
    _longLabel.text = lonString;
    _latLabel.text = latString;
    _elevationLabel.text = altString;
    
    NSString *distTotal;
    if (data.totalDistance < 0.1) {distTotal = [NSString stringWithFormat:@"%.0f m", (data.totalDistance)*1000];}
    else {distTotal = [NSString stringWithFormat:@"%.1f km", data.totalDistance];}
    
    NSString *altTotal;
    if (data.runStatus == 1) {
        altTotal = [NSString stringWithFormat:@"%.0f m", data.totalCumulativeAltitude];
    }
    else {
        altTotal = [NSString stringWithFormat:@"%.0f m", data.totalCumulativeDescent];
    }
    
    _distanceLabel.text = distTotal;
    _altitudeLabel.text = altTotal;
    
    _totalDistanceLabel.text = [NSString stringWithFormat:@"%.1f km",data.sumDistance];
    _totalAltitudeLabel.text = [NSString stringWithFormat:@"%.1f m",data.sumCumulativeAltitude];
    
    if (data.rateTimer > 10) {
        double diffDistance = data.totalDistance - data.rateLastDistance;
        double diffAltitude = data.totalAltitude - data.rateLastAltitude;
        data.DistanceRate = diffDistance/data.rateTimer * 3600.0;
        data.AltitudeRate = diffAltitude/data.rateTimer * 3600.0;
        
        NSString *r_dist_str = [NSString stringWithFormat:@"%.1f km/h", data.DistanceRate];
        NSString *r_alt_str = [NSString stringWithFormat:@"%.1f m/h", data.AltitudeRate];
        
        _distanceRateLabel.text = r_dist_str;
        _altitudeRateLabel.text = r_alt_str;
        
        if (data.AltitudeRate > 0) {_altitudeRateIcon.image = [UIImage imageNamed:@"arrow_up@3x.png"]; [_altitudeRateIcon setHidden:NO];}
        else if (data.AltitudeRate < 0) {_altitudeRateIcon.image = [UIImage imageNamed:@"arrow_down@3x.png"]; [_altitudeRateIcon setHidden:NO];}
        else {[_altitudeRateIcon setHidden:YES];}
        
        data.rateTimer = 0;
        data.rateLastDistance = data.totalDistance;
        data.rateLastAltitude = data.totalAltitude;
    }
    
    [lonEW release];
    [latNS release];
    [distTotal release];
    [altTotal release];
}

- (void) SaveCurrentLocation:(CLLocation*)location
{
    if (!location) {return;}
    
    CLLocationDistance alt = location.altitude;
    
    if (data.StartLocation == 0) {
        data.StartLocation = location;
        
        [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if (error == nil && [placemarks count] > 0) {
                _placemark = [placemarks lastObject];
                data.country = _placemark.country;
                data.province = _placemark.administrativeArea;
            }
            else {
                NSLog(@"%@", error.debugDescription);
            }
        }];
    }
    NSLog(@"Calculating haversine distance...");
    [data AddCoordinate:location];
    double d = [data CalculateHaversineForCurrentCoordinate];
    
    double altitudeDiff = [data CalculateAltitudeDiffForCurrentCoordinate];
    [data AddDistance:d andHeight:altitudeDiff];
    
    UIDevice *device = [UIDevice currentDevice];
    [device setBatteryMonitoringEnabled:YES];
    float level = [device batteryLevel];
    
    [data.batteryLevel addObject:[NSNumber numberWithFloat:level]];
    
    if (alt < data.lowestPoint.altitude) {data.lowestPoint = location;}
    if (alt > data.highestPoint.altitude) {data.highestPoint = location;}
    if (alt < data.sumlowestPoint.altitude) {data.sumlowestPoint = location;}
    if (alt > data.sumhighestPoint.altitude) {data.sumhighestPoint = location;}
    
    NSLog(@"Haversine distance: %f", d);
    
    if (level < 0.2 && data.profileSettings.safetyModus) {
        [self FinishTour:YES];
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        
        [notification setAlertAction:@"Launch"];
        [notification setAlertBody:@"\U0001F50B Die Battery ist unter 20% gefallen. Die GPS-Aufzeichnung wurde gestoppt und die Tour beendet."];
        [notification setHasAction:YES];
        notification.applicationIconBadgeNumber = 1;
        notification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        [notification release];
    }
}

- (void) SetBackgroundTimer
{
    self.backgroundTaskManager = [XTBackgroundTaskManager sharedBackgroundTaskManager];
    [self.backgroundTaskManager beginNewBackgroundTask];
    
    if (!_locationStartTimer) {_locationStartTimer = [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(startLocationUpdate) userInfo:nil repeats:NO];}
    
    if (!_locationStopTimer) {_locationStopTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(stopLocationUpdate) userInfo:nil repeats:NO];}
}

- (void) ResetTour
{
    _timerLabel.text = @"00h 00m 00s";
    _distanceLabel.text = @"-- km";
    _altitudeLabel.text = @"-- m";
    _distanceRateLabel.text = @"-- km/h";
    _altitudeRateLabel.text = @"-- m/h";
    
    [_PauseButton setImage:[UIImage imageNamed:@"pause_button.png"] forState:UIControlStateNormal];
    
    [_totalTimeLabel setHidden:YES];
    [_totalDistanceLabel setHidden:YES];
    [_totalAltitudeLabel setHidden:YES];
    
    data.runStatus = 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _didReachInitialAccuracy = true;
        
        if (!_pollingTimer) {_pollingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(pollTime) userInfo:nil repeats:YES];}
        
        data.startTime = [NSDate date];
        data.TotalStartTime = [NSDate date];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyLLddHHmmss"];
        
        NSString *tourID = [[NSString alloc] initWithFormat:@"%@%@", [formatter stringFromDate:[NSDate date]], data.userID];
        
        data.tourID = tourID;
        
        if (data.runStatus == 1) {
            data.upCount++;
            
            [_StartButton setImage:[UIImage imageNamed:@"skier_up_button_inactive.png"] forState:UIControlStateNormal];
        }
        else {
            data.downCount++;
            
            [_StopButton setImage:[UIImage imageNamed:@"skier_down_button_inactive.png"] forState:UIControlStateNormal];
        }
        
        [formatter release];
        [tourID release];
        
        [_GPSSignalLabel setHidden:YES];
        
        [_longLabel setHidden:NO];
        [_latLabel setHidden:NO];
        [_elevationLabel setHidden:NO];
        
        if (data.profileSettings.batterySafeMode) {[self SetBackgroundTimer];}
    }
    else {data.runStatus = 0;}
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* Location = [locations lastObject];
    
    data.CurrentLocation = Location;
    
    NSLog(@"Accuracy: %.1f",Location.horizontalAccuracy);
    
    double accuracy = Location.horizontalAccuracy;
    
    if (accuracy < _oldAccuracy) {self.bestLocation = Location; self.oldAccuracy = accuracy;}
    
    if (accuracy >= 1000.0) {[_GPSSignal setImage:[UIImage imageNamed:@"GPS_none.png"]]; if (!_didReachInitialAccuracy) {return;}}
    if (accuracy >= 100.0 && accuracy < 1000.0) {[_GPSSignal setImage:[UIImage imageNamed:@"GPS_weak.png"]]; if (!_didReachInitialAccuracy) {return;}}
    if (accuracy > 10.0 && accuracy < 100.0) {[_GPSSignal setImage:[UIImage imageNamed:@"GPS_medium.png"]]; if (!_didReachInitialAccuracy) {return;}}
    if (accuracy <= 10.0) {
        [_GPSSignal setImage:[UIImage imageNamed:@"GPS_strong.png"]];
        if (!_didReachInitialAccuracy) {
            _didReachInitialAccuracy = true;
            [self stopLocationUpdate:NO];
            
            [_GPSSignalLabel setHidden:YES];
            
            [_longLabel setHidden:NO];
            [_latLabel setHidden:NO];
            [_elevationLabel setHidden:NO];
            
            [self UpdateDisplayWithLocation:Location];
            
            return;
        }
    }
    
    if (data.runStatus == 0 || data.runStatus == 2 || data.runStatus == 4) {return;}
    
    if (data.profileSettings.batterySafeMode) {
        if (_locationStartTimer) {return;}
        
        [self SetBackgroundTimer];
    }
    else {
        [self UpdateDisplayWithLocation:Location];
        
        if (accuracy < 300) {[self SaveCurrentLocation:Location];}
    }
}

@end
