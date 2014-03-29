//
//  SGLogInViewController.m
//  Saga
//
//  Created by Raphaël Korach on 28/03/2014.
//  Copyright (c) 2014 cottonTracks. All rights reserved.
//

#import "SGLogInViewController.h"
#import "UIColor+SGColors.h"
#import "ECSlidingViewController/ECSlidingViewController.h"

@interface SGLogInViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIView *bottomBoxView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) CALayer *usernameLine;
@property (weak, nonatomic) CALayer *passwordLine;
@end

@implementation SGLogInViewController

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
    self.passwordField.delegate = self;
    [self initPlaceholderColorForTextField:self.usernameField];
    [self initPlaceholderColorForTextField:self.passwordField];
    [self drawLines];
    [self.usernameField becomeFirstResponder];

    self.usernameField.tag = 0;
    self.passwordField.tag = self.usernameField.tag + 1;
    
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

- (IBAction)unwindToLogIn:(UIStoryboardSegue *)unwindSegue
{
    
}

-(void)keyboardWillShow:(NSNotification *)notification
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
    NSArray *textFields = @[self.usernameField, self.passwordField];
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
    self.passwordLine = lines[[textFields indexOfObject:self.passwordField]];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    [textField setTextColor:[UIColor SGRedColor]];
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor SGRedColor]}];
    [textField setAttributedPlaceholder:attributedPlaceholder];
    
    NSArray *textFields = @[self.usernameField, self.passwordField];
    NSArray *fieldLines = @[self.usernameLine, self.passwordLine];
    CAShapeLayer *line = fieldLines[[textFields indexOfObject:textField]];
    line.strokeColor = [UIColor SGRedColor].CGColor;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setTextColor:[UIColor whiteColor]];
    NSAttributedString *attributedPlaceholder = [[NSAttributedString alloc]initWithString:textField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor lightTextColor]}];
    [textField setAttributedPlaceholder:attributedPlaceholder];
    
    NSArray *textFields = @[self.usernameField, self.passwordField];
    NSArray *fieldLines = @[self.usernameLine, self.passwordLine];
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
        [self login];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (IBAction)touchLoginButton {
    [self login];
}

- (void) login {
    NSString *username = [self.usernameField.text lowercaseString];
    NSString *password = self.passwordField.text;
    
    
    [PFUser logInWithUsernameInBackground:username password:password
                                    block:^(PFUser *user, NSError *error) {
        if (user) {
            // login successful, go to feed
            [self accessFeed];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // The login failed.
            // check if the user didn't try to log in with his email
            PFQuery *query = [PFUser query];
            [query whereKey:@"email" equalTo:username];
            NSArray *users = [query findObjects];
            if ([users count] > 0) {
                user = users[0];
                NSString *fetchedUsername = user.username;
                
                [PFUser logInWithUsernameInBackground:fetchedUsername password:password
                                                block:^(PFUser *userFromEmail, NSError *secondError) {
                    if (userFromEmail) {
                        // login successful, go to feed
                        [self accessFeed];
                    } else {
                        // The login failed. Check error to see why.
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:errorString
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                }];
            } else {
                // The login failed. Check error to see why.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:errorString
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
}

- (void)accessFeed
{
    // TODO(pink): release all the walkthrough, login, signup VCs and go back to the original initVC
    UIViewController *initViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"init"];
    [self presentViewController:initViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
