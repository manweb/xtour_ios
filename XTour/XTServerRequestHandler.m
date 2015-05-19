//
//  XTServerRequestHandler.m
//  XTour
//
//  Created by Manuel Weber on 08/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTServerRequestHandler.h"

@implementation XTServerRequestHandler

- (NSMutableArray *) GetNewsFeedString:(int)numberOfNewsFeeds
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_news_feed_string.php?num=%i", numberOfNewsFeeds];
    NSURL *url = [NSURL URLWithString:requestString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    
    NSMutableArray *news_feeds = [[NSMutableArray alloc] init];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSArray *news_feed_array = [response componentsSeparatedByString:@";"];
        
        for (int i = 0; i < [news_feed_array count] - 1; i++) {
            NSString *elements = [news_feed_array objectAtIndex:i];
            NSArray *element = [elements componentsSeparatedByString:@","];
            
            if ([element count] < 13) {continue;}
            
            XTTourInfo *tourInfo = [[XTTourInfo alloc] init];
            
            tourInfo.tourID = [element objectAtIndex:0];
            tourInfo.userID = [element objectAtIndex:1];
            tourInfo.userName = [element objectAtIndex:2];
            tourInfo.profilePicture = [element objectAtIndex:3];
            tourInfo.date = [[element objectAtIndex:4] integerValue];
            tourInfo.totalTime = [[element objectAtIndex:5] integerValue];
            tourInfo.altitude = [[element objectAtIndex:6] floatValue];
            tourInfo.distance = [[element objectAtIndex:7] floatValue];
            tourInfo.descent = [[element objectAtIndex:8] floatValue];
            tourInfo.lowestPoint = [[element objectAtIndex:9] floatValue];
            tourInfo.highestPoint = [[element objectAtIndex:10] floatValue];
            tourInfo.latitude = [[element objectAtIndex:11] floatValue];
            tourInfo.longitude = [[element objectAtIndex:12] floatValue];
            
            [news_feeds addObject:tourInfo];
        }
    }
    else {
        NSLog(@"There was a problem retrieving the news feed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    return news_feeds;
}

- (NSMutableArray *) GetTourFilesForTour:(NSString *)tourID andType:(NSString *)type
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_tour_files_string.php?tid=%@&type=%@", tourID, type];
    NSURL *url = [NSURL URLWithString:requestString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    
    NSMutableArray *tour_files = nil;
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSArray *tour_files_array = [response componentsSeparatedByString:@";"];
        tour_files = [NSMutableArray arrayWithArray:tour_files_array];
        [tour_files removeLastObject];
    }
    else {
        NSLog(@"There was a problem retrieving the tour files");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    return tour_files;
}

- (NSMutableArray *) GetCoordinatesForFile:(NSString *)file
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_tour_coordinates_string.php?file=%@", file];
    NSURL *url = [NSURL URLWithString:requestString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    
    NSMutableArray *coordinatesTMP = nil;
    NSMutableArray *coordinates = [[NSMutableArray alloc] init];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSArray *coordinates_array = [response componentsSeparatedByString:@";"];
        coordinatesTMP = [NSMutableArray arrayWithArray:coordinates_array];
        [coordinatesTMP removeLastObject];
        
        for (int i = 0; i < [coordinatesTMP count]; i++) {
            NSString *currentCoordinate = [coordinatesTMP objectAtIndex:i];
            
            NSArray *LatLon = [currentCoordinate componentsSeparatedByString:@":"];
            float lon = [[LatLon objectAtIndex:0] doubleValue];
            float lat = [[LatLon objectAtIndex:1] doubleValue];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
            
            [coordinates addObject:location];
        }
    }
    else {
        NSLog(@"There was a problem retrieving the tour coordinates");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    return coordinates;
}

- (NSMutableArray *) GetImagesForTour:(NSString *)tourID
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_tour_images_string.php?tid=%@", tourID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    
    NSMutableArray *tour_images = [[NSMutableArray alloc] init];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSArray *tour_images_array = [response componentsSeparatedByString:@";"];
        NSMutableArray *tour_images_info = [NSMutableArray arrayWithArray:tour_images_array];
        [tour_images_info removeLastObject];
        
        for (int i = 0; i < [tour_images_info count]; i++) {
            XTImageInfo *imageInfo = [[XTImageInfo alloc] init];
            
            NSString *currentImage = [tour_images_info objectAtIndex:i];
            
            NSArray *imageInfoArray = [currentImage componentsSeparatedByString:@","];
            
            if ([imageInfoArray count] < 6) {continue;}
            
            imageInfo.Filename = [imageInfoArray objectAtIndex:0];
            imageInfo.Date = [imageInfoArray objectAtIndex:1];
            imageInfo.Longitude = [[imageInfoArray objectAtIndex:2] floatValue];
            imageInfo.Latitude = [[imageInfoArray objectAtIndex:3] floatValue];
            imageInfo.Elevation = [[imageInfoArray objectAtIndex:4] floatValue];
            imageInfo.Comment = [imageInfoArray objectAtIndex:5];
            
            [tour_images addObject:imageInfo];
        }
    }
    else {
        NSLog(@"There was a problem retrieving the tour images");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    return tour_images;
}

@end
