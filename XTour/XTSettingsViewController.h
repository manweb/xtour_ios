//
//  XTSettingsViewController.h
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) UITextView *info;
@property (nonatomic,retain) NSDictionary *tableArrays;
@property (nonatomic,retain) NSArray *sectionTitles;
@property (nonatomic,retain) NSArray *sectionFooter;
@property (nonatomic) NSInteger selectedIndex;

@end
