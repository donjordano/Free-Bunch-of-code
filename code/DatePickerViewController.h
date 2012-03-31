//
//  DatePickerViewController.h
//  C4F
//
//  Created by Ivan Yordanov on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *birthDateBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
