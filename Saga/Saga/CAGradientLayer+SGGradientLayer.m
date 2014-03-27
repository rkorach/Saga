//
//  CAGradientLayer+SGGradientLayer.m
//  Saga
//
//  Created by Raphaël Korach on 27/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "CAGradientLayer+SGGradientLayer.h"
#import "UIColor+SGColors.h"

@implementation CAGradientLayer (SGGradientLayer)

+ (void)addTransparentBlueGradientLayerToView: (UIView *)view{
    
    // code found here http://stackoverflow.com/questions/422066/gradients-on-uiview-and-uilabels-on-iphone/1931498#1931498
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;
    gradient.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor SGTransparentBlueColor].CGColor];
    gradient.startPoint = CGPointMake(0.0, 0.3);
    gradient.endPoint = CGPointMake(1.0, 0.7);
    [view.layer insertSublayer:gradient atIndex:0];
}

@end
