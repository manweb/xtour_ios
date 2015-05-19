//
//  XTSingletonTimer.m
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTDataSingleton.h"

@implementation XTDataSingleton

+(XTDataSingleton *)singleObj{
    
    static XTDataSingleton * single=nil;
    
    @synchronized(self)
    {
        if(!single)
        {
            single = [[XTDataSingleton alloc] init];
            [single ClearData];
        }
        
    }
    return single;
}

- (void) ClearData
{
    if (!_locationData) {_locationData = [[NSMutableArray alloc] init];}
    if (!_imageInfo) {_imageInfo = [[NSMutableArray alloc] init];}
    [_locationData removeAllObjects];
    _StartLocation = 0;
    _totalTime = 0;
    _totalDistance = 0.0;
    _totalAltitude = 0.0;
    _totalDescent = 0.0;
    _sumDistance = 0.0;
    _sumAltitude = 0.0;
    _sumDescent = 0.0;
    _lowestPoint = 1e6;
    _highestPoint = -1e6;
    _sumlowestPoint = 1e6;
    _sumhighestPoint = -1e6;
    _DistanceRate = 0.0;
    _AltitudeRate = 0.0;
    _rateLastDistance = 0.0;
    _rateLastAltitude = 0.0;
    _startTime = 0;
    _endTime = 0;
    _TotalStartTime = 0;
    _TotalEndTime = 0;
    _timer = 0;
    _loggedIn = false;
    _userID = nil;
    _tourID = nil;
    _upCount = 0;
    _downCount = 0;
    _photoCount = 0;
    _lastRunIndex = 0;
}

- (void) ResetDataForNewRun
{
    //[_locationData removeAllObjects];
    _totalDistance = 0.0;
    _totalAltitude = 0.0;
    _totalDescent = 0.0;
    _lowestPoint = 1e6;
    _highestPoint = -1e6;
    _startTime = 0;
    _endTime = 0;
    _timer = 0;
    _lastRunIndex = [_locationData count];
}

- (void) ResetAll
{
    [_locationData removeAllObjects];
    [_imageInfo removeAllObjects];
    _StartLocation = 0;
    _totalDistance = 0.0;
    _totalAltitude = 0.0;
    _totalDescent = 0.0;
    _sumDistance = 0.0;
    _sumAltitude = 0.0;
    _sumDescent = 0.0;
    _lowestPoint = 1e6;
    _highestPoint = -1e6;
    _sumlowestPoint = 1e6;
    _sumhighestPoint = -1e6;
    _DistanceRate = 0.0;
    _AltitudeRate = 0.0;
    _rateLastDistance = 0.0;
    _rateLastAltitude = 0.0;
    _totalTime = 0;
    _startTime = 0;
    _TotalStartTime = 0;
    _TotalEndTime = 0;
    _endTime = 0;
    _timer = 0;
    _tourID = nil;
    _upCount = 0;
    _downCount = 0;
    _photoCount = 0;
    _lastRunIndex = 0;
}

- (void) AddCoordinate:(CLLocation *)p
{
    [_locationData addObject:p];
}

- (void) AddDistance:(double)dist andHeight:(double)height
{
    _totalDistance += dist;
    _sumDistance += dist;
    
    if (height > 0) {
        _totalAltitude += height;
        _sumAltitude += height;
    }
    else {
        _totalDescent += fabs(height);
        _sumDescent += fabs(height);
    }
}

