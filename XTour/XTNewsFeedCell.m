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
        _title = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 223, 15)];
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
        
        _title.textColor = [UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
        
        _timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(80, 30, 30, 30)];
        _altitudeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(140, 30, 30, 30)];
        _distanceIcon = [[UIImageView alloc] initWithFrame:CGRectMake(200, 30, 30, 30)];
        
        _timeIcon.image = [UIImage imageNamed:@"clock_icon.png"];
        _altitudeIcon.image = [UIImage imageNamed:@"altitude_icon.png"];
        _distanceIcon.image = [UIImage imageNamed:@"skier_up_icon.png"];
        
        _tourDescription = [[UITextView alloc] initWithFrame:CGRectMake(5, 80, self.frame.size.width-10, 60)];
        
        _tourDescription.textColor = [UIColor colorWithRed:190.0f/255.0f green:190.0f/255.0f blue:190.0f/255.0f alpha:1.0f];
        _tourDescription.font = [UIFont fontWithName:@"Helvetica" size:12];
        _tourDescription.editable = NO;
        _tourDescription.scrollEnabled = NO;
        
        _gradientOverlay = [[UIView alloc] initWithFrame:CGRectMake(5, 80, self.frame.size.width-10, 60)];
        
        _gradientOverlay.backgroundColor = [UIColor whiteColor];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = _gradientOverlay.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor clearColor].CGColor, (id)[UIColor whiteColor].CGColor, nil];
        gradientLayer.startPoint = CGPointMake(1.0f, 0.2f);
        gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
        _gradientOverlay.layer.mask = gradientLayer;
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        _moreButton.frame = CGRectMake(frame.size.width-45, 0, 45, 25);
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"dots_icon@3x.png"] forState:UIControlStateNormal];
        
        [self addSubview:_profilePicture];
        [self addSubview:_title];
        [self addSubview:_time];
        [self addSubview:_altitude];
        [self addSubview:_distance];
        [self addSubview:_timeIcon];
        [self addSubview:_altitudeIcon];
        [self addSubview:_distanceIcon];
        [self addSubview:_tourDescription];
        [self addSubview:_gradientOverlay];
        [self addSubview:_moreButton];
        
        self.layer.borderWidth = boxBorderWidth;
        self.layer.borderColor = boxBorderColor.CGColor;
        self.layer.cornerRadius = boxRadius;
    }
    return self;
}

- (void)dealloc {
    [_title release];
    [_time release];
    [_altitude release];
    [_distance release];
    [_profilePicture release];
    [_timeIcon release];
    [_altitudeIcon release];
    [_distanceIcon release];
    [_tourDescription release];
    [_gradientOverlay release];
    [super dealloc];
}

@end
