//
//  XTNewsFeedViewController.m
//  XTour
//
//  Created by Manuel Weber on 07/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTNewsFeedViewController.h"

@interface XTNewsFeedViewController ()

@end

@implementation XTNewsFeedViewController

static NSString * const reuseIdentifier = @"NewsFeedCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    ServerHandler = [[XTServerRequestHandler alloc] init];
    
    dispatch_queue_t fetch = dispatch_queue_create("fetchQueue", NULL);
    
    dispatch_async(fetch, ^{
        //UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //activityView.tag = 15;
        
        //activityView.center = self.view.center;
        
        //[activityView startAnimating];
        
        //[self.view addSubview:activityView];
        
        CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
        UIView *loadingView = [[UIView alloc] initWithFrame:applicationFrame];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha = 0.8;
        loadingView.tag = 15;
        
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        activityView.center = loadingView.center;
        [loadingView addSubview:activityView];
        [activityView startAnimating];
        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(applicationFrame.size.width/2, applicationFrame.size.height/2+50, 100, 20)];
        [loadingLabel setText:@"fetching data..."];
        [loadingLabel setTextColor:[UIColor whiteColor]];
        [loadingView addSubview:loadingLabel];
        
        [self.view addSubview:loadingView];
        
        self.news_feed = [ServerHandler GetNewsFeedString:10];
        
        self.profile_pictures = [[NSMutableArray alloc] init];
        for (NSString *feed in self.news_feed) {
            NSString *url = [[feed componentsSeparatedByString:@","] objectAtIndex:3];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            UIImage *image = [UIImage imageWithData:imageData];
            
            [self.profile_pictures addObject:image];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"finished with loading projects");
            UIView *viewToRemove = [self.view viewWithTag:15];
            [viewToRemove removeFromSuperview];
            [self.collectionView reloadData];
        });
    });
    
    dispatch_release(fetch);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.news_feed count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    UIImageView *cellImageView = (UIImageView *)[cell viewWithTag:100];
    UILabel *title = (UILabel *)[cell viewWithTag:101];
    UILabel *time = (UILabel *)[cell viewWithTag:102];
    UILabel *altitude = (UILabel *)[cell viewWithTag:103];
    UILabel *distance = (UILabel *)[cell viewWithTag:104];
    
    NSLog(@"row: %li number of feeds: %lu",(long)indexPath.row,(unsigned long)[self.news_feed count]);
    
    NSString *currentElement = [self.news_feed objectAtIndex:indexPath.row];
    NSArray *element = [currentElement componentsSeparatedByString:@","];
    NSMutableArray *elements = [NSMutableArray arrayWithArray:element];
    [elements removeLastObject];
    
    //NSString *url = [elements objectAtIndex:3];
    //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    cellImageView.image = [self.profile_pictures objectAtIndex:indexPath.row];
    
    title.text = [NSString stringWithFormat:@"%@ am %@",[elements objectAtIndex:2], [elements objectAtIndex:4]];
    time.text = [NSString stringWithFormat:@"%@", [elements objectAtIndex:5]];
    altitude.text = [NSString stringWithFormat:@"%@ m", [elements objectAtIndex:6]];
    distance.text = [NSString stringWithFormat:@"%@ km", [elements objectAtIndex:7]];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
