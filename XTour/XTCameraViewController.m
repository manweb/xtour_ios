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
    
    ImagePicker = [[UIImagePickerController alloc] init];
    ImagePicker.delegate = self;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [ImagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [self presentViewController:ImagePicker animated: YES completion:nil];
        [ImagePicker release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message: @"Camera is not available. Choose existing?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alert show];
        
    }
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    ImageArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
        NSString *imgName = [[NSString alloc] initWithFormat:@"/image%i.jpg", i+1];
        NSString *ImagePath = [documentsDirectory stringByAppendingString:imgName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:ImagePath]) {
            [ImageArray addObject:ImagePath];
        }
    }
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
    if (buttonIndex == 1) {
        [ImagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController:ImagePicker animated: YES completion:nil];
        [ImagePicker release];
    }
    else {
        [ImagePicker release];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *ImageData = UIImageJPEGRepresentation(pickedImage, 0.9);
    
    NSString *FileName=[NSString stringWithFormat:@"test1.jpeg"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *tempPath = [documentsDirectory stringByAppendingPathComponent:FileName];
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
