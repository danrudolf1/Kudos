//
//  AppDelegate.m
//  Recommend
//
//  Created by Thomas Orten on 6/16/14.
//  Copyright (c) 2014 Orten, Thomas. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ParseRecommendation.h"
#import "HeaderImage.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    UIImage *tabBar = [UIImage imageWithColor:RGBA(255, 255, 255, 0.8)];
    [[UITabBar appearance] setTintColor:RGB(2, 156, 188)];
    //[[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundImage:tabBar];

    //UIImage *topNav = [UIImage imageWithColor:RGBA(2, 156, 188, 0.8)];
    UIImage *topNav = [UIImage imageNamed:@"navbar"];
    [[UINavigationBar appearance] setBackgroundImage:topNav forBarPosition:UIBarPositionTopAttached  barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundImage:topNav forBarPosition:UIBarPositionTopAttached  barMetrics:UIBarMetricsLandscapePhone];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];

    [ParseRecommendation registerSubclass];
    [Parse setApplicationId:@"ymMgNJ1eeZYYVWEvdjZ6K1LtfFuv797PHjOYjETj"
                  clientKey:@"twz1zFWlhnT3MSNUCLKp4wYIzIng25qp5p6qoFe1"];

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    return YES;

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
