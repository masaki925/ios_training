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
#import <UICKeyChainStore.h>

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

- (void) verify {
    NSLog(@"verify");
    NSString *token = @"dummyAccessToken";
    [UICKeyChainStore setString:token forKey:@"cyAccessToken"];
    FBTest01AccessToken *cyAccessToken = [FBTest01AccessToken new];
    cyAccessToken.token = token;
    _accessToken = cyAccessToken;
    _hasToken = YES;
}

- (void)openSession:(void (^)(NSString *))success
            failure:(void (^)(NSString *))failure {
    NSLog(@"FBTest01AccessToken: openSession");

    [self verify];

    success(_accessToken.token);
    
    _sessionIsOpen = YES;
}

@end
