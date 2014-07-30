//
//  FBTest01AnotherViewController.m
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/21.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import "FBTest01AnotherViewController.h"
#import "FBTest01AppDelegate.h"
#import <UICKeyChainStore.h>
#import <AFNetworking/AFNetworking.h>

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
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.cyAuth closeAndClearTokenInfo];    
}

- (IBAction)pushGetData:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"1derlust" password:@"compa4"];
    
    NSString *cyProtocol = [[NSProcessInfo processInfo] environment][@"CY_PROTOCOL"];
    NSString *cyFqdn     = [[NSProcessInfo processInfo] environment][@"CY_FQDN"];
    
    [manager GET:[NSString stringWithFormat:@"%@://%@/api/countries", cyProtocol, cyFqdn] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
@end
