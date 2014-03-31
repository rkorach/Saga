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
    [self SAGAMode];
    
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
    
    CALayer *rootLayer = [[self backgroundView] layer];
    [rootLayer setMasksToBounds:YES];
    CGRect frame = self.frameForCapture.frame;
    
    [previewLayer setFrame:frame];
    
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:stillImageOutput];
    [session startRunning];
    
	// Do any additional setup after loading the view.
    self.closeButton.layer.cornerRadius = self.closeButton.bounds.size.width / 2.0;
}

- (void)viewDidUnload{
    //Stop the camera video
    [session stopRunning];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Hide the status bar on the camera view
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

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
            
            UIImage *SAGAimage = [self resizeImage:[self cropSquareImage:image] newSize:CGSizeMake(640.0f, 640.0f)];
            
            //Display the output image
            self.outputImage.image = SAGAimage;
            
            if([[self switchImageType] isOn])
                self.SAImage.image = [self cropSAGAImage:SAGAimage isSA:YES];
            else
                self.SAImage.image = [self cropSAGAImage:SAGAimage isSA:NO];        }
    }];
}

- (IBAction)switchSAGA:(id)sender {
    [self SAGAMode];
}

#pragma mark - Helper methods

- (void)SAGAMode {
    if([[self switchImageType] isOn]){
        [[self GALabel] setHidden: true];
        [[self SAImage] setHidden: false];
    }
    else{
        [[self GALabel] setHidden: false];
        [[self SAImage] setHidden: true];
    }
}

- (UIImage *)cropSquareImage:(UIImage *)original{
    UIImage *newImage = nil;
    
    // This calculates the crop area.
    
    float newWidth  = original.size.width * original.scale;
    float newHeight = original.size.width * original.scale;
    
    float posX = (original.size.height * original.scale - newHeight) * 0.5f;
    float posY = (original.size.width * original.scale - newWidth) * 0.5f;
    CGRect cropSquare = CGRectMake(posX, posY, newWidth, newHeight);
    
    // This performs the image cropping.
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], cropSquare);
    
    newImage = [UIImage imageWithCGImage:imageRef scale:original.scale orientation:original.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return newImage;
}

- (UIImage *)cropSAGAImage:(UIImage *)original isSA:(BOOL)isSa{
    UIImage *newImage = nil;
    
    // This calculates the crop area.
    
    float newWidth  = original.size.width * original.scale;
    float newHeight = original.size.height * original.scale * 0.5f;
    
    float posY = 0.0f;
    float posX = 0.0f;
    if (!isSa)
        posY = (original.size.height * original.scale) * 0.5f;
    
    CGRect cropSquare = CGRectMake(posX, posY, newWidth, newHeight);
    
    // This performs the image cropping.
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], cropSquare);
    
    newImage = [UIImage imageWithCGImage:imageRef scale:original.scale orientation:original.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return newImage;
}

- (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)newSize {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGImageRef imageRef = image.CGImage;
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, newSize.height);
    
    CGContextConcatCTM(context, flipVertical);
    // Draw into the context; this scales the image
    CGContextDrawImage(context, newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(context);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:image.scale orientation:image.imageOrientation];
    
    CGImageRelease(newImageRef);
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
