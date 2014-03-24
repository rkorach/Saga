//
//  SGShooterViewController.m
//  Saga
//
//  Created by Raphaël Korach on 22/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGShooterViewController.h"

@interface SGShooterViewController ()

@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation SGShooterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)touchEscapeShooterButton:(UIButton *)sender {
    if (self.active) { // do not perform anything if the VC is animating
        [self backToPreviousViewController:sender.center];
    }
}

- (void)backToPreviousViewController:(CGPoint)originPoint
{
    UIView *destinationVCView = self.backViewControllerView;
    
    // Add the destination view as a subview, temporarily
    // and send it in the back.
    // because we need to hide the destination view, we've added a
    // 'background' view to the current view
    [self.view addSubview:destinationVCView];
    [self.view sendSubviewToBack:destinationVCView];
    CGRect rect = CGRectMake(originPoint.x-10, originPoint.y-10, 20.0, 20.0);
    CGRect maskRect = CGRectMake(0, 0, 20.0, 20.0);
    
    // Create the mask that will be animated
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskRect
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(destinationVCView.bounds.size.height/2, destinationVCView.bounds.size.height/2)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // for this disapearing transition, we animate the current view
    // with a mask, not the destination view.
    self.backgroundView.layer.mask = maskLayer;
    
    // Custom transformation (because it is on a CALayer, not on a UIView) start scale
    self.backgroundView.layer.mask.anchorPoint = CGPointMake(0.5f, 0.5f);
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scale setFromValue:[NSNumber numberWithFloat:60.0f]];
    [scale setToValue:[NSNumber numberWithFloat:0.0]];
    [scale setDuration:0.2f];
    [scale setRemovedOnCompletion:NO];
    [scale setFillMode:kCAFillModeForwards];
    
    // completion block serves as a completion callback.
    // When all code between the completion block definition and the [CATransaction commit]
    // is done executing, th completion block executes
    [CATransaction setCompletionBlock:^{
        [destinationVCView removeFromSuperview]; // remove from temp super view
        // dismiss current VC and pop back to previous one
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    [self.backgroundView.layer.mask addAnimation:scale forKey:nil]; // launch animation
    
    [CATransaction commit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.closeButton.layer.cornerRadius = self.closeButton.bounds.size.width / 2.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