- (double) CalculateHaversineForPoint:(CLLocation *)p1 andPoint:(CLLocation *)p2
{
    CLLocationDegrees longitude1 = M_PI / 180.0 * p1.coordinate.longitude;
    CLLocationDegrees latitude1 = M_PI / 180.0 * p1.coordinate.latitude;
    CLLocationDegrees longitude2 = M_PI / 180.0 * p2.coordinate.longitude;
    CLLocationDegrees latitude2 = M_PI / 180.0 * p2.coordinate.latitude;
    
    NSLog(@"Calculating haversin for: (%f,%f) (%f,%f)", longitude1, latitude1, longitude2, latitude2);
    
    double r = 6371.0;
    
    double h_phi1_phi2 = sin((latitude2 - latitude1)/2.0)*sin((latitude2 - latitude1)/2.0);
    double h_lambda1_lambda2 = sin((longitude2 - longitude1)/2.0)*sin((longitude2 - longitude1)/2.0);
    
    double d = 2*r*asin(sqrt(h_phi1_phi2 + cos(latitude1)*cos(latitude2)*h_lambda1_lambda2));
    
    return d;
}

- (double) CalculateHaversineForCurrentCoordinate
{
    if ([_locationData count] < 2) {NSLog(@"Not enough coordinates to calculate haversine distance."); return 0;}
    
    NSUInteger nCoordinates = [_locationData count];
    CLLocation *p1 = [self GetCoordinatesAtIndex:(nCoordinates - 1)];
    CLLocation *p2 = [self GetCoordinatesAtIndex:(nCoordinates - 2)];
    
    double timeDiff = (p1.timestamp.timeIntervalSince1970 - p2.timestamp.timeIntervalSince1970)/3600.0;
    
    double distance = [self CalculateHaversineForPoint:p1 andPoint:p2];
    double speed = distance/timeDiff;
    
    if (speed > 50.0) {return -1;}
    
    return distance;
}

- (double) CalculateAltitudeDiffForCurrentCoordinate
{
    if ([_locationData count] < 2) {NSLog(@"Not enough coordinates to calculate haversine distance."); return 0;}
    
    NSUInteger nCoordinates = [_locationData count];
    CLLocation *p1 = [self GetCoordinatesAtIndex:(nCoordinates - 1)];
    CLLocation *p2 = [self GetCoordinatesAtIndex:(nCoordinates - 2)];
    
    double alt1 = p1.altitude;
    double alt2 = p2.altitude;
    
    return alt1 - alt2;
}

- (void) RemoveLastCoordinate
{
    [_locationData removeLastObject];
    
    return;
}

- (NSUInteger) GetNumCoordinates
{
    return [_locationData count];
}

- (CLLocation *) GetCoordinatesAtIndex:(NSUInteger)index
{
    if (index > [_locationData count] - 1) {NSLog(@"Array index exceeds boundary."); return 0;}
    
    return [_locationData objectAtIndex:index];
}

- (CLLocation *) GetLastCoordinates
{
    if ([_locationData count] == 0) {NSLog(@"No data in the location array."); return 0;}
    
    return [_locationData objectAtIndex:([self GetNumCoordinates] - 1)];
}

- (NSMutableArray *) GetCoordinatesForCurrentRun
{
    if ([_locationData count] == 0) {NSLog(@"No data in the location array."); return 0;}
    
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    for (int i = (int)_lastRunIndex; i < [_locationData count]; i++) {
        [locations addObject:[_locationData objectAtIndex:i]];
    }
    
    return locations;
}

- (void) CreateTourDirectory
{
    NSString *tourImagePath = [self GetDocumentFilePathForFile:@"/tours/images" CheckIfExist:NO];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tourImagePath]) {[[NSFileManager defaultManager] createDirectoryAtPath:tourImagePath withIntermediateDirectories:YES attributes:nil error:nil];}
}

