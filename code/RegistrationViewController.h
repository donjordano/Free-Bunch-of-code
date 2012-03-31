//
//  RegistrationViewController.h
//  Created by Ivan Yordanov on 1/29/12.
//This work is licensed under a Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License
//http://creativecommons.org/licenses/by-nc-sa/3.0/
//CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE LEGAL SERVICES. 
//DISTRIBUTION OF THIS LICENSE DOES NOT CREATE AN ATTORNEY-CLIENT RELATIONSHIP. 
//CREATIVE COMMONS PROVIDES THIS INFORMATION ON AN "AS-IS" BASIS. 
//CREATIVE COMMONS MAKES NO WARRANTIES REGARDING THE INFORMATION PROVIDED, 
//AND DISCLAIMS LIABILITY FOR DAMAGES RESULTING FROM ITS USE. 
//THE WORK (AS DEFINED BELOW) IS PROVIDED UNDER THE TERMS OF THIS CREATIVE COMMONS PUBLIC LICENSE
// ("CCPL" OR "LICENSE"). THE WORK IS PROTECTED BY COPYRIGHT AND/OR OTHER APPLICABLE LAW.
//ANY USE OF THE WORK OTHER THAN AS AUTHORIZED UNDER THIS LICENSE OR COPYRIGHT LAW IS PROHIBITED.
//Copyright (c) Ivan Yordanov 2012

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
