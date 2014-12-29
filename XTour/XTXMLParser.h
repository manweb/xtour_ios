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
@property(nonatomic,retain) NSDateFormatter *formatter;

- (void) SetMetadataUserID:(NSString *)uid;
- (void) SetMetadataTourID:(NSString *)tid;
- (void) SetMetadataStartDate:(NSDate *)time_start;
- (void) SetMetadataEndDate:(NSDate *)time_end;
- (void) SetMetadataBounds:(NSArray *)bounds;
- (void) SetMetadataTotalTime:(int)time;
- (void) SetMetadataTotalDistance:(double)distance;
- (void) SetMetadataTotalAltitude:(double)altitude;
- (void) SetMetadataTotalDescent:(double)descent;
- (void) AddTrackpoint:(CLLocation *)coordinate;
- (void) SaveXML:(NSString *)filename;

@end
