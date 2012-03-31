//
//  ResetPasswordViewContrller.h
//  C4F
//
//  Created by Ivan Yordanov on 2/28/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewContrller : UIViewController{
}

@property (strong, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)goBack:(id)sender;
- (IBAction)resetPassword:(id)sender;

@end
