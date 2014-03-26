//
//  SGMenuViewController.m
//  Saga
//
//  Created by Raphaël Korach on 25/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGMenuViewController.h"
#import "ECSlidingViewController/ECSlidingViewController.h"
#import "SGMenuTableViewController.h"

@interface SGMenuViewController ()

@property (strong, nonatomic) NSArray *menuCells;

@end

@implementation SGMenuViewController

- (NSArray *)menuCells
{
    // lazy instanciation
    if (!_menuCells) {
        _menuCells = @[@"Home", @"Profile"];
    }
    return _menuCells;
}

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
    [self.slidingViewController setAnchorRightRevealAmount:240.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // -- Master View Controller
    if ([segue.identifier isEqualToString:@"MenuTableViewEmbed"])
    {
        SGMenuTableViewController *menuTableViewController = segue.destinationViewController;
        menuTableViewController.menuCells = self.menuCells;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
