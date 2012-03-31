//
//  ProfileViewController.h
//   
//
//  Created by Ivan Yordanov on 2/25/12.

#import <UIKit/UIKit.h>

@class  JSONCommunication;

@interface ProfileViewController : UITableViewController<UIActionSheetDelegate>{
    IBOutlet UIBarButtonItem *editBtn;
    IBOutlet UIButton *getMoneyBtn;
    IBOutlet UISegmentedControl *sexSegment;
    IBOutlet UITableView *tView;
    IBOutlet UITextField *fullName;
    BOOL isEditMode;
    
    UIActionSheet *aac;
    UIDatePicker *theDatePicker;
    
    NSDictionary *userData;
    
//     Session *session;
    
     JSONCommunication *json;
    UIView *datePickerContainer;
//     DB *db;
}
@property (strong, nonatomic) IBOutlet UITextField *fullName;
@property (strong, nonatomic) IBOutlet UITableView *tView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *sexSegment;
@property (strong, nonatomic) IBOutlet UITextField *bankAccount;
@property (strong, nonatomic) IBOutlet UIButton *getMoneyBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBtn;

- (IBAction)setEditMode:(id)sender;
- (IBAction)getTheMoney:(id)sender;
- (void)textFieldFinished:(id)sender;

-(void)reloadUserData;
-(void)showDatePicker;

@end
