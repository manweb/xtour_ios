//
//  XTCameraViewController.m
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import "XTCameraViewController.h"

@interface XTCameraViewController ()

@end

@implementation XTCameraViewController

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
    
    [self LoadCamera:nil];
    
    data = [XTDataSingleton singleObj];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //self.ImageArray = [[NSMutableArray alloc] init];
    /*for (int i = 0; i < 16; i++) {
        NSString *imgName = [[NSString alloc] initWithFormat:@"/tours/images/image%i.jpg", i+1];
        NSString *ImagePath = [documentsDirectory stringByAppendingString:imgName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:ImagePath]) {
            [_ImageArray addObject:ImagePath];
        }
    }*/
    
    UIImageView *CameraHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    CameraHeader.image = [UIImage imageNamed:@"xtour_header.png"];
    
    _loginButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 25, 40, 40)];
    [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(LoadLogin:) forControlEvents:UIControlEventTouchDown];
    
    _CameraIcon = [[UIButton alloc] initWithFrame:CGRectMake(25, 30, 38, 30)];
    [_CameraIcon setImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
    [_CameraIcon addTarget:self action:@selector(LoadCamera:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:CameraHeader];
    [self.view addSubview:_loginButton];
    [self.view addSubview:_CameraIcon];
    
    [CameraHeader release];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [_loginButton setImage:img forState:UIControlStateNormal];
    }
    else {
        [_loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    }
    
    //[self.collectionView reloadData];
}

- (void) LoadCamera:(id)sender
{
    if (!data.tourID) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"Photos können nur während einer Tour aufgenommen werden." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (!_ImagePicker) {_ImagePicker = [[UIImagePickerController alloc] init];}
    _ImagePicker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_ImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self.view.window.rootViewController presentViewController:_ImagePicker animated: YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"Camera is not available. Choose existing?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    }
    
    [_ImagePicker release];
    _ImagePicker = nil;
}

- (void) LoadLogin:(id)sender
{
    if (!login) {login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];}
    [self presentViewController:login animated:YES completion:nil];
    
    [login release];
    login = nil;
}

#pragma mark CollectionView methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [data GetNumImages];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *imageName = [data GetImageFilenameAt:indexPath.row];
    
    UIImageView *cellImageView = (UIImageView *)[cell viewWithTag:100];
    NSLog(@"Setting image: %@",imageName);
    UIImage *currentImage = [UIImage imageWithContentsOfFile:imageName];
    
    cellImageView.contentMode = UIViewContentModeScaleAspectFill;
    cellImageView.image = currentImage;
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected photo %li", indexPath.row);
    
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    _cellRect = attributes.frame;
    
    NSString *imageName = [data GetImageFilenameAt:indexPath.row];
    
    if (!_selectedImageView) {_selectedImageView = [[UIImageView alloc] initWithFrame:_cellRect];}
    UIImage *selectedImage = [UIImage imageWithContentsOfFile:imageName];
    
    _selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
    _selectedImageView.clipsToBounds = true;
    _selectedImageView.image = selectedImage;
    
    //[self.view addSubview:_selectedImageView];
    
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
    
    NSString *imageLongitude = [data GetImageLongitudeStringAt:indexPath.row];
    NSString *imageLatitude = [data GetImageLatitudeStringAt:indexPath.row];
    float imageElevation = [data GetImageElevationAt:indexPath.row];
    NSString *imageComment = [data GetImageCommentAt:indexPath.row];
    NSDate *imageDate = [data GetImageDateAt:indexPath.row];
    
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    [cell setHidden:YES];
    
    UITapGestureRecognizer *tapRecognition = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CloseImageView:)];
    tapRecognition.numberOfTapsRequired = 1;
    
    _background.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {
        _selectedImageView.frame = CGRectMake(xOffset-10, yOffset-10, fullWidth+20, fullHeight+20);
        _background.backgroundColor = bgColorSolid;
    } completion:^(bool finished)
     {
         [_background addGestureRecognizer:tapRecognition];
         [_background addSubview:_compassImage];
         [_background addSubview:_imgLongitudeLabel];
         [_background addSubview:_imgLatitudeLabel];
         [_background addSubview:_imgElevationLabel];
         [_background addSubview:_imgCommentLabel];
         [UIView animateWithDuration:0.2f animations:^(void) {_selectedImageView.frame = CGRectMake(xOffset, yOffset, fullWidth, fullHeight);}];
     }];
    
    [_CameraIcon removeTarget:self action:@selector(LoadCamera:) forControlEvents:UIControlEventTouchDown];
    [_CameraIcon addTarget:self action:@selector(CloseImageView:) forControlEvents:UIControlEventTouchDown];
    [_CameraIcon setImage:[UIImage imageNamed:@"arrow_back.png"] forState:UIControlStateNormal];
}

