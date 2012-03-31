//
//  RegistrationViewController.m
//  C4F
//
//  Created by Ivan Yordanov on 1/29/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import "RegistrationViewController.h"
#import "MTPopupWindow.h"
#import "C4FJSONCommunication.h"
#import "DatePickerViewController.h"
#import "C4FSession.h"

@implementation RegistrationViewController

@synthesize activeTextField;

UIDatePicker *datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                       name:UIKeyboardDidShowNotification
                                       object:nil];
 
 [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                       name:UIKeyboardWillHideNotification
                                       object:nil];
 }

- (void)viewDidUnload
{
    regPassword = nil;
    regConfirmPassword = nil;
    regEmail = nil;
    birthDate = nil;
    sex = nil;
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    theScrollView = nil;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //C4FSession *session = [C4FSession sharedInstance];
   // birthDate.text = session.birthdate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Popup Action

-(IBAction)reg_info:(id)sender{
    if ([sender tag] == 1) {
        [MTPopupWindow showWindowWithHTMLFile:@"fullname.html" insideView:self.view];
    }
    if ([sender tag] == 2) {
        [MTPopupWindow showWindowWithHTMLFile:@"username.html" insideView:self.view];
    }
    if ([sender tag] == 3) {
        [MTPopupWindow showWindowWithHTMLFile:@"password.html" insideView:self.view];
    }
    if ([sender tag] == 4) {
        [MTPopupWindow showWindowWithHTMLFile:@"confirm_password.html" insideView:self.view];
    }
    if ([sender tag] == 5) {
        [MTPopupWindow showWindowWithHTMLFile:@"email.html" insideView:self.view];
    }
    if ([sender tag] == 6) {
        [MTPopupWindow showWindowWithHTMLFile:@"phone_number.html" insideView:self.view];
    }
}

#pragma mark - TextField section

- (void)keyboardWasShown:(NSNotification *)notification{
    //Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //Adjust the bottom content inset of scroll view by the keyboard height.
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    theScrollView.contentInset = contentInsets;
    theScrollView.scrollIndicatorInsets = contentInsets;

    //Scroll the target text field into view.
    CGRect aRect = self.view.frame;
    aRect.size.height += keyboardSize.height;
    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.activeTextField.frame.origin.y + 44);
        [theScrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    theScrollView.contentInset = contentInsets;
    theScrollView.scrollIndicatorInsets = contentInsets;
}

// Set activeTextField to the current active textfield
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.activeTextField = textField; 
}

// Set activeTextField to nil
- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.activeTextField = nil;
}


// Dismiss the keyboard
- (IBAction)dismissKeyboard:(id)sender{
    [self.activeTextField resignFirstResponder];
}

- (IBAction)dismissRegView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// When any of my buttons are pressed, push the next view
- (IBAction)checkUserData:(id)sender
{   
    C4FJSONCommunication *jsonClass = [[C4FJSONCommunication alloc] init];
    
    if ([regPassword.text length] == 0 ||
        [regConfirmPassword.text length] == 0 ||
        [regEmail.text length] == 0) {
        [jsonClass showAlert:@"All fields are required"];
    } else if(![self validateEmail:regEmail.text]){
        [jsonClass showAlert:@"Please enter valid email"];
    } else if([regPassword.text length] < 5){
        [jsonClass showAlert:@"Password is too short!"];
    }
    else {
        NSNumber *sexNum;
        if (sex.selectedSegmentIndex == 0) {
            sexNum = [NSNumber numberWithInt:2];
        }
        
        if (sex.selectedSegmentIndex == 1) {
            sexNum = [NSNumber numberWithInt:1];
        }
        
        NSDictionary *result = [jsonClass registerTester:birthDate.text whitPassword:regPassword.text email:regEmail.text andSex:sexNum];
        
        if ([result objectForKey:@"success"]) {
            [self performSegueWithIdentifier:@"registerConfirm" sender:sender];
        }
    }
}


// This will get called too before the view appears
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"registerConfirm"]) {
        
        // Get destination view
        //SecondView *vc = [segue destinationViewController];
        
        // Get button tag number (or do whatever you need to do here, based on your object
        //NSInteger tagIndex = [(UIButton *)sender tag];
        
        // Pass the information to your destination view
        //[vc setSelectedButton:tagIndex];
    }
}

//helpers
- (BOOL) validateEmail:(NSString *)candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9._-]+\\.[A-Za-z]{2,6}"; 
	
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark -
#pragma mark DateContainer
- (IBAction)showPicker:(id)sender {
    [regConfirmPassword resignFirstResponder];
    //DatePickerViewController *datePick = [[DatePickerViewController alloc] init];
    
    // load the storyboard by name
    //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //datePick = [storyboard instantiateViewControllerWithIdentifier:@"DatePickerViewController"];
    //[self presentModalViewController:datePick animated:YES];
    
   aac = [[UIActionSheet alloc] initWithTitle:@"How many?"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil];
    
    theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
        theDatePicker.datePickerMode = UIDatePickerModeDate;
    
    [theDatePicker addTarget:self action:@selector(changeDateInLabel) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DatePickerDoneClick:)];
    [barItems addObject:doneBtn];
    
    [pickerDateToolbar setItems:barItems animated:YES];
    
    [aac addSubview:pickerDateToolbar];
    [aac addSubview:theDatePicker];
    [aac showInView:self.view];
    [aac setBounds:CGRectMake(0,0,320, 464)];
}

- (void)DatePickerDoneClick:(id)sender{
    [aac dismissWithClickedButtonIndex:0 animated:YES];
}


- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)changeDateInLabel{  
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *stringDate = [dateFormat stringFromDate:theDatePicker.date];
    C4FSession *session = [C4FSession sharedInstance];
    [session setBirthdate:stringDate];
    NSDate *date = [dateFormat dateFromString:session.birthdate];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd-MM-yyyy" options:0
                                                              locale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:formatString];
    NSString *dateString = [dateFormat stringFromDate:date];
    [birthDate setText:dateString];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSArray *fileds = [NSArray arrayWithObjects:regPassword,regConfirmPassword,regEmail,nil];
         UITouch *touch = [[event allTouches] anyObject];
    for (id field in fileds) {
        if ([field isFirstResponder] && [touch view] != field) {
            [field resignFirstResponder];
        }
    }
    [super touchesBegan:touches withEvent:event];
}

@end
