//
//  AppDelegate.m
//  FunctionalReactivePixels
//
//  Created by Cee on 20/04/2015.
//  Copyright (c) 2015 Cee. All rights reserved.
//

#import "AppDelegate.h"
#import "FRPGalleryViewController.h"

@interface AppDelegate () <UITabBarControllerDelegate>
@property (nonatomic, readwrite) PXAPIHelper *apiHelper;
@property (nonatomic, strong) UITabBarController *tabBarController;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.apiHelper = [[PXAPIHelper alloc] initWithHost:nil
                                         consumerKey:@"DC2To2BS0ic1ChKDK15d44M42YHf9gbUJgdFoF0m"
                                      consumerSecret:@"i8WL4chWoZ4kw9fh3jzHK7XzTer1y5tUNvsTFNnB"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Setup Tabbar Controller
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.delegate = self;
    
    // Setup Controllers
    UIViewController *popularViewController = [[UINavigationController alloc] initWithRootViewController:
                                               [[FRPGalleryViewController alloc] initWithFeature:PXAPIHelperPhotoFeaturePopular]];
    UIViewController *editorsViewController = [[UINavigationController alloc] initWithRootViewController:
                                               [[FRPGalleryViewController alloc] initWithFeature:PXAPIHelperPhotoFeatureEditors]];
    UIViewController *upcomingViewController = [[UINavigationController alloc] initWithRootViewController:
                                                [[FRPGalleryViewController alloc] initWithFeature:PXAPIHelperPhotoFeatureUpcoming]];
    UIViewController *todayViewController = [[UINavigationController alloc] initWithRootViewController:
                                                [[FRPGalleryViewController alloc] initWithFeature:PXAPIHelperPhotoFeatureFreshToday]];
    
    // Setup Tabbar Item
    todayViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Today"
                                                                   image:[UIImage imageNamed:@"today"]
                                                                     tag:1];
    popularViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Popular"
                                                                     image:[UIImage imageNamed:@"popular"]
                                                                       tag:2];
    editorsViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Choice"
                                                                     image:[UIImage imageNamed:@"choice"]
                                                                       tag:3];
    upcomingViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Upcoming"
                                                                      image:[UIImage imageNamed:@"upcoming"]
                                                                        tag:4];

    
    self.tabBarController.viewControllers = @[todayViewController, popularViewController, editorsViewController, upcomingViewController];
    self.window.rootViewController = self.tabBarController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
