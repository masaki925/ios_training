//
//  FBTest01Auth.h
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/23.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FBTest01User.h"
#import "FBTest01AccessToken.h"

@interface FBTest01Auth : NSObject

@property BOOL sessionIsOpen;
@property BOOL hasToken;

- (FBTest01User *) currentUser;

- (void)openCySession:(void (^)(NSString *))success
              failure:(void (^)(NSString *))failure;

- (void)closeAndClearTokenInfo;
- (NSString *)getToken;
@end
