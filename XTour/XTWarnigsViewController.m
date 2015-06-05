//
//  XTWarnigsViewController.m
//  XTour
//
//  Created by Manuel Weber on 22/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTWarnigsViewController.h"

@interface XTWarnigsViewController ()

@end

@implementation XTWarnigsViewController

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
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    [_tableView setContentInset:UIEdgeInsetsMake(75, 0, 0, 0)];
    
    _background = [[UIView alloc] initWithFrame:screenBounds];
    _background.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    _emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, screenBounds.size.height/2-25, screenBounds.size.width - 40, 50)];
    _emptyLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _emptyLabel.text = @"Im Umkreis von 20km sind keine Gefahrenstellen markiert.";
    [_emptyLabel setNumberOfLines:3];
    [_emptyLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_background addSubview:_emptyLabel];
    [self.view addSubview:_background];
    
    [self.view sendSubviewToBack:_background];
    
    _warningsArray = [[NSMutableArray alloc] init];
    [_warningsArray removeAllObjects];
    
    if ([_warningsArray count] == 0) {
        [_tableView setHidden:YES];
        [_background setHidden:NO];
    }
    else {
        [_tableView setHidden:NO];
        [_background setHidden:YES];
    }
    
    data = [XTDataSingleton singleObj];
}

- (void) viewWillAppear:(BOOL)animated
{
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    }

    [self tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", 0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)dealloc {
    [_loginButton release];
    [_tableView release];
    [super dealloc];
}

- (IBAction)LoadLogin:(id)sender {
    if (login) {[login.view removeFromSuperview];}
    
    login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:login.view];
    [login animate];
}

@end
