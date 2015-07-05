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
#import "XTWarningsInfo.h"
#import "XTServerRequestHandler.h"
#import "XTWarningCell.h"

@interface XTWarnigsViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
    UIRefreshControl *refreshControl;
}

@property (retain, nonatomic) UIView *header;
@property (retain, nonatomic) UIView *header_shadow;
@property (retain, nonatomic) UIView *background;
@property (retain, nonatomic) UILabel *emptyLabel;
@property (retain, nonatomic) UIButton *loginButton;
@property (retain, nonatomic) NSMutableArray *warningsArray;

- (void)LoadLogin:(id)sender;
- (void)UpdateWarnings:(id)sender;

@end
