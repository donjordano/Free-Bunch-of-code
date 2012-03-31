//
//  OrderInfoViewController.h
//   
//
//  Created by Ivan Yordanov on 2/28/12.

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
