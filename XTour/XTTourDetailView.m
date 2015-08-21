//
//  XTTourDetailView.m
//  XTour
//
//  Created by Manuel Weber on 02/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTTourDetailView.h"

@implementation XTTourDetailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) Initialize:(XTTourInfo *) tourInfo fromServer:(BOOL)server withOffset:(NSInteger)offset andContentOffset:(NSInteger)offsetContent
{
    _viewOffset = 0;
    if (offset) {_viewOffset = offset;}
    
    _viewContentOffset = 0;
    if (offsetContent) {_viewContentOffset = offsetContent;}
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    float boxWidth = width - 20;
    float boxRadius = 5.f;
    float boxBorderWidth = 1.0f;
    float boxMarginLeft = 10.0f;
    float boxMarginTop = 75.0f;
    UIColor *boxBorderColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    float boxYPosition = 5;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:6];
    if (!mapView) {mapView = [GMSMapView mapWithFrame:CGRectMake(5, 5, boxWidth - 10, 240) camera:camera];}
    
    _summaryViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, 140)];
    
    boxYPosition += 145;
    
    _mapViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, 250)];
    
    boxYPosition += 255;
    
    if (server) {
        _graphViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, width/320*200+10)];
        
        boxYPosition += width/320*200+15;
    }
    
    _imageViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, 200)];
    
    boxYPosition += 205;
    
    _descriptionViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+boxYPosition, boxWidth, 200)];
    
    boxYPosition += 205;
    
    _mapViewContainer.backgroundColor = [UIColor whiteColor];
    _summaryViewContainer.backgroundColor = [UIColor whiteColor];
    _imageViewContainer.backgroundColor = [UIColor whiteColor];
    _descriptionViewContainer.backgroundColor = [UIColor whiteColor];
    _graphViewContainer.backgroundColor = [UIColor whiteColor];
    
    _mapViewContainer.layer.cornerRadius = boxRadius;
    _summaryViewContainer.layer.cornerRadius = boxRadius;
    _imageViewContainer.layer.cornerRadius = boxRadius;
    _descriptionViewContainer.layer.cornerRadius = boxRadius;
    _graphViewContainer.layer.cornerRadius = boxRadius;
    
    _mapViewContainer.layer.borderWidth = boxBorderWidth;
    _summaryViewContainer.layer.borderWidth = boxBorderWidth;
    _imageViewContainer.layer.borderWidth = boxBorderWidth;
    _descriptionViewContainer.layer.borderWidth = boxBorderWidth;
    _graphViewContainer.layer.borderWidth = boxBorderWidth;
    
    _mapViewContainer.layer.borderColor = boxBorderColor.CGColor;
    _summaryViewContainer.layer.borderColor = boxBorderColor.CGColor;
    _imageViewContainer.layer.borderColor = boxBorderColor.CGColor;
    _descriptionViewContainer.layer.borderColor = boxBorderColor.CGColor;
    _graphViewContainer.layer.borderColor = boxBorderColor.CGColor;
    
    /*NSString *TimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
     lround(floor(data.totalTime / 3600.)) % 100,
     lround(floor(data.totalTime / 60.)) % 60,
     lround(floor(data.totalTime)) % 60];*/
    
    _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
    
    if (server) {
    [_profilePicture setImageWithURL:[NSURL URLWithString:tourInfo.profilePicture] placeholderImage:[UIImage imageNamed:@"profile_icon_gray.png"]];
    }
    else {
        _profilePicture.image = [UIImage imageNamed:tourInfo.profilePicture];
    }
    
    float labelX1 = 5;
    float labelX2 = (boxWidth-10)/3;
    float labelX3 = (boxWidth-10)*2/3;
    
    _TimeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 17, 94, 21)];
    _DistanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 58, 100, 15)];
    _SpeedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 58, 100, 15)];
    _UpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 58, 100, 15)];
    _DownTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 100, 100, 15)];
    _HighestPointTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 100, 100, 15)];
    _LowestPointTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 100, 100, 15)];
    
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(boxWidth/3-10, 15, boxWidth*2/3-10, 30)];
    _DistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 72, 100, 20)];
    _SpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 72, 100, 20)];
    _UpLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 72, 100, 20)];
    _DownLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX1, 114, 100, 20)];
    _HighestPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX2, 114, 100, 20)];
    _LowestPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX3, 114, 100, 20)];
    
    _TimeTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _DistanceTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _SpeedTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _UpTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _DownTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _HighestPointTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _LowestPointTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    
    _TimeLabel.textAlignment = NSTextAlignmentRight;
    
    _TimeTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _DistanceTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _SpeedTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _UpTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _DownTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _HighestPointTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _LowestPointTitleLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    
    _TimeLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*32.0f];
    _DistanceLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _SpeedLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _UpLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _DownLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _HighestPointLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    _LowestPointLabel.font = [UIFont fontWithName:@"Helvetica" size:width/320*16.0f];
    
    _TimeTitleLabel.text = @"Time";
    _DistanceTitleLabel.text = @"Distanz";
    _SpeedTitleLabel.text = @"Geschwindigkeit";
    _UpTitleLabel.text = @"Aufstieg";
    _DownTitleLabel.text = @"Abfahrt";
    _HighestPointTitleLabel.text = @"Höchster Punkt";
    _LowestPointTitleLabel.text = @"Tiefster Punkt";
    
    NSUInteger tm = tourInfo.totalTime;
    
    NSString *TimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                            lround(floor(tm / 3600.)) % 100,
                            lround(floor(tm / 60.)) % 60,
                            lround(floor(tm)) % 60];
    
    float distance = tourInfo.distance;
    float time = (float)tourInfo.totalTime/3600.0;
    float speed = distance/time;
    
    NSString *distanceUnit = @"km";
    NSString *speedUnit = @"km/h";
    
    if (distance < 10.0) {
        distance *= 1000.0;
        distanceUnit = @"m";
    }
    
    if (speed < 10.0) {
        speed *= 1000.0;
        speedUnit = @"m/h";
    }
    
    _TimeLabel.text = TimeString;
    _DistanceLabel.text = [NSString stringWithFormat:@"%.1f %@", distance, distanceUnit];
    _SpeedLabel.text = [NSString stringWithFormat:@"%.1f %@", speed, speedUnit];
    _UpLabel.text = [NSString stringWithFormat:@"%.1f m", tourInfo.altitude];
    _DownLabel.text = [NSString stringWithFormat:@"%.1f m", tourInfo.descent];
    _HighestPointLabel.text = [NSString stringWithFormat:@"%.1f m", tourInfo.highestPoint];
    _LowestPointLabel.text = [NSString stringWithFormat:@"%.1f m", tourInfo.lowestPoint];
    
    _descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, boxWidth-10, 190)];
    
    _descriptionView.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _descriptionView.font = [UIFont fontWithName:@"Helvetica" size:16];
    
    _hasDescription = false;
    if ([tourInfo.tourDescription isEqualToString:@""] && server) {_descriptionView.text = @"Keine Bechreibung zu dieser Tour vorhanden.";}
    else if ([tourInfo.tourDescription isEqualToString:@""]) {_descriptionView.text = @"Kurze Beschreibung zur Tour";}
    else {_descriptionView.text = tourInfo.tourDescription; _hasDescription = true;}
    
    if (server) {_descriptionView.editable = NO;}
    else {_descriptionView.editable = YES;}
    
    /*[_TimeLabel setText:TimeString];
     [_AltitudeLabel setText:[NSString stringWithFormat:@"%.1f km",data.sumDistance]];
     [_UpLabel setText:[NSString stringWithFormat:@"%.1f m",data.sumAltitude]];
     [_DownLabel setText:[NSString stringWithFormat:@"%.1f m",data.sumDescent]];*/
    
    _loadingView = [[UIView alloc] initWithFrame:CGRectMake(105, 75, 100, 100)];
    _loadingView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.6];
    _loadingView.layer.cornerRadius = 10.0f;
    
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityView.frame = CGRectMake(20, 20, 60, 60);
    [_activityView startAnimating];
    
    [_loadingView addSubview:_activityView];
    
    [_mapViewContainer addSubview:mapView];
    [_mapViewContainer addSubview:_loadingView];
    [_summaryViewContainer addSubview:_profilePicture];
    //[_summaryViewContainer addSubview:_TimeTitleLabel];
    [_summaryViewContainer addSubview:_DistanceTitleLabel];
    [_summaryViewContainer addSubview:_SpeedTitleLabel];
    [_summaryViewContainer addSubview:_UpTitleLabel];
    [_summaryViewContainer addSubview:_DownTitleLabel];
    [_summaryViewContainer addSubview:_HighestPointTitleLabel];
    [_summaryViewContainer addSubview:_LowestPointTitleLabel];
    [_summaryViewContainer addSubview:_TimeLabel];
    [_summaryViewContainer addSubview:_DistanceLabel];
    [_summaryViewContainer addSubview:_SpeedLabel];
    [_summaryViewContainer addSubview:_UpLabel];
    [_summaryViewContainer addSubview:_DownLabel];
    [_summaryViewContainer addSubview:_HighestPointLabel];
    [_summaryViewContainer addSubview:_LowestPointLabel];
    [_descriptionViewContainer addSubview:_descriptionView];
    
    [self addSubview:_mapViewContainer];
    [self addSubview:_summaryViewContainer];
    [self addSubview:_imageViewContainer];
    [self addSubview:_descriptionViewContainer];
    if (server) {[self addSubview:_graphViewContainer];}
    
    if (server) {self.contentSize = CGSizeMake(width, _viewOffset+boxYPosition+_viewContentOffset);}
    else {self.contentSize = CGSizeMake(width, _viewOffset+boxYPosition);}
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)dealloc {
    [_coordinateArray release];
    [_tourImages release];
    [_tourFiles release];
    [_loadingView release];
    [_activityView release];
    [_mapViewContainer release];
    [_summaryViewContainer release];
    [_imageViewContainer release];
    [_descriptionViewContainer release];
    [_graphViewContainer release];
    [_descriptionView release];
    [_profilePicture release];
    [_TimeTitleLabel release];
    [_DistanceTitleLabel release];
    [_SpeedTitleLabel release];
    [_UpTitleLabel release];
    [_DownTitleLabel release];
    [_HighestPointTitleLabel release];
    [_LowestPointTitleLabel release];
    [_UpRateTitleLabel release];
    [_DownRateTitleLabel release];
    [_TimeLabel release];
    [_DistanceLabel release];
    [_SpeedLabel release];
    [_UpLabel release];
    [_DownLabel release];
    [_HighestPointLabel release];
    [_LowestPointLabel release];
    [_UpRateLabel release];
    [_DownRateLabel release];
    [super dealloc];
}

