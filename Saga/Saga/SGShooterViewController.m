//
//  SGShooterViewController.m
//  Saga
//
//  Created by Raphaël Korach on 22/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGShooterViewController.h"
#import "ECSlidingViewController/ECSlidingViewController.h"
#import "UIImage+ImageWithUIView.h"
#import <AVFoundation/AVFoundation.h>

@interface SGShooterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation SGShooterViewController

//Global variables from the camera
AVCaptureSession *session;
AVCaptureStillImageOutput *stillImageOutput;

- (void)viewWillAppear:(BOOL)animated
{
    //Set camera type
    [self SAGAType];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)touchEscapeShooterButton:(UIButton *)sender {
    [self backToPreviousViewController:sender.center];
}

- (void)backToPreviousViewController:(CGPoint)originPoint
{
    UIViewController *destinationVC = self.previousViewController;
    
    // TODO(pink) it looks like having a layer on top still enables to click on
    // the "dismiss" cross underneath. Handle this.
    
    // Create destination image layer
    UIImage *destinationImage = [UIImage imageFromView:destinationVC.view];
    CALayer * destinationLayer = [CALayer layer];
    CGRect destinationFrame = CGRectMake(0.0, 0.0, destinationImage.size.width, destinationImage.size.height);
    destinationLayer.contents = (id)destinationImage.CGImage;
    destinationLayer.frame = destinationFrame;
    
    // Create current image layer
    UIImage *currentImage = [UIImage imageFromView:self.view];
    CALayer * currentLayer = [CALayer layer];
    CGRect currentFrame = CGRectMake(0.0, 0.0, currentImage.size.width, currentImage.size.height);
    currentLayer.contents = (id)currentImage.CGImage;
    currentLayer.frame = currentFrame;
    
    // Add the two layers for the animation
    [self.view.layer addSublayer:destinationLayer];
    [self.view.layer addSublayer:currentLayer];

    CGRect rect = CGRectMake(originPoint.x-10, originPoint.y-10, 20.0, 20.0);
    CGRect maskRect = CGRectMake(0, 0, 20.0, 20.0);

    // Create the mask that will be animated
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:maskRect
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(destinationVC.view.bounds.size.height/2, destinationVC.view.bounds.size.height/2)];

    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // for this disapearing transition, we animate the current view
    // with a mask, not the destination view.
    currentLayer.mask = maskLayer;
    
    // Custom transformation (because it is on a CALayer, not on a UIView) start scale
    currentLayer.mask.anchorPoint = CGPointMake(0.5f, 0.5f);
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
        [destinationLayer removeFromSuperlayer];
        [currentLayer removeFromSuperlayer];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
    
    [currentLayer.mask addAnimation:scale forKey:nil]; // launch animation
    
    [CATransaction commit];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Get the back camera display on the screen where the frame is
    session = [[AVCaptureSession alloc] init];
    [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:&error];
    
    if([session canAddInput:deviceInput]){
        [session addInput:deviceInput];
    }
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self frameForCapture] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.frameForCapture.frame;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    [session startRunning];
    NSLog(@"startrunning");
    
	// Do any additional setup after loading the view.
    self.closeButton.layer.cornerRadius = self.closeButton.bounds.size.width / 2.0;
}

- (void)viewDidUnload{
    [session stopRunning];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewDidAppear:animated];
}

- (IBAction)takePhoto:(id)sender {
    AVCaptureConnection *videoConnection = nil;
    for(AVCaptureConnection *connection in stillImageOutput.connections){
        for(AVCaptureInputPort *port in connection.inputPorts){
            if([[port mediaType] isEqual:AVMediaTypeVideo]){
                videoConnection = connection;
                break;
            }
        }
        if(videoConnection)
            break;
    }
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if(imageDataSampleBuffer != NULL){
            NSData *imagedata = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation: imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imagedata];
            //TODO: resize the image according to camera mode then send it to parse
            self.outputImage.image = image;
        }
    }];
}

- (IBAction)switchSAGA:(id)sender {
    [self SAGAType];
}

- (void)SAGAType {
    if([[self switchImageType] isOn]){
        [[self GALabel] setHidden: true];
        [[self SAImage] setHidden: false];
    }
    else{
        [[self GALabel] setHidden: false];
        [[self SAImage] setHidden: true];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
