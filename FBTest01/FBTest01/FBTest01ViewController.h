//
//  FBTest01ViewController.h
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/09.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBTest01ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
- (IBAction)pushLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *getDataButton;
- (IBAction)getData:(id)sender;
- (IBAction)getToken:(id)sender;
- (IBAction)openAnotherView:(id)sender;

@end
