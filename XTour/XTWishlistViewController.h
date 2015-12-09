//
//  XTWishlistViewController.h
//  XTour
//
//  Created by Manuel Weber on 07/12/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTWishlistViewCell.h"
#import "XTTourInfo.h"

@interface XTWishlistViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,retain) NSMutableArray *tourInfos;
@property (nonatomic) NSInteger clickedButton;

- (void) ShowOptions:(id)sender;
- (void) StartTour:(id)sender;

@end
