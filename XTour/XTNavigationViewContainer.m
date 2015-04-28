//
//  XTNavigationViewContainer.m
//  XTour
//
//  Created by Manuel Weber on 28/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTNavigationViewContainer.h"

@interface XTNavigationViewContainer ()

@end

@implementation XTNavigationViewContainer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 25, 40, 40)];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [_backButton setImage:[UIImage imageNamed:@"arrow_back@3x.png"] forState:UIControlStateNormal];
    [_backButton setHidden:YES];
    
    [self.view addSubview:_backButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) back:(id)sender
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    [_backButton setHidden:YES];
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {self.view.frame = CGRectMake(2*width, 0, width, height);} completion:^(bool finished) {[self.view removeFromSuperview];}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
