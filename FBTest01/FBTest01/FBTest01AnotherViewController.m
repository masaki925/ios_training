//
//  FBTest01AnotherViewController.m
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/21.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import "FBTest01AnotherViewController.h"
#import <UICKeyChainStore.h>

@interface FBTest01AnotherViewController ()

@end

@implementation FBTest01AnotherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)rmTokenFromLocal:(id)sender {
    [UICKeyChainStore removeItemForKey:@"cyAccessToken"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *initialViewController = [storyboard instantiateInitialViewController];
    [self presentViewController:initialViewController animated:NO completion:nil];
}
@end
