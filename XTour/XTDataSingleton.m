//
//  XTSingletonTimer.m
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTDataSingleton.h"

@implementation XTDataSingleton

@synthesize timer;
@synthesize locationData;
@synthesize totalDistance;
@synthesize totalAltitude;
@synthesize startTime;
@synthesize endTime;
@synthesize loggedIn;
@synthesize userID;
@synthesize tourID;

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
    if (!locationData) {locationData = [[NSMutableArray alloc] init];}
    [locationData removeAllObjects];
    totalDistance = 0.0;
    totalAltitude = 0.0;
    startTime = 0;
    endTime = 0;
    timer = 0;
    loggedIn = false;
    userID = nil;
}

- (void) AddCoordinate:(CLLocation *)p
{
    [locationData addObject:p];
}

- (void) AddDistance:(double)dist andHeight:(double)height
{
    totalDistance += dist;
    totalAltitude += height;
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
    if ([locationData count] < 2) {NSLog(@"Not enough coordinates to calculate haversine distance."); return 0;}
    
    NSUInteger nCoordinates = [locationData count];
    CLLocation *p1 = [self GetCoordinatesAtIndex:(nCoordinates - 1)];
    CLLocation *p2 = [self GetCoordinatesAtIndex:(nCoordinates - 2)];
    
    return [self CalculateHaversineForPoint:p1 andPoint:p2];
}

- (double) CalculateAltitudeDiffForCurrentCoordinate
{
    if ([locationData count] < 2) {NSLog(@"Not enough coordinates to calculate haversine distance."); return 0;}
    
    NSUInteger nCoordinates = [locationData count];
    CLLocation *p1 = [self GetCoordinatesAtIndex:(nCoordinates - 1)];
    CLLocation *p2 = [self GetCoordinatesAtIndex:(nCoordinates - 2)];
    
    double alt1 = p1.altitude;
    double alt2 = p2.altitude;
    
    return alt1 - alt2;
}

- (NSUInteger) GetNumCoordinates
{
    return [locationData count];
}

- (CLLocation *) GetCoordinatesAtIndex:(NSUInteger)index
{
    if (index > [locationData count] - 1) {NSLog(@"Array index exceeds boundary."); return 0;}
    
    return [locationData objectAtIndex:index];
}

- (void) SetStartTime:(NSDate *)time
{
    startTime = time;
}

- (void) SetEndTime:(NSDate *)time
{
    endTime = time;
}

- (void) SetTourID:(NSString *)ID
{
    tourID = ID;
    
    NSString *tourImagePath = [self GetDocumentFilePathForFile:[NSString stringWithFormat:@"/tours/%s/images", [ID UTF8String]] CheckIfExist:NO];
    if (![[NSFileManager defaultManager] fileExistsAtPath:tourImagePath]) {[[NSFileManager defaultManager] createDirectoryAtPath:tourImagePath withIntermediateDirectories:YES attributes:nil error:nil];}
}

- (NSMutableArray *) GetMinMaxCoordinates
{
    double minLat = 1e6;
    double minLon = 1e6;
    double maxLat = -1e6;
    double maxLon = -1e6;
    
    for (int i = 0; i < [locationData count]; i++) {
        CLLocation *tmp = [locationData objectAtIndex:i];
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

- (void) Finalize
{
    XTXMLParser *xml = [[XTXMLParser alloc] init];
    
    NSMutableArray *bounds = [self GetMinMaxCoordinates];
    CLLocation *firstEntry = [locationData objectAtIndex:0];
    NSDate *startDate = firstEntry.timestamp;
    
    CLLocation *lastEntry = [locationData objectAtIndex:([self GetNumCoordinates] - 1)];
    NSDate *endDate = lastEntry.timestamp;
    
    [xml SetMetadataForUserID:userID TourID:tourID StartTime:startDate EndTime:endDate Bounds:bounds];
    
    for (int i = 0; i < [locationData count]; i++) {
        [xml AddTrackpoint:[locationData objectAtIndex:i]];
    }
    
    NSString *FileName = [NSString stringWithFormat:@"/tours/%@/%@_up1.xml", tourID, tourID];
    
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

@end
