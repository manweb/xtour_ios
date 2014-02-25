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

@property (retain, nonatomic) IBOutlet UITextField *username;
@property (retain, nonatomic) IBOutlet UITextField *password;
- (IBAction)Login;
- (IBAction)Cancel;

@end
