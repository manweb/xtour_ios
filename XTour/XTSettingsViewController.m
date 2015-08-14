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
    
    self.view.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    _info = [[UITextView alloc] initWithFrame:CGRectMake(10, 80, 300, 200)];
    
    _info.backgroundColor = [UIColor clearColor];
    _info.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _info.font = [UIFont fontWithName:@"Helvetica" size:14];
    
    _info.text = @"Dieser Teil ist noch in Bearbeitung. Hier werden Einstellungen vorgenommen werden können, die das Verhalten der App bestimmen. Die Einstellungen können auch online geändert werden und sollten immer synchronisiert sein.";
    
    [self.view addSubview:_info];
    
    [_info release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)LoadLogin:(id)sender {
}

- (void)dealloc {
    [super dealloc];
}
@end
