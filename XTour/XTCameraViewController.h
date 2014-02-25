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
    UIImagePickerController *ImagePicker;
    XTDataSingleton *data;
}

@property(nonatomic,retain) NSMutableArray *ImageArray;
@property(strong,nonatomic,retain) UIButton *CameraIcon;
@property(strong,nonatomic,retain) UIButton *loginButton;

- (void) LoadCamera:(id)sender;
- (void) LoadLogin:(id)sender;

@end
