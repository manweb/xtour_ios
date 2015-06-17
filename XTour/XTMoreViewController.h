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
#import "XTSettingsViewController.h"
#import "XTProfileViewController.h"

@interface XTMoreViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
    XTNewsFeedViewController *collection;
    XTNavigationViewContainer *navigationView;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UIView *header;
@property (retain, nonatomic) IBOutlet UIView *header_shadow;
@property(nonatomic,retain) NSMutableArray *listOfFiles;
@property(nonatomic,retain) NSMutableArray *listOfIcons;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property(nonatomic,retain) UIView *detailView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)back:(id)sender;
- (void)LoadLogin:(id)sender;
- (void)ShowLoginOptions:(id)sender;
- (void)LoginViewDidClose:(id)sender;

@end
