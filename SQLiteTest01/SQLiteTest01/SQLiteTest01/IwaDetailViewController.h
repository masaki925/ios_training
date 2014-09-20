//
//  IwaDetailViewController.h
//  SQLiteTest01
//
//  Created by Masaki Iwamoto on 2014/09/20.
//  Copyright (c) 2014年 Wanderlust, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IwaDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
