//
//  XTProfileViewController.m
//  XTour
//
//  Created by Manuel Weber on 03/06/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTProfileViewController.h"

@interface XTProfileViewController ()

@end

@implementation XTProfileViewController

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
    
    data = [XTDataSingleton singleObj];
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    _profileSummary = [[UIView alloc] initWithFrame:CGRectMake(5, 75, 310, 140)];
    
    _profileSummary.backgroundColor = [UIColor whiteColor];
    _profileSummary.layer.cornerRadius = 5.0f;
    
    _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    
    _profilePicture.image = [UIImage imageNamed:[data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO]];
    
    [_profileSummary addSubview:_profilePicture];
    [self.view addSubview:_profileSummary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
