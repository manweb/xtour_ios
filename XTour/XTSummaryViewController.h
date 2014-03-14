//
//  XTSummaryViewController.h
//  XTour
//
//  Created by Manuel Weber on 25/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTFileUploader.h"

@interface XTSummaryViewController : UIViewController
{
    XTDataSingleton *data;
}

- (IBAction)Close;

@end
