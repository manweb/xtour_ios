//
//  XTSettingsViewController.m
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTSettingsViewController.h"

@interface XTSettingsViewController ()

@end

@implementation XTSettingsViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GetFileList:(id)sender {
    XTFileUploader *uploader = [[XTFileUploader alloc] init];
    
    [uploader UploadGPXFiles];
    [uploader UploadImages];
}

- (IBAction)ShowSummary:(id)sender {
    if (!summary) {summary = [[XTSummaryViewController alloc] initWithNibName:nil bundle:nil];}
    
    [self presentViewController:summary animated:YES completion:nil];
    [summary release];
    
    summary = nil;
}

- (IBAction)ShowNewsFeed:(id)sender {
    if (!NewsFeed) {NewsFeed = [[XTNewsFeedViewController alloc] initWithNibName:nil bundle:nil];}
    
    [self presentViewController:NewsFeed animated:YES completion:nil];
    [NewsFeed release];
    
    NewsFeed = nil;
}

@end
