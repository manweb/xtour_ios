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

@interface XTWarnigsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
}

@property(nonatomic,retain) NSMutableArray *listOfFiles;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
- (IBAction)LoadLogin:(id)sender;

@end
