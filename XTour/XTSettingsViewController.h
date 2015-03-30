//
//  XTSettingsViewController.h
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTFileUploader.h"
#import "XTSummaryViewController.h"

@interface XTSettingsViewController : UIViewController
{
    XTSummaryViewController *summary;
}

- (IBAction)GetFileList:(id)sender;
- (IBAction)ShowSummary:(id)sender;

@end
