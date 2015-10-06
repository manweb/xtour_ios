//
//  XTCalendarPageViewController.h
//  XTour
//
//  Created by Manuel Weber on 26/09/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XTCalendarViewController.h"

@interface XTCalendarPageViewController : UIViewController<UIPageViewControllerDataSource>

@property (nonatomic,retain) UIPageViewController *pageController;

- (XTCalendarViewController*)viewControllerAtIndex:(NSUInteger)index;

@end
