//
//  IwaDetailViewController.m
//  SQLiteTest01
//
//  Created by Masaki Iwamoto on 2014/09/20.
//  Copyright (c) 2014年 Wanderlust, Inc. All rights reserved.
//

#import "IwaDetailViewController.h"

@interface IwaDetailViewController ()
- (void)configureView;
@end

@implementation IwaDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
