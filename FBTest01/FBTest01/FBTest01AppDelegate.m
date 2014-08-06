//
//  FBTest01AppDelegate.m
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/09.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import "FBTest01AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import <Security/Security.h>
#import <UICKeyChainStore.h>
#import "FBTest01Auth.h"

@implementation FBTest01AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.

    // Parseに登録したアプリのApplicationIdとclientKey

#ifdef DEBUG
    NSLog(@"DEBUG");
    NSLog(@"cyAccessToken: %@", [UICKeyChainStore stringForKey:@"cyAccessToken"]);
#endif
    NSString *parseAppId     = [[NSProcessInfo processInfo] environment][@"PARSE_APP_ID"];
    NSString *parseClientKey = [[NSProcessInfo processInfo] environment][@"PARSE_CLIENT_KEY"];
    [Parse setApplicationId:parseAppId clientKey:parseClientKey];

    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];

    _cyAuth = [FBTest01Auth new];

    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    

//    if (!_cyAuth.sessionIsOpen) {
//        NSLog(@"FBTest01AppDelegate: didFinishLaunchingWithOptions: !cyAuth.sessionIsOpen");
//        if (_cyAuth.hasToken) {
//            NSLog(@"FBTest01AppDelegate: didFinishLaunchingWithOptions: cyAuth.hasToken");
//
//            [_cyAuth openCySession:^(NSString *token){
//                NSLog(@"didFinishLaunchingWithOptions: openSession: success");
//                NSLog(@"%@", token);
//                [self updateRootView];
//            } failure:^(NSString *token){
//                NSLog(@"didFinishLaunchingWithOptions: openSession: failure");
//                NSLog(@"error: %@", token);
//            }];
//            return YES;
//        }
//    }

//    [self updateDeviceToken];

    return YES;
}

- (void) updateRootView
{
    NSString *sbId = @"";
    if (_cyAuth.sessionIsOpen) {
        sbId = @"SubStoryboard";
    } else {
        sbId = @"Main";
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbId bundle:[NSBundle mainBundle]];
    UIViewController *initialViewController = [storyboard instantiateInitialViewController];
    self.window.rootViewController = initialViewController;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:self.session];

    // You can add your app-specific url handling code here if needed

    return wasHandled;
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - Push Notification

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // ParseにdeviceTokenを送信
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    NSLog(@"APNS: didRegisterForRemoteNotificationsWithDeviceToken");

    // サービス側にdeviceTokenを登録
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"remote notification error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // DEBUG
    [PFPush handlePush:userInfo];
    NSLog(@"APNS: didReceiveRemoteNotification");
}

@end
