//
//  FailedBankInfo.m
//  SQLiteTest01
//
//  Created by Masaki Iwamoto on 2014/09/20.
//  Copyright (c) 2014年 Wanderlust, Inc. All rights reserved.
//

#import "FailedBankInfo.h"

@implementation FailedBankInfo

- (id)initWithUniqueId:(int)uniqueId name:(NSString *)name city:(NSString *)city state:(NSString *)state
{
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.name = name;
        self.city = city;
        self.state = state;
    }
    return self;
}

@end
