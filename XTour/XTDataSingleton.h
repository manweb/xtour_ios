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
@property(nonatomic) NSInteger rateTimer;
@property(nonatomic,retain) NSMutableArray *locationData;
@property(nonatomic,retain) CLLocation *StartLocation;
@property(nonatomic) int totalTime;
@property(nonatomic) double totalDistance;
@property(nonatomic) double totalAltitude;
@property(nonatomic) double totalDescent;
@property(nonatomic) double sumDistance;
@property(nonatomic) double sumAltitude;
@property(nonatomic) double sumDescent;
@property(nonatomic) double DistanceRate;
@property(nonatomic) double AltitudeRate;
@property(nonatomic) double rateLastDistance;
@property(nonatomic) double rateLastAltitude;
@property(nonatomic,retain) NSDate *startTime;
@property(nonatomic,retain) NSDate *endTime;
@property(nonatomic,retain) NSDate *TotalStartTime;
@property(nonatomic,retain) NSDate *TotalEndTime;
@property(nonatomic) bool loggedIn;
@property(nonatomic,retain) NSString *userID;
@property(nonatomic,retain) NSString *tourID;
@property(nonatomic) NSInteger upCount;
@property(nonatomic) NSInteger downCount;
@property(nonatomic,retain) NSString *country;
@property(nonatomic) NSInteger photoCount;

+ (XTDataSingleton *) singleObj;

- (void) ClearData;
- (void) ResetDataForNewRun;
- (void) ResetAll;
- (void) AddCoordinate:(CLLocation *)p;
- (void) AddDistance:(double)dist andHeight:(double)height;
- (double) CalculateHaversineForPoint:(CLLocation *)p1 andPoint:(CLLocation *)p2;
- (double) CalculateHaversineForCurrentCoordinate;
- (double) CalculateAltitudeDiffForCurrentCoordinate;
- (NSUInteger) GetNumCoordinates;
- (CLLocation *) GetCoordinatesAtIndex:(NSUInteger)index;
- (CLLocation *) GetLastCoordinates;
- (void) CreateTourDirectory;
- (NSMutableArray *) GetMinMaxCoordinates;
- (NSMutableArray *) GetCoordinateBounds;
- (void) CreateXMLForCategory:(NSString *)category;
- (void) WriteRecoveryFile;
- (void) RecoverTour;
- (NSString *) GetDocumentFilePathForFile:(NSString *)filename CheckIfExist:(bool)check;
- (NSString *) GetTourDocumentPath;
- (NSString *) GetTourImagePath;
- (NSString *) GetNewPhotoName;
- (NSMutableArray *) GetAllGPXFiles;
- (NSMutableArray *) GetGPXFilesForCurrentTour;
- (NSMutableArray *) GetAllImages;
- (NSMutableArray *) GetImagesForCurrentTour;
- (void) CleanUpTourDirectory;

@end
