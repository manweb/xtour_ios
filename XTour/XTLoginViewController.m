//
//  XTLoginViewController.m
//  XTour
//
//  Created by Manuel Weber on 24/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTLoginViewController.h"

@interface XTLoginViewController ()

@end

@implementation XTLoginViewController

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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    data = [XTDataSingleton singleObj];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    self.view.frame = CGRectMake(0, 0, width, height+tabBarHeight);
    self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    
    _loginView = [[UIView alloc] initWithFrame:CGRectMake(280, 30, 0, 0)];
    _loginView.layer.cornerRadius = 10.0f;
    _loginView.layer.borderWidth = 5.0f;
    _loginView.layer.borderColor = [UIColor grayColor].CGColor;
    _loginView.backgroundColor = [UIColor whiteColor];
    
    _username = [[UITextField alloc] initWithFrame:CGRectMake(50, 50, 200, 30)];
    _password = [[UITextField alloc] initWithFrame:CGRectMake(50, 100, 200, 30)];
    
    _username.borderStyle = UITextBorderStyleRoundedRect;
    _password.borderStyle = UITextBorderStyleRoundedRect;
    
    _username.placeholder = @"Username";
    _password.placeholder = @"Password";
    
    _password.secureTextEntry = YES;
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginButton.frame = CGRectMake(100, 150, 100, 20);
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _cancelButton.frame = CGRectMake(220, 10, 80, 20);
    
    [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    [_loginButton addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
    [_cancelButton addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    
    [_username setAlpha:0.0f];
    [_password setAlpha:0.0f];
    [_loginButton setAlpha:0.0f];
    [_cancelButton setAlpha:0.0f];
    
    [_loginView addSubview:_username];
    [_loginView addSubview:_password];
    [_loginView addSubview:_loginButton];
    [_loginView addSubview:_cancelButton];
    
    [self.view addSubview:_loginView];
    
    [_username release];
    [_password release];
    [_loginButton release];
    [_cancelButton release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_username release];
    [_password release];
    [_loginButton release];
    [_cancelButton release];
    [super dealloc];
}

- (void)Login {
    NSString *requestString = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/validate_login.php?uid=%s&pwd=%s", [_username.text UTF8String], [_password.text UTF8String]];
    NSURL *url = [NSURL URLWithString:requestString];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        NSString *response = [request responseString];
        if ([response isEqualToString:@"false"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"Incorrect login." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
            data.loggedIn = false;
        }
        else {
            data.loggedIn = true;
            
            NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
            NSString *userFile = [data GetDocumentFilePathForFile:@"/user.nfo" CheckIfExist:NO];
            
            data.userID = response;
            [response writeToFile:userFile atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            NSString *requestString2 = [[NSString alloc] initWithFormat:@"http://www.xtour.ch/users/%s/profile.png", [response UTF8String]];
            NSURL *url2 = [NSURL URLWithString:requestString2];
            ASIHTTPRequest *request2 = [ASIHTTPRequest requestWithURL:url2];
            [request2 setDownloadDestinationPath:tempPath];
            [request2 startSynchronous];
            NSError *error2 = [request2 error];
            if (error2) {NSLog(@"There was an error downloading the profile picture.");}
            [self Cancel];
        }
    }
    else {
        NSLog(@"There was a problem sending login information.");
    }
}

- (void)Cancel {
    [self HideView];
}

- (void) animate
{
    [self ShowView];
}

- (void) ShowView
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8f];
        _loginView.frame = CGRectMake(0, 70, 320, 220);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_loginView.frame = CGRectMake(15, 85, 290, 190);} completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
                _loginView.frame = CGRectMake(10, 80, 300, 200);
                
                [_username setAlpha:1.0f];
                [_password setAlpha:1.0f];
                [_loginButton setAlpha:1.0f];
                [_cancelButton setAlpha:1.0f];
            } completion:NULL
             ];
        }];
    }];
}

- (void) HideView
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        self.view.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
        _loginView.frame = CGRectMake(280, 30, 0, 0);
        
        [_username setAlpha:0.0f];
        [_password setAlpha:0.0f];
        [_loginButton setAlpha:0.0f];
        [_cancelButton setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

@end
