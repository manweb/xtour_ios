//
//  XTMoreViewController.m
//  XTour
//
//  Created by Manuel Weber on 19/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTMoreViewController.h"

@interface XTMoreViewController ()

@end

@implementation XTMoreViewController

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
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    _header.frame = CGRectMake(0, 0, width, 69);
    _header_shadow.frame = CGRectMake(0, 69, width, 1);
    
    _loginButton.frame = CGRectMake(width-50, 25, 40, 40);
    
    [_tableView setContentInset:UIEdgeInsetsMake(70, 0, 0, 0)];
    
    data = [XTDataSingleton singleObj];
    
    //_listOfFiles = [data GetAllImages];
    
    NSArray *tableItems1 = [NSArray arrayWithObjects:@"Profil", @"Einstellungen", @"News feed", @"Wunschliste", @"Ausloggen", nil];
    NSArray *tableItems2 = [NSArray arrayWithObjects:@"Dateien hochladen", @"Aufräumen", nil];
    NSArray *tableIcons1 = [NSArray arrayWithObjects:@"profile_icon_small@3x.png", @"settings_icon@3x.png", @"news_feed_icon@3x.png", @"wishlist_icon@3x.png", @"logout@3x.png", nil];
    NSArray *tableIcons2 = [NSArray arrayWithObjects:@"upload_icon@3x.png", @"cleanup_icon@3x.png", nil];
    
    _listOfFiles = [[NSDictionary alloc] initWithObjectsAndKeys:tableItems1, @"Allgemein", tableItems2, @"Beta testing", nil];
    
    _listOfIcons = [[NSDictionary alloc] initWithObjectsAndKeys:tableIcons1, @"Allgemein", tableIcons2, @"Beta testing", nil];
    
    _sectionTitles = [[NSArray alloc] initWithObjects:@"Allgemein", @"Beta testing", nil];
    
    /*_listOfFiles = [[NSMutableArray alloc] init];
    [_listOfFiles addObject:@"Profil"];
    [_listOfFiles addObject:@"Einstellungen"];
    [_listOfFiles addObject:@"News feed"];
    [_listOfFiles addObject:@"Dateien hochladen (beta)"];
    [_listOfFiles addObject:@"Aufräumen (beta)"];
    [_listOfFiles addObject:@"Wunschliste"];
    
    _listOfIcons = [[NSMutableArray alloc] init];
    [_listOfIcons addObject:@"profile_icon_small@3x.png"];
    [_listOfIcons addObject:@"settings_icon@3x.png"];
    [_listOfIcons addObject:@"news_feed_icon@3x.png"];
    [_listOfIcons addObject:@"upload_icon@3x.png"];
    [_listOfIcons addObject:@"cleanup_icon@3x.png"];
    [_listOfIcons addObject:@"wishlist_icon@3x.png"];*/
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(2*width, 70, width, height-70-tabBarHeight)];
    _detailView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_detailView];
    
    [_backButton setHidden:YES];
    
    self.tableView.frame = CGRectMake(0, 0, width, height);
    
    self.tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:nil];
    
    [self LoginViewDidClose:nil];
    
    if (navigationView.view.frame.origin.x == 0) {[navigationView.backButton setHidden:NO];}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (navigationView.view.frame.origin.x == 0) {[navigationView.backButton setHidden:YES];}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectionTitles count];
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [_sectionTitles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [_sectionTitles objectAtIndex:section];
    NSArray *sectionItems = [_listOfFiles objectForKey:sectionTitle];
    
    return [sectionItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    
    NSString *sectionTitle = [_sectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionItems = [_listOfFiles objectForKey:sectionTitle];
    NSArray *sectionIcons = [_listOfIcons objectForKey:sectionTitle];
    
    cell.textLabel.text = [sectionItems objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[sectionIcons objectAtIndex:indexPath.row]];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil];
                    navigationView.view.frame = CGRectMake(2*width, 0, width, height-tabBarHeight);
                    
                    [self.view addSubview:navigationView.view];
                    
                    [self.view bringSubviewToFront:_header];
                    [self.view bringSubviewToFront:_header_shadow];
                    
                    profile = [[XTProfileViewController alloc] initWithFrame:CGRectMake(0, 0, width, height-tabBarHeight)];
                    
                    [profile initialize];
                    
                    [navigationView.view addSubview:profile];
                    
                    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {navigationView.view.frame = CGRectMake(0, 0, width, height-tabBarHeight);} completion:^(BOOL finished) {[navigationView.backButton setHidden:NO];}];
                }
                    
                    break;
                case 1:
                {
                    navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil];
                    navigationView.view.frame = CGRectMake(2*width, 0, width, height-tabBarHeight);
                    
                    [self.view addSubview:navigationView.view];
                    
                    [self.view bringSubviewToFront:_header];
                    [self.view bringSubviewToFront:_header_shadow];
                    
                    settings = [[XTSettingsViewController alloc] initWithNibName:nil bundle:nil];
                    
                    settings.view.frame = CGRectMake(0, 0, width, height-tabBarHeight);
                
                    [navigationView.view addSubview:settings.view];
                    
                    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {navigationView.view.frame = CGRectMake(0, 0, width, height-tabBarHeight);} completion:^(BOOL finished) {[navigationView.backButton setHidden:NO];}];
                }
                    
                    break;
                case 2:
                {
                    navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil];
                    navigationView.view.frame = CGRectMake(2*width, 0, width, height-tabBarHeight);
                    
                    //[[UIApplication sharedApplication].keyWindow addSubview:navigationView.view];
                    [self.view addSubview:navigationView.view];
                    
                    [self.view bringSubviewToFront:_header];
                    [self.view bringSubviewToFront:_header_shadow];
                    
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    [layout setItemSize:CGSizeMake(300, 100)];
                    collection = [[XTNewsFeedViewController alloc] initWithCollectionViewLayout:layout];
                    collection.view.frame = CGRectMake(0, 0, width, height-tabBarHeight);
                    
                    [navigationView.view addSubview:collection.view];
                    
                    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {navigationView.view.frame = CGRectMake(0, 0, width, height-tabBarHeight);} completion:^(BOOL finished) {[navigationView.backButton setHidden:NO];}];
                    
                    [layout release];
                }
                    break;
                case 3:
                    
                    break;
                case 4:
                    [data Logout];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    XTFileUploader *uploader = [[XTFileUploader alloc] init];
                    
                    [uploader UploadGPXFiles];
                    [uploader UploadImages];
                    [uploader UploadImageInfo];
                }
                    break;
                case 1:
                {
                    [data CleanUpTourDirectory];
                }
                    break;
            }
            break;
    }
    
    //[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_detailView.frame = CGRectMake(0, 70, width, height-70-tabBarHeight);} completion:^(bool finished) {[_backButton setHidden:NO];}];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, 15, 100, 20)];
    
    lblTitle.font = [UIFont fontWithName:@"Helvetica" size:16];
    lblTitle.textColor = [UIColor colorWithRed:150.0F/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.text = [_sectionTitles objectAtIndex:section];
    
    [viewHeader addSubview:lblTitle];
    
    [lblTitle release];
    
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (void)dealloc {
    [_loginButton release];
    [_backButton release];
    [_header release];
    [_header_shadow release];
    [_tableView release];
    [super dealloc];
}
- (void)LoadLogin:(id)sender {
    if (login) {[login.view removeFromSuperview];}
    
    login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];
    
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

- (IBAction)back:(id)sender {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_detailView.frame = CGRectMake(2*width, 70, width, height-70-tabBarHeight);} completion:NULL];
    
    if (collection.view.frame.origin.x == 0) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {collection.view.frame = CGRectMake(2*width, 70, width, height-70-tabBarHeight);} completion:NULL];
    }
    
    for (UIView *view in _detailView.subviews) {
        [view removeFromSuperview];
    }
    
    [_backButton setHidden:YES];
}

@end