- (void) LoadTourDetail:(XTTourInfo *) tourInfo fromServer:(BOOL) server
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float boxWidth = width - 20;
    
    _coordinateArray = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (server) {
            XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
            NSMutableArray *tourFilesUp = [request GetTourFilesForTour:tourInfo.tourID andType:@"up"];
            NSMutableArray *tourFilesDown = [request GetTourFilesForTour:tourInfo.tourID andType:@"down"];
            _tourFiles = [tourFilesUp mutableCopy];
            [_tourFiles addObjectsFromArray:tourFilesDown];
            
            for (int i = 0; i < [_tourFiles count]; i++) {
                NSString *currentFile = [_tourFiles objectAtIndex:i];
                
                NSMutableArray *currentCoordinates = [request GetCoordinatesForFile:currentFile];
                [_coordinateArray addObject:currentCoordinates];
            }
            
            _tourImages = [request GetImagesForTour:tourInfo.tourID];
            
            [request CheckGraphsForTour:tourInfo.tourID];
        }
        else {
            data = [XTDataSingleton singleObj];
            
            _tourFiles = [data GetGPXFilesForCurrentTour];
            
            XTXMLParser *xml = [[[XTXMLParser alloc] init] autorelease];
            
            for (int i = 0; i < [_tourFiles count]; i++) {
                NSString *currentFile = [_tourFiles objectAtIndex:i];
                
                [xml ReadGPXFile:currentFile];
                
                NSMutableArray *locationData = [xml GetLocationDataFromFile];
                [_coordinateArray addObject:locationData];
            }
            
            _tourImages = data.imageInfo;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            float minLon = 1e6;
            float maxLon = -1e6;
            float minLat = 1e6;
            float maxLat = -1e6;
            
            GMSMutablePath *currentPath = [[GMSMutablePath alloc] init];
            NSMutableArray *polylines = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < [_coordinateArray count]; i++) {
                [currentPath removeAllCoordinates];
                
                NSMutableArray *coordinate = [_coordinateArray objectAtIndex:i];
                
                for (int k = 0; k < [coordinate count]; k++) {
                    CLLocation *location = [coordinate objectAtIndex:k];
                    [currentPath addCoordinate:location.coordinate];
                    
                    if (location.coordinate.longitude < minLon) {minLon = location.coordinate.longitude;}
                    if (location.coordinate.longitude > maxLon) {maxLon = location.coordinate.longitude;}
                    if (location.coordinate.latitude < minLat) {minLat = location.coordinate.latitude;}
                    if (location.coordinate.latitude > maxLat) {maxLat = location.coordinate.latitude;}
                }
                
                GMSPolyline *polyline = [[GMSPolyline alloc] init];
                [polyline setPath:currentPath];
                if ([[_tourFiles objectAtIndex:i] containsString:@"up"]) {polyline.strokeColor = [UIColor blueColor];}
                else {polyline.strokeColor = [UIColor redColor];}
                polyline.strokeWidth = 5.f;
                
                [polylines addObject:polyline];
                GMSPolyline *currentPolyline = [polylines objectAtIndex:i];
                
                currentPolyline.map = mapView;
            }
            
            GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate fitBounds:[[GMSCoordinateBounds alloc]initWithCoordinate:CLLocationCoordinate2DMake(minLat, minLon) coordinate:CLLocationCoordinate2DMake(maxLat, maxLon)] withPadding:50.0f];
            [mapView moveCamera:cameraUpdate];
            
            [_loadingView removeFromSuperview];
            
            XTSummaryImageViewController *imageView = [[XTSummaryImageViewController alloc] initWithNibName:nil bundle:nil];
            
            imageView.view.frame = CGRectMake(0, 0, boxWidth, 200);
            imageView.images = _tourImages;
            
            [_imageViewContainer addSubview:imageView.view];
            
            XTGraphPageViewController *graphPageController = [[XTGraphPageViewController alloc] initWithNibName:nil bundle:nil andTourInfo:tourInfo];
            
            graphPageController.view.frame = CGRectMake(5, 5, boxWidth-10, width/320*200);
            graphPageController.pageController.view.frame = CGRectMake(0, 0, boxWidth-10, width/320*200);
            
            [_graphViewContainer addSubview:graphPageController.view];
        });
    });
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    
    // Step 1: Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Step 2: Adjust the bottom content inset of your scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
    
    [self setContentOffset:CGPointMake(0, self.contentSize.height - self.bounds.size.height + self.contentInset.bottom) animated:YES];
    
    if (!_hasDescription) {_descriptionView.text = @"";}
}

- (void) keyboardWillHide:(NSNotification *)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
    
    if ([_descriptionView.text isEqualToString:@""]) {_descriptionView.text = @"Kurze Beschreibung zur Tour"; _hasDescription = false;}
    else {_hasDescription = true;}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.descriptionView endEditing:YES];
}

@end