- (NSMutableArray *) GetMinMaxCoordinates
{
    double minLat = 1e6;
    double minLon = 1e6;
    double maxLat = -1e6;
    double maxLon = -1e6;
    
    for (int i = 0; i < [_locationData count]; i++) {
        CLLocation *tmp = [_locationData objectAtIndex:i];
        if (tmp.coordinate.latitude < minLat) {minLat = tmp.coordinate.latitude;}
        if (tmp.coordinate.longitude < minLon) {minLon = tmp.coordinate.longitude;}
        if (tmp.coordinate.latitude > maxLat) {maxLat = tmp.coordinate.latitude;}
        if (tmp.coordinate.longitude > maxLon) {maxLon = tmp.coordinate.longitude;}
    }
    
    NSMutableArray *arrayMinMax = [[NSMutableArray alloc] init];
    if ([_locationData count] == 0) {
        minLat = 0;
        minLon = 0;
        maxLat = 0;
        maxLon = 0;
    }
    [arrayMinMax addObject:[[NSString alloc] initWithFormat:@"%f",minLat]];
    [arrayMinMax addObject:[[NSString alloc] initWithFormat:@"%f",minLon]];
    [arrayMinMax addObject:[[NSString alloc] initWithFormat:@"%f",maxLat]];
    [arrayMinMax addObject:[[NSString alloc] initWithFormat:@"%f",maxLon]];
    
    return arrayMinMax;
}

- (NSMutableArray *) GetCoordinateBounds
{
    double minLat = 1e6;
    double minLon = 1e6;
    double maxLat = -1e6;
    double maxLon = -1e6;
    
    for (int i = 0; i < [_locationData count]; i++) {
        CLLocation *tmp = [_locationData objectAtIndex:i];
        if (tmp.coordinate.latitude < minLat) {minLat = tmp.coordinate.latitude;}
        if (tmp.coordinate.longitude < minLon) {minLon = tmp.coordinate.longitude;}
        if (tmp.coordinate.latitude > maxLat) {maxLat = tmp.coordinate.latitude;}
        if (tmp.coordinate.longitude > maxLon) {maxLon = tmp.coordinate.longitude;}
    }
    
    NSMutableArray *arrayBounds = [[NSMutableArray alloc] init];
    [arrayBounds addObject:[[CLLocation alloc] initWithLatitude:maxLat longitude:minLon]];
    [arrayBounds addObject:[[CLLocation alloc] initWithLatitude:minLat longitude:maxLon]];
    
    return arrayBounds;
}

- (void) CreateXMLForCategory:(NSString *)category
{
    XTXMLParser *xml = [[XTXMLParser alloc] init];
    
    NSMutableArray *bounds = [self GetMinMaxCoordinates];
    //CLLocation *firstEntry = [_locationData objectAtIndex:0];
    //NSDate *startDate = firstEntry.timestamp;
    
    //CLLocation *lastEntry = [_locationData objectAtIndex:([self GetNumCoordinates] - 1)];
    //NSDate *endDate = lastEntry.timestamp;
    
    if ([category isEqualToString:@"sum"]) {
        _startTime = _TotalStartTime;
        _endTime = _TotalEndTime;
        _totalDistance = _sumDistance;
        _totalAltitude = _sumAltitude;
        _totalDescent = _sumDescent;
        _lowestPoint = _sumlowestPoint;
        _highestPoint = _sumhighestPoint;
        _timer = _totalTime;
        _lastRunIndex = 0;
    }
    
    [xml SetMetadataString:_userID forKey:@"userid"];
    [xml SetMetadataString:_tourID forKey:@"tourid"];
    [xml SetMetadataDate:_startTime forKey:@"StartTime"];
    [xml SetMetadataDate:_endTime forKey:@"EndTime"];
    [xml SetMetadataBounds:bounds];
    [xml SetMetadataDouble:(double)_timer forKey:@"TotalTime" withPrecision:0];
    [xml SetMetadataDouble:_totalDistance forKey:@"TotalDistance" withPrecision:1];
    [xml SetMetadataDouble:_totalAltitude forKey:@"TotalAltitude" withPrecision:1];
    [xml SetMetadataDouble:_totalDescent forKey:@"TotalDescent" withPrecision:1];
    [xml SetMetadataDouble:_lowestPoint forKey:@"LowestPoint" withPrecision:1];
    [xml SetMetadataDouble:_highestPoint forKey:@"HighestPoint" withPrecision:1];
    [xml SetMetadataString:_country forKey:@"Country"];
    
    for (int i = _lastRunIndex; i < [_locationData count]; i++) {
        [xml AddTrackpoint:[_locationData objectAtIndex:i]];
    }
    
    /*if ([category isEqualToString:@"sum"]) {
     [xml AddTrackpoint:_StartLocation];
     }*/
    
    NSInteger count;
    if ([category isEqualToString:@"up"]) {count = _upCount;}
    if ([category isEqualToString:@"down"]) {count = _downCount;}
    if ([category isEqualToString:@"sum"]) {count = 0;}
    
    NSString *FileName = [NSString stringWithFormat:@"/tours/%@_%@%i.gpx", _tourID, category, (int)count];
    
    [xml SaveXML:FileName];
}

