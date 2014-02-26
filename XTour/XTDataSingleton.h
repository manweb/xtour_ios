//
//  XTSingletonTimer.h
//  XTour
//
//  Created by Manuel Weber on 15/01/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XTXMLParser.h"

@interface XTDataSingleton : NSObject

@property(nonatomic) NSInteger timer;
@property(nonatomic,retain) NSMutableArray *locationData;
@property(nonatomic) double totalDistance;
@property(nonatomic) double totalAltitude;
@property(nonatomic,retain) NSDate *startTime;
@property(nonatomic,retain) NSDate *endTime;
@property(nonatomic) bool loggedIn;
@property(nonatomic,retain) NSString *userID;
@property(nonatomic,retain) NSString *tourID;

+ (XTDataSingleton *) singleObj;

- (void) ClearData;
- (void) AddCoordinate:(CLLocation *)p;
- (void) AddDistance:(double)dist andHeight:(double)height;
- (double) CalculateHaversineForPoint:(CLLocation *)p1 andPoint:(CLLocation *)p2;
- (double) CalculateHaversineForCurrentCoordinate;
- (double) CalculateAltitudeDiffForCurrentCoordinate;
- (NSUInteger) GetNumCoordinates;
- (CLLocation *) GetCoordinatesAtIndex:(NSUInteger)index;
- (void) SetStartTime:(NSDate *)time;
- (void) SetEndTime:(NSDate *)time;
- (void) SetTourID:(NSString *)ID;
- (NSMutableArray *) GetMinMaxCoordinates;
- (void) Finalize;
- (NSString *) GetDocumentFilePathForFile:(NSString *)filename CheckIfExist:(bool)check;

@end
