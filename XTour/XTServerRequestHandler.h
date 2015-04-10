//
//  XTServerRequestHandler.h
//  XTour
//
//  Created by Manuel Weber on 08/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface XTServerRequestHandler : NSObject

- (NSMutableArray *) GetNewsFeedString:(int)numberOfNewsFeeds;

@end
