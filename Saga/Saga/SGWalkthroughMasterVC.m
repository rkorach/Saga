//
//  SGWalkthroughMasterVC.m
//  Saga
//
//  Created by Raphaël Korach on 26/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGWalkthroughMasterVC.h"
#import "CAGradientLayer+SGGradientLayer.h"

@interface SGWalkthroughMasterVC ()

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageNames;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SGWalkthroughMasterVC

- (NSArray *)pageNames
{
    // lazy instanciation
    if (!_pageNames) {
        _pageNames = @[@"Page1", @"Page2", @"Page3", @"Page4"];
    }
    return _pageNames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.signUpButton.layer.cornerRadius = 6;

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [CAGradientLayer addTransparentBlueGradientLayerToView:self.view];

    // Create page view controller
    UIPageViewController *pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WalkthroughPageViewController"];
    pageViewController.dataSource = self;
    
    SGWalkthroughPageVC *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.bottomView.frame.size.height);
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SGWalkthroughPageVC*)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= [self.pageNames count]) {
        return nil;
    }
    // Create a new view controller.
    return [self.storyboard instantiateViewControllerWithIdentifier:self.pageNames[index]];
}

- (IBAction)unwindToWalkthrough:(UIStoryboardSegue *)unwindSegue
{
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pageNames indexOfObject:viewController.restorationIdentifier];
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }

    return [self viewControllerAtIndex:index-1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.pageNames indexOfObject:viewController.restorationIdentifier];
    
    if (index == [self.pageNames count] || (index == NSNotFound)) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index+1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageNames count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
