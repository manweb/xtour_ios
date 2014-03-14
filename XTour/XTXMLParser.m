//
//  XTXMLParser.m
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTXMLParser.h"

@implementation XTXMLParser

@synthesize Metadata;
@synthesize TrackSegment;
@synthesize formatter;

- (XTXMLParser *) init
{
    if (self = [super init]) {
        Metadata = [GDataXMLElement elementWithName:@"Metadata"];
        TrackSegment = [GDataXMLElement elementWithName:@"trkseg"];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
    }
    
    return self;
}

- (void) SetMetadataUserID:(NSString *)uid
{
    if (!Metadata) {return;}
    
    GDataXMLElement *UserID = [GDataXMLElement elementWithName:@"userid" stringValue:uid];
    
    [Metadata addChild:UserID];
}

- (void) SetMetadataTourID:(NSString *)tid
{
    if (!Metadata) {return;}
    
    GDataXMLElement *TourID = [GDataXMLElement elementWithName:@"tourid" stringValue:tid];
    
    [Metadata addChild:TourID];
}

- (void) SetMetadataStartDate:(NSDate *)time_start
{
    if (!Metadata) {return;}
    if (!formatter) {return;}
    
    GDataXMLElement *StartTime = [GDataXMLElement elementWithName:@"StartTime" stringValue:[formatter stringFromDate:time_start]];
    
    [Metadata addChild:StartTime];
}

- (void) SetMetadataEndDate:(NSDate *)time_end
{
    if (!Metadata) {return;}
    if (!formatter) {return;}
    
    GDataXMLElement *EndTime = [GDataXMLElement elementWithName:@"EndTime" stringValue:[formatter stringFromDate:time_end]];
    
    [Metadata addChild:EndTime];
}

- (void) SetMetadataBounds:(NSArray *)bounds
{
    if (!Metadata) {return;}
    
    GDataXMLElement *Bounds = [GDataXMLElement elementWithName:@"bounds"];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"minlat" stringValue:[bounds objectAtIndex:0]]];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"minlon" stringValue:[bounds objectAtIndex:1]]];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"maxlat" stringValue:[bounds objectAtIndex:2]]];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"maxlon" stringValue:[bounds objectAtIndex:3]]];
    
    [Metadata addChild:Bounds];
}

- (void) SetMetadataTotalTime:(int)time
{
    if (!Metadata) {return;}
    
    GDataXMLElement *TotalTime = [GDataXMLElement elementWithName:@"TotalTime" stringValue:[NSString stringWithFormat:@"%i", time]];
    
    [Metadata addChild:TotalTime];
}

- (void) SetMetadataTotalDistance:(double)distance
{
    if (!Metadata) {return;}
    
    GDataXMLElement *TotalDistance = [GDataXMLElement elementWithName:@"TotalDistance" stringValue:[NSString stringWithFormat:@"%.1f", distance]];
    
    [Metadata addChild:TotalDistance];
}

- (void) SetMetadataTotalAltitude:(double)altitude
{
    if (!Metadata) {return;}
    
    GDataXMLElement *TotalAltitude = [GDataXMLElement elementWithName:@"TotalAltitude" stringValue:[NSString stringWithFormat:@"%.0f", altitude]];
    
    [Metadata addChild:TotalAltitude];
}

- (void) AddTrackpoint:(CLLocation *)coordinate
{
    if (!TrackSegment) {return;}
    if (!formatter) {return;}
    
    double lat = coordinate.coordinate.latitude;
    double lon = coordinate.coordinate.longitude;
    double ele = coordinate.altitude;
    NSDate *time = coordinate.timestamp;
    
    NSString *latitude = [[NSString alloc] initWithFormat:@"%f", lat];
    NSString *longitude = [[NSString alloc] initWithFormat:@"%f", lon];
    NSString *elevation = [[NSString alloc] initWithFormat:@"%f", ele];
    
    NSString *timestamp = [formatter stringFromDate:time];
    
    GDataXMLElement *TrackPoint = [GDataXMLElement elementWithName:@"trkpt"];
    [TrackPoint addAttribute:[GDataXMLNode attributeWithName:@"lat" stringValue:latitude]];
    [TrackPoint addAttribute:[GDataXMLNode attributeWithName:@"lon" stringValue:longitude]];
    
    GDataXMLElement *Elevation = [GDataXMLElement elementWithName:@"ele" stringValue:elevation];
    GDataXMLElement *Time = [GDataXMLElement elementWithName:@"time" stringValue:timestamp];
    
    [TrackPoint addChild:Elevation];
    [TrackPoint addChild:Time];
    [TrackSegment addChild:TrackPoint];
}

- (void) SaveXML:(NSString *)filename
{
    GDataXMLElement *GPXElement = [GDataXMLNode elementWithName:@"gpx"];
    
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"version" stringValue:@"1.1"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xsi:schemaLocation" stringValue:@"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns" stringValue:@"http://www.topografix.com/GPX/1/1"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:gpxtpx" stringValue:@"http://www.garmin.com/xmlschemas/TrackPointExtension/v1"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:gpxx" stringValue:@"http://www.garmin.com/xmlschemas/GpxExtensions/v3"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:xsi" stringValue:@"http://www.w3.org/2001/XMLSchema-instance"]];
    
    GDataXMLElement *Track = [GDataXMLElement elementWithName:@"trk"];
    [Track addChild:TrackSegment];
    [GPXElement addChild:Metadata];
    [GPXElement addChild:Track];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:GPXElement];
    
    NSData *xmlData = doc.XMLData;
    NSString *xml = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    [xmlData writeToFile:documentsPath atomically:YES];
}

@end
