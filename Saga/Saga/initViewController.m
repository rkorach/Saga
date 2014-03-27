//
//  initViewController.m
//  Saga
//
//  Created by Raphaël Korach on 25/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "initViewController.h"

@interface initViewController ()

@end

@implementation initViewController

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


#pragma mark - Login and Signup Process
// tutorial and code available on Parse website: https://parse.com/tutorials/login-and-signup-views

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) {
        UIViewController *walkthroughVC = [self.storyboard instantiateViewControllerWithIdentifier:@"WalkthroughMaster"];
        [self presentViewController:walkthroughVC animated:NO completion:NULL];
    } else {
        [PFUser logOut]; // log out, for coding purpose.
        
        /* Hamburger menu code */
        // we set the what we want to be the initial ViewController as the top viewController
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
        /* end hamburger menu code */
    }
}

@end
