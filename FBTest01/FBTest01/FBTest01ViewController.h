//
//  FBTest01ViewController.h
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/09.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBTest01PageContentViewController.h"

@interface FBTest01ViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;

- (IBAction)pushCyLogin:(id)sender;
- (IBAction)pushCyLogout:(id)sender;

@end
