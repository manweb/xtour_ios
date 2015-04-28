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
    
    data = [XTDataSingleton singleObj];
    
    //_listOfFiles = [data GetAllImages];
    
    _listOfFiles = [[NSMutableArray alloc] init];
    [_listOfFiles addObject:@"Profile"];
    [_listOfFiles addObject:@"Settings"];
    [_listOfFiles addObject:@"News feed"];
    
    _listOfIcons = [[NSMutableArray alloc] init];
    [_listOfIcons addObject:@"profile_icon_small@3x.png"];
    [_listOfIcons addObject:@"settings_icon@3x.png"];
    [_listOfIcons addObject:@"news_feed_icon@3x.png"];
    
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
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    }
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
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 20)];
            label1.text = @"First detail view";
            label1.textColor = [UIColor blackColor];
            
            [_detailView addSubview:label1];
        }
            
            break;
        case 1:
        {
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 200, 20)];
            label2.text = @"Second detail view";
            label2.textColor = [UIColor blackColor];
            
            [_detailView addSubview:label2];
        }
            
            break;
        case 2:
        {
            navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil];
            navigationView.view.frame = CGRectMake(2*width, 0, width, height);
            
            [[UIApplication sharedApplication].keyWindow addSubview:navigationView.view];
            
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            [layout setItemSize:CGSizeMake(300, 100)];
            collection = [[XTNewsFeedViewController alloc] initWithCollectionViewLayout:layout];
            collection.view.frame = CGRectMake(0, 70, width, height-70-tabBarHeight);
            
            [navigationView.view addSubview:collection.view];
            
            [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {navigationView.view.frame = CGRectMake(0, 0, width, height);} completion:^(bool finished) {[navigationView.backButton setHidden:NO];}];
        }
            break;
    }
    
    //[UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_detailView.frame = CGRectMake(0, 70, width, height-70-tabBarHeight);} completion:^(bool finished) {[_backButton setHidden:NO];}];
}

- (void)dealloc {
    [_loginButton release];
    [_backButton release];
    [super dealloc];
}
- (IBAction)loadLogin:(id)sender {
    if (!login) {login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];}
    [self presentViewController:login animated:YES completion:nil];
    
    [login release];
    login = nil;
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
