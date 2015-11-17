//
//  XTServerRequestHandler.h
//  XTour
//
//  Created by Manuel Weber on 08/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "XTTourInfo.h"
#import "XTImageInfo.h"
#import "XTDataSingleton.h"
#import "XTWarningsInfo.h"
#import "XTUserStatistics.h"

@interface XTServerRequestHandler : NSObject
{
    XTDataSingleton *data;
}

@property (nonatomic,retain) NSMutableArray *tourFilesType;
@property (nonatomic,retain) NSMutableArray *tourFilesCoordinates;

- (NSMutableArray *) GetNewsFeedString:(NSData*)responseData;
- (void) ProcessTourCoordinates:(NSData*)responseData;
- (NSMutableArray *) GetImagesForTour:(NSData*)responseData;
- (NSMutableArray *) GetWarningsWithinRadius:(NSData*)responseData;
- (BOOL) SubmitImageComment:(NSString *)comment forImage:(NSString *)imageID;
- (BOOL) SubmitWarningInfo:(XTWarningsInfo *)warningInfo;
- (void) CheckGraphsForTour:(NSString*)tourID;
- (XTUserStatistics*) GetUserStatistics:(NSData*)responseData;
- (NSMutableArray*) GetYearlyStatistics:(NSData*)responseData;

@end
