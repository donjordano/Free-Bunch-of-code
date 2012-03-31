//
//  ResetPasswordViewContrller.m
//  C4F
//
//  Created by Ivan Yordanov on 2/28/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import "ResetPasswordViewContrller.h"
#import "C4FJSONCommunication.h"
#import "C4FSession.h"

@implementation ResetPasswordViewContrller
@synthesize emailField;

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

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [self setEmailField:nil];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)resetPassword:(id)sender {
    C4FJSONCommunication *json = [[C4FJSONCommunication alloc] init];
    C4FSession *session = [C4FSession sharedInstance];
    
    NSDictionary *result = [json resetPassword:emailField.text];
    
    if ([[result objectForKey:@"success"] intValue] == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"C4F" message:@"Check provided E-mail for new password" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"" forKey:@"kPassword"];
    [prefs synchronize];
    [session setPass:@""];
    
}

#pragma mark - AllertView delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
