//
//  XTUserInfo.h
//  XTour
//
//  Created by Manuel Weber on 08/06/15.
//  Copyright (c) 2015 Manuel Weber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTUserInfo : NSObject

@property(nonatomic) NSUInteger userID;
@property(nonatomic, retain) NSString *userName;
@property(nonatomic) NSUInteger dateJoined;
@property(nonatomic, retain) NSString *home;
@property(nonatomic) NSUInteger timeThisSeason;
@property(nonatomic) NSUInteger timeTotal;
@property(nonatomic) float distanceThisSeason;
@property(nonatomic) float distanceTotal;
@property(nonatomic) float altitudeThisSeason;
@property(nonatomic) float altitudeTotal;

@end
