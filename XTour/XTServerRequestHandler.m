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
    
    NSMutableArray *news_feeds = nil;
    
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        
        NSArray *news_feed_array = [response componentsSeparatedByString:@";"];
        news_feeds = [NSMutableArray arrayWithArray:news_feed_array];
        [news_feeds removeLastObject];
    }
    else {
        NSLog(@"There was a problem retrieving the news feed");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" message:@"Verbindung zum Server ist fehlgeschlagen." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
    return news_feeds;
}

@end
