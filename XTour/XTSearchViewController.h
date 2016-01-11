//
//  XTSearchViewController.h
//  XTour
//
//  Created by Manuel Weber on 08/01/16.
//  Copyright © 2016 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTSearchViewCell.h"

@interface XTSearchViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,retain) UITextField *searchField;

@end
