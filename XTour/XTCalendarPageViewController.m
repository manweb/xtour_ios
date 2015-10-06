//
//  XTCalendarPageViewController.m
//  XTour
//
//  Created by Manuel Weber on 26/09/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import "XTCalendarPageViewController.h"

@implementation XTCalendarPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    
    XTCalendarViewController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.view addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_pageController release];
    [super dealloc];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(XTCalendarViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(XTCalendarViewController *)viewController index];
    
    index++;
    
    return [self viewControllerAtIndex:index];
    
}

- (XTCalendarViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    XTCalendarViewController *calendarViewController = [[XTCalendarViewController alloc] initWithNibName:nil bundle:nil];
    
    calendarViewController.view.frame = self.view.frame;
    
    calendarViewController.index = index;
    
    [calendarViewController LoadCalendarAtIndex:index];
    
    return calendarViewController;
}

@end
