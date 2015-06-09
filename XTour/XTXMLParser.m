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
@synthesize Images;
@synthesize UserInfo;
@synthesize formatter;

- (XTXMLParser *) init
{
    if (self = [super init]) {
        Metadata = [GDataXMLElement elementWithName:@"Metadata"];
        TrackSegment = [GDataXMLElement elementWithName:@"trkseg"];
        Images = [GDataXMLElement elementWithName:@"images"];
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
    }
    
    return self;
}

- (void) SetMetadataString:(NSString *)value forKey:(NSString *)key
{
    if (!Metadata) {return;}
    
    GDataXMLElement *xmlElement = [GDataXMLElement elementWithName:key stringValue:value];
    
    [Metadata addChild:xmlElement];
}

- (void) SetMetadataDouble:(double)value forKey:(NSString *)key withPrecision:(int)precision
{
    if (!Metadata) {return;}
    
    NSString *precisionFormat = [NSString stringWithFormat:@"%%.%if",precision];
    
    GDataXMLElement *xmlElement = [GDataXMLElement elementWithName:key stringValue:[NSString stringWithFormat:precisionFormat, value]];
    
    [Metadata addChild:xmlElement];
}

- (void) SetMetadataDate:(NSDate *)date forKey:(NSString *)key
{
    if (!Metadata) {return;}
    if (!formatter) {return;}
    
    GDataXMLElement *xmlElement = [GDataXMLElement elementWithName:key stringValue:[formatter stringFromDate:date]];
    
    [Metadata addChild:xmlElement];
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

- (void) SaveRecoveryFile:(NSString *)filename
{
    GDataXMLElement *GPXElement = [GDataXMLNode elementWithName:@"xml"];
    
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

- (void) ReadGPXFile:(NSString *)filename
{
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filename];
    _RecoveredData = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
}

- (NSString *)GetValueFromFile:(NSString *)element
{
    if (!_RecoveredData) {return nil;}
    
    GDataXMLElement *metadata = [[_RecoveredData.rootElement elementsForName:@"Metadata"] objectAtIndex:0];
    GDataXMLElement *e = [[metadata elementsForName:element] objectAtIndex:0];
    
    return e.stringValue;
}

- (NSMutableArray *)GetLocationDataFromFile
{
    if (!_RecoveredData) {return nil;}
    
    GDataXMLElement *trackSegment = [[_RecoveredData.rootElement elementsForName:@"trk"] objectAtIndex:0];
    GDataXMLElement *track = [[trackSegment elementsForName:@"trkseg"] objectAtIndex:0];
    
    NSArray *trackPoints = [track elementsForName:@"trkpt"];
    
    NSMutableArray *locations = [[NSMutableArray alloc] init];
    
    for (GDataXMLElement *trkpt in trackPoints) {
        NSString *lat = [[trkpt attributeForName:@"lat"] stringValue];
        NSString *lon = [[trkpt attributeForName:@"lon"] stringValue];
        
        GDataXMLElement *elevation = [[trkpt elementsForName:@"ele"] objectAtIndex:0];
        GDataXMLElement *time = [[trkpt elementsForName:@"time"] objectAtIndex:0];
        
        NSString *ele = elevation.stringValue;
        NSString *t = time.stringValue;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-LL-dd HH:mm:ss"];
        NSDate *date = [dateFormatter dateFromString:t];
        
        CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(lat.floatValue, lon.floatValue);
        
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:coordinates altitude:ele.floatValue horizontalAccuracy:0 verticalAccuracy:0 timestamp:date];
        
        [locations addObject:location];
    }
    
    return locations;
}

- (void) AddImageInfo:(XTImageInfo *)imageInfo
{
    GDataXMLElement *image = [GDataXMLElement elementWithName:@"image"];
    
    NSArray *fnameString = [imageInfo.Filename componentsSeparatedByString:@"/"];
    NSString *fnameOriginal = [fnameString lastObject];
    NSString *fname = [fnameOriginal stringByReplacingOccurrencesOfString:@"_original.jpg" withString:@".jpg"];
    GDataXMLElement *filename = [GDataXMLElement elementWithName:@"filename" stringValue:fname];
    GDataXMLElement *longitude = [GDataXMLElement elementWithName:@"longitude" stringValue:[NSString stringWithFormat:@"%f",imageInfo.Longitude]];
    GDataXMLElement *latitude = [GDataXMLElement elementWithName:@"latitude" stringValue:[NSString stringWithFormat:@"%f",imageInfo.Latitude]];
    GDataXMLElement *elevation = [GDataXMLElement elementWithName:@"elevation" stringValue:[NSString stringWithFormat:@"%f",imageInfo.Elevation]];
    GDataXMLElement *comment = [GDataXMLElement elementWithName:@"comment" stringValue:imageInfo.Comment];
    GDataXMLElement *date = [GDataXMLElement elementWithName:@"date" stringValue:[formatter stringFromDate:imageInfo.Date]];
    
    [image addChild:filename];
    [image addChild:longitude];
    [image addChild:latitude];
    [image addChild:elevation];
    [image addChild:comment];
    [image addChild:date];
    
    [Images addChild:image];
}

- (void) SaveImageInfo:(NSString *)filename
{
    GDataXMLElement *XMLElement = [GDataXMLNode elementWithName:@"xml"];
    
    [XMLElement addChild:Images];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithRootElement:XMLElement];
    
    NSData *xmlData = doc.XMLData;
    NSString *xml = [[NSString alloc] initWithData:xmlData encoding:NSUTF8StringEncoding];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    [xmlData writeToFile:documentsPath atomically:YES];
}

- (XTUserInfo*) GetUserInfo:(NSString*)filename
{
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:filename];
    GDataXMLDocument *userInfoFile = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    
    GDataXMLElement *userInfo = [[userInfoFile.rootElement elementsForName:@"userdata"] objectAtIndex:0];
    
    XTUserInfo *info = [[XTUserInfo alloc] init];
    
    info.userID = [[[userInfo elementsForName:@"userID"] objectAtIndex:0] integerValue];
    info.userName = [[[userInfo elementsForName:@"userName"] objectAtIndex:0] stringValue];
    info.dateJoined = [[[userInfo elementsForName:@"dateJoined"] objectAtIndex:0] integerValue];
    info.timeThisSeason = [[[userInfo elementsForName:@"timeThisSeason"] objectAtIndex:0] integerValue];
    info.timeTotal = [[[userInfo elementsForName:@"totalTime"] objectAtIndex:0] integerValue];
    info.distanceThisSeason = [[[userInfo elementsForName:@"distanceThisSeason"] objectAtIndex:0] floatValue];
    info.distanceTotal = [[[userInfo elementsForName:@"distanceTotal"] objectAtIndex:0] floatValue];
    info.altitudeThisSeason = [[[userInfo elementsForName:@"altitudeThisSeason"] objectAtIndex:0] floatValue];
    info.altitudeTotal = [[[userInfo elementsForName:@"altitudeTotal"] objectAtIndex:0] floatValue];
    
    return info;
}

@end
