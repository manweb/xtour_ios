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
    
    data = [XTDataSingleton singleObj];
    
    //_listOfFiles = [data GetAllImages];
    
    _listOfFiles = [[NSMutableArray alloc] init];
    [_listOfFiles addObject:@"Test1"];
    [_listOfFiles addObject:@"Test2"];
    
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

    [self tabBarItem].badgeValue = [NSString stringWithFormat:@"%lu", [_listOfFiles count]];
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
    
    // Get filename
    NSString *currentFile = [_listOfFiles objectAtIndex:indexPath.row];
    NSArray *parts = [currentFile componentsSeparatedByString:@"/"];
    NSString *fname = [parts lastObject];
    
    cell.textLabel.text = fname;
    if ([[fname pathExtension] isEqualToString:@"jpg"]) {
        cell.imageView.image = [UIImage imageNamed:currentFile];
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
    
    for (UIView *view in _detailView.subviews) {
        [view removeFromSuperview];
    }
    
    [_backButton setHidden:YES];
}

@end