- (void) WriteRecoveryFile
{
    XTXMLParser *xml = [[XTXMLParser alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
    
    [xml SetMetadataString:_userID forKey:@"userid"];
    [xml SetMetadataString:_tourID forKey:@"tourid"];
    [xml SetMetadataDouble:(double)_timer forKey:@"TotalTime" withPrecision:0];
    [xml SetMetadataDouble:_totalDistance forKey:@"TotalDistance" withPrecision:1];
    [xml SetMetadataDouble:_totalAltitude forKey:@"TotalAltitude" withPrecision:1];
    [xml SetMetadataDouble:_totalDescent forKey:@"TotalDescent" withPrecision:1];
    [xml SetMetadataDouble:_sumDistance forKey:@"SumDistance" withPrecision:1];
    [xml SetMetadataDouble:_sumAltitude forKey:@"SumAltitude" withPrecision:1];
    [xml SetMetadataDouble:_sumDescent forKey:@"SumDescent" withPrecision:1];
    [xml SetMetadataDouble:_lowestPoint forKey:@"LowestPoint" withPrecision:1];
    [xml SetMetadataDouble:_highestPoint forKey:@"HighestPoint" withPrecision:1];
    [xml SetMetadataDouble:_sumlowestPoint forKey:@"SumLowestPoint" withPrecision:1];
    [xml SetMetadataDouble:_sumhighestPoint forKey:@"SumHighestPoint" withPrecision:1];
    [xml SetMetadataString:[dateFormatter stringFromDate:_startTime] forKey:@"StartTime"];
    [xml SetMetadataString:[dateFormatter stringFromDate:_endTime] forKey:@"EndTime"];
    [xml SetMetadataString:[dateFormatter stringFromDate:_TotalStartTime] forKey:@"TotalStartTime"];
    [xml SetMetadataString:[dateFormatter stringFromDate:_TotalEndTime] forKey:@"TotalEndTime"];
    [xml SetMetadataDouble:_upCount forKey:@"UpCount" withPrecision:0];
    [xml SetMetadataDouble:_downCount forKey:@"DownCount" withPrecision:0];
    [xml SetMetadataDouble:_photoCount forKey:@"PhotoCount" withPrecision:0];
    [xml SetMetadataDouble:_lastRunIndex forKey:@"LastRunIndex" withPrecision:0];
    [xml SetMetadataDouble:_StartLocation.coordinate.latitude forKey:@"StartLocationLat" withPrecision:5];
    [xml SetMetadataDouble:_StartLocation.coordinate.longitude forKey:@"StartLocationLon" withPrecision:5];
    [xml SetMetadataDouble:_StartLocation.altitude forKey:@"StartLocationAltitude" withPrecision:1];
    
    for (int i = 0; i < [_locationData count]; i++) {
        [xml AddTrackpoint:[_locationData objectAtIndex:i]];
    }
    
    [xml SaveRecoveryFile:@"/recovery.xml"];
}

- (void) RecoverTour
{
    [self ResetAll];
    
    XTXMLParser *xml = [[XTXMLParser alloc] init];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
    
    NSString *FileName = [NSString stringWithFormat:@"%@/recovery.xml",[self GetTourDocumentPath]];
    
    [xml ReadGPXFile:FileName];
    _userID = [xml GetValueFromFile:@"userid"];
    _tourID = [xml GetValueFromFile:@"tourid"];
    _timer = [[xml GetValueFromFile:@"TotalTime"] integerValue];
    _totalDistance = [[xml GetValueFromFile:@"TotalDistance"] doubleValue];
    _totalAltitude = [[xml GetValueFromFile:@"TotalAltitude"] doubleValue];
    _totalDescent = [[xml GetValueFromFile:@"TotalDescent"] doubleValue];
    _sumDistance = [[xml GetValueFromFile:@"SumDistance"] doubleValue];
    _sumAltitude = [[xml GetValueFromFile:@"SumAltitude"] doubleValue];
    _sumDescent = [[xml GetValueFromFile:@"SumDescent"] doubleValue];
    _lowestPoint = [[xml GetValueFromFile:@"LowestPoint"] doubleValue];
    _highestPoint = [[xml GetValueFromFile:@"HighestPoint"] doubleValue];
    _sumlowestPoint = [[xml GetValueFromFile:@"SumLowestPoint"] doubleValue];
    _sumhighestPoint = [[xml GetValueFromFile:@"SumHighestPoint"] doubleValue];
    _upCount = [[xml GetValueFromFile:@"UpCount"] integerValue];
    _downCount = [[xml GetValueFromFile:@"DownCount"] integerValue];
    _photoCount = [[xml GetValueFromFile:@"PhotoCount"] integerValue];
    _lastRunIndex = [[xml GetValueFromFile:@"LastRunIndex"] integerValue];
    
    NSString *StartTime = [xml GetValueFromFile:@"StartTime"];
    NSString *EndTime = [xml GetValueFromFile:@"EndTime"];
    NSString *TotalStartTime = [xml GetValueFromFile:@"TotalStartTime"];
    NSString *TotalEndTime = [xml GetValueFromFile:@"TotalEndTIme"];
    
    _startTime = [dateFormatter dateFromString:StartTime];
    _endTime = [dateFormatter dateFromString:EndTime];
    _TotalStartTime = [dateFormatter dateFromString:TotalStartTime];
    _TotalEndTime = [dateFormatter dateFromString:TotalEndTime];
    
    double lat = [[xml GetValueFromFile:@"StartLocationLat"] doubleValue];
    double lon = [[xml GetValueFromFile:@"StartLocationLon"] doubleValue];
    double altitude = [[xml GetValueFromFile:@"StartLocationAltitude"] doubleValue];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
    CLLocation *startLocation = [[CLLocation alloc] initWithCoordinate:coordinate altitude:altitude horizontalAccuracy:0 verticalAccuracy:0 timestamp:_TotalStartTime];
    
    _StartLocation = startLocation;
    
    NSMutableArray *locationData = [xml GetLocationDataFromFile];
    
    for (CLLocation *location in locationData) {
        [self AddCoordinate:location];
    }
}

- (void) RemoveRecoveryFile
{
    NSString *recoveryFile = [NSString stringWithFormat:@"%@/recovery.xml",[self GetDocumentFilePathForFile:@"/" CheckIfExist:NO]];
    
    [[NSFileManager defaultManager] removeItemAtPath:recoveryFile error:nil];
    
    NSLog(@"Removed recovery file");
}

- (NSString *) GetDocumentFilePathForFile:(NSString *)filename CheckIfExist:(bool)check
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *FilePath = [documentsDirectory stringByAppendingString:filename];
    
    if (check) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:FilePath]) {return nil;}
    }
    
    return FilePath;
}

