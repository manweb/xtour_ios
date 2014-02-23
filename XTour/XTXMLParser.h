//
//  XTXMLParser.h
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDataXMLNode.h"
#import <CoreLocation/CoreLocation.h>

@interface XTXMLParser : NSObject {
    
}

@property(nonatomic,retain) GDataXMLElement *Metadata;
@property(nonatomic,retain) GDataXMLElement *TrackSegment;

- (void) TestXML;
- (void) SetMetadataForUserID:(NSString *)uid TourID:(NSString *)tid StartTime:(NSDate *)time_start EndTime:(NSDate *)time_end Bounds:(NSArray *)bounds;
- (void) AddTrackpoint:(CLLocation *)coordinate;
- (void) SaveXML:(NSString *)filename;

@end
