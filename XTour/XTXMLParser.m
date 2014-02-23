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

- (void) TestXML
{
    GDataXMLElement *GPXElement = [GDataXMLNode elementWithName:@"gpx"];
    GDataXMLElement *Metadata = [GDataXMLNode elementWithName:@"Metadata"];
    GDataXMLElement *Author = [GDataXMLNode elementWithName:@"Author"];
    GDataXMLElement *Name = [GDataXMLNode elementWithName:@"Name" stringValue:@"Manuel Weber"];
    
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"version" stringValue:@"1.1"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xsi:schemaLocation" stringValue:@"http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns" stringValue:@"http://www.topografix.com/GPX/1/1"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:gpxtpx" stringValue:@"http://www.garmin.com/xmlschemas/TrackPointExtension/v1"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:gpxx" stringValue:@"http://www.garmin.com/xmlschemas/GpxExtensions/v3"]];
    [GPXElement addAttribute:[GDataXMLNode attributeWithName:@"xmlns:xsi" stringValue:@"http://www.w3.org/2001/XMLSchema-instance"]];
    
    [Author addChild:Name];
    [Metadata addChild:Author];
    [GPXElement addChild:Metadata];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:GPXElement];
    
    NSData *xmlData = doc.XMLData;
    NSString *xml = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    NSLog(xml);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"testXML.xml"];
    
    NSLog(documentsPath);
    
    [xmlData writeToFile:documentsPath atomically:YES];
}

- (void) SetMetadataForUserID:(NSString *)uid TourID:(NSString *)tid StartTime:(NSDate *)time_start EndTime:(NSDate *)time_end Bounds:(NSArray *)bounds
{
    if (!Metadata) {Metadata = [GDataXMLElement elementWithName:@"Metadata"];}
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-LL-dTHH:m:sZ"];
    
    GDataXMLElement *UserID = [GDataXMLElement elementWithName:@"userid" stringValue:uid];
    GDataXMLElement *TourID = [GDataXMLElement elementWithName:@"tourid" stringValue:tid];
    GDataXMLElement *StartTime = [GDataXMLElement elementWithName:@"StartTime" stringValue:[formatter stringFromDate:time_start]];
    GDataXMLElement *EndTime = [GDataXMLElement elementWithName:@"EndTime" stringValue:[formatter stringFromDate:time_end]];
    GDataXMLElement *Bounds = [GDataXMLElement elementWithName:@"bounds"];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"minlat" stringValue:[bounds objectAtIndex:0]]];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"minlon" stringValue:[bounds objectAtIndex:1]]];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"maxlat" stringValue:[bounds objectAtIndex:2]]];
    [Bounds addAttribute:[GDataXMLNode attributeWithName:@"maxlon" stringValue:[bounds objectAtIndex:3]]];
    
    [Metadata addChild:UserID];
    [Metadata addChild:TourID];
    [Metadata addChild:StartTime];
    [Metadata addChild:EndTime];
    [Metadata addChild:Bounds];
    
}

- (void) AddTrackpoint:(CLLocation *)coordinate
{
    if (!TrackSegment) {TrackSegment = [GDataXMLElement elementWithName:@"trkseg"];}
    
    double lat = coordinate.coordinate.latitude;
    double lon = coordinate.coordinate.longitude;
    double ele = coordinate.altitude;
    NSDate *time = coordinate.timestamp;
    
    NSString *latitude = [[NSString alloc] initWithFormat:@"%f", lat];
    NSString *longitude = [[NSString alloc] initWithFormat:@"%f", lon];
    NSString *elevation = [[NSString alloc] initWithFormat:@"%f", ele];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-LL-dTHH:m:sZ"];
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
