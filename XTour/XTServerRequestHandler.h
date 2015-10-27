//
//  XTServerRequestHandler.h
//  XTour
//
//  Created by Manuel Weber on 08/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
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
- (NSMutableArray *) GetTourFilesForTour:(NSString *)tourID andType:(NSString *)type;
- (NSMutableArray *) GetCoordinatesForFile:(NSString *)file;
- (void) ProcessTourCoordinates:(NSData*)responseData;
- (NSMutableArray *) GetImagesForTour:(NSData*)responseData;
- (NSMutableArray *) GetWarningsWithinRadius:(NSData*)responseData;
- (BOOL) SubmitImageComment:(NSString *)comment forImage:(NSString *)imageID;
- (BOOL) SubmitWarningInfo:(XTWarningsInfo *)warningInfo;
- (BOOL) DownloadProfilePicture:(NSString*)userID;
- (BOOL) DownloadUserInfo:(NSString*)userID;
- (void) CheckGraphsForTour:(NSString*)tourID;
- (XTUserStatistics*) GetUserStatistics:(NSData*)responseData;
- (NSMutableArray*) GetYearlyStatistics:(NSData*)responseData;

@end
