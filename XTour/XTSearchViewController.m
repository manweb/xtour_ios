//
//  XTSearchViewController.m
//  XTour
//
//  Created by Manuel Weber on 08/01/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import "XTSearchViewController.h"

@interface XTSearchViewController ()

@end

@implementation XTSearchViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    float width = screenBound.size.width;
    float height = screenBound.size.height;
    
    UITabBarController *tabBarController = [UITabBarController new];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[XTSearchViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView setContentInset:UIEdgeInsetsMake(110, 0, tabBarHeight, 0)];
    
    // Do any additional setup after loading the view.
    [self.collectionView setBackgroundColor:[UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(5, 75, width-10, 40)];
    
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView setAlpha:0.9];
    searchView.layer.cornerRadius = 5.0f;
    
    UIView *searchFieldBackground = [[UIView alloc] initWithFrame:CGRectMake(10, 5, width-30, 30)];
    
    searchFieldBackground.backgroundColor = [UIColor clearColor];
    searchFieldBackground.layer.borderWidth = 1.0f;
    searchFieldBackground.layer.cornerRadius = 5.0f;
    searchFieldBackground.layer.borderColor = [[UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0f] CGColor];
    
    _searchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, width-30, 30)];
    
    _searchField.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    _searchField.text = @"Suche";
    
    [searchFieldBackground addSubview:_searchField];
    
    [searchView addSubview:searchFieldBackground];
    
    [self.view addSubview:searchView];
    
    [searchView release];
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height/2-20, width, 40)];
    
    emptyLabel.backgroundColor = [UIColor clearColor];
    emptyLabel.textColor = [UIColor colorWithRed:150.0f/255.0f green:150.0f/255.0f blue:150.0f/255.0f alpha:1.0f];
    emptyLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.text = @"Suchfunktion noch nicht implementiert";
    
    self.collectionView.backgroundView = emptyLabel;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

- (void)keyboardWasShown:(NSNotification *)notification
{
    if ([_searchField.text isEqualToString:@"Suche"]) {_searchField.text = @"";}
}

- (void) keyboardWillHide:(NSNotification *)notification
{
    if ([_searchField.text isEqualToString:@""]) {_searchField.text = @"Suche";}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchField endEditing:YES];
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
