//
//  XTNewsFeedCell.m
//  XTour
//
//  Created by Manuel Weber on 16/04/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTNewsFeedCell.h"

@implementation XTNewsFeedCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float boxRadius = 5.f;
        float boxBorderWidth = 1.0f;
        UIColor *boxBorderColor = [UIColor colorWithRed:230.0f/255.0f green:230.0f/255.0f blue:230.0f/255.0f alpha:1.0f];
        
        // initialize label and imageview here, then add them as subviews to the content view
        _profilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(8, 25, 50, 50)];
        _title = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 223, 15)];
        _time = [[UILabel alloc] initWithFrame:CGRectMake(60, 60, 70, 15)];
        _altitude = [[UILabel alloc] initWithFrame:CGRectMake(130, 60, 50, 15)];
        _distance = [[UILabel alloc] initWithFrame:CGRectMake(190, 60, 50, 15)];
        
        _title.font = [UIFont fontWithName:@"Helvetica" size:12];
        _time.font = [UIFont fontWithName:@"Helvetica" size:10];
        _altitude.font = [UIFont fontWithName:@"Helvetica" size:10];
        _distance.font = [UIFont fontWithName:@"Helvetica" size:10];
        
        _title.textAlignment = NSTextAlignmentLeft;
        _time.textAlignment = NSTextAlignmentCenter;
        _altitude.textAlignment = NSTextAlignmentCenter;
        _distance.textAlignment = NSTextAlignmentCenter;
        
        _title.textColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:1.0f];
        
        _timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(80, 30, 30, 30)];
        _altitudeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(140, 30, 30, 30)];
        _distanceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(200, 30, 30, 30)];
        
        _timeIcon.image = [UIImage imageNamed:@"clock_icon.png"];
        _altitudeIcon.image = [UIImage imageNamed:@"altitude_icon.png"];
        _distanceIcon.image = [UIImage imageNamed:@"skier_up_icon.png"];
        
        [self addSubview:_profilePicture];
        [self addSubview:_title];
        [self addSubview:_time];
        [self addSubview:_altitude];
        [self addSubview:_distance];
        [self addSubview:_timeIcon];
        [self addSubview:_altitudeIcon];
        [self addSubview:_distanceIcon];
        
        self.layer.borderWidth = boxBorderWidth;
        self.layer.borderColor = boxBorderColor.CGColor;
        self.layer.cornerRadius = boxRadius;
    }
    return self;
}

@end
