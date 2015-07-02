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
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    updateButton.frame = CGRectMake(screenBounds.size.width/2-50, screenBounds.size.height/2+40, 100, 30);
    
    [updateButton setTitle:@"Update" forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(UpdateWarnings:) forControlEvents:UIControlEventTouchUpInside];
    
    [_background addSubview:_emptyLabel];
    [_background addSubview:updateButton];
    [self.view addSubview:_background];
    
    [self.view sendSubviewToBack:_background];
    
    _warningsArray = [[NSMutableArray alloc] init];
    [_warningsArray removeAllObjects];
    
    data = [XTDataSingleton singleObj];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self UpdateWarnings:nil];
    [self LoginViewDidClose:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_warningsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    
    XTWarningsInfo *currentWarning = [_warningsArray objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:@"warning_icon@2x.png"];
    cell.textLabel.text = currentWarning.comment;
    
    [currentWarning release];
    
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

- (void)LoadLogin:(id)sender {
    if (login) {[login.view removeFromSuperview];}
    
    login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewDidClose:) name:@"LoginViewDismissed" object:nil];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:login.view];
    [login animate];
}

- (void)ShowLoginOptions:(id)sender {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginViewDidClose:) name:@"LoginViewDismissed" object:nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[NSString stringWithFormat:@"Du bist eingelogged als %@",data.userInfo.userName] delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:@"Ausloggen" otherButtonTitles:@"Profil anzeigen", nil];
    
    [actionSheet showInView:self.view];
}

- (void) LoginViewDidClose:(id)sender
{
    [_loginButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(ShowLoginOptions:) forControlEvents:UIControlEventTouchUpInside];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(LoadLogin:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Ausloggen"]) {[data Logout];}
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginViewDismissed" object:nil userInfo:nil];
}

- (void) UpdateWarnings:(id)sender
{
    XTServerRequestHandler *request = [[XTServerRequestHandler alloc] init];
    
    if (!data.CurrentLocation) {return;}
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.warningsArray = [request GetWarningsWithinRadius:20 atLongitude:data.CurrentLocation.coordinate.longitude andLatitude:data.CurrentLocation.coordinate.latitude];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_warningsArray count] > 0) {
                [_background setHidden:YES];
                [_tableView setHidden:NO];
                [self.tableView reloadData];
                
                [self tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", [_warningsArray count]];
            }
            else {
                [_background setHidden:NO];
                [_tableView setHidden:YES];
                
                [self tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", 0];
            }
        });
    });
}

@end
