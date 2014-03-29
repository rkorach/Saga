//
//  SGPasswordReseterViewController.m
//  Saga
//
//  Created by Raphaël Korach on 29/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGPasswordReseterViewController.h"
#import "UIColor+SGColors.h"

@interface SGPasswordReseterViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) UITextField *emailLine;

@end

@implementation SGPasswordReseterViewController

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
    self.emailField.delegate = self;
    [self initPlaceholderColorForTextField:self.emailField];
    [self drawLines];
    [self.emailField becomeFirstResponder];
    
    self.emailField.tag = 0;
}

- (void)initPlaceholderColorForTextField:(UITextField *)textField
{
    if (!textField.placeholder) return;
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    [textField setAttributedPlaceholder:attributedPlaceholder];
}

- (void)drawLines
{
    NSArray *textFields = @[self.emailField];
    NSMutableArray *lines;
    
    for (UITextField *textField in textFields) {
        // Add a bottomBorder.
        CGRect layerFrame = CGRectMake(0, 0, textField.frame.size.width, textField.frame.size.height);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, layerFrame.size.height-7);
        CGPathAddLineToPoint(path, NULL, layerFrame.size.width, layerFrame.size.height-7);
        CAShapeLayer * line = [CAShapeLayer layer];
        line.path = path;
        line.lineWidth = 1;
        line.frame = layerFrame;
        line.strokeColor = [UIColor whiteColor].CGColor;
        [textField.layer addSublayer:line];
        if (!lines){
            lines = [[NSMutableArray alloc]init];
        }
        [lines addObject:line];
    }
    
    self.emailLine = lines[[textFields indexOfObject:self.emailField]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    [textField setTextColor:[UIColor SGRedColor]];
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor SGRedColor]}];
    [textField setAttributedPlaceholder:attributedPlaceholder];
    
    NSArray *textFields = @[self.emailField];
    NSArray *fieldLines = @[self.emailLine];
    CAShapeLayer *line = fieldLines[[textFields indexOfObject:textField]];
    line.strokeColor = [UIColor SGRedColor].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setTextColor:[UIColor whiteColor]];
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    [textField setAttributedPlaceholder:attributedPlaceholder];
    
    NSArray *textFields = @[self.emailField];
    NSArray *fieldLines = @[self.emailLine];
    CAShapeLayer *line = fieldLines[[textFields indexOfObject:textField]];
    line.strokeColor = [UIColor whiteColor].CGColor;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // last field, signup.
        [self resetPassword];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (IBAction)touchResetPasswordButton {
    [self resetPassword];
}

- (void) resetPassword {
    NSString *email = self.emailField.text;
    [PFUser requestPasswordResetForEmailInBackground:email block:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // User found in DB. An email has been sent to the user to reset the password
            NSString *message = @"We emailed you instructions to reset your password";
            // Show the errorString somewhere and let the user try again.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:errorString
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
