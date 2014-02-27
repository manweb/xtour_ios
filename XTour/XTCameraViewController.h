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

@interface XTCameraViewController : UICollectionViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    XTDataSingleton *data;
    XTLoginViewController *login;
}

@property(retain, nonatomic) NSMutableArray *ImageArray;
@property(retain, nonatomic) UIButton *CameraIcon;
@property(retain, nonatomic) UIButton *loginButton;
@property(retain, nonatomic) UIImagePickerController *ImagePicker;

- (void) LoadCamera:(id)sender;
- (void) LoadLogin:(id)sender;

@end
