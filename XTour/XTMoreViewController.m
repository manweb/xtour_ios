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
    
    _header.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    _header_shadow.backgroundColor = [UIColor colorWithRed:24.f/255.f green:71.f/255.f blue:111.f/255.f alpha:0.9f];
    
    [_tableView setContentInset:UIEdgeInsetsMake(75, 0, 0, 0)];
    
    data = [XTDataSingleton singleObj];
    
    //_listOfFiles = [data GetAllImages];
    
    _listOfFiles = [[NSMutableArray alloc] init];
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
    [_listOfIcons addObject:@"wishlist_icon@3x.png"];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(2*width, 70, width, height-70-tabBarHeight)];
    _detailView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_detailView];
    
    [_backButton setHidden:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:nil];
    
    [self LoginViewDidClose:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listOfFiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TableCell"];
    }
    
    cell.textLabel.text = [_listOfFiles objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[_listOfIcons objectAtIndex:indexPath.row]];
    
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
    
    switch (indexPath.row) {
        case 0:
        {
            navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil];
            navigationView.view.frame = CGRectMake(2*width, 0, width, height-tabBarHeight);
            
            [self.view addSubview:navigationView.view];
            
            [self.view bringSubviewToFront:_header];
            [self.view bringSubviewToFront:_header_shadow];
            
            XTProfileViewController *settings = [[XTProfileViewController alloc] initWithNibName:nil bundle:nil];
            
            settings.view.frame = CGRectMake(0, 0, width, height-tabBarHeight);
            
            [navigationView.view addSubview:settings.view];
            
            [settings release];
            
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
            
            XTSettingsViewController *settings = [[XTSettingsViewController alloc] initWithNibName:nil bundle:nil];
            
            settings.view.frame = CGRectMake(0, 0, width, height-tabBarHeight);
            
            [navigationView.view addSubview:settings.view];
            
            [settings release];
            
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
        {
            XTFileUploader *uploader = [[XTFileUploader alloc] init];
            
            [uploader UploadGPXFiles];
            [uploader UploadImages];
            [uploader UploadImageInfo];
            
            break;
        }
        case 4:
        {
            [data CleanUpTourDirectory];
            
            break;
        }
    }
    
    //[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_detailView.frame = CGRectMake(0, 70, width, height-70-tabBarHeight);} completion:^(bool finished) {[_backButton setHidden:NO];}];
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
