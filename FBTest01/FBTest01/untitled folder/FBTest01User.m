//
//  FBTest01User.m
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/23.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import "FBTest01User.h"

@interface FBTest01User ()

@property NSString *username;

@end

@implementation FBTest01User

- (instancetype) init{
        NSLog(@"FBTest01User: init!");
        _username = @"testusername";
        _isActive = YES;
        return self;
}

@end
