//
//  XTWarningCell.m
//  XTour
//
//  Created by Manuel Weber on 05/07/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import "XTWarningCell.h"

@implementation XTWarningCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *warningIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        
        warningIcon.image = [UIImage imageNamed:@"warning_icon@3x.png"];
        
        _warningTitle = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 235, 20)];
        
        _warningTitle.font = [UIFont fontWithName:@"Helvetica-BoldMT" size:12];
        _warningTitle.textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
        
        _warningDescription = [[UITextView alloc] initWithFrame:CGRectMake(60, 25, 235, 60)];
        
        _warningDescription.font = [UIFont fontWithName:@"Helvetica" size:12];
        _warningDescription.textColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1.0];
        
        [self addSubview:warningIcon];
        [self addSubview:_warningTitle];
        [self addSubview:_warningDescription];
        
        self.layer.cornerRadius = 3.f;
    }
    
    return self;
}

@end
