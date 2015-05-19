//
//  XTNewsFeedViewController.h
//  XTour
//
//  Created by Manuel Weber on 16/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTServerRequestHandler.h"
#import "XTNewsFeedCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XTNavigationViewContainer.h"
#import "XTTourDetailView.h"
#import "XTTourInfo.h"

@interface XTNewsFeedViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    XTServerRequestHandler *ServerHandler;
    UIRefreshControl *refreshControl;
    XTNavigationViewContainer *navigationView;
}

@property (nonatomic,retain) NSMutableArray *news_feed;
@property (nonatomic,retain) NSMutableArray *profile_pictures;

- (void) refreshNewsFeed;

@end
