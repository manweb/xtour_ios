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
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    _ImageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 16; i++) {
        NSString *imgName = [[NSString alloc] initWithFormat:@"/tours/images/image%i.jpg", i+1];
        NSString *ImagePath = [documentsDirectory stringByAppendingString:imgName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:ImagePath]) {
            [_ImageArray addObject:ImagePath];
        }
    }
    
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
    
    data = [XTDataSingleton singleObj];
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
}

- (void) LoadCamera:(id)sender
{
    if (!_ImagePicker) {_ImagePicker = [[UIImagePickerController alloc] init];}
    _ImagePicker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [_ImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:_ImagePicker animated: YES completion:nil];
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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_ImageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *cellImageView = (UIImageView *)[cell viewWithTag:100];
    cellImageView.image = [[UIImage alloc] initWithContentsOfFile:[_ImageArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected photo %i", indexPath.row);
    
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
    _cellRect = attributes.frame;
    
    if (!_selectedImageView) {_selectedImageView = [[UIImageView alloc] initWithFrame:_cellRect];}
    UIImage *selectedImage = [[UIImage alloc] initWithContentsOfFile:[_ImageArray objectAtIndex:indexPath.row]];
    _selectedImageView.image = selectedImage;
    
    [self.view addSubview:_selectedImageView];
    
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_selectedImageView.frame = CGRectMake(0, 70, 320, 480);} completion:NULL];
    
    [_CameraIcon removeTarget:self action:@selector(LoadCamera:) forControlEvents:UIControlEventTouchDown];
    [_CameraIcon addTarget:self action:@selector(CloseImageView:) forControlEvents:UIControlEventTouchDown];
    [_CameraIcon setImage:[UIImage imageNamed:@"arrow_back.png"] forState:UIControlStateNormal];
}

- (void) CloseImageView:(id)sender
{
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^(void) {_selectedImageView.frame = _cellRect;} completion:^(BOOL finished) {[_selectedImageView removeFromSuperview]; [_selectedImageView release]; _selectedImageView = nil;}];
    
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
    
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *ImageData = UIImageJPEGRepresentation(pickedImage, 0.9);
    
    NSString *tempPath = [data GetDocumentFilePathForFile:@"/test1.jpeg" CheckIfExist:NO];
    
    [ImageData writeToFile:tempPath atomically:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
