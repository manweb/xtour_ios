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
    
    float boxWidth = width - 20;
    float boxRadius = 5.f;
    float boxBorderWidth = 1.0f;
    float boxMarginLeft = 10.0f;
    float boxMarginTop = 75.0f;
    UIColor *boxBorderColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    _profileSummary = [[UIView alloc] initWithFrame:CGRectMake(boxMarginLeft, boxMarginTop, boxWidth, 140)];
    
    _profileSummary.backgroundColor = [UIColor whiteColor];
    _profileSummary.layer.cornerRadius = boxRadius;
    _profileSummary.layer.borderWidth = boxBorderWidth;
    _profileSummary.layer.borderColor = boxBorderColor.CGColor;
    
    _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    
    if (data.loggedIn) {
        _profilePicture.image = [UIImage imageNamed:[data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO]];
    }
    else {
        _profilePicture.image = [UIImage imageNamed:@"profile_icon_gray.png"];
    }
    
    _userName = [[UILabel alloc] initWithFrame:CGRectMake(55, 15, 255, 20)];
    
    _userName.font = [UIFont fontWithName:@"Helvetica-BoldMT" size:12];
    _userName.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    
    if (data.loggedIn) {
        _userName.text = data.userInfo.userName;
    }
    else {
        _userName.text = @"Nicht eingelogged";
    }
    
    [_profileSummary addSubview:_profilePicture];
    [_profileSummary addSubview:_userName];
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
