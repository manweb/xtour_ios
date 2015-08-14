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

static NSString * const reuseIdentifier = @"Cell";

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
    
    // Register cell classes
    [self.collectionView registerClass:[XTWarningCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(70, 0, 0, 0)];
    
    // Do any additional setup after loading the view.
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    _header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 69)];
    _header_shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 69, 320, 1)];
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 25, 40, 40)];
    [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(LoadLogin:) forControlEvents:UIControlEventTouchDown];
    
    [_header addSubview:_loginButton];
    
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
    [self.view addSubview:_header];
    [self.view addSubview:_header_shadow];
    [self.view addSubview:_background];
    
    [self.view sendSubviewToBack:_background];
    
    _warningsArray = [[NSMutableArray alloc] init];
    [_warningsArray removeAllObjects];
    
    data = [XTDataSingleton singleObj];
    
    if (refreshControl == nil) {
        refreshControl = [[UIRefreshControl alloc] init];
    }
    [refreshControl addTarget:self action:@selector(UpdateWarnings:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:nil];
    
    [self UpdateWarnings:nil];
    [self LoginViewDidClose:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_warningsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XTWarningCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    XTWarningsInfo *currentWarning = [_warningsArray objectAtIndex:indexPath.row];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[currentWarning.submitDate integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    NSString *formattedDate = [formatter stringFromDate:date];
    
    cell.warningTitle.text = @"Title of warning";
    cell.warningDescription.text = [NSString stringWithFormat:@"Eingetragen von %@ am %@. Distanz zur Gefahrenstelle: %.1f km",currentWarning.userName,formattedDate,currentWarning.distance];
    
    [formatter release];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    
    float boxWidth = width - 20;
    
    return CGSizeMake(boxWidth, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void)dealloc {
    [_header release];
    [_header_shadow release];
    [_background release];
    [_emptyLabel release];
    [_loginButton release];
    [_warningsArray release];
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
        
        [img release];
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
    XTServerRequestHandler *request = [[[XTServerRequestHandler alloc] init] autorelease];
    
    if (!data.CurrentLocation) {return;}
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.warningsArray = [request GetWarningsWithinRadius:20 atLongitude:data.CurrentLocation.coordinate.longitude andLatitude:data.CurrentLocation.coordinate.latitude];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_warningsArray count] > 0) {
                [_background setHidden:YES];
                [self.collectionView setHidden:NO];
                [self.collectionView reloadData];
                
                [self tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", [_warningsArray count]];
            }
            else {
                [_background setHidden:NO];
                [self.collectionView setHidden:YES];
                
                [self tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", 0];
            }
            
            [refreshControl endRefreshing];
        });
    });
}

@end
