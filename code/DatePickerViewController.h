//
//  DatePickerViewController.h
//   
//
//  Created by Ivan Yordanov on 3/15/12.

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *birthDateBtn;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
@end
