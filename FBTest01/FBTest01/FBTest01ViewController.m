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

@implementation FBTest01ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    [self updateView];

    // ログインしてない状態
    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] init];

        // トークンがキャッシュされてる状態
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded) {

            // セッションを開く
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                [NSThread sleepForTimeInterval:1.0f];
                NSLog(@"viewDidLoad: isOpen");
                [self updateView];
            }];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushLogin:(id)sender {
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    // 既にログインしている場合
    if (appDelegate.session.isOpen) {
        [appDelegate.session closeAndClearTokenInformation];

    // ログインしてない場合
    } else {
        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            NSLog(@"buttonClickHandler");
            [self updateView];
        }];
    }

}

- (void)updateView
{
    NSLog(@"updateView");

    // get the app delegate, so that we can reference the session property
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {
        NSLog(@"updateView isOpen");
        // valid account UI is shown whenever the session is open
        [self.loginButton setTitle:@"Log out" forState:UIControlStateNormal];
        [self.textLabel setText:[NSString stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
                                      appDelegate.session.accessTokenData.accessToken]];
        NSLog(@"accessToken: %@", appDelegate.session.accessTokenData.accessToken);

        // FBログイン後、Push通知の登録／更新を実施
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];

    } else {
        NSLog(@"updateView NOT isOpen");
        // login-needed account UI is shown whenever the session is closed
        [self.loginButton setTitle:@"Log in" forState:UIControlStateNormal];
        [self.textLabel setText:@"Login to create a link to fetch account data"];
    }
}

- (IBAction)getData:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://10.0.1.6:9000/api/countries" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)getToken:(id)sender {
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen) {

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:@"http://10.0.1.6:9000/api/sessions" parameters:@{@"provider": @"facebook", @"access_token_hash": @{@"access_token": appDelegate.session.accessTokenData.accessToken}} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}
@end
