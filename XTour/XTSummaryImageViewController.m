//
//  XTSummaryImageViewController.m
//  XTour
//
//  Created by Manuel Weber on 14/05/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTSummaryImageViewController.h"

@interface XTSummaryImageViewController ()

@end

@implementation XTSummaryImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.view.frame = CGRectMake(5, 5, 300, 190);
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_collectionView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:_collectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    XTImageInfo *imageInfo = [_images objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
    [imageView setImageWithURL:[NSURL URLWithString:imageInfo.Filename]];
    
    [cell addSubview:imageView];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    _cellRect = attributes.frame;
    
    CGPoint p = [self.view.superview convertPoint:_cellRect.origin toView:nil];
    
    _cellRect.origin.x = p.x + 5;
    _cellRect.origin.y = p.y + 5;
    
    XTImageInfo *imageInfo = [_images objectAtIndex:indexPath.row];
    
    if (!_selectedImageView) {_selectedImageView = [[UIImageView alloc] initWithFrame:_cellRect];}
    
    _selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
    _selectedImageView.clipsToBounds = true;
    [_selectedImageView setImageWithURL:[NSURL URLWithString:imageInfo.Filename]];
    UIImage *selectedImage = _selectedImageView.image;
    
    CGFloat imgWidth = selectedImage.size.width;
    CGFloat imgHeight = selectedImage.size.height;
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenBound.size.width;
    CGFloat screenHeight = screenBound.size.height;
    
    UITabBarController *tabBarController = [super tabBarController];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    CGFloat fullWidth = screenWidth;
    CGFloat fullHeight = imgHeight/imgWidth*fullWidth;
    CGFloat yOffset = (screenHeight - 70 - tabBarHeight)/2. - fullHeight/2. + 70;
    CGFloat xOffset = 0;
    
    UIColor *bgColorSolid = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:1.0];
    UIColor *bgColorOpaque = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0];
    
    if (!_background) {
        CGRect bgRect = CGRectMake(0, 0, screenWidth, screenHeight + tabBarHeight);
        _background = [[UIImageView alloc] initWithFrame:bgRect];
        _background.backgroundColor = bgColorOpaque;
    }
    
    NSString *imageLongitude = [NSString stringWithFormat:@"%.5f",imageInfo.Longitude];
    NSString *imageLatitude = [NSString stringWithFormat:@"%.5f",imageInfo.Latitude];
    float imageElevation = imageInfo.Elevation;
    NSString *imageComment = imageInfo.Comment;
    NSDate *imageDate = imageInfo.Date;
    
    if (!_compassImage) {
        _compassImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, yOffset-45, 40, 40)];
        _compassImage.image = [UIImage imageNamed:@"compass_icon_white.png"];
    }
    
    if (!_imgLongitudeLabel) {
        _imgLongitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, yOffset-45, 100, 20)];
        _imgLongitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _imgLongitudeLabel.textColor = [UIColor whiteColor];
    }
    
    if (!_imgLatitudeLabel) {
        _imgLatitudeLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, yOffset-25, 100, 20)];
        _imgLatitudeLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _imgLatitudeLabel.textColor = [UIColor whiteColor];
    }
    
    if (!_imgElevationLabel) {
        _imgElevationLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, yOffset-35, 50, 20)];
        _imgElevationLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _imgElevationLabel.textColor = [UIColor whiteColor];
    }
    
    if (imageLongitude) {_imgLongitudeLabel.text = imageLongitude;}
    else {_imgLongitudeLabel.text = @"";}
    
    if (imageLatitude) {_imgLatitudeLabel.text = imageLatitude;}
    else {_imgLatitudeLabel.text = @"";}
    
    if (imageElevation) {_imgElevationLabel.text = [NSString stringWithFormat:@"%.0f müm",imageElevation];}
    else {_imgLongitudeLabel.text = @"";}
    
    if (!_imgCommentLabel) {
        _imgCommentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, yOffset+fullHeight+5, 310, 20)];
        _imgCommentLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        _imgCommentLabel.textColor = [UIColor whiteColor];
    }
    
    if (imageComment) {_imgCommentLabel.text = imageComment;}
    else {_imgCommentLabel.text = @"No comments";}
    
    [_background addSubview:_selectedImageView];
    [[[UIApplication sharedApplication] keyWindow] addSubview:_background];
    //[self.view addSubview:_background];
    //[self.view addSubview:_selectedImageView];
    
    _selectedIndexPath = indexPath;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell setHidden:YES];
    
    UITapGestureRecognizer *tapRecognition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CloseImageView:)];
    tapRecognition.numberOfTapsRequired = 1;
    
    _background.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _selectedImageView.frame = CGRectMake(xOffset-10, yOffset-10, fullWidth+20, fullHeight+20);
        _background.backgroundColor = bgColorSolid;
    } completion:^(BOOL finished)
     {
         [_background addGestureRecognizer:tapRecognition];
         [_background addSubview:_compassImage];
         [_background addSubview:_imgLongitudeLabel];
         [_background addSubview:_imgLatitudeLabel];
         [_background addSubview:_imgElevationLabel];
         [_background addSubview:_imgCommentLabel];
         [UIView animateWithDuration:0.2f animations:^(void) {_selectedImageView.frame = CGRectMake(xOffset, yOffset, fullWidth, fullHeight);}];
     }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(90, 90);
}

- (void) CloseImageView:(id)sender
{
    UIColor *bgColorOpaque = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0];
    
    UICollectionViewCell *cell = [_collectionView cellForItemAtIndexPath:_selectedIndexPath];
    
    [_compassImage removeFromSuperview];
    [_imgLongitudeLabel removeFromSuperview];
    [_imgLatitudeLabel removeFromSuperview];
    [_imgElevationLabel removeFromSuperview];
    [_imgCommentLabel removeFromSuperview];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _selectedImageView.frame = CGRectMake(_cellRect.origin.x + 3, _cellRect.origin.y + 3, _cellRect.size.width - 6, _cellRect.size.height - 6);
        _background.backgroundColor = bgColorOpaque;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^(void) {
            _selectedImageView.frame = _cellRect;
        } completion:^(BOOL finished) {
            [cell setHidden:NO];
            [_selectedImageView removeFromSuperview];
            [_selectedImageView release];
            _selectedImageView = nil;
            [_background removeFromSuperview];
            [_background release];
            _background = nil;
        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
