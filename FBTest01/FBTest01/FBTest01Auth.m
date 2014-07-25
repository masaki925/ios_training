//
//  FBTest01Auth.m
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/23.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import "FBTest01Auth.h"
#import "FBTest01User.h"

@implementation FBTest01Auth

- (FBTest01User *) currentUser {
    NSLog(@"FBTest01Auth currentUser");
    return [FBTest01User new];
}

@end