- (NSString *) GetTourDocumentPath
{
    NSString *currentTour = [self GetDocumentFilePathForFile:@"/tours" CheckIfExist:NO];
    
    return currentTour;
}

- (NSString *) GetTourImagePath
{
    NSString *imagePath = [self GetDocumentFilePathForFile:@"/tours/images" CheckIfExist:NO];
    
    return imagePath;
}

- (NSString *) GetNewPhotoName
{
    NSString *path = [self GetDocumentFilePathForFile:@"/tours" CheckIfExist:NO];
    
    NSString *newName = [[NSString alloc] initWithFormat:@"%@/images/%@_%03ld.jpg",path,_tourID,_photoCount];
    
    _photoCount++;
    
    return newName;
}

- (NSMutableArray *) GetAllGPXFiles
{
    NSString *tourDirectory = [self GetTourDocumentPath];
    NSArray *content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tourDirectory error:nil];
    
    NSMutableArray *GPXFiles = [[NSMutableArray alloc] init];
    for (int i = 0; i < [content count]; i++) {
        NSString *file = [NSString stringWithFormat:@"%@/%@", tourDirectory, [content objectAtIndex:i]];
        if ([[file pathExtension] isEqualToString:@"gpx"]) {[GPXFiles addObject:file];}
    }
    
    return GPXFiles;
}

