//
//  FBTest01RegisterProfileViewController.h
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/08/01.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBTest01RegisterProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;

- (IBAction)pushFinishButton:(id)sender;
- (IBAction)textFieldShouldReturn:(UITextField *)textField;

@end
