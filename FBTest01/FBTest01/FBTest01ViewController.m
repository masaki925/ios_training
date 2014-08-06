//
//  FBTest01ViewController.m
//  FBTest01
//
//  Created by Masaki Iwamoto on 2014/07/09.
//  Copyright (c) 2014年 iwatest. All rights reserved.
//

#import "FBTest01ViewController.h"

#import "FBTest01AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AFNetworking/AFNetworking.h>
#import <Security/Security.h>
#import <UICKeyChainStore.h>
#import "FBTest01Auth.h"

@implementation FBTest01ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _pageTitles = @[@"page1 title", @"page2 title", @"page3 title", @"page4 title"];
    _pageImages = @[@"page1.png", @"page2.png", @"page3.png", @"page4.png"];
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    FBTest01PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 60);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pushCyLogin:(id)sender {
    NSLog(@"pushCyLogin");
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    
    if (appDelegate.cyAuth.sessionIsOpen) {
        NSLog(@"pushCyLogin: isOpen");
    } else {
        //if (!appDelegate.cyAuth) {
            appDelegate.cyAuth = [FBTest01Auth new];
        //}
        NSLog(@"pushCyLogin: !isOpen");
        [appDelegate.cyAuth openCySession:^(NSString *token){
            NSLog(@"cyAuth openCySession success");
            NSLog(@"%@", token);
            [self updateRootView];
        } failure:^(NSString *token){
            NSLog(@"cyAuth openCySession failure");
            NSLog(@"error: %@", token);
        }];
    }
}

- (IBAction)pushCyLogout:(id)sender {
    NSLog(@"pushCyLogout");
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];
    [appDelegate.cyAuth closeAndClearTokenInfo];
}

- (void) updateRootView
{
    FBTest01AppDelegate *appDelegate = [[UIApplication sharedApplication]delegate];

    NSString *sbId = @"";
    if (appDelegate.cyAuth.sessionIsOpen) {
        sbId = @"SubStoryboard";
    } else {
        sbId = @"Main";
    }
        
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbId bundle:[NSBundle mainBundle]];
    UIViewController *initialViewController = [storyboard instantiateInitialViewController];
    appDelegate.window.rootViewController = initialViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FBTest01PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((FBTest01PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageTitles count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (FBTest01PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageTitles count] == 0) || (index >= [self.pageTitles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    FBTest01PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    pageContentViewController.imageFile = self.pageImages[index];
    pageContentViewController.titleText = self.pageTitles[index];
    pageContentViewController.pageIndex = index;
    
    return pageContentViewController;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageTitles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
