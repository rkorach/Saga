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

    /* Hamburger menu code */
    // we set the what we want to be the initial ViewController as the top viewController
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Home"];
    /* end hamburger menu code */

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
