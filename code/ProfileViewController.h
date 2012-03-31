//
//  ProfileViewController.h
//  Created by Ivan Yordanov on 2/25/12.
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
