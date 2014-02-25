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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_username release];
    [_password release];
    [super dealloc];
}

- (IBAction)Login {
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
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else {
        NSLog(@"There was a problem sending login information.");
    }
}

- (IBAction)Cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
