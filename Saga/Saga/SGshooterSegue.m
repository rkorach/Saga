//
//  SGshooterSegue.m
//  Saga
//
//  Created by Raphaël Korach on 22/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGshooterSegue.h"
#import "SGShooterViewController.h"

@implementation SGshooterSegue

- (void)perform {
    // overrides the UIStoryboardSegue superclass perform method.
    // triggered when the segue happens.
    
    UIViewController *sourceVC = self.sourceViewController;
    SGShooterViewController *destinationVC = self.destinationViewController;
    // We set the destination VC as inactive because clicking a button
    // during the transition crashes the app
    destinationVC.active = NO;
    
    // We tell the destination VC what was the previous view to be able to do the
    // reverse transition effect without a segue
    destinationVC.backViewControllerView = sourceVC.view;
    
    // Add the destination view as a subview, temporarily
    [sourceVC.view addSubview:destinationVC.view];
    
    // Create the mask that will be animated
    CGRect rect = CGRectMake(self.originatingPoint.x - 10, self.originatingPoint.y - 10, 20.0, 20.0);
    CGRect maskRect = CGRectMake(0, 0, 20.0, 20.0);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskRect
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(destinationVC.view.bounds.size.height/2, destinationVC.view.bounds.size.height/2)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the destination VC view's mask
    destinationVC.view.layer.mask = maskLayer;
    
    // Custom transformation (because it is on a CALayer, not on a UIView) start scale
    destinationVC.view.layer.mask.anchorPoint = CGPointMake(0.5f, 0.5f);
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [scale setFromValue:[NSNumber numberWithFloat:0.0f]];
    [scale setToValue:[NSNumber numberWithFloat:60.0]];
    [scale setDuration:0.2f];
    [scale setRemovedOnCompletion:NO];
    [scale setFillMode:kCAFillModeForwards];

    // completion block serves as a completion callback.
    // When all code between the completion block definition and the [CATransaction commit]
    // is done executing, th completion block executes
    [CATransaction setCompletionBlock:^{
        destinationVC.view.layer.mask = nil;
        destinationVC.active = YES; // now the destination VC can be active
        [destinationVC.view removeFromSuperview]; // remove from temp super view
        [sourceVC presentViewController:destinationVC animated:NO completion:NULL]; // present VC
    }];
    
    [destinationVC.view.layer.mask addAnimation:scale forKey:nil]; //launch animation
    
    [CATransaction commit];
}

@end
