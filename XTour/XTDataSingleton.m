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
    [_locationData removeAllObjects];
    _totalDistance = 0.0;
    _totalAltitude = 0.0;
    _startTime = 0;
    _endTime = 0;
    _timer = 0;
    _loggedIn = false;
    _userID = nil;
    _tourID = nil;
    _upCount = 0;
    _downCount = 0;
}

- (void) ResetDataForNewRun
{
    [_locationData removeAllObjects];
    _totalDistance = 0.0;
    _totalAltitude = 0.0;
    _startTime = 0;
    _endTime = 0;
    _timer = 0;
}

- (void) ResetAll
{
    [_locationData removeAllObjects];
    _totalDistance = 0.0;
    _totalAltitude = 0.0;
    _startTime = 0;
    _endTime = 0;
    _timer = 0;
    _tourID = nil;
    _upCount = 0;
    _downCount = 0;
}

- (void) AddCoordinate:(CLLocation *)p
{
    [_locationData addObject:p];
}

- (void) AddDistance:(double)dist andHeight:(double)height
{
    _totalDistance += dist;
    _totalAltitude += height;
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
    
    return [self CalculateHaversineForPoint:p1 andPoint:p2];
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

- (void) CreateTourDirectory
{
    if (!_tourID) {return;}
    
    NSString *tourImagePath = [self GetDocumentFilePathForFile:[NSString stringWithFormat:@"/tours/%@/images", _tourID] CheckIfExist:NO];
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
    CLLocation *firstEntry = [_locationData objectAtIndex:0];
    NSDate *startDate = firstEntry.timestamp;
    
    CLLocation *lastEntry = [_locationData objectAtIndex:([self GetNumCoordinates] - 1)];
    NSDate *endDate = lastEntry.timestamp;
    
    [xml SetMetadataUserID:_userID];
    [xml SetMetadataTourID:_tourID];
    [xml SetMetadataStartDate:startDate];
    [xml SetMetadataEndDate:endDate];
    [xml SetMetadataBounds:bounds];
    [xml SetMetadataTotalDistance:_totalDistance];
    [xml SetMetadataTotalAltitude:_totalAltitude];
    
    for (int i = 0; i < [_locationData count]; i++) {
        [xml AddTrackpoint:[_locationData objectAtIndex:i]];
    }
    
    NSInteger count;
    if ([category isEqualToString:@"up"]) {count = _upCount;}
    if ([category isEqualToString:@"down"]) {count = _downCount;}
    
    NSString *FileName = [NSString stringWithFormat:@"/tours/%@/%@_%@%i.xml", _tourID, _tourID, category, (int)count];
    
    [xml SaveXML:FileName];
}

- (NSString *) GetDocumentFilePathForFile:(NSString *)filename CheckIfExist:(bool)check
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *FilePath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    if (check) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:FilePath]) {return nil;}
    }
    
    return FilePath;
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
