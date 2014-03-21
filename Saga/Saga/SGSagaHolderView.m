//
//  SGSagaHolderView.m
//  Saga
//
//  Created by Raphaël Korach on 21/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGSagaHolderView.h"

@implementation SGSagaHolderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


static float CORNER_RADIUS = 3.0;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Create the path (with the corners rounded)
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(CORNER_RADIUS, CORNER_RADIUS)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the current view's layer
    self.layer.mask = maskLayer;
    
    // clip the subviews
    self.clipsToBounds = YES;
}



#pragma mark - Initialization
-(void)setup {
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib {
    [self setup];
}

@end
