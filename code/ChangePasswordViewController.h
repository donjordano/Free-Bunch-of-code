//
//  ChangePasswordViewController.h
//   
//
//  Created by Ivan Yordanov on 2/26/12.

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController <UITextFieldDelegate>{
    
    UITextField *_currentTextField;
}

@property (strong, nonatomic) IBOutlet UITextField *theNewPass;
@property (strong, nonatomic) IBOutlet UITextField *confirmNewPass;

- (IBAction)goBack:(id)sender;
- (IBAction)changePassword:(id)sender;

@end
