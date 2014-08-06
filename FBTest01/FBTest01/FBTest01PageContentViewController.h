//
//  FBTest01PageContentViewController.h
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/08/06.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBTest01PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

@end
