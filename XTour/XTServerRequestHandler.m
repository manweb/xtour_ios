//
//  XTServerRequestHandler.m
//  XTour
//
//  Created by Manuel Weber on 08/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTServerRequestHandler.h"

@implementation XTServerRequestHandler

- (NSMutableArray *) GetNewsFeedString:(NSData*)responseData
{
    /*NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_news_feed_string.php?num=%i&uid=%@&filter=%i", numberOfNewsFeeds, uid, filter];
    NSURL *url = [NSURL URLWithString:requestString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];*/
    
    NSMutableArray *news_feeds = [[[NSMutableArray alloc] init] autorelease];
    
    //NSError *error = [request error];
    //if (!error) {
        //NSString *response = [request responseString];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSArray *news_feed_array = [response componentsSeparatedByString:@";"];
        
        for (int i = 0; i < [news_feed_array count] - 1; i++) {
            NSString *elements = [news_feed_array objectAtIndex:i];
            NSArray *element = [elements componentsSeparatedByString:@","];
            
            if ([element count] < 17) {continue;}
            
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
            tourInfo.country = [element objectAtIndex:13];
            tourInfo.province = [element objectAtIndex:14];
            
            NSString *tourDescriptionEncoded = [element objectAtIndex:15];
            tourDescriptionEncoded = [tourDescriptionEncoded stringByReplacingOccurrencesOfString:@"+" withString:@" "];
            tourInfo.tourDescription = [tourDescriptionEncoded stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            tourInfo.tourRating = [[element objectAtIndex:16] integerValue];
            
            [news_feeds addObject:tourInfo];
            
            [tourInfo release];
        }
    /*}
    else {
        NSLog(@"There was a problem retrieving the news feed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [requestString release];*/
    
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
    
    [requestString release];
    
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

- (void) ProcessTourCoordinates:(NSData*)responseData
{
    _tourFilesType = [[NSMutableArray alloc] init];
    _tourFilesCoordinates = [[NSMutableArray alloc] init];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSArray *files_array = [response componentsSeparatedByString:@"/"];
    NSMutableArray *files = [NSMutableArray arrayWithArray:files_array];
    [files removeLastObject];
    
    for (int i = 0; i < [files count]; i++) {
        NSString *currentFile = [files objectAtIndex:i];
        
        NSArray *coordinates_array = [currentFile componentsSeparatedByString:@";"];
        NSMutableArray *coordinates = [NSMutableArray arrayWithArray:coordinates_array];
        [coordinates removeLastObject];
        
        NSString *tourType = [coordinates objectAtIndex:0];
        [_tourFilesType addObject:tourType];
        
        NSMutableArray *currentTourCoordinate = [[NSMutableArray alloc] init];
        
        for (int k = 1; k < [coordinates count]; k++) {
            NSString *currentCoordinate = [coordinates objectAtIndex:k];
            
            NSArray *LatLon = [currentCoordinate componentsSeparatedByString:@":"];
            float lon = [[LatLon objectAtIndex:0] floatValue];
            float lat = [[LatLon objectAtIndex:1] floatValue];
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
            
            [currentTourCoordinate addObject:location];
        }
        
        [_tourFilesCoordinates addObject:currentTourCoordinate];
        
        [currentTourCoordinate release];
    }
}

- (NSMutableArray *) GetImagesForTour:(NSData*)responseData
{
    /*NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_tour_images_string.php?tid=%@", tourID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];*/
    
    NSMutableArray *tour_images = [[NSMutableArray alloc] init];
    
    //NSError *error = [request error];
    //if (!error) {
        //NSString *response = [request responseString];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSArray *tour_images_array = [response componentsSeparatedByString:@";"];
        NSMutableArray *tour_images_info = [NSMutableArray arrayWithArray:tour_images_array];
        [tour_images_info removeLastObject];
        
        for (int i = 0; i < [tour_images_info count]; i++) {
            XTImageInfo *imageInfo = [[XTImageInfo alloc] init];
            
            NSString *currentImage = [tour_images_info objectAtIndex:i];
            
            NSArray *imageInfoArray = [currentImage componentsSeparatedByString:@","];
            
            if ([imageInfoArray count] < 8) {continue;}
            
            imageInfo.userID = [imageInfoArray objectAtIndex:0];
            imageInfo.tourID = [imageInfoArray objectAtIndex:1];
            imageInfo.Filename = [imageInfoArray objectAtIndex:2];
            imageInfo.Date = [imageInfoArray objectAtIndex:3];
            imageInfo.Longitude = [[imageInfoArray objectAtIndex:4] floatValue];
            imageInfo.Latitude = [[imageInfoArray objectAtIndex:5] floatValue];
            imageInfo.Elevation = [[imageInfoArray objectAtIndex:6] floatValue];
            imageInfo.Comment = [imageInfoArray objectAtIndex:7];
            
            [tour_images addObject:imageInfo];
            
            [imageInfo release];
        }
    /*}
    else {
        NSLog(@"There was a problem retrieving the tour images");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }*/
    
    return tour_images;
}

- (NSMutableArray*) GetWarningsWithinRadius:(NSData*)responseData
{
    /*NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_warnings_string.php?radius=%f&longitude=%f&latitude=%f", radius, longitude, latitude];
    NSURL *url = [NSURL URLWithString:requestString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];*/
    
    NSMutableArray *warnings = [[NSMutableArray alloc] init];
    
    //NSError *error = [request error];
    //if (!error) {
        //NSString *response = [request responseString];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        if ([response isEqualToString:@"false"]) {return nil;}
        
        NSArray *warnings_array = [response componentsSeparatedByString:@";"];
        NSMutableArray *warnings_info = [NSMutableArray arrayWithArray:warnings_array];
        [warnings_info removeLastObject];
        
        for (int i = 0; i < [warnings_info count]; i++) {
            XTWarningsInfo *warningsInfo = [[XTWarningsInfo alloc] init];
            
            NSString *currentWarning = [warnings_info objectAtIndex:i];
            
            NSArray *warningsInfoArray = [currentWarning componentsSeparatedByString:@","];
            
            if ([warningsInfoArray count] < 9) {continue;}
            
            warningsInfo.userID = [warningsInfoArray objectAtIndex:0];
            warningsInfo.userName = [warningsInfoArray objectAtIndex:1];
            warningsInfo.submitDate = [warningsInfoArray objectAtIndex:2];
            warningsInfo.category = [[warningsInfoArray objectAtIndex:3] integerValue];
            warningsInfo.longitude = [[warningsInfoArray objectAtIndex:4] floatValue];
            warningsInfo.latitude = [[warningsInfoArray objectAtIndex:5] floatValue];
            warningsInfo.elevation = [[warningsInfoArray objectAtIndex:6] floatValue];
            warningsInfo.comment = [warningsInfoArray objectAtIndex:7];
            warningsInfo.distance = [[warningsInfoArray objectAtIndex:8] floatValue];
            
            [warnings addObject:warningsInfo];
            
            [warningsInfo release];
        }
    /*}
    else {
        NSLog(@"There was a problem retrieving the warnings");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }*/
    
    return warnings;
}

- (XTUserStatistics*) GetUserStatistics:(NSData*)responseData
{
    /*NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_user_statistics.php?uid=%@", userID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];*/
    
    XTUserStatistics *userStatistics = [[XTUserStatistics alloc] init];
    
    //NSError *error = [request error];
    //if (!error) {
        //NSString *response = [request responseString];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSArray *userStatistics_array = [response componentsSeparatedByString:@";"];
        
        for (int i = 0; i < [userStatistics_array count]; i++) {
            if ([userStatistics_array count] > 12) {return nil;}
            
            userStatistics.monthlyNumberOfTours = [[userStatistics_array objectAtIndex:0] integerValue];
            userStatistics.monthlyTime = [[userStatistics_array objectAtIndex:1] integerValue];
            userStatistics.monthlyDistance = [[userStatistics_array objectAtIndex:2] floatValue];
            userStatistics.monthlyAltitude = [[userStatistics_array objectAtIndex:3] floatValue];
            userStatistics.seasonalNumberOfTours = [[userStatistics_array objectAtIndex:4] integerValue];
            userStatistics.seasonalTime = [[userStatistics_array objectAtIndex:5] integerValue];
            userStatistics.seasonalDistance = [[userStatistics_array objectAtIndex:6] floatValue];
            userStatistics.seasonalAltitude = [[userStatistics_array objectAtIndex:7] floatValue];
            userStatistics.totalNumberOfTours = [[userStatistics_array objectAtIndex:8] integerValue];
            userStatistics.totalTime = [[userStatistics_array objectAtIndex:9] integerValue];
            userStatistics.totalDistance = [[userStatistics_array objectAtIndex:10] floatValue];
            userStatistics.totalAltitude = [[userStatistics_array objectAtIndex:11] floatValue];
        }
    /*}
    else {
        NSLog(@"There was a problem retrieving the user statistics");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [requestString release];*/
    
    return userStatistics;
}

- (NSMutableArray *) GetYearlyStatistics:(NSData*)responseData
{
    /*NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/get_yearly_statistics.php?uid=%@", userID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];*/
    
    NSMutableArray *yearlyStatistics = nil;
    
    //NSError *error = [request error];
    //if (!error) {
        //NSString *response = [request responseString];
    
    NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        NSArray *userStatistics_array = [response componentsSeparatedByString:@";"];
        
        if ([userStatistics_array count] != 53) {return nil;}
        
        yearlyStatistics = [[NSMutableArray alloc] initWithArray:userStatistics_array];
        
        [yearlyStatistics removeLastObject];
    /*}
    else {
        NSLog(@"There was a problem retrieving the user statistics");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    [requestString release];*/
    
    yearlyStatistics = [[[yearlyStatistics reverseObjectEnumerator] allObjects] mutableCopy];
    
    return yearlyStatistics;
}

- (BOOL) SubmitImageComment:(NSString *)comment forImage:(NSString *)imageID
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/insert_image_comment.php?image=%@&comment=%@", imageID, [comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:requestString];
    
    /*ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        if ([response isEqualToString:@"true"]) {return true;}
        else {return false;}
    }
    else {
        NSLog(@"There was a problem submitting the image comment");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }*/
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [sessionTask resume];
    
    return true;
}

- (BOOL) SubmitWarningInfo:(XTWarningsInfo *)warningInfo
{
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/insert_warning_info.php?userID=%@&tourID=%@&date=%@&longitude=%.5f&latitude=%.5f&elevation=%.5f&category=%lu&comment=%@", warningInfo.userID, warningInfo.tourID, warningInfo.submitDate, warningInfo.longitude, warningInfo.latitude, warningInfo.elevation, (unsigned long)warningInfo.category, [warningInfo.comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:requestString];
    
    /*ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        if ([response isEqualToString:@"true"]) {return true;}
        else {return false;}
    }
    else {
        NSLog(@"There was a problem submitting the warning info");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }*/
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [sessionTask resume];
    
    return true;
}

- (BOOL) DownloadProfilePicture:(NSString*)userID
{
    BOOL success = false;
    
    if (!data) {data = [XTDataSingleton singleObj];}
    
    NSString *filePath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/users/%@/profile.png", userID];
    NSURL *url = [NSURL URLWithString:requestString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:filePath];
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {success = true;}
    else {NSLog(@"There was a problem downloading the profile picture.");}
    
    return success;
}

- (BOOL) DownloadUserInfo:(NSString*)userID
{
    BOOL success = false;
    
    if (!data) {data = [XTDataSingleton singleObj];}
        
        NSString *filePath = [data GetDocumentFilePathForFile:@"/UserInfo.xml" CheckIfExist:NO];
        
        NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/users/%@/UserInfo.xml", userID];
        NSURL *url = [NSURL URLWithString:requestString];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDownloadDestinationPath:filePath];
        [request startSynchronous];
        
        NSError *error = [request error];
        if (!error) {success = true;}
        else {NSLog(@"There was a problem downloading the user info file.");}
        
        return success;
}

- (void) CheckGraphsForTour:(NSString*)tourID
{
    /*NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/create_graphs.php?tid=%@", tourID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    NSLog(@"%@",requestString);
    [requestString release];*/
    
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/create_graphs.php?tid=%@", tourID];
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *sessionTask = [session dataTaskWithRequest:[NSURLRequest requestWithURL:url]];
    
    [sessionTask resume];
}

@end
