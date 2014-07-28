//
//  FBTest01Auth.m
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/23.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import "FBTest01Auth.h"
#import "FBTest01User.h"
#import "FBTest01AccessToken.h"
#import "FBTest01AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

#import <UICKeyChainStore.h>
#import <Bolts.h>

@interface FBTest01Auth ()

@property FBTest01AccessToken *accessToken;

@end

@implementation FBTest01Auth

- (instancetype) init {
    _sessionIsOpen = NO;
    _hasToken    = NO;
    _accessToken = NULL;

    [self getAccessTokenFromLocal];

    return self;
}

- (FBTest01User *) currentUser {
    NSLog(@"FBTest01Auth currentUser");
    return [FBTest01User new];
}

- (void) getAccessTokenFromLocal {
    NSString *token = [UICKeyChainStore stringForKey:@"cyAccessToken"];
    if (token) {
        NSLog(@"getAccessTokenFromLocal: token is EXIST!");
        FBTest01AccessToken *cyAccessToken = [FBTest01AccessToken new];
        cyAccessToken.token = token;
        _accessToken = cyAccessToken;
        _hasToken = YES;
    }
}

//- (void)openCySession:(void (^)(NSString *))success
//            failure:(void (^)(NSString *))failure {
//    NSLog(@"FBTest01AccessToken: openSession");
//
//    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
//
//    if (!appDelegate.session.isOpen) {
//        appDelegate.session = [[FBSession alloc] init];
//        
//        if (appDelegate.session.state != FBSessionStateCreated) {
//            // Create a new, logged out session.
//            appDelegate.session = [[FBSession alloc] init];
//        }
//        // if the session isn't open, let's open it now and present the login UX to the user
//        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
//                                                         FBSessionState status,
//                                                         NSError *error) {
//            // and here we make sure to update our UX according to the new session state
//            NSLog(@"FBTest01Auth: openCySession");
//            NSLog(@"FBTest01Auth: accessToken: %@", appDelegate.session.accessTokenData.accessToken);
//
//            //[self verify];
//            //success(appDelegate.session.accessTokenData.accessToken);
//        }];
//    }
//}

// javascript っぽい書き方
//        $bolt.get('/api/fbLogin').success( function(data) {
//         $bolt.get('/api/cyLogin').success( function(data) {
//             NSlog("%@", data);
//         }).error( function(data){
//              // error handling
//           });
//        }).error( function(data) {
//            // error handle
//        });
//- (void)nestedRequest {
- (void)openCySession:(void (^)(NSString *))success
            failure:(void (^)(NSString *))failure {
    [[[self fbLogin] continueWithBlock:^id(BFTask *task) {
        NSLog(@"do something for hoge: %@", task.result);
        // ...
        return [self cyLogin];
    }] continueWithBlock:^id(BFTask *task){
        NSLog(@"do something for fuga: %@", task.result);
        return nil;
    }];
}

- (BFTask *)fbLogin {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];

    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] init];

        if (appDelegate.session.state != FBSessionStateCreated) {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            NSLog(@"FBTest01Auth: openCySession");
            NSLog(@"FBTest01Auth: accessToken: %@", appDelegate.session.accessTokenData.accessToken);
            task.result = appDelegate.session.accessTokenData.accessToken;
            
            //[self verify];
            //success(appDelegate.session.accessTokenData.accessToken);
        }];
    } else {
        task.result = nil;
    }

    return task.task;
}

- (BFTask *)cyLogin {
    BFTaskCompletionSource *task = [BFTaskCompletionSource taskCompletionSource];
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSString *cyProtocol = [[NSProcessInfo processInfo] environment][@"CY_PROTOCOL"];
    NSString *cyFqdn     = [[NSProcessInfo processInfo] environment][@"CY_FQDN"];
    
    if (appDelegate.session.accessTokenData) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager POST:[NSString stringWithFormat:@"%@://%@/api/sessions", cyProtocol, cyFqdn] parameters:@{@"provider": @"facebook", @"access_token_hash": @{@"access_token": appDelegate.session.accessTokenData.accessToken
        }} success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *token    = responseObject[@"access_token"];
            NSString *username = responseObject[@"username"];
            
            [UICKeyChainStore setString:token forKey:@"cyAccessToken"];
            NSLog(@"cyAccessToken: %@", [UICKeyChainStore stringForKey:@"cyAccessToken"]);

            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:username forKey:@"username"];
            NSLog(@"username: %@", [ud objectForKey:@"username"]);

            FBTest01AccessToken *cyAccessToken = [FBTest01AccessToken new];
            cyAccessToken.token = token;
            _accessToken = cyAccessToken;
            _hasToken = YES;
            _sessionIsOpen = YES;

            task.result = token;

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } else {
        task.result = nil;
    }
    
    return task.task;
}

- (void)closeAndClearTokenInfo {
    NSLog(@"closeAndClearTokenInfo");
    [UICKeyChainStore removeItemForKey:@"cyAccessToken"];
    _hasToken = NO;
    _sessionIsOpen = NO;

    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.session closeAndClearTokenInformation];
}

@end
