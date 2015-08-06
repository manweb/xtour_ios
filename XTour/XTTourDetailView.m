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
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:46.770809 longitude:8.377733 zoom:6];
    if (!mapView) {mapView = [GMSMapView mapWithFrame:CGRectMake(5, 5, boxWidth - 10, 240) camera:camera];}
    
    _summaryViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+5, boxWidth, 140)];
    _mapViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+150, boxWidth, 250)];
    _imageViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+405, boxWidth, 200)];
    _descriptionViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+610, boxWidth, 200)];
    _graphViewContainer = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, _viewOffset+815, boxWidth, 200)];
    
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
    
    _TimeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(56, 17, 94, 21)];
    _DistanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 55, 100, 15)];
    _SpeedTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 55, 100, 15)];
    _UpTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 55, 100, 15)];
    _DownTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 97, 100, 15)];
    _HighestPointTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 97, 100, 15)];
    _LowestPointTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 97, 100, 15)];
    
    _TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 200, 30)];
    _DistanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 72, 100, 20)];
    _SpeedLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 72, 100, 20)];
    _UpLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 72, 100, 20)];
    _DownLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 114, 100, 20)];
    _HighestPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 114, 100, 20)];
    _LowestPointLabel = [[UILabel alloc] initWithFrame:CGRectMake(205, 114, 100, 20)];
    
    _TimeTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _DistanceTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _SpeedTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _UpTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _DownTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _HighestPointTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    _LowestPointTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0f];
    
    _TimeTitleLabel.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
    _DistanceTitleLabel.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
    _SpeedTitleLabel.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
    _UpTitleLabel.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
    _DownTitleLabel.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
    _HighestPointTitleLabel.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
    _LowestPointTitleLabel.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
    
    _TimeLabel.font = [UIFont fontWithName:@"Helvetica" size:32.0f];
    _DistanceLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    _SpeedLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    _UpLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    _DownLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    _HighestPointLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    _LowestPointLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    
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
    
    _descriptionView.layer.borderColor = [[UIColor blackColor] CGColor];
    _descriptionView.layer.borderWidth = 1.0f;
    _descriptionView.layer.cornerRadius = boxRadius;
    
    _descriptionView.text = tourInfo.tourDescription;
    
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
    [self addSubview:_graphViewContainer];
    
    if (server) {self.contentSize = CGSizeMake(320, _viewOffset+1020+_viewContentOffset);}
    else {self.contentSize = CGSizeMake(320, _viewOffset+1020);}
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
            
            graphPageController.view.frame = CGRectMake(5, 5, boxWidth-10, 190);
            graphPageController.pageController.view.frame = CGRectMake(0, 0, boxWidth-10, 190);
            
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
}

- (void) keyboardWillHide:(NSNotification *)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.contentInset = contentInsets;
    self.scrollIndicatorInsets = contentInsets;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.descriptionView endEditing:YES];
}

@end
