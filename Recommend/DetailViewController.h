//
//  DetailViewController.h
//  Recommend
//
//  Created by Thomas Orten on 6/18/14.
//  Copyright (c) 2014 Orten, Thomas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface DetailViewController : UIViewController
@property PFObject *recommendation;
@end
