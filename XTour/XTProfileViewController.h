//
//  XTProfileViewController.h
//  XTour
//
//  Created by Manuel Weber on 03/06/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"

@interface XTProfileViewController : UIScrollView
{
    XTDataSingleton *data;
}

@property (retain, nonatomic) UIView *profileSummary;
@property (retain, nonatomic) UIImageView *profilePicture;
@property (retain, nonatomic) UILabel *userName;

- (void)initialize;

@end
