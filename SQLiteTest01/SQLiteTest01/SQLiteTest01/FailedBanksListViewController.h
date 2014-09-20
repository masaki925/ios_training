//
//  FailedBanksListViewController.h
//  SQLiteTest01
//
//  Created by Masaki Iwamoto on 2014/09/20.
//  Copyright (c) 2014年 Wanderlust, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FailedBanksDetailViewController.h"

@interface FailedBanksListViewController : UITableViewController

@property (nonatomic, retain) NSArray *failedBankInfos;
@property (nonatomic, retain) FailedBanksDetailViewController *details;

@end
