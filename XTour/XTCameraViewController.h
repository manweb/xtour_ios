//
//  XTCameraViewController.h
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTDataSingleton.h"
#import "XTLoginViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface XTCameraViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
}

@property(retain, nonatomic) NSMutableArray *ImageArray;
@property(retain, nonatomic) UIButton *CameraIcon;
@property(retain, nonatomic) UIButton *loginButton;
@property(retain, nonatomic) UIImagePickerController *ImagePicker;
@property(retain, nonatomic) UIImageView *selectedImageView;
@property(nonatomic) CGRect cellRect;

- (void) LoadCamera:(id)sender;
- (void) LoadLogin:(id)sender;
- (void) CloseImageView:(id)sender;

@end
