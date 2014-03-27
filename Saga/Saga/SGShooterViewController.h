//
//  SGShooterViewController.h
//  Saga
//
//  Created by Raphaël Korach on 22/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGShooterViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *frameForCapture;
@property (strong, nonatomic) IBOutlet UIImageView *SAImage;
@property (strong, nonatomic) IBOutlet UILabel *GALabel;
@property (strong, nonatomic) IBOutlet UISwitch *switchImageType;

@property (nonatomic, weak) UIView *backViewControllerView;
@property (nonatomic) BOOL active;

- (IBAction)takePhoto:(id)sender;
- (IBAction)switchSAGA:(id)sender;

- (void)SAGAType;

@end
