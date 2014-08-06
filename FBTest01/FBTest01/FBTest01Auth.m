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

typedef void (^CompletionBlock)(NSString *);
CompletionBlock _completionHandler;

@interface FBTest01Auth ()

@property FBTest01AccessToken *accessToken;
@property FBTest01User *currentUser;

@end

@implementation FBTest01Auth

- (instancetype) init {
    _sessionIsOpen = NO;
    _hasToken    = NO;
    _accessToken = nil;
    _currentUser = nil;

    [self getAccessTokenFromLocal];

    return self;
}

- (FBTest01User *) getCurrentUser {
    NSLog(@"FBTest01Auth currentUser");
    return _currentUser;
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

- (void)verify {
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    NSString *cyProtocol = [[NSProcessInfo processInfo] environment][@"CY_PROTOCOL"];
    NSString *cyFqdn     = [[NSProcessInfo processInfo] environment][@"CY_FQDN"];
    
    if (appDelegate.session.accessTokenData) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        [manager POST:[NSString stringWithFormat:@"%@://%@/api/sessions", cyProtocol, cyFqdn] parameters:@{@"provider": @"facebook", @"access_token_hash": @{@"access_token": appDelegate.session.accessTokenData.accessToken
         }} success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSString *token    = responseObject[@"access_token"];
             NSString *username = responseObject[@"username"];
             NSString *name     = responseObject[@"name"];
             BOOL userIsActive = ([responseObject[@"active"] boolValue] == 1);
             
             [UICKeyChainStore setString:token forKey:@"cyAccessToken"];
             NSLog(@"cyAccessToken: %@", [UICKeyChainStore stringForKey:@"cyAccessToken"]);
             
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
             [ud setObject:username forKey:@"username"];
             [ud setObject:name forKey:@"name"];
             [ud setBool:userIsActive forKey:@"userIsActive"];
             NSLog(@"username: %@", [ud objectForKey:@"username"]);
             NSLog(@"userIsActive: %@", [ud objectForKey:@"userIsActive"]);
             
             FBTest01AccessToken *cyAccessToken = [FBTest01AccessToken new];
             cyAccessToken.token = token;
             
             _currentUser = [FBTest01User new];
             _currentUser.isActive = userIsActive;
             _currentUser.username = username;
             _currentUser.name = name;
             _accessToken = cyAccessToken;
             _hasToken = YES;
             _sessionIsOpen = YES;
             
             if (!_currentUser.isActive){
                 UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"RegisterProfile" bundle:[NSBundle mainBundle]];
                 UIViewController *initialViewController = [storyboard instantiateInitialViewController];
                 [appDelegate.window.rootViewController presentViewController:initialViewController animated:NO completion:nil];
             }

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    }
}

- (void)openCySession:(void (^)(NSString *))success
            failure:(void (^)(NSString *))failure {
    NSLog(@"FBTest01Auth: openSession");

    _completionHandler = success;

    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    if (!appDelegate.session.isOpen) {
        appDelegate.session = [[FBSession alloc] initWithPermissions:@[@"public_profile", @"email", @"user_friends"]];

        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            NSLog(@"FBTest01Auth: openCySession");
            NSLog(@"FBTest01Auth: accessToken: %@", appDelegate.session.accessTokenData.accessToken);
            [self updateFbSession];
        }];
    } else {
        NSLog(@"appDelegate.session.isOpen");
    }
}

- (void)updateFbSession {
    NSLog(@"updateFbSession");
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    if (appDelegate.session.isOpen) {
        NSLog(@"updateFbSession: fb session.isOpen");
        if (_sessionIsOpen) {
            NSLog(@"updateFbSession: cy sessionIsOpen");
        } else {
            NSLog(@"updateFbSession: ! cy sessionIsOpen");
            [self verify];
            _sessionIsOpen = YES;
            _completionHandler(@"hoge");
        }
    } else {
        _completionHandler(@"hoge");
        NSLog(@"updateFbSession: ! fb session.isOpen");
    }
}

- (void)closeAndClearTokenInfo {
    NSLog(@"closeAndClearTokenInfo");
    [UICKeyChainStore removeItemForKey:@"cyAccessToken"];
    _hasToken = NO;
    _sessionIsOpen = NO;

    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.session closeAndClearTokenInformation];
}

- (NSString *)getToken {
    return _accessToken.token;
}

@end
