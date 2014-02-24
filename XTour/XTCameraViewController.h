//
//  XTCameraViewController.h
//  XTour
//
//  Created by Manuel Weber on 21/02/14.
//  Copyright (c) 2014 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTCameraViewController : UICollectionViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    UIImagePickerController *ImagePicker;
}

@property(nonatomic,retain) NSMutableArray *ImageArray;

@end
