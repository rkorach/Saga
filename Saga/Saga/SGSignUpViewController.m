//
//  SGSignUpViewController.m
//  Saga
//
//  Created by Raphaël Korach on 28/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGSignUpViewController.h"
#import "UIColor+SGColors.h"

@interface SGSignUpViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) CALayer *usernameLine;
@property (weak, nonatomic) CALayer *emailLine;
@property (weak, nonatomic) CALayer *passwordLine;
@property (weak, nonatomic) IBOutlet UIView *bottomBoxView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SGSignUpViewController

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
    self.usernameField.delegate = self;
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    [self initPlaceholderColorForTextField:self.usernameField];
    [self initPlaceholderColorForTextField:self.emailField];
    [self initPlaceholderColorForTextField:self.passwordField];
    [self drawLines];
    [self.usernameField becomeFirstResponder];
    
    self.usernameField.tag = 0;
    self.emailField.tag = self.usernameField.tag + 1;
    self.passwordField.tag = self.emailField.tag + 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.activeField) {
        [self.activeField becomeFirstResponder];
    }
}

- (IBAction)unwindToSignUp:(UIStoryboardSegue *)unwindSegue
{
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    float keyboardHeight = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size.height;
    
    // Using self.bottomBoxView.transform = CGAffineTransformMakeTranslation(0, -keyboardHeight);
    // does a weird "move back down a bit" when segueing, So I had to use the code below with a UIScrollView
    
    // Adjust the bottom content inset of the scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardHeight, 0.0);
    self.scrollView.contentInset = contentInsets;
    
    // Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height -= keyboardHeight;
    if (!CGRectContainsPoint(aRect, self.bottomBoxView.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.bottomBoxView.frame.origin.y - keyboardHeight);
        [self.scrollView setContentOffset:scrollPoint animated:NO]; // weird offset added if animated:YES
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)initPlaceholderColorForTextField:(UITextField *)textField
{
    if (!textField.placeholder) return;
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    [textField setAttributedPlaceholder:attributedPlaceholder];
}

- (void)drawLines
{
    NSArray *textFields = @[self.usernameField, self.emailField, self.passwordField];
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
    
    self.usernameLine = lines[[textFields indexOfObject:self.usernameField]];
    self.emailLine = lines[[textFields indexOfObject:self.emailField]];
    self.passwordLine = lines[[textFields indexOfObject:self.passwordField]];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    [textField setTextColor:[UIColor SGRedColor]];
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor SGRedColor]}];
    [textField setAttributedPlaceholder:attributedPlaceholder];

    NSArray *textFields = @[self.usernameField, self.emailField, self.passwordField];
    NSArray *fieldLines = @[self.usernameLine, self.emailLine, self.passwordLine];
    CAShapeLayer *line = fieldLines[[textFields indexOfObject:textField]];
    line.strokeColor = [UIColor SGRedColor].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setTextColor:[UIColor whiteColor]];
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    [textField setAttributedPlaceholder:attributedPlaceholder];
    
    NSArray *textFields = @[self.usernameField, self.emailField, self.passwordField];
    NSArray *fieldLines = @[self.usernameLine, self.emailLine, self.passwordLine];
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
        [self signup];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (IBAction)touchTermsOfServicesButton {
}

- (IBAction)touchSignUpButton {
    [self signup];
}

- (void) signup {
    NSString *username = self.usernameField.text;
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    
    NSString *error;
    if (username.length < 2) {
        error = @"Username is too short. Please make it at least 2 characters";
        [self.usernameField becomeFirstResponder];
    } else if (username.length > 12) {
        error = @"Please use 12 characters max for your username";
        [self.usernameField becomeFirstResponder];
    } else if (password.length < 6) {
        error = @"Please choose a password longer than 6 characters";
        [self.emailField becomeFirstResponder];
    } else {
        error = nil;
    }
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:error
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    PFUser *user = [PFUser user];
    [user setObject:username forKey:@"casedUsername"];
    user.username = [username lowercaseString];
    user.password = password;
    user.email = email;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            
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

@end