- (NSMutableArray *) GetGPXFilesForCurrentTour
{
    if (!_tourID) {return nil;}
    
    NSMutableArray *GPXFiles = [self GetAllGPXFiles];
    NSMutableArray *GPXFilesCurrent = [[NSMutableArray alloc] init];
    for (int i = 0; i < [GPXFiles count]; i++) {
        if ([[GPXFiles objectAtIndex:i] containsString:_tourID]) {[GPXFilesCurrent addObject:[GPXFiles objectAtIndex:i]];}
    }
    
    return GPXFilesCurrent;
}

- (NSMutableArray *) GetAllImages
{
    NSString *imageDirectory = [self GetTourImagePath];
    NSArray *content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imageDirectory error:nil];
    
    NSMutableArray *imageFiles = [[NSMutableArray alloc] init];
    for (int i = 0; i < [content count]; i++) {
        NSString *file = [NSString stringWithFormat:@"%@/%@", imageDirectory, [content objectAtIndex:i]];
        if ([[file pathExtension] isEqualToString:@"jpg"]) {[imageFiles addObject:file];}
    }
    
    return imageFiles;
}

- (NSMutableArray *) GetImagesForCurrentTour
{
    if (!_tourID) {return nil;}
    
    NSMutableArray *imageFiles = [self GetAllImages];
    NSMutableArray *imageFilesCurrent = [[NSMutableArray alloc] init];
    for (int i = 0; i < [imageFiles count]; i++) {
        if ([[imageFiles objectAtIndex:i] containsString:_tourID]) {[imageFilesCurrent addObject:[imageFiles objectAtIndex:i]];}
    }
    
    return imageFilesCurrent;
}

- (NSMutableArray *) GetAllImageInfoFiles
{
    NSString *tourDirectory = [self GetTourDocumentPath];
    NSArray *content = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:tourDirectory error:nil];
    
    NSMutableArray *imageInfoFiles = [[NSMutableArray alloc] init];
    for (int i = 0; i < [content count]; i++) {
        NSString *file = [NSString stringWithFormat:@"%@/%@", tourDirectory, [content objectAtIndex:i]];
        if ([file containsString:@"ImageInfo"] && [[file pathExtension] isEqualToString:@"xml"]) {[imageInfoFiles addObject:file];}
    }
    
    return imageInfoFiles;
}

- (void) CleanUpTourDirectory
{
    NSMutableArray *GPXFiles = [self GetAllGPXFiles];
    NSMutableArray *imageFiles = [self GetAllImages];
    
    for (int i = 0; i < [GPXFiles count]; i++) {
        [[NSFileManager defaultManager] removeItemAtPath:[GPXFiles objectAtIndex:i] error:nil];
    }
    
    for (int i = 0; i < [imageFiles count]; i++) {
        [[NSFileManager defaultManager] removeItemAtPath:[imageFiles objectAtIndex:i] error:nil];
    }
    
    [self RemoveRecoveryFile];
}

- (void) AddImage:(XTImageInfo *)image
{
    [_imageInfo addObject:image];
}

- (NSUInteger) GetNumImages
{
    return [_imageInfo count];
}

