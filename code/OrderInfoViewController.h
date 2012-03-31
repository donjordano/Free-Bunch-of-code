//
//  OrderInfoViewController.h
//  C4F
//
//  Created by Ivan Yordanov on 2/28/12.
//  Copyright (c) 2012 ITEco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface OrderInfoViewController : UITableViewController<MFMailComposeViewControllerDelegate>{
    IBOutlet UIButton *cancelTestBtn;
    
    NSDictionary *orderInfo;
}

@property (weak, nonatomic) IBOutlet UIButton *cancelTestBtn;

- (IBAction)goBack:(id)sender;
- (void)writeMailToContact;
- (IBAction)cancelOrder:(id)sender;
- (IBAction)completeOrder:(id)sender;


@end
