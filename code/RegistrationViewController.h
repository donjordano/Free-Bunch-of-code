//
//  RegistrationViewController.h
//   
//
//  Created by Ivan Yordanov on 1/29/12.

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController<UIPickerViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UITextField *regPassword;
    IBOutlet UITextField *regConfirmPassword;
    IBOutlet UITextField *regEmail;
    IBOutlet UITextField *birthDate;
    IBOutlet UISegmentedControl *sex;
    IBOutlet UIScrollView *theScrollView;
    __weak UITextField *activeTextField;
    UIActionSheet *aac;
    UIDatePicker *theDatePicker;
}
@property (nonatomic, weak) UITextField *activeTextField;

- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)reg_info:(id)sender;
- (IBAction)dismissRegView:(id)sender;
- (IBAction)checkUserData:(id)sender;
- (IBAction)showPicker:(id)sender;
- (IBAction)goBack:(id)sender;
- (void)DatePickerDoneClick:(id)sender;

//helpers
- (BOOL) validateEmail:(NSString *)candidate;
@end
