//
//  XTNewsFeedViewController.m
//  XTour
//
//  Created by Manuel Weber on 16/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTNewsFeedViewController.h"

@interface XTNewsFeedViewController ()

@end

@implementation XTNewsFeedViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    data = [XTDataSingleton singleObj];
    
    // Register cell classes
    [self.collectionView registerClass:[XTNewsFeedCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(110, 0, 0, 0)];
    
    // Do any additional setup after loading the view.
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, width, 40)];
    
    filterView.backgroundColor = [UIColor whiteColor];
    filterView.alpha = 0.9f;
    
    _filterTab = [[UIView alloc] initWithFrame:CGRectMake(5, 28, 100, 2)];
    
    _filterTab.backgroundColor = [UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f];
    
    _filterAll = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _filterAll.frame = CGRectMake(5, 10, 100, 16);
    [_filterAll setTitle:@"Alle" forState:UIControlStateNormal];
    [_filterAll setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    [_filterAll addTarget:self action:@selector(SelectAll:) forControlEvents:UIControlEventTouchUpInside];
    
    _filterMine = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _filterMine.frame = CGRectMake(width/2-50, 10, 100, 16);
    [_filterMine setTitle:@"Meine" forState:UIControlStateNormal];
    [_filterMine setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterMine addTarget:self action:@selector(SelectMine:) forControlEvents:UIControlEventTouchUpInside];
    
    _filterBest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _filterBest.frame = CGRectMake(width-105, 10, 100, 16);
    [_filterBest setTitle:@"Beste" forState:UIControlStateNormal];
    [_filterBest setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterBest addTarget:self action:@selector(SelectBest:) forControlEvents:UIControlEventTouchUpInside];
    
    [filterView addSubview:_filterAll];
    [filterView addSubview:_filterMine];
    [filterView addSubview:_filterBest];
    [filterView addSubview:_filterTab];
    [self.view addSubview:filterView];
    
    _UID = @"0";
    _filter = 0;
    
    ServerHandler = [[XTServerRequestHandler alloc] init];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    if (refreshControl == nil) {
        refreshControl = [[UIRefreshControl alloc] init];
    }
    [refreshControl addTarget:self action:@selector(refreshNewsFeed) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    [refreshControl beginRefreshing];
    
    dispatch_queue_t fetch = dispatch_queue_create("fetchQueue", NULL);
    
    dispatch_async(fetch, ^{
        self.news_feed = [ServerHandler GetNewsFeedString:10 forUID:@"0" filterBest:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            
            [refreshControl endRefreshing];
        });
    });
    
    dispatch_release(fetch);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_news_feed release];
    [_profile_pictures release];
    [super dealloc];
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
    XTNewsFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    cell.backgroundColor = [UIColor whiteColor];
    
    XTTourInfo *currentElement = [self.news_feed objectAtIndex:indexPath.row];
    
    NSUInteger timestamp = currentElement.date;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    NSString *formattedDate = [formatter stringFromDate:date];
    
    NSUInteger tm = currentElement.totalTime;
    
    NSString *TimeString = [NSString stringWithFormat:@"%02lih %02lim %02lis",
                            lround(floor(tm / 3600.)) % 100,
                            lround(floor(tm / 60.)) % 60,
                            lround(floor(tm)) % 60];
    
    [cell.profilePicture setImageWithURL:[NSURL URLWithString:currentElement.profilePicture] placeholderImage:[UIImage imageNamed:@"profile_icon_gray.png"]];
    
    cell.title.text = [NSString stringWithFormat:@"%@ am %@",currentElement.userName, formattedDate];
    cell.time.text = TimeString;
    cell.altitude.text = [NSString stringWithFormat:@"%.1f m", currentElement.altitude];
    cell.distance.text = [NSString stringWithFormat:@"%.2f km", currentElement.distance];
    cell.tourDescription.text = currentElement.tourDescription;
    
    if ([currentElement.tourDescription isEqualToString:@""]) {
        [cell.tourDescription setHidden:YES];
        [cell.gradientOverlay setHidden:YES];
    }
    else {
        [cell.tourDescription setHidden:NO];
        [cell.gradientOverlay setHidden:NO];
    }
    
    [formatter release];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    //float imageOriginX = attributes.frame.origin.x + 8;
    //float imageOriginY = attributes.frame.origin.y + 25 - collectionView.contentOffset.y;
    
    XTTourInfo *currentElement = [self.news_feed objectAtIndex:indexPath.row];
    
    if (!navigationView) {navigationView = [[XTNavigationViewContainer alloc] initWithNibName:nil bundle:nil];}
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    navigationView.view.frame = CGRectMake(2*width, 0, width, height-tabBarHeight);
    //navigationView.view.alpha = 0.0f;
    
    XTTourDetailView *detailView = [[XTTourDetailView alloc] initWithFrame:CGRectMake(0, 0, width, height-tabBarHeight)];
    detailView.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
    
    [detailView Initialize:currentElement fromServer:YES withOffset:70 andContentOffset:50];
    
    [navigationView.view addSubview:detailView];
    [self.view addSubview:navigationView.view];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        navigationView.view.frame = CGRectMake(0, 0, width, height-tabBarHeight);
    } completion:^(BOOL finished)
     {
         [navigationView.backButton setHidden:NO];
         
         [detailView LoadTourDetail:currentElement fromServer:YES];
     }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    
    float boxWidth = width - 20;
    float height;
    
    XTTourInfo *currentElement = [self.news_feed objectAtIndex:indexPath.row];
    if ([currentElement.tourDescription isEqualToString:@""]) {height = 100;}
    else {height = 140;}
    
    return CGSizeMake(boxWidth, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}

- (void) refreshNewsFeed
{
    dispatch_queue_t fetch = dispatch_queue_create("fetchQueue", NULL);
    
    dispatch_async(fetch, ^{
        self.news_feed = [ServerHandler GetNewsFeedString:10 forUID:_UID filterBest:_filter];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
            
            [refreshControl endRefreshing];
        });
    });
    
    dispatch_release(fetch);
}

- (void)SelectAll:(id)sender
{
    float position = _filterAll.frame.origin.x;
    
    [self MoveTabTo:position];
    
    [_filterAll setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    [_filterMine setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterBest setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    _UID = @"0";
    _filter = 0;
    
    [self refreshNewsFeed];
}

- (void)SelectMine:(id)sender
{
    if (!data.loggedIn) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login" message:@"Du musst dich einloggen um deine Touren anzuzeigen. Klicke auf das Profil-Icon." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        return;
    }
    
    float position = _filterMine.frame.origin.x;
    
    [self MoveTabTo:position];
    
    [_filterAll setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterMine setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    [_filterBest setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    _UID = data.userID;
    _filter = 0;
    
    [self refreshNewsFeed];
}

- (void)SelectBest:(id)sender
{
    float position = _filterBest.frame.origin.x;
    
    [self MoveTabTo:position];
    
    [_filterAll setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterMine setTitleColor:[UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    [_filterBest setTitleColor:[UIColor colorWithRed:41.f/255.f green:127.f/255.f blue:199.f/255.f alpha:0.9f] forState:UIControlStateNormal];
    
    _UID = @"0";
    _filter = 1;
    
    [self refreshNewsFeed];
}

- (void)MoveTabTo:(float)position
{
    CGRect frame = _filterTab.frame;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _filterTab.frame = CGRectMake(position, frame.origin.y, frame.size.width, frame.size.height);
    } completion:nil];
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
