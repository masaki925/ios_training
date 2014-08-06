//
//  FBTest01RegisterProfileViewController.m
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/08/01.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import "FBTest01RegisterProfileViewController.h"
#import "FBTest01AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@interface FBTest01RegisterProfileViewController ()

@end

@implementation FBTest01RegisterProfileViewController

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
    
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    if (appDelegate.cyAuth){
        NSString *name =[appDelegate.cyAuth getCurrentUser].name;
        _nameField.text = name;
    }

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushFinishButton:(id)sender
{
    NSLog(@"push");
    
    NSString *cyProtocol = [[NSProcessInfo processInfo] environment][@"CY_PROTOCOL"];
    NSString *cyFqdn     = [[NSProcessInfo processInfo] environment][@"CY_FQDN"];

    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    NSString *username = [appDelegate.cyAuth getCurrentUser].username;
    NSString *name = _nameField.text;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
#ifdef DEBUG
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:@"1derlust" password:@"compa4"];
#endif
    [manager.requestSerializer setValue:appDelegate.cyAuth.getToken forHTTPHeaderField:@"cyAccessToken"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];

    [manager PUT:[NSString stringWithFormat:@"%@://%@/api/v3/users/%@", cyProtocol, cyFqdn, username] parameters:@{@"user": @{@"name": name} } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
}

- (IBAction)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
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

@end
