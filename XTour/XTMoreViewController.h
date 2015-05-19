//
//  XTMoreViewController.h
//  XTour
//
//  Created by Manuel Weber on 19/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTLoginViewController.h"
#import "XTNewsFeedViewController.h"
#import "XTNavigationViewContainer.h"
#import "XTFileUploader.h"

@interface XTMoreViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
    XTNewsFeedViewController *collection;
    XTNavigationViewContainer *navigationView;
}

@property(nonatomic,retain) NSMutableArray *listOfFiles;
@property(nonatomic,retain) NSMutableArray *listOfIcons;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property(nonatomic,retain) UIView *detailView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)back:(id)sender;
- (IBAction)loadLogin:(id)sender;

@end