- (UIImage *) GetSquareSubImage:(UIImage *)image
{
    CGFloat imgWidth = image.size.width;
    CGFloat imgHeight = image.size.height;
    CGFloat subImgWidth;
    CGFloat subImgHeight;
    CGFloat yOffset;
    CGFloat xOffset;
    
    if (imgHeight > imgWidth) {
        subImgHeight = imgWidth;
        subImgWidth = imgWidth;
        
        yOffset = floor(imgHeight/2. - imgWidth/2.);
        xOffset = 0;
    }
    else {
        subImgHeight = imgHeight;
        subImgWidth = imgHeight;
        
        yOffset = 0;
        xOffset = floor(imgWidth/2. - imgHeight/2.);
    }
    
    CGRect subImgRect = CGRectMake(xOffset, yOffset, subImgWidth, subImgHeight);
    
    CGImageRef newImage = CGImageCreateWithImageInRect(image.CGImage, subImgRect);
    UIImage *subImg = [UIImage imageWithCGImage:newImage scale:1 orientation:image.imageOrientation];
    CGImageRelease(newImage);
    
    return subImg;
}

- (void) CloseImageView:(id)sender
{
    UIColor *bgColorOpaque = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0];
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:_selectedIndexPath];
    
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
        } completion:^(bool finished) {
            [cell setHidden:NO];
            [_selectedImageView removeFromSuperview];
            [_selectedImageView release];
            _selectedImageView = nil;
            [_background removeFromSuperview];
            [_background release];
            _background = nil;
        }];
    }];
    
    [_CameraIcon removeTarget:self action:@selector(CloseImageView:) forControlEvents:UIControlEventTouchDown];
    [_CameraIcon addTarget:self action:@selector(LoadCamera:) forControlEvents:UIControlEventTouchDown];
    [_CameraIcon setImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!_ImagePicker) {_ImagePicker = [[UIImagePickerController alloc] init];}
    _ImagePicker.delegate = self;
    
    if (buttonIndex == 1) {
        [_ImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:_ImagePicker animated: YES completion:nil];
    }
    
    [_ImagePicker release];
    _ImagePicker = nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSLog(@"New image");
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!pickedImage) {return;}
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float imgHeight = pickedImage.size.height;
        float imgWidth = pickedImage.size.width;
        
        float newImgHeight = 0.;
        float newImgWidth = 0.;
        if (imgHeight > imgWidth) {newImgHeight = 1024.; newImgWidth = ceilf(imgWidth/imgHeight*1024.);}
        else {newImgWidth = 1024.; newImgHeight = ceilf(imgHeight/imgWidth*1024.);}
        
        CGRect rect = CGRectMake(0,0,newImgWidth,newImgHeight);
        UIGraphicsBeginImageContext(rect.size);
        [pickedImage drawInRect:rect];
        UIImage *newImg= UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSString *newImageName = [data GetNewPhotoName];
        NSString *newImageNameOriginal = [newImageName stringByReplacingOccurrencesOfString:@".jpg" withString:@"_original.jpg"];
        
        NSLog(@"Resizing image %@...",newImageName);
        
        NSData *ImageData = UIImageJPEGRepresentation(pickedImage, 0.9);
        NSData *imageResizedData = UIImageJPEGRepresentation(newImg, 0.9);
        
        [ImageData writeToFile:newImageNameOriginal atomically:YES];
        [imageResizedData writeToFile:newImageName atomically:YES];
        
        XTImageInfo *imageInfo = [[XTImageInfo alloc] init];
        imageInfo.Filename = newImageNameOriginal;
        
        CLLocation *location = (CLLocation*)[data GetLastCoordinates];
        
        if (location) {
            imageInfo.Longitude = location.coordinate.longitude;
            imageInfo.Latitude = location.coordinate.latitude;
            imageInfo.Elevation = location.altitude;
            imageInfo.Date = location.timestamp;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Done");
            [data AddImage:imageInfo];
            [self.collectionView reloadData];
            [imageInfo release];
        });
    });
}

- (void) LoadImagesForCurrentTour
{
    NSString *imagePath = [data GetTourImagePath];
    
    NSArray *imagesInDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imagePath error:nil];
    for (int i = 0; i < [imagesInDirectory count]; i++) {
        NSString *img = [imagePath stringByAppendingString:[imagesInDirectory objectAtIndex:i]];
        if ([[img pathExtension] isEqualToString:@"jpg"] && [img containsString:data.tourID]) {[_ImageArray addObject:img];}
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_ImageArray release];
    [_CameraIcon release];
    [_loginButton release];
    [_ImagePicker release];
    [login release];
    [super dealloc];
}

@end
