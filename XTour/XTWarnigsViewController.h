//
//  XTWarnigsViewController.h
//  XTour
//
//  Created by Manuel Weber on 22/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTLoginViewController.h"

@interface XTWarnigsViewController : UIViewController <UIActionSheetDelegate, UITableViewDelegate, UITableViewDataSource>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
}

@property (retain, nonatomic) IBOutlet UIView *header;
@property (retain, nonatomic) IBOutlet UIView *header_shadow;
@property (retain, nonatomic) UIView *background;
@property (retain, nonatomic) UILabel *emptyLabel;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *warningsArray;

- (void)LoadLogin:(id)sender;

@end
