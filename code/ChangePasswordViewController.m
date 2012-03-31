//
//  ChangePasswordViewController.m
//   
//
//  Created by Ivan Yordanov on 2/26/12.

#import "ChangePasswordViewController.h"
#import " JSONCommunication.h"
#import " Session.h"
#import " DB.h"

@interface ChangePasswordViewController(Private)
-(BOOL)validateInput:(NSString *)input;
@end

@implementation ChangePasswordViewController

@synthesize theNewPass;
@synthesize confirmNewPass;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewWillAppear:(BOOL)animated
{
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void) alertView:(UIAlertView *)alert clickedButtonAtIndex:(NSInteger)buttonIndex 
{
    if (alert.tag != 1) {
        _currentTextField.text = @"";
        
        _currentTextField.delegate = self;
        [_currentTextField becomeFirstResponder];
        _currentTextField = nil;
    }
    else {
        theNewPass.delegate = self;
        [theNewPass becomeFirstResponder];
        _currentTextField = nil;
    }
}


#pragma mark - UITextField delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == confirmNewPass)
    {
        return YES;
    }

    if([self validateInput:textField.text])
    {
        return YES;
    }
    else {
        if (textField == theNewPass) {
            textField.delegate = nil;
            [textField resignFirstResponder];
            _currentTextField = textField;
            
            UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"" 
                                                             message:@"The password must be bigger than 5 characters" 
                                                            delegate:self 
                                                   cancelButtonTitle:nil 
                                                   otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if([self validateInput:textField.text])
    {
        return YES;
    }
    else {
        textField.delegate = nil;
        [textField resignFirstResponder];
        _currentTextField = textField;
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"" 
                                                         message:@"The password must be at least 5 characters" 
                                                        delegate:self 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
    return NO;
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    theNewPass.delegate = self;
    confirmNewPass.delegate = self;
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [self setTheNewPass:nil];
    [self setConfirmNewPass:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)goBack:(id)sender {
    theNewPass.delegate = nil;
    confirmNewPass.delegate = nil;
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)changePassword:(id)sender {
    // Get rid of delegates so we don't trigger multiple errors
    theNewPass.delegate = nil;
    confirmNewPass.delegate = nil;
    
    if( [theNewPass.text isEqualToString:@""])
    {
        confirmNewPass.delegate = nil;
        _currentTextField = confirmNewPass;
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"" 
                                                         message:@"Pasword can not be empty" 
                                                        delegate:self 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
        
        return;
    }
    else if(![theNewPass.text isEqualToString:confirmNewPass.text])
    {
        
        confirmNewPass.delegate = nil;
        _currentTextField = confirmNewPass;
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"" 
                                                         message:@"Passwords do not match" 
                                                        delegate:self 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"Ok", nil];
        [alert show];
        
        return;
    }
    else if(![self validateInput:theNewPass.text] || ![self validateInput:confirmNewPass.text])
    {
        theNewPass.text     = @"";
        confirmNewPass.text = @"";
        confirmNewPass.delegate = nil;
        _currentTextField = theNewPass;
        
        UIAlertView *alert  = [[UIAlertView alloc] initWithTitle:@"" 
                                                         message:@"The password must be at least 5 characters" 
                                                        delegate:self 
                                               cancelButtonTitle:nil 
                                               otherButtonTitles:@"Ok", nil];
        [alert show];
        
        return;
    }
    else {
         Session *session = [ Session sharedInstance];
        [session setPass:theNewPass.text];
        
         JSONCommunication *jsonClass = [[ JSONCommunication alloc] init];
        NSDictionary *result = [jsonClass updateProfile];
        
        if ([result objectForKey:@"success"]) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setInteger:0 forKey:@"kGoToRadar"];
            [prefs synchronize];
            
            [self dismissModalViewControllerAnimated:YES];
        }
        else {
            
        }
    }
}

#pragma mark - Private methods

-(BOOL)validateInput:(NSString *)input
{
    // Currently we only care about length
    if ([input length] < 5) {
        return NO;
    }
    else { 
        return YES;
    }
}

@end
