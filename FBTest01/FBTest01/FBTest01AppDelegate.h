//
//  FBTest01AppDelegate.h
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/09.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "FBTest01Auth.h"

@interface FBTest01AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) FBSession *session;
@property (strong, nonatomic) FBTest01Auth *cyAuth;

@end
