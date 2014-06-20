//
//  Recommendation.h
//  Recommend
//
//  Created by Thomas Orten on 6/19/14.
//  Copyright (c) 2014 Orten, Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ParseRecommendation : PFObject <PFSubclassing>

+ (NSString *)parseClassName;

@property PFFile *file;
@property (retain, nonatomic) NSDate *createdAt;
@property NSString *title;
@property NSString *description;
@property PFObject *creator;
@property NSNumber *numLikes;
@property PFGeoPoint *location;

@end
