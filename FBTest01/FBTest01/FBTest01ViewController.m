//
//  FBTest01ViewController.m
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/09.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import "FBTest01ViewController.h"

#import "FBTest01AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AFNetworking/AFNetworking.h>
#import <Security/Security.h>
#import <UICKeyChainStore.h>
#import "FBTest01Auth.h"

@implementation FBTest01ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushCyLogin:(id)sender {
    NSLog(@"pushCyLogin");
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (appDelegate.cyAuth.sessionIsOpen) {
        NSLog(@"pushCyLogin: isOpen");
    } else {
        //if (!appDelegate.cyAuth) {
            appDelegate.cyAuth = [FBTest01Auth new];
        //}
        NSLog(@"pushCyLogin: !isOpen");
        [appDelegate.cyAuth openCySession:^(NSString *token){
            NSLog(@"cyAuth openCySession success");
            NSLog(@"%@", token);
            [self updateRootView];
        } failure:^(NSString *token){
            NSLog(@"cyAuth openCySession failure");
            NSLog(@"error: %@", token);
        }];
    }
}

- (IBAction)pushCyLogout:(id)sender {
    NSLog(@"pushCyLogout");
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.cyAuth closeAndClearTokenInfo];
}

- (void) updateRootView
{
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    NSString *sbId = @"";
    if (appDelegate.cyAuth.sessionIsOpen) {
        sbId = @"SubStoryboard";
    } else {
        sbId = @"Main";
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbId bundle:[NSBundle mainBundle]];
    UIViewController *initialViewController = [storyboard instantiateInitialViewController];
    appDelegate.window.rootViewController = initialViewController;
}

@end
