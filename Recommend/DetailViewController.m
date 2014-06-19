//
//  DetailViewController.m
//  Recommend
//
//  Created by Thomas Orten on 6/18/14.
//  Copyright (c) 2014 Orten, Thomas. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailMapViewController.h"
#import "UserTableViewController.h"
#import <Parse/Parse.h>

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *recommendationImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UIButton *personButton;
@property BOOL hasLikedPhoto;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleLabel.text = [[self.recommendation objectForKey:@"photo"] objectForKey:@"title"];
    self.descriptionLabel.text = [[self.recommendation objectForKey:@"photo"] objectForKey:@"description"];
    [self.personButton setTitle:[[PFUser currentUser] objectForKey:@"username"] forState:UIControlStateNormal];
    if ([[self.recommendation objectForKey:@"photo"] objectForKey:@"numLikes"]) {
        NSNumber *numLikes = [[self.recommendation objectForKey:@"photo"] objectForKey:@"numLikes"];
        self.likesLabel.text = [NSString stringWithFormat:@"%@", numLikes];
    }

    // Get image file
    PFFile *userImageFile = [[self.recommendation objectForKey:@"photo"] objectForKey:@"file"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            self.recommendationImageView.image = [UIImage imageWithData:imageData];
        }
    }];

    // Get Location
    PFQuery *locationQuery = [PFQuery queryWithClassName:@"Location"];
    [locationQuery whereKey:@"parent" equalTo:[self.recommendation objectForKey:@"photo"]];
    locationQuery.limit = 1;
    [locationQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *location in objects) {
                if ([location objectForKey:@"street"]) {
                    [self.addressButton setTitle:[NSString stringWithFormat:@"%@, %@", [location objectForKey:@"street"], [location objectForKey:@"city"]] forState:UIControlStateNormal];
                }
            }
        }
    }];

//    // Get Likes
//    PFQuery *likesQuery = [PFQuery queryWithClassName:@"Like"];
//    [likesQuery whereKey:@"photo" equalTo:[self.recommendation objectForKey:@"photo"]];
//    [likesQuery countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
//        if (!error && count) {
//            self.likesLabel.text = @(count).description;
//        }
//    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self setTabBarVisible:NO animated:YES];
}

- (IBAction)onRecommendButtonPressed:(id)sender
{
    // Check if user has liked
    if (self.hasLikedPhoto) {
         NSLog(@"User already liked.");
        return;
    }
    PFQuery *likeQuery = [PFQuery queryWithClassName:@"Like"];
    [likeQuery whereKey:@"photo" equalTo:[self.recommendation objectForKey:@"photo"]];
    [likeQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [likeQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            // Increment counter on photo object for fast retrieval
            PFObject *photoLikes = [self.recommendation objectForKey:@"photo"];
            [photoLikes incrementKey:@"numLikes"];
            [photoLikes saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    self.likesLabel.text = [NSString stringWithFormat:@"%@", photoLikes[@"numLikes"]];
                    self.hasLikedPhoto = YES;
                }
            }];
            // Save in likes table
            PFObject *userLike = [PFObject objectWithClassName:@"Like"];
            userLike[@"photo"] = [self.recommendation objectForKey:@"photo"];
            userLike[@"user"] = [PFUser currentUser];
            [userLike saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                self.hasLikedPhoto = YES;
            }];
        } else {
            // The find succeeded.
            NSLog(@"User already liked.");
        }
    }];
}

- (IBAction)onLocationButtonPressed:(id)sender
{

}

- (IBAction)onPersonPressed:(id)sender
{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailToTableViewSegue"]) {
        UserTableViewController *vc = segue.destinationViewController;
        vc.recommendation = self.recommendation;
    } else {
        DetailMapViewController *vc = segue.destinationViewController;
        vc.recommendation = self.recommendation;
    }
    [self setTabBarVisible:YES animated:YES];
}

// a param to describe the state change, and an animated flag
// optionally add a completion block which matches UIView animation
- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated {

    // bail if the current state matches the desired state
    if ([self tabBarIsVisible] == visible) return;

    // get a frame calculation ready
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;

    // zero duration means no animation
    CGFloat duration = (animated)? 0.3 : 0.0;

    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    }];
}

// know the current state
- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

@end
