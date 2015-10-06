//
//  XTCalendarViewController.h
//  XTour
//
//  Created by Manuel Weber on 26/09/15.
//  Copyright © 2015 Manuel Weber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XTCalendarViewController : UIViewController

@property (nonatomic,retain) UILabel *monthTitle;
@property (nonatomic) NSUInteger index;
@property (nonatomic) float calendarWidth;
@property (nonatomic) float calendarHeight;
@property (nonatomic,retain) UIColor *calendarActiveColor;

- (void)LoadCalendarAtIndex:(NSUInteger)index;

@end
