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

@interface XTServerRequestHandler : NSObject

- (NSMutableArray *) GetNewsFeedString:(int)numberOfNewsFeeds;
- (NSMutableArray *) GetTourFilesForTour:(NSString *)tourID andType:(NSString *)type;
- (NSMutableArray *) GetCoordinatesForFile:(NSString *)file;
- (NSMutableArray *) GetImagesForTour:(NSString *)tourID;

@end
