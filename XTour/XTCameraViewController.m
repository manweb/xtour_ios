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

@synthesize ImageArray;
@synthesize CameraIcon;
@synthesize loginButton;

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
    
    ImageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 16; i++) {
        NSString *imgName = [[NSString alloc] initWithFormat:@"/image%i.jpg", i+1];
        NSString *ImagePath = [documentsDirectory stringByAppendingString:imgName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:ImagePath]) {
            [ImageArray addObject:ImagePath];
        }
    }
    
    UIImageView *CameraHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
    CameraHeader.image = [UIImage imageNamed:@"xtour_header.png"];
    
    loginButton = [[UIButton alloc] initWithFrame:CGRectMake(270, 25, 40, 40)];
    [loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(LoadLogin:) forControlEvents:UIControlEventTouchDown];
    
    CameraIcon = [[UIButton alloc] initWithFrame:CGRectMake(25, 30, 38, 30)];
    [CameraIcon setImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
    [CameraIcon addTarget:self action:@selector(LoadCamera:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:CameraHeader];
    [self.view addSubview:loginButton];
    [self.view addSubview:CameraIcon];
    
    [loginButton release];
    [CameraIcon release];
    [CameraHeader release];
    
    data = [XTDataSingleton singleObj];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (data.loggedIn) {
        NSString *tempPath = [data GetDocumentFilePathForFile:@"/profile.png" CheckIfExist:NO];
        UIImage *img = [[UIImage alloc] initWithContentsOfFile:tempPath];
        [loginButton setImage:img forState:UIControlStateNormal];
    }
    else {
        [loginButton setImage:[UIImage imageNamed:@"profile_icon.png"] forState:UIControlStateNormal];
    }
}

- (void) LoadCamera:(id)sender
{
    ImagePicker = [[UIImagePickerController alloc] init];
    ImagePicker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [ImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:ImagePicker animated: YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"Camera is not available. Choose existing?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    }
    
    [ImagePicker release];
}

- (void) LoadLogin:(id)sender
{
    XTLoginViewController *login = [[XTLoginViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:login animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [ImageArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    UIImageView *cellImageView = (UIImageView *)[cell viewWithTag:100];
    cellImageView.image = [[UIImage alloc] initWithContentsOfFile:[ImageArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ImagePicker = [[UIImagePickerController alloc] init];
    ImagePicker.delegate = self;
    
    if (buttonIndex == 1) {
        [ImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:ImagePicker animated: YES completion:nil];
    }
    
    [ImagePicker release];
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

@end
