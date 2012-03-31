//
//  DatePickerViewController.m
//
//  Created by Ivan Yordanov on 3/15/12.

#import "DatePickerViewController.h"
#import " Session.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController
@synthesize birthDateBtn;
@synthesize datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{   
    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
	// Do any additional setup after loading the view.
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [self setBirthDateBtn:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cancel:(id)sender {
     Session *session = [ Session sharedInstance];
    [session setBirthdate:@""];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)changeDate{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
     [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *stringDate = [dateFormat stringFromDate:datePicker.date];
     Session *session = [ Session sharedInstance];
    [session setBirthdate:stringDate];
    NSDate *date = [dateFormat dateFromString:session.birthdate];
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"dd-MM-yyyy" options:0
                                                              locale:[NSLocale currentLocale]];
    [dateFormat setDateFormat:formatString];
    NSString *dateString = [dateFormat stringFromDate:date];
    [birthDateBtn setTitle:[NSString stringWithFormat:@"Birthdate: %@", dateString] forState:UIControlStateNormal];
}

@end
