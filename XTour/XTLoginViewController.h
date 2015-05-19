//
//  XTLoginViewController.h
//  XTour
//
//  Created by Manuel Weber on 24/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "XTDataSingleton.h"

@interface XTLoginViewController : UIViewController
{
    XTDataSingleton *data;
}

@property (retain, nonatomic) UIView *loginView;
@property (retain, nonatomic) UITextField *username;
@property (retain, nonatomic) UITextField *password;
@property (retain, nonatomic) UIButton *loginButton;
@property (retain, nonatomic) UIButton *cancelButton;

- (void)Login;
- (void)Cancel;
- (void) animate;
- (void) ShowView;
- (void) HideView;

@end
