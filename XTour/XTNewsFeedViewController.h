//
//  XTNewsFeedViewController.h
//  XTour
//
//  Created by Manuel Weber on 07/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTServerRequestHandler.h"

@interface XTNewsFeedViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource>
{
    XTServerRequestHandler *ServerHandler;
}

@property (nonatomic,retain) NSMutableArray *news_feed;
@property (nonatomic,retain) NSMutableArray *profile_pictures;

@end
