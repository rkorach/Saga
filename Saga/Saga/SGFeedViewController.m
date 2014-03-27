//
//  SGFeedViewController.m
//  Saga
//
//  Created by Julien on 09/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGFeedViewController.h"
#import "SGshooterSegue.h"
#import "SGShooterViewController.h"
#import "ECSlidingViewController/ECSlidingViewController.h"
#import "SGMenuViewController.h"
#import "CAGradientLayer+SGGradientLayer.h"


@interface SGFeedViewController ()
@property (weak, nonatomic) IBOutlet UIButton *shooterButton;
@property (weak, nonatomic) IBOutlet UIView *topBarView;

@end

@implementation SGFeedViewController

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
    
    self.shooterButton.layer.cornerRadius = self.shooterButton.bounds.size.width / 2.0;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [CAGradientLayer addTransparentBlueGradientLayerToView:self.topBarView];
    
    /* hamburger menu code */
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[SGMenuViewController class]]) {
        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    /* end hamburger menu code */

}

- (IBAction)touchMenuButton {
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue isKindOfClass:[SGshooterSegue class]]) {
        // Set the start point for the animation to center of the button for the animation
        ((SGshooterSegue *)segue).originatingPoint =  self.shooterButton.center;
    }
}

- (IBAction)unwindFromViewController:(UIStoryboardSegue *)segue {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Styling methods

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
