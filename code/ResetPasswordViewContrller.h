//
//  ResetPasswordViewContrller.h
//  Created by Ivan Yordanov on 2/28/12.

#import <UIKit/UIKit.h>

@interface ResetPasswordViewContrller : UIViewController{
}

@property (strong, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)goBack:(id)sender;
- (IBAction)resetPassword:(id)sender;

@end
