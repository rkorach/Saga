//
//  SGShooterViewController.h
//  Saga
//
//  Created by Raphaël Korach on 22/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGShooterViewController : UIViewController
@property (nonatomic, weak) UIViewController *previousViewController;

@property (strong, nonatomic) IBOutlet UIView *frameForCapture;

@property (nonatomic) BOOL active;

- (IBAction)takePhoto:(id)sender;

@end
