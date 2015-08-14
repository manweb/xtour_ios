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

@interface XTServerRequestHandler : NSObject
{
    XTDataSingleton *data;
}

- (NSMutableArray *) GetNewsFeedString:(int)numberOfNewsFeeds;
- (NSMutableArray *) GetTourFilesForTour:(NSString *)tourID andType:(NSString *)type;
- (NSMutableArray *) GetCoordinatesForFile:(NSString *)file;
- (NSMutableArray *) GetImagesForTour:(NSString *)tourID;
- (NSMutableArray *) GetWarningsWithinRadius:(double)radius atLongitude:(double)longitude andLatitude:(double)latitude;
- (BOOL) SubmitImageComment:(NSString *)comment forImage:(NSString *)imageID;
- (BOOL) SubmitWarningInfo:(XTWarningsInfo *)warningInfo;
- (BOOL) DownloadProfilePicture:(NSString*)userID;
- (BOOL) DownloadUserInfo:(NSString*)userID;
- (void) CheckGraphsForTour:(NSString*)tourID;

@end
