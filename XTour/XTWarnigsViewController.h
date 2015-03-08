//
//  XTWarnigsViewController.h
//  XTour
//
//  Created by Manuel Weber on 22/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"

@interface XTWarnigsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    XTDataSingleton *data;
}

@property(nonatomic,retain) NSMutableArray *listOfFiles;

@end
