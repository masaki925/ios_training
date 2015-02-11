//
//  ViewController.m
//  iwaHoge02
//
//  Created by Masaki Iwamoto on 2015/02/11.
//  Copyright (c) 2015年 Wanderlust, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[GAI sharedInstance].defaultTracker set:kGAIScreenName value:@"トップページ"];
    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createAppView] build]];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
