//
//  ChangePasswordViewController.h
//  C4F
//
//  Created by Ivan Yordanov on 2/26/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController <UITextFieldDelegate>{
    
    UITextField *_currentTextField;
}

@property (strong, nonatomic) IBOutlet UITextField *theNewPass;
@property (strong, nonatomic) IBOutlet UITextField *confirmNewPass;

- (IBAction)goBack:(id)sender;
- (IBAction)changePassword:(id)sender;

@end