- (XTImageInfo *) GetImageInfoAt:(NSUInteger)index
{
    if (index > [_imageInfo count] - 1) {NSLog(@"Array index exceeds boundary"); return 0;}
    
    return [_imageInfo objectAtIndex:index];
}

- (NSString *) GetImageFilenameAt:(NSUInteger)index
{
    return [self GetImageInfoAt:index].Filename;
}

- (float) GetImageLongitudeAt:(NSUInteger)index
{
    float lon = [self GetImageInfoAt:index].Longitude;
    
    if (lon) {return lon;}
    else {return 0;}
}

- (float) GetImageLatitudeAt:(NSUInteger)index
{
    float lat = [self GetImageInfoAt:index].Latitude;
    
    if (lat) {return lat;}
    else {return 0;}
}

- (float) GetImageElevationAt:(NSUInteger)index
{
    float elevation = [self GetImageInfoAt:index].Elevation;
    
    if (elevation) {return elevation;}
    else {return 0;}
}

- (NSString *) GetImageCommentAt:(NSUInteger)index
{
    NSString *comment = [self GetImageInfoAt:index].Comment;
    
    if (comment) {return comment;}
    else {return 0;}
}

- (NSDate *) GetImageDateAt:(NSUInteger)index
{
    NSDate *date = [self GetImageInfoAt:index].Date;
    
    if (date) {return date;}
    else {return 0;}
}

- (NSString *) GetImageLongitudeStringAt:(NSUInteger)index
{
    float lon = [self GetImageInfoAt:index].Longitude;
    
    NSString *longitude = nil;
    
    if (lon) {
        NSString *lonEW;
        if (lon < 0) {lonEW = [[NSString alloc] initWithString:@"W"]; lon = fabsf(lon);}
        else {lonEW = [[NSString alloc] initWithString:@"E"];}
        
        longitude = [[NSString alloc] initWithFormat:@"%.0f°%.0f'%.1f\" %s",
                               floor(lon),
                               floor((lon - floor(lon)) * 60),
                               ((lon - floor(lon)) * 60 - floor((lon - floor(lon)) * 60)) * 60, [lonEW UTF8String]];
    }
    
    return longitude;
}

- (NSString *) GetImageLatitudeStringAt:(NSUInteger)index
{
    float lat = [self GetImageInfoAt:index].Latitude;
    
    NSString *latitude = nil;
    
    if (lat) {
        NSString *latNS;
        if (lat < 0) {latNS = [[NSString alloc] initWithString:@"S"]; lat = fabsf(lat);}
        else {latNS = [[NSString alloc] initWithString:@"N"];}
        
        latitude = [[NSString alloc] initWithFormat:@"%.0f°%.0f'%.1f\" %s",
                               floor(lat),
                               floor((lat - floor(lat)) * 60),
                               ((lat - floor(lat)) * 60 - floor((lat - floor(lat)) * 60)) * 60, [latNS UTF8String]];
    }
    
    return latitude;
}

- (NSString *) GetImageCoordinateStringAt:(NSUInteger)index
{
    NSString *longitude = [self GetImageLongitudeStringAt:index];
    NSString *latitude = [self GetImageLatitudeStringAt:index];
    float elevation = [self GetImageElevationAt:index];
    
    NSString *coordinates = nil;
    
    if (longitude && latitude && elevation) {
        coordinates = [NSString stringWithFormat:@"%@ %@ %.0f",longitude,latitude,elevation];
    }
    
    return coordinates;
}

- (void) WriteImageInfo
{
    XTXMLParser *parser = [[XTXMLParser alloc] init];
    
    for (int i = 0; i < [_imageInfo count]; i++) {
        [parser AddImageInfo:[_imageInfo objectAtIndex:i]];
    }
    
    NSString *filename = [NSString stringWithFormat:@"/tours/ImageInfo_%@.xml",_tourID];
    
    [parser SaveImageInfo:filename];
}

- (void)dealloc
{
    [super dealloc];
    [_locationData release];
    [_startTime release];
    [_endTime release];
    [_userID release];
    [_tourID release];
}

@end
